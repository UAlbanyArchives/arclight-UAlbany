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

end
