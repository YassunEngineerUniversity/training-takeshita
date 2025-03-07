module Api
  class ReservationsController < ApplicationController
    before_action :authorized_ticket_agency
    before_action :logged_in_user

    def index
      @reservations = Reservation.where(user_id: current_user.id, ticket_agency_id: @current_ticket_agency.id)

      # paramsから値を取得
      not_used_ticket = params[:not_used_ticket]
      event_ids = params[:event_ids]
      start_time = params[:start_time]
      end_time = params[:end_time]
      performance_id = params[:performance_id]

      # reservations_dataをフィルタリング
      selected_reservations = @reservations.select do |reservation|
        # 全てのフィルターがnilの場合、trueを返す
        if (not_used_ticket.nil? && performance_id.nil? && event_ids.nil? && start_time.nil? && end_time.nil?)
          next true
        end

        # not_used_ticketがtrueの場合、usedがfalseのチケットが存在するか
        # @ticketsは複数存在する可能性があり、また０の場合もある
        @tickets = Ticket.where(reservation_id: reservation.id)
        not_used_match = @tickets.exists? && (not_used_ticket.nil? || @tickets.where(used: false).exists?)
        next false unless not_used_match

        # event_idが一致するか
        @ticket_type = TicketType.find_by(id: @tickets[0].ticket_type_id)
        @event = Event.find_by(id: @ticket_type.event_id)
        event_match = event_ids.nil? || event_ids.include?(@event.id)
        next false unless event_match

        # # event.start_timeが指定された期間（start_time）の後か
        start_time_match = start_time.nil? || @event.start_time >= start_time
        next false unless start_time_match

        # # event.end_timeが指定された期間（end_time）の前か
        end_time_match = end_time.nil? || @event.end_time <= end_time
        next false unless end_time_match

        # performance_idが一致するか
        performance_match = performance_id.nil? || @event.performance_id == performance_id
        next false unless performance_match

        true
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

  end
end
