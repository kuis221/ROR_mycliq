class Event < ActiveRecord::Base
  attr_reader :remove_image

  belongs_to :user
  has_many :event_invitations, dependent: :destroy

  validates_presence_of :user_id
  validates_presence_of :title

  has_attached_file :background_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/gravatar.jpg"

  validates_attachment_content_type :background_image, content_type: /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :background_image, less_than: 2.megabytes

  auto_html_for :description do
    html_escape
    sized_image(width: "50%", height: "50%")
    youtube(width: "100%", height: 250, autoplay: false)
    link target: "_blank", rel: "nofollow"
    simple_format
  end

  class << self
    def accepted_by(user)
      joins(:event_invitations).where(event_invitations: { invitee_id: user.id, status: "accepted" }).uniq
    end

    def rejected_by(user)
      joins(:event_invitations).where(event_invitations: { invitee_id: user.id, status: "rejected" }).uniq
    end

    def not_replied_by(user)
      joins(:event_invitations).where(event_invitations: { invitee_id: user.id, status: "sent" }).uniq
    end
  end
end
