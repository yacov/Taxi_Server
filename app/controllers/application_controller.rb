class ApplicationController < ActionController::Base
  #protect_from_forgery
  private
     def render_404
       render file: "public/404.html",status: 404 ,layout: false
     end

end