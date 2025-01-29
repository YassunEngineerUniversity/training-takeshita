module Api
  class TicketsController < ApplicationController
    before_action :authorized_ticket_agency
    before_action :logged_in_user

    def index
      @tickets = current_user.tickets
      @tickets = @tickets.select do |ticket|
        reservation = Reservation.find_by(id: ticket.reservation_id)
        reservation&.ticket_agency_id == @current_ticket_agency.id
      end

      tickets_data = @tickets.map do |ticket|
        ticket_type = TicketType.find_by(id: ticket.ticket_type_id)
        event = ticket_type&.event
        venue = event&.venue
        entrance = ticket_type&.entrance

        ticket.as_json.merge(
          event_name: event&.name,
          venue_name: venue&.name,
          entrance_name: entrance&.name,
          ticket_type_name: ticket_type&.name,
          event_start_time: event&.start_time,
          event_end_time: event&.end_time,
        )
      end

      render json: tickets_data, status: :ok
    end

    def show
      render json: { message: 'Hello, world!' }, status: :ok
    end

    def create
      # render json: { message: 'Hello, world!' }, status: :ok
    end

  end
end
