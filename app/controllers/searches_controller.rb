class SearchesController < ApplicationController
    
  def new
    id = session[:id]
    @search = Search.new
    @search.get_data(id)
    @search.smart_search
    render 'searches/new'
  end
  
end
  