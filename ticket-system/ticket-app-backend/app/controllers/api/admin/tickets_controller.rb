module Api
  module Admin
    class TicketsController < ApplicationController
      before_action :admin_user

      def index
        @tickets = Ticket.all

        tickets_data = @tickets.map do |ticket|
          user_name = User.find_by(id: ticket.user_id)&.name
          ticket_type = TicketType.find_by(id: ticket.ticket_type_id)
          event = ticket_type&.event
          venue = event&.venue
          entrance = ticket_type&.entrance
          perks = ticket_type&.perks
          perks_data = perks&.map do |perk|
            {
              perk_id: perk.id,
              perk_name: perk.name,
              perk_active: perk.active,
              perk_valid_from: perk.valid_from,
              perk_valid_until: perk.valid_until,
              perk_used: PerkUsage.find_by(perk_id: perk.id, ticket_id: ticket.id).present?
            }
          end




          ticket.as_json.merge(
            user_name: user_name,
            event_name: event&.name,
            venue_name: venue&.name,
            entrance_name: entrance&.name,
            ticket_type_name: ticket_type&.name,
            event_start_time: event&.start_time,
            event_end_time: event&.end_time,
            perks_data: perks_data,
            ticket_used: ticket&.used?,
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

      def use
        if params[:id].present?
          ticket = Ticket.find(params[:id])
          ticket.update(used: true)
          render json: { message: 'Ticket used' }, status: :ok
        else
          render json: { message: 'Ticket not found' }, status: :not_found
        end

      end
    end
  end
end
