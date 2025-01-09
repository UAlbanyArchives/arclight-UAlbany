# frozen_string_literal: true

module Arclight
  # Render an oembed viewer for a document
  class OembedViewerComponent < ViewComponent::Base
    with_collection_parameter :resource

    def initialize(resource:, document:, depth: 0)
      super

      @resource = resource
      @document = document
      @depth = depth
      if document.id.include? "aspace_"
          @searchID = document.id.split("aspace_")[1]
          @facet_field = "archivesspace_record_tesim"
      else
          @searchID = document.id
          @facet_field = "collection_number_tesim"
      end
      #parents = Arclight::Parents.from_solr_document(document).as_parents
    end

    def icon(href)
      if href.include? "/avs/" 
        @icon = "fas fa-film"
      elsif href.include? "/images/"
        @icon = "fas fa-image"
      else
        @icon = "fas fa-file"
      end
    end
    
  end
end
