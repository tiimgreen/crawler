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
    @site = Site.find_by params[:id]
    if @site.update_attributes site_params
      flash[:success] = 'Site updated'
      redirect_to site_path @site
    else
      render :edit
    end
  end

  def show
    @site = Site.find params[:id]
  end

  def index
    @sites = Site.all
  end

  def destroy
    site = Site.find params[:id]
    if site.destroy
      flash[:success] = 'Site destroyed'
      redirect_to sites_path
    else
      flash[:warning] = 'Error deleting site'
      redirect_to site_path site
    end
  end

  private

  def site_params
    params.require(:site).permit(:name, :url)
  end
end
