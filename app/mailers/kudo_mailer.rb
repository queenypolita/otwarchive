class KudoMailer < ActionMailer::Base
  include Resque::Mailer # see README in this directory

  default :from => ArchiveConfig.RETURN_ADDRESS

  def kudo_notification(user_id, kudo_id)
    user = User.find(user_id)
    kudo = Kudo.find(kudo_id)
    @pseud = kudo.pseud
    @commentable = kudo.commentable
    mail(
      :to => user.email,
      :subject => "[#{ArchiveConfig.APP_NAME}] Kudos on " + @commentable.commentable_name
    )
  end

end
