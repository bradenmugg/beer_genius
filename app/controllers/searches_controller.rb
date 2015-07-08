class SearchesController < ApplicationController
    
  def new
    id = session[:id]
    @search = Search.new
    success = @search.get_data(id)
    if (success != 0)
        @search.smart_search
        render 'searches/new'
    else
        flash[:notice] = "Beer not found"
        redirect_to root_path
    end
  end
  
end
  