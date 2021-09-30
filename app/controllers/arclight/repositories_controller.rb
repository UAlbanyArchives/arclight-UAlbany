# frozen_string_literal: true

module Arclight
  # Controller for our /repositories index page
  class RepositoriesController < ApplicationController
    def index
      @repositories = Arclight::Repository.all
      load_collection_counts
    end

    def show
      @repository = Arclight::Repository.find_by!(slug: params[:id])
      search_service = Blacklight.repository_class.new(blacklight_config)
      @all_response = search_service.search(
        q: "level_sim:Collection repository_sim:\"#{@repository.name}\"",
        rows: 9999
      )
      @last_response = search_service.search(
        q: "level_sim:Collection repository_sim:\"#{@repository.name}\"",
        sort: "timestamp desc", 
        rows: 5
      )
      @all_collections = @all_response.documents
      @last_collections = @last_response.documents
      @sorted_collections = @all_collections.sort_by! {|col| col._source["title_filing_si"] || ""}
      @alpha_collections = {}
      @sorted_collections.each do |document|
        if document._source.key?("title_filing_si")
          letter = document._source["title_filing_si"][0,1]
        else
          letter = ""
        end
        if @alpha_collections.key?(letter)
          @alpha_collections[letter] << document
        else
          @alpha_collections[letter] = [document]
        end
      end
    end

    private

    def load_collection_counts
      counts = fetch_collection_counts
      @repositories.each do |repository|
        repository.collection_count = counts[repository.name] || 0
      end
    end

    def fetch_collection_counts
      search_service = Blacklight.repository_class.new(blacklight_config)
      results = search_service.search(
        q: 'level_sim:Collection',
        'facet.field': 'repository_sim',
        rows: 0
      )
      Hash[*results.facet_fields['repository_sim']]
    end
  end
end
