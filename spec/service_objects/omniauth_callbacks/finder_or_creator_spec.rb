require 'rails_helper'

RSpec.describe OmniauthCallbacks::FinderOrCreator do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678', info: {}) }

  describe '#call' do
    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '12345678')
        expect(described_class.new(auth).call).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { described_class.new(auth).call }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { described_class.new(auth).call }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = described_class.new(auth).call.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(described_class.new(auth).call).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com', name: 'name' }) }

        it 'creates new user' do
          expect { described_class.new(auth).call }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(described_class.new(auth).call).to be_a(User)
        end

        it 'fills user email' do
          user = described_class.new(auth).call
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = described_class.new(auth).call
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider, uid, checksum' do
          authorization = described_class.new(auth).call.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
