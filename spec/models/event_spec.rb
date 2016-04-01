require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:title) }

  it { is_expected.to have_attached_file(:background_image) }
  it { is_expected.to validate_attachment_content_type(:background_image).
    allowing('image/png', 'image/gif').
    rejecting('text/plain', 'text/xml') }
  it { is_expected.to validate_attachment_size(:background_image).less_than(1.megabytes) }
end
