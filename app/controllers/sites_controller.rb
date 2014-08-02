class SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def create
    @site = Site.new site_params
    if @site.save
      flash[:success] = 'Site created'
      redirect_to site_path @site
    else
      render :new
    end
  end

  def edit
    @site = Site.find params[:id]
  end

  def update
  end

  def show
    @site = Site.find params[:id]
  end

  def index
    @sites = Site.all
  end

  def destroy
  end

  private

  def site_params
    params.require(:site).permit(:name, :url)
  end
end
