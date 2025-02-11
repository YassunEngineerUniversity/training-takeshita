module Api
  module Admin
    class ReservationsController < ApplicationController
      before_action :admin_user

      def index
        @reservations = Reservation.all

        reservations_data = @reservations.map do |reservation|
          user_name = User.find_by(id: reservation.user_id)&.name
          tickets = Ticket.where(reservation_id: reservation.id)
          tickets_data = tickets.map do |ticket|
            ticket_id = ticket.id
            ticket_type = TicketType.find_by(id: ticket.ticket_type_id)
            ticket_user_name = User.find_by(id: ticket.user_id)&.name
            ticket.as_json.merge(
              ticket_user_name: ticket_user_name,
              ticket_type: ticket_type,              
            )
          end

          reservation.as_json.merge(
            reservation_user_name: user_name,
            tickets_data: tickets_data,
          )
        end
        render json: reservations_data, status: :ok
      end

      def show
        render json: { message: 'Hello, world!' }, status: :ok
      end

      def create
        # render json: { message: 'Hello, world!' }, status: :ok
      end
    end
  end
end
