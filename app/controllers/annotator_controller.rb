class AnnotatorController < ApplicationController
  layout 'ontology'

  ANNOTATOR = NCBO::Annotator.new(:apikey => $API_KEY, :annotator_location => "http://#{$REST_DOMAIN}/obs")

  def index
    ontologies = ANNOTATOR.ontologies
    ontology_ids = []
    ontologies.each {|ont| ontology_ids << ont[:virtualOntologyId]}

    semantic_types = ANNOTATOR.semantic_types
    @semantic_types_for_select = []
    semantic_types.each do |semantic_type|
      @semantic_types_for_select << [semantic_type[:description], semantic_type[:semanticType]]
    end
    @semantic_types_for_select.sort! {|a,b| a[0] <=> b[0]}

    @annotator_ontologies = DataAccess.getFilteredOntologyList(ontology_ids)
  end

  def create
    text = params[:text]

    options = { :ontologiesToKeepInResult => params[:ontology_ids],
                :withDefaultStopWords => true,
                :levelMax => params[:levelMax],
                :semanticTypes => params[:semanticTypes],
                :mappingTypes => params[:mappings],
                :wholeWordOnly => params[:wholeWordOnly]
    }

    start = Time.now
    annotations = ANNOTATOR.annotate(text, options)
    LOG.add :debug, "Getting annotations: #{Time.now - start}s"

    annotations_hash = {}
    highlight_cache = {}
    start = Time.now
    annotations.annotations.each do |annotation|
      unless annotations_hash.key?(annotation[:concept][:localConceptId])
        if highlight_cache.key?([annotation[:context][:from], annotation[:context][:to]])
          annotation[:context][:highlight] = highlight_cache[[annotation[:context][:from], annotation[:context][:to]]]
        else
          annotation[:context][:highlight] = highlight_and_get_context(text, [annotation[:context][:from], annotation[:context][:to]])
          highlight_cache[[annotation[:context][:from], annotation[:context][:to]]] = annotation[:context][:highlight]
        end

        annotations_hash[annotation[:concept][:localConceptId]] = annotation unless annotations_hash.key?(annotation[:concept][:localConceptId])
      end
    end
    annotations.annotations = annotations_hash.values.sort {|a,b| b[:score] <=> a[:score]}
    LOG.add :debug, "Processing annotations: #{Time.now - start}s"

    ontologies_hash = {}
    annotations.ontologies.each do |ont|
      ontologies_hash[ont[:localOntologyId]] = ont
    end
    annotations.ontologies = ontologies_hash

    render :json => annotations
  end

private

  def highlight_and_get_context(text, position, words_to_keep = 4)
    before = text[0, position[0] - 1].split
    highlight = text[position[0] - 1..position[1] - 1]
    after = text[position[1], text.length].split

    before_words = before.length <= words_to_keep ? before.join(" ") : before[before.length - words_to_keep..before.length].join(" ")
    after_words = after.length <= words_to_keep ? after.join(" ") : after[0, words_to_keep].join(" ")

    space_before = before_words[/^[\.\-=\?,'"]/].nil? ? " " : ""
    space_after = after_words[/^[\.\-=\?,'"]/].nil? ? " " : ""

    "#{before_words}#{space_before}<b>#{highlight}</b>#{space_after}#{after_words}"
  end
end