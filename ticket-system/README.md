チケットID（２０桁）
(アルファベット3文字(固有))-(英数４文字)-(英数４文字)-(英数４文字)-(英数5文字（ランダム))
|_______________________|
        興行主ID
|___________________________________|
                興行ID
|_______________________________________________|
                    公演ID
|__________________________________________________________|
                            券種ID
|__________________________________________________________________________________|
                                    チケットID

例：J1リーグマリノス対鹿島 チケットID：
JLG-24J1-YMKA-1W15-DF39E
興行主ID: JLG
興行ID: JLG-24J1
公演ID: JLG-24J1-YMKA
券種ID: JLG-24J1-YMKA-1W15
チケットID: JLG-24J1-YMKA-1W15-DF39E


「興行主Aの興行で、プレイガイドBによって売られた特典付きのチケットの中で、2024年1月中に行われるイベントのもので、一度でも人に渡したことのあるものを検索する」
ticket-er-diagram.drawioファイルで記述されているデータベース構造について、プレイガイドBによって売られた特典付きのチケットの中で、2024年1月中に行われるイベントのもので、一度でも人に渡したことのあるものを検索するためのSQLはどうなるか？

以下のようなSQLクエリで、指定された条件のチケットを検索できます：
```sql
SELECT DISTINCT t.*
FROM tickets t
JOIN events e ON t.event_id = e.id
JOIN ticket_types tt ON t.ticket_type_id = tt.id
JOIN ticket_transfers tf ON t.id = tf.ticket_id
WHERE tt.seller_id = 'B'  -- プレイガイドBによって売られたチケット
AND tt.has_bonus = true   -- 特典付きチケット
AND e.event_date >= '2024-01-01'  -- 2024年1月中のイベント
AND e.event_date <= '2024-01-31'
AND tf.transfer_date IS NOT NULL;  -- 一度でも人に渡したことのあるチケット
```
このSQLクエリの説明：
ticketsテーブルを基準に、関連するevents、ticket_types、ticket_transfersテーブルを結合します
以下の条件でフィルタリングしています：
ticket_types.seller_id = 'B' でプレイガイドBのチケットに限定
ticket_types.has_bonus = true で特典付きチケットに限定
events.event_date で2024年1月中のイベントに限定
ticket_transfers.transfer_date IS NOT NULL で譲渡履歴のあるチケットに限定
DISTINCTを使用して重複を除外しています（同じチケットが複数回譲渡されている場合に備えて）



「公演Cのチケットのうち、券種Aで、かつまだ消し込みされていないものがある「チケットを閲覧する単位」の数」
→チケットIDが'JLG-24J1-YMKA-1W15'から始まるIDで、かつ使用されていないチケットを含む予約の数を取得するSQLを記述せよ。

以下のSQLクエリで、指定された条件の予約数を取得できます：
```sql
SELECT COUNT(DISTINCT r.id) 
FROM reservations r
JOIN tickets t ON r.id = t.reservation_id
WHERE t.ticket_id LIKE 'JLG-24J1-YMKA-1W15%'
AND t.is_used = false;
```
このSQLクエリの説明：
reservationsテーブルとticketsテーブルを結合します
以下の条件でフィルタリングしています：
ticket_id LIKE 'JLG-24J1-YMKA-1W15%' で指定されたIDパターンに一致するチケット
is_used = false で未使用のチケット
COUNT(DISTINCT r.id) で予約の数をカウント
DISTINCTを使用することで、同じ予約内に複数の該当チケットがある場合でも1つとしてカウント
このクエリは、指定されたチケットIDパターンに一致し、かつ未使用のチケットを含む予約の総数を返します。