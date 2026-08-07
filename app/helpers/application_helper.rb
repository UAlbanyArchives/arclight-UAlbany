module ApplicationHelper
  include Blacklight::LocalePicker::LocaleHelper

  def additional_locale_routing_scopes
    [blacklight, arclight_engine]
  end

  # For Local Grenander styling
  def source_name
    'Collections'
  end

  # search bar is custom to arclight so we need a helper
  def render_search_bar(params: {}, q: nil, search_field: nil)
    # Fall back to the current search state so query/facets persist when the
    # caller does not explicitly pass params/q.
    params = search_state.params_for_search if params.blank?
    q = q.presence || params[:q]
    render(Arclight::SearchBarComponent.new(
      url: search_catalog_path,
      params: params.merge(f: (params[:f] || {}).except(:collection)),
      q: q,
      search_field: search_field,
      autocomplete_path: suggest_index_catalog_path
    ))
  end

  # Grenander search results helpers
  def render_search_header
    render 'search_results_header'
  end

  # Borrowed DUL custom helper methods
  # HT https://gitlab.oit.duke.edu/dul-its/dul-arclight/-/blob/main/app/helpers/field_config_helpers.rb

  def link_to_all_restrictions(_args)
    link_to 'Read full access restrictions',
            '#using-these-materials',
            class: 'fw-semibold'
  end

  def render_using_these_materials_header(_args)
    render 'catalog/using_header'
  end

  def truncate_restrictions_teaser(args)
    values = args[:value] || []
    teaser = truncate(strip_tags(values.join(' ')), length: 200, separator: ' ')
    [teaser, link_to_all_restrictions(nil)].join('<br/>').html_safe
  end

  def pdf_finding_aid(args)
    render 'catalog/pdf_btn', id: args[:value]
  end

  def collecting_area_path(repository)
    search_action_url(
      f: {
        collecting_area: [repository.name],
        level: ['Collection']
      }
    )
  end

  def render_rights(args)
    value = Array(args[:value])
    return if value.blank?

    # Blacklight passes arrays for *_ssim fields
    uri = value.is_a?(Array) ? value.first : value
    rights = RIGHTS[uri]

    if rights
      content_tag(:div, class: 'd-flex flex-column align-items-start') do
        link_to(uri, class: 'text-decoration-none d-flex flex-column gap-2 align-items-start') do
          image_tag(rights["image_name"], alt: "", style: 'max-width: 80px;') +
          content_tag(:span, rights["display_text"])
        end
      end
    else
      uri
    end
  end

  def render_date(args)
    value = Array(args[:value]).first
    return if value.blank?

    begin
      date = Time.iso8601(value)
      date.strftime("%B %-d, %Y")
    rescue ArgumentError
      value # fallback to original value if parsing fails
    end
  end


  
  def render_list(args)
    values = Array(args[:value])
    config = args[:config]
    document = args[:document]

    rendered_values = values.map do |v|
      html = if config.link_to_facet
        field = (config.link_to_facet == true ? config.key : config.link_to_facet)
        link_to v, search_action_path(search_state.reset.filter(field).add(v).params)
      else
        v.to_s
      end

      content_tag(:p, html)
    end

    safe_join(rendered_values)
  end


  def render_formatted_html_tags(args)
    values = Array(args[:value])
    # Assume transform_ead_to_html already returns HTML safe strings
    values.map! do |value|
      html = transform_ead_to_html(value)
      # Mark the string as html_safe here if not already
      html.respond_to?(:html_safe) ? html.html_safe : html
    end
    values.map! { |value| wrap_in_paragraph(value) } if values.size > 1
    safe_join(values)
  end

  def render_html_bibliography(args)
    raw_values = Array.wrap(args[:value])

    # These HTML items need consistent wrapping,
    # regardless of how many items there are.
    formatted = raw_values.map do |value|
      html = transform_ead_to_html(value)
      content_tag(:p, html.html_safe)
    end

    safe_join(formatted)
  end

  def keep_raw_values(args)
    args[:value] || []
  end

  def all_collections_path(repository)
    search_action_url(
      f: {
        level: ['Collection']
      }
    )
  end

  def arclight_metadata_payload
    document = arclight_metadata_document
    return if document.blank?

    page_title = arclight_clean_text(render_page_title)
    description = arclight_best_description(document)

    {
      title: page_title,
      description: description,
      url: request.original_url,
      site_name: arclight_clean_text(application_name),
      image: arclight_document_image_url(document),
      json_ld: arclight_json_ld(document, page_title:, description:)
    }.compact
  end

  def arclight_metadata_document
    return unless controller_name == 'catalog' && action_name == 'show'
    return unless defined?(@document)

    @document
  end

  def arclight_best_description(document)
    candidates = [
      document.try(:abstract),
      document.try(:scope),
      document.first('bioghist_html_tesm'),
      arclight_inherited_parent_description(document)
    ]

    candidates.map { |value| arclight_clean_text(value) }.find(&:present?)
  end

  def arclight_inherited_parent_description(document)
    return if document.try(:collection?)

    collection = document.try(:collection)
    return if collection.blank? || collection.id == document.id

    [
      collection.try(:abstract),
      collection.try(:scope),
      collection.first('bioghist_html_tesm')
    ].find(&:present?)
  end

  def arclight_json_ld(document, page_title:, description:)
    schema = {
      '@context' => 'https://schema.org',
      '@type' => arclight_schema_type(document),
      'name' => arclight_clean_text(document.try(:normalized_title) || page_title),
      'description' => description,
      'url' => request.original_url,
      'creator' => arclight_creators(document),
      'dateCreated' => arclight_date_created(document),
      'keywords' => arclight_keywords(document),
      'rights' => arclight_rights_statement(document),
      'holdingArchive' => arclight_holding_archive(document),
      'isPartOf' => arclight_is_part_of(document),
      'contentUrl' => arclight_content_url(document),
      'thumbnailUrl' => arclight_thumbnail_url(document)
    }.compact

    schema
  end

  def arclight_schema_type(document)
    return 'DigitalDocument' if document.try(:digital_objects).present?
    return 'ArchiveCollection' if document.try(:collection?)

    'CreativeWork'
  end

  def arclight_creators(document)
    corp_names = Array(document.fetch('creator_corpname_ssim', [])).map { |value| arclight_clean_text(value) }.compact_blank
    person_names = Array(document.fetch('creator_persname_ssim', [])).map { |value| arclight_clean_text(value) }.compact_blank
    family_names = Array(document.fetch('creator_famname_ssim', [])).map { |value| arclight_clean_text(value) }.compact_blank

    creators = []
    seen = []

    Array(document.fetch('creator_ssim', [])).each do |raw_name|
      name = arclight_clean_text(raw_name)
      next if name.blank? || seen.include?(name)

      if corp_names.include?(name)
        creators << { '@type' => 'Organization', 'name' => name }
        seen << name
        next
      end

      if person_names.include?(name) || family_names.include?(name)
        creators << { '@type' => 'Person', 'name' => name }
        seen << name
      end
    end

    creators.presence
  end

  def arclight_date_created(document)
    date_value = document.first('normalized_date_ssm') || document.first('unitdate_ssm')
    arclight_clean_text(date_value)
  end

  def arclight_keywords(document)
    keywords = %w[dado_subjects_ssim access_subjects_ssim subject_ssim geogname_ssim].flat_map do |field|
      Array(document.fetch(field, []))
    end

    cleaned_keywords = keywords.map { |value| arclight_clean_text(value) }.compact_blank.uniq
    cleaned_keywords.presence
  end

  def arclight_rights_statement(document)
    rights = Array(document.fetch('dado_rights_statement_ssim', [])).first
    rights ||= document.first('userestrict_html_tesm')
    arclight_clean_text(rights)
  end

  def arclight_holding_archive(document)
    archive = {
      '@type' => 'ArchiveOrganization',
      'name' => 'M.E. Grenander Department of Special Collections & Archives, University Libraries, University at Albany, State University of New York',
    }

    repository_slug = document.try(:repository_config)&.slug
    if repository_slug.present?
      archive['url'] = arclight_engine.repository_url(repository_slug)
    end

    archive
  end

  def arclight_is_part_of(document)
    return if document.try(:collection?)

    collection = document.try(:collection)
    return if collection.blank? || collection.id == document.id

    chain = {
      '@type' => 'ArchiveCollection',
      'name' => arclight_clean_text(collection.try(:normalized_title)),
      'url' => solr_document_url(collection.id)
    }.compact

    parents = Array(document.try(:parents)).reject do |parent|
      parent.respond_to?(:collection?) && parent.collection?
    end

    parents.each do |parent|
      node = {
        '@type' => 'CreativeWork',
        'name' => arclight_clean_text(parent.try(:label)),
        'url' => solr_document_url(parent.id)
      }.compact

      next if node.except('@type').blank?

      node['isPartOf'] = chain
      chain = node
    end

    chain
  end

  def arclight_content_url(document)
    href = document.try(:digital_objects)&.first&.href
    arclight_clean_text(href)
  end

  def arclight_thumbnail_url(document)
    return unless arclight_schema_type(document) == 'DigitalDocument'

    thumbnail_path = document.try(:digital_objects)&.first&.thumbnail_path
    thumbnail_path = document.first('thumbnail_path_ss') if thumbnail_path.blank?

    arclight_normalize_url(thumbnail_path)
  end

  def arclight_document_image_url(document)
    arclight_normalize_url(document.first('thumbnail_path_ss'))
  end

  def arclight_clean_text(value)
    return if value.blank?

    plain_text = strip_tags(Array(value).join(' ')).squish
    CGI.unescapeHTML(plain_text).presence
  end

  def arclight_normalize_url(value)
    url = arclight_clean_text(value)
    return if url.blank?
    return url if url.match?(%r{\Ahttps?://}i)

    URI.join(request.base_url, url).to_s
  rescue URI::InvalidURIError
    nil
  end

end
