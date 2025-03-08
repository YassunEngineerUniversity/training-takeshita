"use client"

import { useEffect, useState } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"

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

  useEffect(() => {
    const fetchReservations = async () => {
      try {
        const response = await fetch('/api/reservations', {
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

    fetchReservations()
  }, [])

  if (isLoading) {
    return <div className="container mx-auto px-4 py-8">読み込み中...</div>
  }

  if (error) {
    return <div className="container mx-auto px-4 py-8 text-red-500">{error}</div>
  }

  return (
    <main className="container mx-auto px-4 py-8">
      <h2 className="text-2xl font-bold mb-6">予約一覧</h2>
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