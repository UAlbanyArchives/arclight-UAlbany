# frozen_string_literal: true

module Arclight
  #
  # Static information about a given repository identified by a unique `slug`
  #
  class Repository
    include ActiveModel::Conversion # for to_partial_path

    FIELDS = %i[name
                description
                tagline
                visit_note
                building
                address1
                address2
                city
                state
                zip
                country
                phone
                contact_info
                thumbnail_url
                google_request_url
                google_request_mappings
                collection_count].freeze

    attr_accessor :slug, *FIELDS

    # @param [String] `slug` the unique identifier for the repository
    # @param [Hash] `data`
    def initialize(slug, data = {})
      @slug = slug
      FIELDS.each do |field|
        value = data[field.to_s]
        send("#{field}=", value) if value.present?
      end
    end

    # @return [String] handles the formatting of "city, state zip, country"
    def city_state_zip_country
      state_zip = state
      state_zip += " #{zip}" if zip
      [city, state_zip, country].compact.join(', ')
    end

    # Load repository information from a YAML file
    #
    # @param [String] `filename`
    # @return [Hash<Slug,Repository>]
    def self.from_yaml(file)
      repos = {}
      data = YAML.safe_load(File.read(file))
      data.keys.each do |slug|
        repos[slug] = new(slug, data[slug])
      end
      repos
    end

    # Mimics ActiveRecord's `all` behavior
    #
    # @return [Array<Repository>]
    def self.all
      from_yaml(ENV['REPOSITORY_FILE'] || 'config/repositories.yml').values
    end

    # Mimics ActiveRecord dynamic `find_by` behavior for the slug or name
    #
    # @param [String] `slug` or `name`
    # @return [Repository]
    def self.find_by(slug: nil, name: nil)
      if slug
        all.find { |repo| repo.slug == slug }
      elsif name
        all.find { |repo| repo.name == name }
      else
        raise ArgumentError, 'Requires either slug or name parameters to find_by'
      end
    end

    # Mimics ActiveRecord dynamic `find_by!` behavior for the slug or name
    #
    # @param [String] `slug` or `name` -- same as `find_by`
    # @return [Repository]
    # @raise [ActiveRecord::RecordNotFound] if cannot find repository
    def self.find_by!(*args)
      repository = find_by(*args)
      raise ActiveRecord::RecordNotFound if repository.blank?
      repository
    end
  end
end
