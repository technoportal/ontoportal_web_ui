class SubmissionsController < ApplicationController

  layout :determine_layout
  before_action :authorize_and_redirect, :only=>[:edit,:update,:create,:new]

  def new
    @ontology = LinkedData::Client::Models::Ontology.get(CGI.unescape(params[:ontology_id])) rescue nil
    @ontology = LinkedData::Client::Models::Ontology.find_by_acronym(params[:ontology_id]).first unless @ontology
    @submission = @ontology.explore.latest_submission
    @submission ||= LinkedData::Client::Models::OntologySubmission.new
  end

  def create
    # Make the contacts an array
    params[:submission][:contact] = params[:submission][:contact].values

    @submission = LinkedData::Client::Models::OntologySubmission.new(values: submission_params)
    @ontology = LinkedData::Client::Models::Ontology.get(params[:submission][:ontology])
    
    # Update summaryOnly on ontology object
    @ontology.summaryOnly = @submission.isRemote.eql?("3")
    @ontology.update
    
    @submission_saved = @submission.save
    if response_error?(@submission_saved)
      @errors = response_errors(@submission_saved) # see application_controller::response_errors
      if @errors && @errors[:uploadFilePath]
        @errors = ["Please specify the location of your ontology"]
      elsif @errors && @errors[:contact]
        @errors = ["Please add an author"]
      end

      render "new"
    else
      redirect_to "/ontologies/success/#{@ontology.acronym}"
    end
  end

  def edit
    @ontology = LinkedData::Client::Models::Ontology.find_by_acronym(params[:ontology_id]).first
    submissions = @ontology.explore.submissions
    @submission = submissions.select {|o| o.submissionId == params["id"].to_i}.first
  end

  def update
    # Make the contacts an array
    params[:submission][:contact] = params[:submission][:contact].values

    params[:submission][:contact].delete_if { |c| c[:name].empty? || c[:email].empty? }

    @ontology = LinkedData::Client::Models::Ontology.get(params[:submission][:ontology])
    submissions = @ontology.explore.submissions
    @submission = submissions.select {|o| o.submissionId == params["id"].to_i}.first

    @submission.update_from_params(submission_params)
    # Update summaryOnly on ontology object
    @ontology.summaryOnly = @submission.isRemote.eql?("3")
    @ontology.update
    error_response = @submission.update
    if response_error?(error_response)
      @errors = response_errors(error_response) # see application_controller::response_errors
      render 'edit'
    else
      redirect_to "/ontologies/#{@ontology.acronym}"
    end
  end

  private

  def submission_params
    p = params.require(:submission).permit(:ontology, :description, :hasOntologyLanguage, :prefLabelProperty,
                                           :synonymProperty, :definitionProperty, :authorProperty, :obsoleteProperty,
                                           :obsoleteParent, :version, :status, :released, :isRemote, :pullLocation,
                                           :filePath, { contact:[:name, :email] }, :homepage, :documentation,
                                           :publication)
    p.to_h
  end

end
