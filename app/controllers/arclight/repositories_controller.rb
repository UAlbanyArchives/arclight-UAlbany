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
      @subjects = get_subjects

      if params[:id] == "all" or params[:id] == "sub"
	@all_response = search_service.search(
          q: "level_sim:Collection",
          rows: 9999
        )
	@last_response = search_service.search(
          q: "level_sim:Collection",
          sort: "timestamp desc",
          rows: 5
        )
      else
        @all_response = search_service.search(
          q: "level_sim:Collection repository_sim:\"#{@repository.name}\"",
          rows: 9999
        )
	@last_response = search_service.search(
          q: "level_sim:Collection repository_sim:\"#{@repository.name}\"",
          sort: "timestamp desc",
          rows: 5
        )
      end
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

    def subjects_list
	subjects = Array.new
        subjects << "African Americans and Civil Rights Organizations"
        subjects << "Africana Studies"
        subjects << "Agriculture"
        subjects << "Albany, New York"
        subjects << "Anthropology"
        subjects << "Architecture"
        subjects << "Art"
        subjects << "Athletics and Sports"
        subjects << "Business and Industry"
        subjects << "Conservation and the Environment"
        subjects << "Criminal Justice and Prisons"
        subjects << "Death Penalty"
        subjects << "Economics"
        subjects << "Education"
        subjects << "Ethnic Groups"
        subjects << "Folklore"
        subjects << "Human Sexuality and Gender Identity"
        subjects << "Labor"
        subjects << "Literature"
        subjects << "Medicare"
        subjects << "Medicine and Health Care"
        subjects << "Military and Armed Conflict"
        subjects << "Music"
        subjects << "Native Americans"
        subjects << "Neighborhood and Community Associations"
        subjects << "Political Science"
        subjects << "Politics and Politicians"
        subjects << "Public Servants"
        subjects << "Radio and Television Broadcasting"
        subjects << "Railways"
        subjects << "Rensselaer County, New York"
        subjects << "Schenectady, New York"
        subjects << "Senior Citizens"
        subjects << "Social Activists and Public Advocates"
        subjects << "State University of New York SUNY, Central Administration"
        subjects << "Travel"
        subjects << "Women"
    end

    def get_subjects
	@subjects = Array.new
	subjects_list.each do |subject|
	    sub = Hash.new
	    sub["name"] = subject
            subjectURI = URI.join(request.base_url, "description")
            subjectFacet = Hash.new
            subjectFacet["f"] = {"access_subjects_ssim": [subject.gsub(" ", "+")]}
            subjectURI.query = subjectFacet.to_query
	    sub["uri"] = subjectURI
	    @subjects << sub
	end
	@subjects
    end

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
      counts = Hash[*results.facet_fields['repository_sim']]
      counts["A-Z Complete List of Collections"] = results.response["numFound"]

      counts
    end
  end
end
