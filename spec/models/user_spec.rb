require 'rails_helper'

RSpec.describe User, type: :model do


  subject(:user) do
    FactoryBot.build(:user,
      username: "AJ",
      password: "password")
  end

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }
  it { should validate_length_of(:password).is_at_least(6) }
  it { should have_many(:goals) }

  describe "#is_password?" do
    it "verifies a password is correct" do
      expect(user.is_password?("password")).to be true
    end

    it "verifies a password is not correct" do
      expect(user.is_password?("incorrect_password")).to be false
    end
  end

  describe 'password encryption' do
    it 'does not save the password to the database' do
      User.create!(username: "AJ", password: 'password')
      user = User.find_by(username: "AJ")
      expect(user.password).not_to eq('password')
    end

    it 'encrypts the password using BCrypt' do
      user_params = {username: "AJ", password: 'password'}
      expect(BCrypt::Password).to receive(:create).with(user_params[:password])
      User.new(user_params)
    end
  end

  describe '#ensure_session_token' do
    it 'assigns a user a session token before validation' do
      user.valid?
      expect(user.session_token).to_not be_nil
    end
  end

  describe '#reset_session_token' do
    context 'when log in' do
      it 'generates a new session token' do
        user.valid?
        old_session_token = user.session_token
        user.reset_session_token!

        expect(user.session_token).to_not eq(old_session_token)
      end
    end

    it 'returns the new session token' do
      expect(user.reset_session_token!).to eq(user.session_token)
    end
  end

  describe '.find_by_credentials' do
    before { user.save! }

    it 'returns user with correct credentials' do
      expect(User.find_by_credentials("AJ", "password")).to eq(user)
    end
  end

end
