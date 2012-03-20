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

    driver = Envy::WebDriver.new(:logger => logger)
    config = {}
    Envy.parse_config_file_into(config)
    driver.username = config[:username]
    driver.password = config[:password]
    #if @environment.url and not @environment.url.empty?
      #driver.navigate.to @environment.url
    #else
      #driver.navigate.to @environment.default_url
    #end
    logger.info("Envy::WebDriver loading (#{@environment.code.inspect}, #{@environment.url.inspect})")
    driver.load(@environment.code, @environment.url)
    @build_number = driver.build_number

    respond_to do |format|
      format.html # envestigate__build_number.html.erb
      format.json { render json: @environment }
      format.js   # envestigate__build_number.js.erb
    end
  end
end
