module ApplicationHelper
  include Blacklight::LocalePicker::LocaleHelper

  def additional_locale_routing_scopes
    [blacklight, arclight_engine]
  end

  # For Local Grenander styling
  def source_name
    'Collections'
  end

  def collection_doc(document)
    SolrDocument.find(normalize_id(document.eadid))
  end

  def container_classes
    'container-fluid'
  end
  
  def show_content_classes
    'show-document col-md-7 col-lg-8 order-md-2'
  end

  def show_sidebar_classes
    'page-sidebar col-md-5 col-lg-4 order-md-1'
  end

end
