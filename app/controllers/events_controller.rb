class EventsController < ApplicationController

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      @event.host.add_points
      flash[:success] = "Event created! You now have #{@event.host.points} points!"
      redirect_to @event
    else
      render :new
    end
  end

  def update

  end

  def add_guest_to_event
    @event = Event.find(params[:event_id])
    if current_user.has_enough_points? && @event.add_guest_to_event(current_user)
      current_user.subtract_points
      flash[:notice] = "You now have #{@event.host.points} points! Can't wait to see you there!"
      redirect_to current_user
    else
      flash[:notice] = "Sorry, you don't have enough points to attend. Maybe it's time to host one!"
      redirect_to @event
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :address, :datetime, :points, :host_id, :interest_id)
  end
end
