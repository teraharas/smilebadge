class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector
  
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper
end
