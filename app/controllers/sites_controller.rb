class SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def create
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
  end
end
