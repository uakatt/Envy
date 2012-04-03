class EnvestigationsController < ApplicationController
  # GET /envestigations
  # GET /envestigations.json
  # GET /environments/1/envestigations
  # GET /environments/1/envestigations.json
  def index
    if params[:environment_id]
      @environment = Environment.find(params[:environment_id])
      @envestigations = @environment.envestigations
    else
      today = Time.now
      today -= (today.sec + today.min*60 + today.hour*60*60)
      @envestigations = Envestigation.where("time >= '#{today+7*60*60}'")
      @envestigation_groups = @envestigations.all.group_by { |envest|
        t=envest.time.localtime
        Time.local(t.year, t.month, t.day, t.hour, t.min/10*10)
      }.sort_by {|t,e| t.to_i*(-1)}  # newest at top
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @envestigations }
    end
  end

  # GET /envestigations/2012-01-31_09:00:00_-0700
  # GET /envestigations/2012-01-31_09:00:00_-0700.json
  # GET /environments/1/envestigations/2012-01-31_09:00:00_-0700
  # GET /environments/1/envestigations/2012-01-31_09:00:00_-0700.json
  def group_by_time
    t = Time.parse(params[:time])
    @rounded_time = Time.local(t.year, t.month, t.day, t.hour, t.min/10*10)
    db_time = @rounded_time + 7*60*60 # database is not in AZ...
    db_time2 = db_time + 600
    if params[:environment_id]
      @environment = Environment.find(params[:environment_id])
      @envestigations = @environment.envestigations.where("time >= '#{db_time}' and time < '#{db_time2}'")
    else
      @envestigations = Envestigation.where("time >= '#{db_time}' and time < '#{db_time2}'")
    end

    respond_to do |format|
      format.html # group_by_time.html.erb
      format.json { render json: @envestigations }
    end
  end
end
