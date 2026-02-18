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
    params ||= {}
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
    link_to 'More...',
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
      link_to(uri, class: 'text-decoration-none') do
        content_tag(:div, class: 'd-flex flex-column align-items-start') do
          image_tag(rights["image_name"], alt: "Image for license or rights statement.", style: 'max-width: 80px;') +
          content_tag(:div, rights["display_text"], class: 'mt-1')
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

end
