class StylesController < ApplicationController
	layout 'vendor_portal'
  before_action :set_style, only: [:show, :edit, :update, :destroy]
	#for authentication
	before_filter :authenticate_user!

	#for checking user roles
	before_filter :admin_only

  # GET /styles
  # GET /styles.json
  def index
    @styles = Style.all
  end

  # GET /styles/1
  # GET /styles/1.json
  def show
		redirect_to styles_path
  end

  # GET /styles/new
  def new
    @style = Style.new
  end

  # GET /styles/1/edit
  def edit
  end
	
	#admin only
	def admin_only
    if current_user.userrole==VendorPortal::Application.config.admin || current_user.userrole==VendorPortal::Application.config.operationadmin
				true
    else
				redirect_to root_path, :alert => "Access denied."
    end
  end

  # POST /styles
  # POST /styles.json
  def create

    @style = Style.new(style_params)

    respond_to do |format|
      if @style.save
        format.html { redirect_to styles_url, notice: 'Style was successfully created.' }
        format.json { render :show, status: :created, location: @style }
      else
        format.html { render :new }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /styles/1
  # PATCH/PUT /styles/1.json
  def update
		@style = Style.find(params[:id])
		@style.users.clear
    respond_to do |format|
			
      if @style.update(style_params)
        format.html { redirect_to styles_url, notice: 'Style was successfully updated.' }
        format.json { render :show, status: :ok, location: @style }
      else
        format.html { render :edit }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /styles/1
  # DELETE /styles/1.json
  def destroy
    @style.destroy
    respond_to do |format|
      format.html { redirect_to styles_url, notice: 'Style was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
	def get_styles
		@styles = Style.where(:division_id=>params[:division_id])
    render json: Hash[@styles.map { |v| [ v[:id].to_s, v[:stylename].to_s ] } ]
	end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_style
      @style = Style.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def style_params
      params.require(:style).permit(:stylename, :string, :stylecode,:division_id,:operationuser_id,:sales_id,:designer_id, :image, :mate, { :user_ids => [] } )
    end
end
