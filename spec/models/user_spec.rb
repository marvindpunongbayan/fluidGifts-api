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

    it "must  email format is invalid" do
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

  describe "with a valid image" do
    before(:each) do
      @user = create(:user)
    end

    it "is attached" do
      @user.image.attach(
        io: File.open(Rails.root.join('spec', 'factories', 'images', 'test.png')),
        filename: 'test.png',
        content_type: 'image/png'
      )
      expect(@user.image).to be_attached
    end
  end

  describe "future-proofs" do
    let(:user) { build(:user) }
    it "when validations has other errors" do
      expect(user.errors).to_not be_present
    end
  end
end
