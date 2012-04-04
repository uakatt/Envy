class EnvironmentsController < ApplicationController
  # GET /environments
  # GET /environments.json
  def index
    @environments = Environment.order(:code)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @environments }
    end
  end

  # GET /environments/state_of_the_universe
  # GET /environments/state_of_the_universe.json
  def state_of_the_universe
    @environments = Environment.order(:code)

    respond_to do |format|
      format.html # state_of_the_universe.html.erb
      format.json { render json: @environments }
    end
  end

  # GET /environments/email_screen
  # GET /environments/email_screen.json
  def email_screen
    @environments = Environment.order(:code)
    @envestigations = @environments.map { |env| env.envestigate_build_number }

    respond_to do |format|
      format.html # email_screen.html.erb
      format.json { render json: @environments }
    end
  end

  # GET /environments/1
  # GET /environments/1.json
  def show
    @environment = Environment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @environment }
    end
  end

  # GET /environments/new
  # GET /environments/new.json
  def new
    @environment = Environment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @environment }
    end
  end

  # GET /environments/1/edit
  def edit
    @environment = Environment.find(params[:id])
  end

  # POST /environments
  # POST /environments.json
  def create
    @environment = Environment.new(params[:environment])

    respond_to do |format|
      if @environment.save
        format.html { redirect_to @environment, notice: 'Environment was successfully created.' }
        format.json { render json: @environment, status: :created, location: @environment }
      else
        format.html { render action: "new" }
        format.json { render json: @environment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /environments/1
  # PUT /environments/1.json
  def update
    @environment = Environment.find(params[:id])

    respond_to do |format|
      if @environment.update_attributes(params[:environment])
        format.html { redirect_to @environment, notice: 'Environment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @environment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /environments/1
  # DELETE /environments/1.json
  def destroy
    @environment = Environment.find(params[:id])
    @environment.destroy

    respond_to do |format|
      format.html { redirect_to environments_url }
      format.json { head :no_content }
    end
  end

  # GET /environments/1/envestigate__build_number
  # GET /environments/1/envestigate__build_number.json
  def envestigate__build_number
    @environment = Environment.find(params[:id])

    Resque.enqueue(Envestigators::BuildNumber, @environment.id)

    #PrivatePub.publish_to("/envestigate/new", message: "Foo")
    #$("#<%= @environment.code.gsub(/ /, '-') %>-results").addClass('loading').html("<img src=\"/assets/     ajax-loader-003366.gif\" />");
  end

  # GET /environments/1/envestigate__accounts_count
  # GET /environments/1/envestigate__accounts_count.json
  def envestigate__accounts_count
    @environment = Environment.find(params[:id])

    Resque.enqueue(Envestigators::AccountsCount, @environment.id)
  end

  # GET /environments/1/take_melodie
  # GET /environments/1/take_melodie.json
  def take_melodie
    @environment = Environment.find(params[:id])

    Resque.enqueue(Melodies::SystemInformation, @environment.id)
  end

  # GET /environments/1/recent_melodie_snapshots
  # GET /environments/1/recent_melodie_snapshots.json
  def recent_melodie_snapshots
    @environment = Environment.find(params[:id])

    @recent_melodie_snapshots = @environment.latest_melodie_snapshots
    if @recent_melodie_snapshots.nil? or @recent_melodie_snapshots.first.nil? or @recent_melodie_snapshots.first.taken_at.localtime < (Time.now - 1.minutes)
      response.status = 404
      #redirect_to "/404.html"
      render "fourohfour"
    elsif @recent_melodie_snapshots.all?(&:snapshot_errors)
      respond_to do |format|
        format.json { render json: {:snapshot_error => "Melodie Error"} }
      end
    end
  end
end
