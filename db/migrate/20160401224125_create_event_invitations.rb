class CreateEventInvitations < ActiveRecord::Migration
  def change
    create_table :event_invitations do |t|
      t.references :user, index: true
      t.references :event
      t.integer  :invitee_id
      t.string   :status, default: "sent"

      t.timestamps null: false
    end
  end
end
