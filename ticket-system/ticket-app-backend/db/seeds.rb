# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(name: 'Admin User',
             email: 'admin@example.com',
             password: 'foobarbaz',
             password_confirmation: 'foobarbaz',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name: 'Takeshita Yoshiki',
             email: 'yoshiki@example.com',
             password: 'foobarbaz',
             password_confirmation: 'foobarbaz',
             admin: false,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name: 'Chatani Tomohito',
             email: 'tomohito@example.com',
             password: 'foobarbaz',
             password_confirmation: 'foobarbaz',
             admin: false,
             activated: true,
             activated_at: Time.zone.now)

Promoter.create!(name: 'J League') #promoter_id: 1
Promoter.create!(name: 'B League') #promoter_id: 2

TicketAgency.create!(name: 'J League Ticket', api_key: '1234567890') #ticket_agency_id: 1  
TicketAgency.create!(name: 'B League Ticket', api_key: '0987654321') #ticket_agency_id: 2
TicketAgency.create!(name: 'チケットぴあ', api_key: '1111111111') #ticket_agency_id: 3

Venue.create!(name: '新国立競技場') #venue_id: 1
Venue.create!(name: '日産スタジアム') #venue_id: 2

Entrance.create!(name: 'Gate A', venue_id: 1) #entrance_id: 1
Entrance.create!(name: 'Gate C', venue_id: 1) #entrance_id: 2
Entrance.create!(name: 'Gate E', venue_id: 1) #entrance_id: 3
Entrance.create!(name: 'Gate G', venue_id: 1) #entrance_id: 4

Entrance.create!(name: 'West Gate', venue_id: 2) #entrance_id: 5
Entrance.create!(name: 'East Gate', venue_id: 2) #entrance_id: 6

Performance.create!(name: '明治安田J1リーグ2025', promoter_id: 1) #performance_id: 1
Performance.create!(name: 'B League2025', promoter_id: 2) #performance_id: 2

Event.create!(name: '第1節東京Ｖvs清水', performance_id: 1, venue_id: 1, start_time: '2025-02-16 14:00:00', end_time: '2025-02-16 16:00:00') #event_id: 1
Event.create!(name: '第1節横浜FMvs新潟', performance_id: 1, venue_id: 2, start_time: '2025-02-15 14:00:00', end_time: '2025-02-15 16:00:00') #event_id: 2

TicketType.create!(name: 'メインSS', event_id: 1, entrance_id: 2) #ticket_type_id: 1
TicketType.create!(name: 'ホーム自由', event_id: 2, entrance_id: 5) #ticket_type_id: 2

Reservation.create!(name: '東京Ｖvs清水', user_id: 1, ticket_agency_id: 1) #reservation_id: 1
Ticket.create!(reservation_id: 1, user_id: 1, ticket_type_id: 1) #ticket_id: 1
Ticket.create!(reservation_id: 1, user_id: 2, ticket_type_id: 1) #ticket_id: 2

Reservation.create!(name: '横浜FMvs新潟', user_id: 2, ticket_agency_id: 2) #reservation_id: 2
Ticket.create!(reservation_id: 2, user_id: 1, ticket_type_id: 2) #ticket_id: 3
Ticket.create!(reservation_id: 2, user_id: 2, ticket_type_id: 2) #ticket_id: 4


