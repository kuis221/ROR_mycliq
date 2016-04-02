class EventInvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:accept, :reject]

  def new
    @chosen_recipient = User.find_by(id: params[:to].to_i) if params[:to]
  end

  def create
    if !params["recipients"]
      redirect_to :back, notice: "Select recipients"
    else
      ActiveRecord::Base.transaction do
        invitees = User.where(username: params["recipients"].map { |p| p.split.last.gsub(/^\(+|\)+$/, "") })
        params[:user_id] = current_user.id
        invitees.each do |invitee|
          unless invitee.recieved_event_invitations.find_by(event_id: params[:event_id])
            invitee.recieved_event_invitations.create!(permitted_params)
          end
        end
      end
      redirect_to :back, notice: "Invitations sent"
    end

  rescue ActiveRecord::RecordInvalid => exc
    flash[:notice] = "#{exc.message}"
    redirect_to :back
  end

  def reject
    invitation = EventInvitation.find_by(event_id: @event.id, invitee_id: current_user.id)
    if invitation.update!(status: "rejected")
      redirect_to :back, notice: "Invitation rejected"
    else
      redirect_to :back, notice: @event.errors.full_messages.join(", ")
    end
  end

  def accept
    invitation = EventInvitation.find_by(event_id: @event.id, invitee_id: current_user.id)
    if invitation.update!(status: "accepted")
      redirect_to :back, notice: "Invitation accepted"
    else
      redirect_to :back, notice: @event.errors.full_messages.join(", ")
    end
  end

  private

  def set_event
    @event ||= Event.find(params[:id])
  end

  def permitted_params
    params.permit(:event_id, :user_id)
  end
end
