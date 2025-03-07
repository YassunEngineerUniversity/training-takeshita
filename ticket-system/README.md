<!-- チケット識別子（２０桁）
(アルファベット3文字(固有))-(英数４文字)-(英数４文字)-(英数４文字)-(英数5文字（ランダム))
|_______________________|
        興行主識別子
|___________________________________|
                興行識別子
|_______________________________________________|
                    公演識別子
|__________________________________________________________|
                            券種識別子
|__________________________________________________________________________________|
                                    チケット識別子

例：J1リーグマリノス対鹿島 チケット識別子：
JLG-24J1-YMKA-1W15-DF39E
興行主識別子: JLG
興行識別子: JLG-24J1
公演識別子: JLG-24J1-YMKA
券種識別子: JLG-24J1-YMKA-1W15
チケット識別子: JLG-24J1-YMKA-1W15-DF39E -->


検索の課題
「J League」の興行で、チケットぴあによって売られた特典付きのチケットの中で、2025年2月中に行われるイベントのもので、一度でも人に渡したことのあるものを検索する

```sql
SELECT DISTINCT t.*
FROM tickets t
JOIN ticket_types tt ON t.ticket_type_id = tt.id
JOIN events e ON tt.event_id = e.id
JOIN performances p ON e.performance_id = p.id
JOIN promoters pr ON p.promoter_id = pr.id
JOIN reservations r ON t.reservation_id = r.id
JOIN ticket_agencies ta ON r.ticket_agency_id = ta.id
JOIN ticket_transfer_histories tth ON t.id = tth.ticket_id
JOIN ticket_type_perks ttp ON tt.id = ttp.ticket_type_id
JOIN perks pk ON ttp.perk_id = pk.id
WHERE pr.name = 'J League'
AND ta.name = 'チケットぴあ'
AND e.start_time >= '2025-02-01 00:00:00'
AND e.end_time <= '2025-02-28 23:59:59'
AND tth.id IS NOT NULL;
```


「第1節東京Ｖvs清水」のチケットのうち、券種「メインSS」で、かつまだ消し込みされていないものがある予約の数
```sql
SELECT COUNT(DISTINCT reservations.id)
FROM reservations
JOIN tickets ON tickets.reservation_id = reservations.id
JOIN ticket_types ON tickets.ticket_type_id = ticket_types.id
JOIN events ON ticket_types.event_id = events.id
WHERE events.name = '第1節東京Ｖvs清水'
AND ticket_types.name = 'メインSS'
AND tickets.used = false;
```