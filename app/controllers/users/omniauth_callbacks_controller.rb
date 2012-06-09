class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"

    sign_in_and_redirect user, :event => :authentication
  end
end