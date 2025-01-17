class GroupMailer < BaseMailer
  layout 'invite_people_mailer'

  def group_announced(recipient_id, event_id)
    @recipient = User.find_by!(id: recipient_id)
    @event = Event.find_by!(id: event_id)
    @membership = Membership.find_by!(group_id: @event.eventable_id, user_id: recipient_id)
    @inviter = @event.user || @membership.inviter

    send_single_mail to:     @recipient.email,
                     locale: @recipient.locale,
                     from:   from_user_via_loomio(@inviter),
                     reply_to: @inviter.name_and_email,
                     subject_key: "email.to_join_group.subject",
                     subject_params: {member: @inviter.name,
                                      group_name: @membership.group.full_name,
                                      site_name: AppConfig.theme[:site_name]}
  end

  def membership_requested(recipient_id, event_id)
    recipient = User.find_by!(id: recipient_id)
    event = Event.find_by!(id: event_id)
    @membership_request = event.eventable
    @group = @membership_request.group
    @introduction = @membership_request.introduction
    send_single_mail  to: recipient.name_and_email,
                      reply_to: "\"#{@membership_request.name}\" <#{@membership_request.email}>",
                      subject_key: "email.membership_request.subject",
                      subject_params: {who: @membership_request.name, which_group: @group.full_name, site_name: AppConfig.theme[:site_name]},
                      locale: recipient.locale
  end

  def destroy_warning(group_id, recipient_id, deletor_id)
    @group = Group.find(group_id)
    @recipient = User.find(recipient_id)
    @deletor = User.find(deletor_id)

    send_single_mail  to: @recipient.name_and_email,
                      reply_to: ENV['SUPPORT_EMAIL'],
                      subject_key: "group_mailer.destroy_warning.subject",
                      locale: @recipient.locale
  end
end
