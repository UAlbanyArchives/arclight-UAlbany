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
    'show-document col-md-12 col-lg-8 order-lg-2'
  end
  def custom_show_content_classes
    'show-document col-md-12 col-lg-8 order-lg-2'
  end

  def show_sidebar_classes
    'page-sidebar col-md-12 col-lg-4 order-lg-1'
  end

  #HT https://gitlab.oit.duke.edu/dul-its/dul-arclight/-/blob/develop/app/helpers/dul_arclight_helper.rb
  def formatted_last_indexed(timestamp)
    date = DateTime.parse(timestamp)
    date.strftime('%F')
  end


end
