# frozen_string_literal: true

module Arclight
  ##
  # Plain ruby class to model serializing/deserializing digital object data
  class DigitalObject
    attr_reader :label, :href, :type, :action,
                :rights_statement, :subjects,
                :legacy_id, :resource_type, :preservation_package,
                :description, :creator, :contributor,
                :date_published, :thumbnail_path

    def initialize(label:, href:, **kwargs)
      @label = label
      @href = href

      @type = kwargs[:type]
      @action = kwargs[:action]
      @rights_statement = kwargs[:rights_statement]
      @subjects = kwargs[:subjects]
      @legacy_id = kwargs[:legacy_id]
      @resource_type = kwargs[:resource_type]
      @preservation_package = kwargs[:preservation_package]
      @description = kwargs[:description]
      @creator = kwargs[:creator]
      @contributor = kwargs[:contributor]
      @date_published = kwargs[:date_published]
      @thumbnail_path = kwargs[:thumbnail_path]
    end

    def to_json(*)
      {
        label: label,
        href: href,
        type: type,
        action: action,
        rights_statement: rights_statement,
        subjects: subjects,
        legacy_id: legacy_id,
        resource_type: resource_type,
        preservation_package: preservation_package,
        description: description,
        creator: creator,
        contributor: contributor,
        date_published: date_published,
        thumbnail_path: thumbnail_path
      }.to_json
    end

    def self.from_json(json)
      object_data = JSON.parse(json)
      new(**object_data.symbolize_keys)
    end

    def ==(other)
      href == other.href && label == other.label
    end
  end
end
