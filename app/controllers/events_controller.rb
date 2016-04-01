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
    @page_header = "My events"
    @events = Event.where(user_id: current_user.id).order(created_at: :desc)
                   .paginate(page: params[:page], per_page: 3)
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
