class MelodieSnapshotsController < ApplicationController
  # GET /environments/1/melodie_snapshots
  # GET /environments/1/melodie_snapshots.json
  def index
    @environment = Environment.find(params[:environment_id])
    @melodie_snapshots = @environment.melodie_snapshots

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @melodie_snapshots }
    end
  end

  # POST /melodie_snapshots/take_snapshots
  # POST /melodie_snapshots/take_snapshots.json
  def take_snapshots
    @environments = Environment.all

    @environments.each do |environment|
      Resque.enqueue(Melodies::SystemInformation, environment.id)
    end
  end

  # GET /environments/1/melodie_snapshots/1
  # GET /environments/1/melodie_snapshots/1.json
  def show
    @environment = Environment.find(params[:environment_id])
    @melodie_snapshot = @environment.melodie_snapshots.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @melodie_snapshot }
    end
  end
end
