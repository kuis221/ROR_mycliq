class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :show, :update, :destroy, :remove_background_image]

  def index
    current_user_id = current_user.try(:id)
    @page_header = "All events"
    @events = Event.where("user_id = ? OR private = ?", current_user_id, false)
                   .order(created_at: :desc)
                   .paginate(page: params[:page], per_page: 3)
    render :index
  end

  def my
    @new_count = Event.not_replied_by(current_user).count
    @rejected_count = Event.rejected_by(current_user).count
    @accepted_count = Event.accepted_by(current_user).count

    @page_header = "My events"

    case params[:specify_my_events]
    when "accepted"
      @events = Event.accepted_by(current_user).order(created_at: :desc).paginate(page: params[:page], per_page: 3)
    when "rejected"
      @events = Event.rejected_by(current_user).order(created_at: :desc).paginate(page: params[:page], per_page: 3)
    when "new"
      @events = Event.not_replied_by(current_user).order(created_at: :desc).paginate(page: params[:page], per_page: 3)
    else
      @events = Event.where(user_id: current_user.id).order(created_at: :desc).paginate(page: params[:page], per_page: 3)
    end

    render :index
  end

  def new
    @event = current_user.events.new
  end

  def create
    params[:event].delete(:background_image) if params[:event][:remove_image] != "1"
    @event = current_user.events.new(event_params)
    if @event.save
      redirect_to events_path, notice: "Event Created"
    else
      redirect_to :back, notice: @event.errors.full_messages.join(", ")
    end
  end

  def edit
  end

  def update
    params[:event].delete(:background_image) if params[:event][:remove_image] != "1"
    if @event.update(event_params)
      redirect_to events_path, notice: "Event Updated"
    else
      redirect_to :back, notice: @event.errors.full_messages.join(", ")
    end
  end

  def show
    @acceptable_link = Event.not_replied_by(current_user).include?(@event)
  end

  def destroy
  end

  def remove_background_image
    @notice = "event background_image has been removed" unless @event.background_image.blank?
    @event.background_image = nil
    @event.save
    redirect_to :back, notice: @notice
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :private, :location, :start_at, :end_at, :background_image)
  end
end
