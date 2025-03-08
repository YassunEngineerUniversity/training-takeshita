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

User.create!(name: 'Test User',
             email: 'test@example.com',
             password: 'foobarbaz',
             password_confirmation: 'foobarbaz',
             admin: false,
             activated: true,
             activated_at: Time.zone.now)

Promoter.create!(name: 'J League') #promoter_id: 1
Promoter.create!(name: 'B League') #promoter_id: 2

TicketAgency.create!(name: 'Admin', api_key: '0000000000') #ticket_agency_id: 1  
TicketAgency.create!(name: 'J League Ticket', api_key: '1234567890') #ticket_agency_id: 2 
TicketAgency.create!(name: 'B League Ticket', api_key: '0987654321') #ticket_agency_id: 3
TicketAgency.create!(name: 'チケットぴあ', api_key: '1111111111') #ticket_agency_id: 4

Venue.create!(name: '新国立競技場') #venue_id: 1
Venue.create!(name: '日産スタジアム') #venue_id: 2
Venue.create!(name: '横浜国際プール') #venue_id: 3

# 新国立競技場
Entrance.create!(name: 'Gate A', venue_id: 1) #entrance_id: 1
Entrance.create!(name: 'Gate C', venue_id: 1) #entrance_id: 2
Entrance.create!(name: 'Gate E', venue_id: 1) #entrance_id: 3
Entrance.create!(name: 'Gate G', venue_id: 1) #entrance_id: 4

# 日産スタジアム
Entrance.create!(name: 'West Gate', venue_id: 2) #entrance_id: 5
Entrance.create!(name: 'East Gate', venue_id: 2) #entrance_id: 6

# 横浜国際プール
Entrance.create!(name: '正面エントランス', venue_id: 3) #entrance_id: 7
Entrance.create!(name: '南エントランス', venue_id: 3) #entrance_id: 9
Entrance.create!(name: 'メインアリーナ観客席入口', venue_id: 3) #entrance_id: 10

Performance.create!(name: '明治安田J1リーグ2025', promoter_id: 1) #performance_id: 1
Performance.create!(name: 'B League2025', promoter_id: 2) #performance_id: 2

#J League
Event.create!(name: '第1節東京Ｖvs清水', performance_id: 1, venue_id: 1, start_time: '2025-02-16 14:00:00', end_time: '2025-02-16 16:00:00') #event_id: 1
Event.create!(name: '第1節横浜FMvs新潟', performance_id: 1, venue_id: 2, start_time: '2025-02-15 14:00:00', end_time: '2025-02-15 16:00:00') #event_id: 2
Event.create!(name: '第4節横浜FMvs湘南', performance_id: 1, venue_id: 2, start_time: '2025-03-01 13:00:00', end_time: '2025-03-01 15:00:00') #event_id: 3
Event.create!(name: '第9節横浜FMvs東京Ｖ', performance_id: 1, venue_id: 2, start_time: '2025-04-05 14:00:00', end_time: '2025-04-05 16:00:00') #event_id: 4

#B League
Event.create!(name: '横浜BCvs川崎', performance_id: 2, venue_id: 3, start_time: '2025-01-29 19:00:00', end_time: '2025-01-29 21:00:00') #event_id: 5
Event.create!(name: '横浜BCvsSR渋谷', performance_id: 2, venue_id: 3, start_time: '2025-03-01 14:00:00', end_time: '2025-03-01 16:00:00') #event_id: 6

#J League
TicketType.create!(name: 'メインSS', event_id: 1, entrance_id: 2) #ticket_type_id: 1

TicketType.create!(name: 'ホーム自由', event_id: 2, entrance_id: 5) #ticket_type_id: 2

TicketType.create!(name: 'メインS', event_id: 3, entrance_id: 5) #ticket_type_id: 3

TicketType.create!(name: 'バックS', event_id: 4, entrance_id: 6) #ticket_type_id: 4

Perk.create!(name: 'ヴェルディスペシャルユニフォーム', active: true, valid_from: '2025-02-01 00:00:00', valid_until: '2025-02-28 23:59:59') #perk_id: 1
TicketTypePerk.create!(ticket_type_id: 1, perk_id: 1) #ticket_type_perk_id: 1

Perk.create!(name: 'マリノススペシャルユニフォーム', active: true, valid_from: '2025-02-01 00:00:00', valid_until: '2025-02-28 23:59:59') #perk_id: 1
TicketTypePerk.create!(ticket_type_id: 2, perk_id: 2) #ticket_type_perk_id: 2
TicketTypePerk.create!(ticket_type_id: 3, perk_id: 2) #ticket_type_perk_id: 3
TicketTypePerk.create!(ticket_type_id: 4, perk_id: 2) #ticket_type_perk_id: 4

#B League
TicketType.create!(name: '2階自由', event_id: 5, entrance_id: 7) #ticket_type_id: 5

TicketType.create!(name: '1階エンド', event_id: 6, entrance_id: 7) #ticket_type_id: 6


#J League
Reservation.create!(user_id: 2, ticket_agency_id: 2) #reservation_id: 1
Ticket.create!(reservation_id: 1, user_id: 2, ticket_type_id: 1) #ticket_id: 1
Ticket.create!(reservation_id: 1, user_id: 3, ticket_type_id: 1) #ticket_id: 2

Reservation.create!(user_id: 2, ticket_agency_id: 4) #reservation_id: 2
Ticket.create!(reservation_id: 2, user_id: 2, ticket_type_id: 2) #ticket_id: 3
Ticket.create!(reservation_id: 2, user_id: 3, ticket_type_id: 2) #ticket_id: 4

Reservation.create!(user_id: 2, ticket_agency_id: 2) #reservation_id: 3
Ticket.create!(reservation_id: 3, user_id: 2, ticket_type_id: 3) #ticket_id: 5
Ticket.create!(reservation_id: 3, user_id: 3, ticket_type_id: 3) #ticket_id: 6

Reservation.create!(user_id: 3, ticket_agency_id: 4) #reservation_id: 4
Ticket.create!(reservation_id: 4, user_id: 2, ticket_type_id: 4) #ticket_id: 7
Ticket.create!(reservation_id: 4, user_id: 3, ticket_type_id: 4) #ticket_id: 8



#B League
Reservation.create!(user_id: 2, ticket_agency_id: 3) #reservation_id: 5
Ticket.create!(reservation_id: 5, user_id: 2, ticket_type_id: 5) #ticket_id: 9
Ticket.create!(reservation_id: 5, user_id: 3, ticket_type_id: 5) #ticket_id: 10

Reservation.create!(user_id: 3, ticket_agency_id: 4) #reservation_id: 6
Ticket.create!(reservation_id: 6, user_id: 2, ticket_type_id: 6) #ticket_id: 11
Ticket.create!(reservation_id: 6, user_id: 3, ticket_type_id: 6) #ticket_id: 12

Reservation.create!(user_id: 2, ticket_agency_id: 4) #reservation_id: 7