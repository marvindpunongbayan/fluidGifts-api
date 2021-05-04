FactoryBot.define do
  factory :email_history do
    from { "MyText" }
    to { "MyText" }
    subject { "MyText" }
    content { "MyText" }
    cc { "MyText" }
    bcc { "MyText" }
    reply_to { "MyText" }
    attachment_names { "MyText" }
  end
end
