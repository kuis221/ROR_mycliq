module OmniauthCallbacks
  class FinderOrCreator
    def initialize(auth)
      @auth = auth
    end

    def call
      if authorization
        update_avatar(authorization) if authorization.user.avatar.blank?
        return authorization.user
      end

      if (user = User.find_by(email: email)) && user.first_name.blank?
        update_user_with_auth(user)
      elsif user = User.find_by(email: email)
        update_avatar(authorization) if user.avatar.blank?
        user.authorizations.create(provider: @auth.provider, uid: @auth.uid)
        user
      else
        create_user_with_auth(email)
      end
    end

    private

    def update_user_with_auth(user)
      first_name, last_name = @auth.info.name.split("\s", 2)
      user.update_attributes(first_name: first_name, last_name: last_name)
      user.avatar = URI.parse(@auth.info.image) if @auth.info.image
      user.authorizations.create(provider: @auth.provider, uid: @auth.uid)
      user
    end

    def create_user_with_auth(email)
      first_name, last_name = @auth.info.name.split("\s", 2)
      username = SecureRandom.urlsafe_base64(nil, false)
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email,
                          password: password,
                          password_confirmation: password,
                          username: username,
                          first_name: first_name,
                          last_name: last_name)
      user.avatar = URI.parse(@auth.info.image) if @auth.info.image
      user.authorizations.create(provider: @auth.provider, uid: @auth.uid)
      user
    end

    def update_avatar(authorization)
      authorization.user.avatar = URI.parse(@auth.info.image) if @auth.info.image
    end

    def authorization
      @authorization ||= Authorization.find_by(provider: @auth.provider, uid: @auth.uid.to_s)
    end

    def email
      @email ||= (@auth.info.email || "#{@auth.uid}@fromtwitter.com")
    end
  end
end
