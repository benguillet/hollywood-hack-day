class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.where('provider = :provider AND uid = :uid', {:provider => auth.provider, :uid => auth.uid}).first

    unless user
      user = User.create
      user.name = auth.extra.raw_info.name
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email

      user.save
    end

    return user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end
end
