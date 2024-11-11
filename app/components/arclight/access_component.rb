# frozen_string_literal: true

module Arclight
  # Render access information for a document
  class AccessComponent < ViewComponent::Base
    def initialize(presenter:)
      super
      @show_config = presenter.configuration.show
      @presenter = presenter
    end

    attr_reader :presenter, :show_config

    delegate :collection?, to: :presenter

    # @return Array<Symbol> a list of metadata section names
    def section_names
      return Array(collection_access_items) if collection?

      Array(component_access_items)
    end

    def restriction_classes
      access_restriction = presenter.document["accessrestrict_tesim"].to_s.downcase

      if presenter.document.level == "collection"
        return "" if access_restriction.include?("access to this collection is unrestricted") ||
                    access_restriction.include?("access to these records is unrestricted") ||
                    access_restriction.include?("this collection is unrestricted") ||
                    access_restriction.include?("access to this record group is unrestricted")
        
        return "accessrestrict-danger" if access_restriction.blank?
        
        "accessrestrict-warning"
      else
        access_restriction.blank? ? nil : "accessrestrict-danger"
      end
    end

    delegate :collection_access_items, :component_access_items, to: :show_config
  end
end
