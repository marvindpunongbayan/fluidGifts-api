require 'rails_helper'

RSpec.describe EmailHistory, type: :model do
  describe "creation" do
    let!(:email_history) { create(:email_history) }
    it "can be created" do
      expect(email_history).to be_valid
    end
  end
end
