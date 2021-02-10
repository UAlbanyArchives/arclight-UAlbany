# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
 include Arclight::SolrDocument

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # HT https://gitlab.oit.duke.edu/dul-its/dul-arclight/-/blob/develop/app/models/solr_document.rb
  # DUL CUSTOMIZATION: Capture last indexed date
  def last_indexed
    fetch('timestamp', '')
  end
  def total_component_count
    first('total_component_count_isim') || 0
  end
  # This count includes all descendant components' DAOs
  def total_digital_object_count
    first('total_digital_object_count_isim') || 0
  end


end
