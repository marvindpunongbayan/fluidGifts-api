require "rails_helper"

RSpec.describe SessionsMailer, type: :mailer do
  describe "forgot_password" do
    let(:user) { create(:user) }
    let!(:token) { generate_jwt_reset_password_test_token(user) }
    let(:mail) { SessionsMailer.forgot_password(user, token) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your reset password link")
      expect(mail.to).to eq(["#{user.email}"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
