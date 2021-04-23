require 'rails_helper'

RSpec.describe User, type: :model do
  describe "creation" do
    let!(:user) { create(:user) }
    it "can be created" do
      expect(user).to be_valid
    end
  end

  describe "validations" do
    let(:user) { build(:user) }
    let(:duplicate_user) { build(:user) }
    it "must have name" do
      user.name = nil
      expect(user).to_not be_valid
    end

    it "must have name atleast 3 characters" do
      user.name = "MP"
      expect(user).to_not be_valid
    end

    it "must have valid name" do
      user.name = "MDP"
      expect(user).to be_valid
    end

    it "must have an email address" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "must have a unique email address" do
      user.save!
      duplicate_user.email = user.email
      expect(duplicate_user).to_not be_valid
    end

    it "muust  email format is invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid
      end
    end

    it "when email format is valid" do
      addresses = %w[user@foo.com user_at_foo@foo.org example.user@foo.org bar_baz@baz.com foo_bar_baz@var.com]
      addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end

    it "must have a password" do
      user.password = nil
      expect(user).to_not be_valid
    end    
  end

  describe "future-proofs" do
    let(:user) { build(:user) }
    it "when validations has other errors" do
      expect(user.errors.count).to be_zero
    end
  end
end
