module EmailHelper

  def send_mail(args = {})
    from_email = args[:from]
    to_email = args[:to]
    subject = args[:subject]
    reply_to = args[:reply_to]
    bcc = args[:bcc]
    cc = args[:cc]

    mail_hash = Hash.new
    mail_hash.merge!(from: from_email) if from_email.present?
    mail_hash.merge!(subject: subject)
    mail_hash.merge!(reply_to: reply_to) if reply_to.present?
    mail_hash.merge!(bcc: bcc) if bcc.present?
    mail_hash.merge!(cc: cc) if cc.present?

    if to_email.present? && subject.present?
      to_email = [to_email] if to_email.is_a?(String)
      mail_hash.merge!(to: to_email)
      # Start sending the notifications
      mail_content = mail(mail_hash)

      # Getting the content and include it on hash to save it in the database
      email_history_content = mail_content.body.raw_source
      email_history_content = mail_content.html_part.body.raw_source unless email_history_content.present?
      email_history_content = mail_content.text_part.body.raw_source unless email_history_content.present?
      if email_history_content.present?
        mail_hash.merge!(content: email_history_content)
      end
      if mail_content.attachments.present?
        mail_hash.merge!(attachment_names: mail_content.attachments.collect{|x| x.filename}.join(", "))
      end

      mail_hash.merge!(to: to_email)

      # Record the notif in email histories
      EmailHistory.create(mail_hash)
      mail_content
    else
      raise "Invalid parameters, in send_email method."
    end

    # Just to ensure it returns nil hash because in GroupMailer.broadcast_scores, it is getting the body of the mail partial
    Hash.new
  end
end
