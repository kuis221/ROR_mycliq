class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy, :remove_background_image]

  def new
    @event = current_user.events.new
  end

  def create
    params[:event].delete(:background_image) if params[:event][:remove_image] != "1"
    @event = current_user.events.new(event_params)
    if @event.save
      respond_to do |format|
        format.html {redirect_to :back, notice: "Event Created"}
      end
    else
      redirect_to :back, notice: @event.errors.full_messages.join(", ")
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      respond_to do |format|
        format.html { redirect_to user_path(@event.user.username), notice: "event Updated" }
      end
    else
      redirect_to event_path(@event), notice: "Something went wrong"
    end
  end

  def destroy
    respond_to do |format|
      format.html { redirect_to user_path(@event.user.username), notice: "event Destroyed" }
    end
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
