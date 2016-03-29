require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:friendships).dependent(:destroy) }
  it { is_expected.to have_many(:inverse_friendships).dependent(:destroy) }
  it { is_expected.to have_many(:posts).dependent(:destroy) }
  it { is_expected.to have_many(:authorizations).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }
end
