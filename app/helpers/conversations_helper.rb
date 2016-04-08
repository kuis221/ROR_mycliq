module ConversationsHelper
  def mailbox_section(title, current_box, opts = {})
    opts[:class] = opts.fetch(:class, "")
    opts[:class] += " active" if title.downcase == current_box
    content_tag :li, link_to(title.capitalize, conversations_path(box: title.downcase)), opts
  end 

  def bold_unread(conversation, user, box)
    conversation.is_unread?(user) && (box == "inbox") ? "bold-unread" : "readed"
  end

  def bold_box(active, box)
    active == box  ? "bold-unread" : "readed"
  end

  def unread_messages_count
    # how to get the number of unread messages for the current user
    # using mailboxer
    current_user.mailbox.inbox(unread: true).count(:id, distinct: true) if current_user.mailbox
  end
end
