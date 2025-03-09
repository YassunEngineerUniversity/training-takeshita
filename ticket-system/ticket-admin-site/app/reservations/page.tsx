"use client"

import { useEffect, useState } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Checkbox } from "@/components/ui/checkbox"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { PlusCircle, X } from "lucide-react"

interface TicketType {
  id: number
  name: string
  event_id: number
  entrance_id: number
  created_at: string
  updated_at: string
}

interface Ticket {
  id: number
  reservation_id: number
  user_id: number
  ticket_type_id: number
  used: boolean
  created_at: string
  updated_at: string
  ticket_user_name: string
  ticket_type: TicketType
}

interface Reservation {
  id: number
  user_id: number
  ticket_agency_id: number
  created_at: string
  updated_at: string
  reservation_user_name: string
  tickets_data: Ticket[]
}

export default function ReservationsPage() {
  const [reservations, setReservations] = useState<Reservation[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [includeNotUsedTickets, setIncludeNotUsedTickets] = useState(false)
  const [eventIds, setEventIds] = useState<string[]>([''])
  const [ticketAgencyIds, setTicketAgencyIds] = useState<string[]>([''])

  const handleAddEventId = () => {
    setEventIds([...eventIds, ''])
  }

  const handleRemoveEventId = (index: number) => {
    const newEventIds = eventIds.filter((_, i) => i !== index)
    setEventIds(newEventIds.length > 0 ? newEventIds : [''])
  }

  const handleEventIdChange = (index: number, value: string) => {
    const newEventIds = [...eventIds]
    newEventIds[index] = value
    setEventIds(newEventIds)
  }

  const handleAddTicketAgencyId = () => {
    setTicketAgencyIds([...ticketAgencyIds, ''])
  }

  const handleRemoveTicketAgencyId = (index: number) => {
    const newTicketAgencyIds = ticketAgencyIds.filter((_, i) => i !== index)
    setTicketAgencyIds(newTicketAgencyIds.length > 0 ? newTicketAgencyIds : [''])
  }

  const handleTicketAgencyIdChange = (index: number, value: string) => {
    const newTicketAgencyIds = [...ticketAgencyIds]
    newTicketAgencyIds[index] = value
    setTicketAgencyIds(newTicketAgencyIds)
  }

  const fetchReservations = async () => {
    try {
      // 空の値を除外して有効なイベントID（自然数）のみを取得
      const validEventIds = eventIds
        .map(id => id.trim())
        .map(Number)
        .filter(id => !isNaN(id) && Number.isInteger(id) && id > 0)
        .sort((a, b) => a - b) // 昇順にソート

      // 空の値を除外して有効なプレイガイドID（自然数）のみを取得
      const validTicketAgencyIds = ticketAgencyIds
        .map(id => id.trim())
        .map(Number)
        .filter(id => !isNaN(id) && Number.isInteger(id) && id > 0)
        .sort((a, b) => a - b) // 昇順にソート

      // クエリパラメーターを構築
      const params = new URLSearchParams();
      
      if (includeNotUsedTickets) {
        params.append('not_used_ticket', 'true');
      }
      
      // 各イベントIDを個別のパラメーターとして追加
      validEventIds.forEach(id => {
        params.append('event_ids[]', id.toString());
      });
      
      // 各プレイガイドIDを個別のパラメーターとして追加
      validTicketAgencyIds.forEach(id => {
        params.append('ticket_agency_ids[]', id.toString());
      });

      const response = await fetch(`/api/admin/reservations?${params.toString()}`, {
        method: 'GET',
        headers: {
          'x-api-key': process.env.NEXT_PUBLIC_API_KEY || '',
        },
      })

      if (!response.ok) {
        throw new Error('予約データの取得に失敗しました')
      }

      const data = await response.json()
      setReservations(data)
    } catch (err) {
      setError(err instanceof Error ? err.message : '予約データの取得中にエラーが発生しました')
    } finally {
      setIsLoading(false)
    }
  }

  useEffect(() => {
    fetchReservations()
  }, [includeNotUsedTickets, eventIds, ticketAgencyIds])

  if (isLoading) {
    return <div className="container mx-auto px-4 py-8">読み込み中...</div>
  }

  if (error) {
    return <div className="container mx-auto px-4 py-8 text-red-500">{error}</div>
  }

  return (
    <main className="container mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold">予約一覧</h2>
        <div className="flex flex-col gap-4 md:flex-row">
          <div className="flex items-center gap-2">
            <Checkbox
              id="includeNotUsedTickets"
              checked={includeNotUsedTickets}
              onCheckedChange={(checked) => setIncludeNotUsedTickets(checked as boolean)}
            />
            <Label htmlFor="includeNotUsedTickets">
              未使用のチケットを含む予約
            </Label>
          </div>
          
          <div className="flex flex-col gap-2">
            <div className="text-sm font-medium">イベントID</div>
            <div className="flex flex-wrap items-center gap-2">
              {eventIds.map((eventId, index) => (
                <div key={index} className="flex items-center gap-2">
                  <div className="flex items-center">
                    <Input
                      type="number"
                      placeholder="イベントID"
                      value={eventId}
                      onChange={(e) => handleEventIdChange(index, e.target.value)}
                      className="w-28"
                      min="1"
                    />
                    {eventIds.length > 1 && (
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={() => handleRemoveEventId(index)}
                        className="ml-1"
                      >
                        <X className="h-4 w-4" />
                      </Button>
                    )}
                  </div>
                  {index === eventIds.length - 1 && (
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={handleAddEventId}
                    >
                      <PlusCircle className="h-4 w-4" />
                    </Button>
                  )}
                </div>
              ))}
            </div>
          </div>
          
          <div className="flex flex-col gap-2">
            <div className="text-sm font-medium">プレイガイドID</div>
            <div className="flex flex-wrap items-center gap-2">
              {ticketAgencyIds.map((agencyId, index) => (
                <div key={index} className="flex items-center gap-2">
                  <div className="flex items-center">
                    <Input
                      type="number"
                      placeholder="プレイガイドID"
                      value={agencyId}
                      onChange={(e) => handleTicketAgencyIdChange(index, e.target.value)}
                      className="w-36"
                      min="1"
                    />
                    {ticketAgencyIds.length > 1 && (
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={() => handleRemoveTicketAgencyId(index)}
                        className="ml-1"
                      >
                        <X className="h-4 w-4" />
                      </Button>
                    )}
                  </div>
                  {index === ticketAgencyIds.length - 1 && (
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={handleAddTicketAgencyId}
                    >
                      <PlusCircle className="h-4 w-4" />
                    </Button>
                  )}
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
      <div className="grid gap-6">
        {reservations.map((reservation) => (
          <Card key={reservation.id}>
            <CardHeader>
              <CardTitle>予約 #{reservation.id}</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div>
                  <p className="text-sm text-gray-500">予約者名</p>
                  <p className="font-medium">{reservation.reservation_user_name}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500">予約日時</p>
                  <p className="font-medium">
                    {new Date(reservation.created_at).toLocaleString('ja-JP')}
                  </p>
                </div>
                {reservation.tickets_data.length > 0 && (
                  <div>
                    <p className="text-sm text-gray-500 mb-2">チケット情報</p>
                    <div className="space-y-2">
                      {reservation.tickets_data.map((ticket) => (
                        <div
                          key={ticket.id}
                          className="border p-3 rounded-lg"
                        >
                          <div className="flex items-center justify-between">
                            <div>
                              <p><span className="font-medium">チケット種別:</span> {ticket.ticket_type.name}</p>
                              <p><span className="font-medium">利用者名:</span> {ticket.ticket_user_name}</p>
                            </div>
                            <Badge variant={ticket.used ? "secondary" : "default"}>
                              {ticket.used ? "使用済み" : "未使用"}
                            </Badge>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </main>
  )
} 