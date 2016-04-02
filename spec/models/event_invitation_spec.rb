require 'rails_helper'

RSpec.describe EventInvitation, type: :model do
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:event_id) }
end
