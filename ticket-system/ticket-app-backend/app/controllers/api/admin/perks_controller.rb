module Api
  module Admin
    class PerksController < ApplicationController
      before_action :admin_user

      def index
        @perks = Perk.all

        render json: @perks, status: :ok
      end


      def show
        # render json: { message: 'Hello, world!' }, status: :ok
      end

      def create
        # render json: { message: 'Hello, world!' }, status: :ok
      end

      def use
        if Ticket.find_by(id: params[:ticket_id]).present? && Perk.find_by(id: params[:id]).present?
          unless PerkUsage.find_by(perk_id: params[:id], ticket_id: params[:ticket_id]).present?
            perk_usage = PerkUsage.create!(perk_id: params[:id], ticket_id: params[:ticket_id], used_at: Time.current)
            render json: { message: 'Perk used' }, status: :ok

          else
            render json: { message: 'Perk already used' }, status: :unprocessable_entity
          end
        else
          render json: { message: 'Perk or ticket not found' }, status: :not_found
        end

      end
    end
  end
end
