require 'rails_helper'

RSpec.describe Post, type: :model do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:content) }

  it { is_expected.to have_attached_file(:photo) }
  it { is_expected.to validate_attachment_content_type(:photo).
    allowing('image/png', 'image/gif').
    rejecting('text/plain', 'text/xml') }
  it { is_expected.to validate_attachment_size(:photo).less_than(1.megabytes) }
end
