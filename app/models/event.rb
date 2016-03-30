class Event < ActiveRecord::Base
  attr_reader :remove_image

  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :title

  has_attached_file :background_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/gravatar.jpg"

  validates_attachment_content_type :background_image, content_type: /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :background_image, less_than: 1.megabytes

  auto_html_for :description do
    html_escape
    sized_image(width: "100%", height: "100%")
    youtube(width: "100%", height: 250, autoplay: false)
    link target: "_blank", rel: "nofollow"
    simple_format
  end
end
