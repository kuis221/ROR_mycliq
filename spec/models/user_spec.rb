require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:friendships).dependent(:destroy) }
  it { is_expected.to have_many(:inverse_friendships).dependent(:destroy) }
  it { is_expected.to have_many(:posts).dependent(:destroy) }
  it { is_expected.to have_many(:authorizations).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }

  it { is_expected.to have_attached_file(:avatar) }
  it { is_expected.to validate_attachment_content_type(:avatar).
    allowing('image/png', 'image/gif').
    rejecting('text/plain', 'text/xml') }
  it { is_expected.to validate_attachment_size(:avatar).less_than(1.megabytes) }
end
