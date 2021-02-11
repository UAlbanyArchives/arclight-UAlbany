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


  # replaces generic_context_navigation in arclight_helper so that component show pages only list children instead of full context
  def children_navigation(document, original_parents: [document.id])
    content_tag(
      :div,
      '',
      class: 'context-navigator',
      data: {
        collapse: I18n.t('arclight.views.show.collapse'),
        expand: I18n.t('arclight.views.show.expand'),
        arclight: {
          path: search_catalog_path(hierarchy_context: 'component'),
          name: document.collection_name,
          view: 'child_components',
          originalDocument: document.id,
          originalParents: original_parents,
          eadid: normalize_id(document.eadid)
        }
      }
    )
  end

end
