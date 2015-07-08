class BeersController < ApplicationController
    
  def new
    @beer = Beer.new
  end
    
  def create
    @beer = Beer.new(secure_params) 
    if @beer.valid?
      session[:id] =  @beer.search
      redirect_to '/searches/new'
    else
      render :new
    end 
  end

  private

  def secure_params
    params.require(:beer).permit(:search)
  end
    
end