module Api
  module Admin
    class ReservationsController < ApplicationController
      before_action :admin_user

      def index
        @reservations = Reservation.all

        # paramsから値を取得
        performance_ids = params[:performance_id]
        event_ids = params[:event_id]
        ticket_agency_ids = params[:ticket_agency_id]
        event_start_time = params[:event_start_time]
        event_end_time = params[:event_end_time]
        not_used_ticket = params[:not_used_ticket]

        # reservations_dataをフィルタリング
        selected_reservations = @reservations.select do |reservation|
          # ticket_agency_idが一致するか
          ticket_agency_match = ticket_agency_ids.nil? || ticket_agency_ids.include?(reservation.ticket_agency_id)
          next false unless ticket_agency_match

          # not_used_ticketがtrueの場合、usedがfalseのチケットが存在するか
          not_used_match = !not_used_ticket || Ticket.where(reservation_id: reservation.id, used: false).exists?
          next false unless not_used_match

          # event_idが一致するか
          event_match = event_ids.nil? || Ticket.where(reservation_id: reservation.id, event_id: event_ids).exists?
          next false unless event_match
          binding.pry
          # # event_start_timeとevent_end_timeの範囲内か
          time_match = (event_start_time.nil? || event_end_time.nil?) || 
                      Ticket.where(reservation_id: reservation.id)
                            .where('event_start_time >= ? AND event_end_time <= ?', event_start_time, event_end_time)
                            .exists?

          time_match
          binding.pry
        end

        reservations_data = selected_reservations.map do |reservation|
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
