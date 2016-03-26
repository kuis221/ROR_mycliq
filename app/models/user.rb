class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, :invitable,
         omniauth_providers: [:facebook, :twitter]

  acts_as_messageable

  validates_presence_of :username
  validates_uniqueness_of :username

  validates :first_name, presence: true

  has_many :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :invitations, dependent: :destroy, class_name: "User", as: :invited_by

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  validates_with AttachmentSizeValidator, attributes: :avatar, less_than: 1.megabytes

  def request_friendship(user_2)
  	self.friendships.create(friend: user_2)
  end

  def pending_friend_requests_from
    self.inverse_friendships.where(state: "pending")
  end

  def pending_friend_requests_to
    self.friendships.where(state: "pending")
  end

  def active_friends
    self.friendships.where(state: "active").map(&:friend) + self.inverse_friendships.where(state: "active").map(&:user)
  end

  def friendship_status(user_2)
    friendship = Friendship.where(user_id: [self.id,user_2.id], friend_id: [self.id,user_2.id])
    unless friendship.any?
      return "not_friends"
    else
      if friendship.first.state == "active"
        return "friends"
      else
        if friendship.first.user == self
          return "pending"
        else
          return "requested"
        end
      end
    end
  end

  def friendship_relation(user_2)
    Friendship.where(user_id: [self.id,user_2.id], friend_id: [self.id,user_2.id]).first
  end

  def mailboxer_email(object)
    email
  end

  def mailboxer_name
    [first_name, last_name].compact.join(" ")
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info.email || "#{auth.uid}@fromtwitter.com"
    if (user = User.find_by(email: email)) && user.first_name.blank?
      update_user_with_auth(auth, user)
    elsif user = User.find_by(email: email)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
      user
    else
      create_user_with_auth(auth, email)
    end
  end

  def self.update_user_with_auth(auth, user)
    first_name, last_name = auth.info.name.split("\s", 2)
    user.update_attributes(first_name: first_name, last_name: last_name)
    user.avatar = URI.parse(auth.info.image) if auth.info.image
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def self.create_user_with_auth(auth, email)
    first_name, last_name = auth.info.name.split("\s", 2)
    username = SecureRandom.urlsafe_base64(nil, false)
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: email,
                        password: password,
                        password_confirmation: password,
                        username: username,
                        first_name: first_name,
                        last_name: last_name)
    user.avatar = URI.parse(auth.info.image) if auth.info.image
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
