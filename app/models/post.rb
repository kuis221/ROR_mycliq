class Post < ActiveRecord::Base
  include PublicActivity::Model
  attr_reader :remove_image

  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :content

  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/gravatar.jpg"

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :photo, less_than: 1.megabytes

  auto_html_for :content do
    html_escape
    image
    youtube(width: "100%", height: 250, autoplay: false)
    link target: "_blank", rel: "nofollow"
    simple_format
  end
end
