module ApplicationHelper
  include Blacklight::LocalePicker::LocaleHelper

  def additional_locale_routing_scopes
    [blacklight, arclight_engine]
  end

  # For Local Grenander styling
  def source_name
    'Archives & Manuscripts'
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
