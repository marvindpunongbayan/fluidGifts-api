class CreateEmailHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :email_histories do |t|
      t.text :from
      t.text :to
      t.text :subject
      t.text :content
      t.text :cc
      t.text :bcc
      t.text :reply_to
      t.text :attachment_names

      t.timestamps
    end
  end
end
