class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :confirmable,
         :rememberable, :trackable, :validatable, :omniauthable, :invitable,
         omniauth_providers: [:facebook, :twitter]

  acts_as_messageable

  validates_presence_of :username
  validates_uniqueness_of :username

  validates :first_name, presence: true

  has_many :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :invitations, dependent: :destroy, class_name: "User", as: :invited_by

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/gravatar.jpg"
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
end
