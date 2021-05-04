class RestrictionsController < ApplicationController
  respond_to :html
  def reset_password
    token = params[:t]
    if token.present?
      payload, _header = Middlewares::Jwt::TokenDecryptor.decrypt(token)
      if payload
        if payload.dig("expire_at")
          if payload.dig("expire_at").to_time > Time.now
            # redirect to frontend change password page
            redirect_to "#{Rails.configuration.env_variables[:protocol]}://#{Rails.configuration.env_variables[:backend_host]}"
          end
        end
      end
    end
  end
end
