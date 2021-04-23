class ApplicationController < ActionController::Base
  # protect_from_forgery with: :null_session
  # skip_before_action :verify_authenticity_token
  before_action :set_host_for_local_storage
  private
    def set_host_for_local_storage
      ActiveStorage::Current.host = request.base_url if Rails.application.config.active_storage.service == :local
    end
end
