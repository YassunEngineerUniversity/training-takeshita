"use client"

import { useEffect, useState } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"

interface Perk {
  perk_id: number
  perk_name: string
  perk_active: boolean
  perk_valid_from: string
  perk_valid_until: string
  perk_used: boolean
}

interface Ticket {
  id: number
  reservation_id: number
  user_id: number
  ticket_type_id: number
  used: boolean
  created_at: string
  updated_at: string
  user_name: string
  event_name: string
  venue_name: string
  entrance_name: string
  ticket_type_name: string
  event_start_time: string
  event_end_time: string
  perks_data: Perk[]
}

export default function TicketsPage() {
  const [tickets, setTickets] = useState<Ticket[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const fetchTickets = async () => {
      try {
        const response = await fetch('/api/tickets', {
          headers: {
            'x-api-key': process.env.NEXT_PUBLIC_API_KEY || '',
          },
        })

        if (!response.ok) {
          throw new Error('チケットデータの取得に失敗しました')
        }

        const data = await response.json()
        setTickets(data)
      } catch (err) {
        setError(err instanceof Error ? err.message : 'チケットデータの取得中にエラーが発生しました')
      } finally {
        setIsLoading(false)
      }
    }

    fetchTickets()
  }, [])

  if (isLoading) {
    return <div className="container mx-auto px-4 py-8">読み込み中...</div>
  }

  if (error) {
    return <div className="container mx-auto px-4 py-8 text-red-500">{error}</div>
  }

  return (
    <main className="container mx-auto px-4 py-8">
      <h2 className="text-2xl font-bold mb-6">チケット一覧</h2>
      <div className="grid gap-6">
        {tickets.map((ticket) => (
          <Card key={ticket.id}>
            <CardHeader>
              <div className="flex items-center justify-between">
                <CardTitle>{ticket.event_name}</CardTitle>
                <Badge variant={ticket.used ? "secondary" : "default"}>
                  {ticket.used ? "使用済み" : "未使用"}
                </Badge>
              </div>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm text-gray-500">利用者名</p>
                    <p className="font-medium">{ticket.user_name}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">チケット種別</p>
                    <p className="font-medium">{ticket.ticket_type_name}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">会場</p>
                    <p className="font-medium">{ticket.venue_name}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">入場ゲート</p>
                    <p className="font-medium">{ticket.entrance_name}</p>
                  </div>
                </div>
                <div>
                  <p className="text-sm text-gray-500">開催日時</p>
                  <p className="font-medium">
                    {new Date(ticket.event_start_time).toLocaleString('ja-JP')} ～{' '}
                    {new Date(ticket.event_end_time).toLocaleString('ja-JP')}
                  </p>
                </div>
                {ticket.perks_data.length > 0 && (
                  <div>
                    <p className="text-sm text-gray-500 mb-2">特典情報</p>
                    <div className="space-y-2">
                      {ticket.perks_data.map((perk) => (
                        <div
                          key={perk.perk_id}
                          className="border p-3 rounded-lg"
                        >
                          <div className="flex items-center justify-between mb-2">
                            <p className="font-medium">{perk.perk_name}</p>
                            <Badge variant={perk.perk_used ? "secondary" : perk.perk_active ? "default" : "outline"}>
                              {perk.perk_used ? "使用済み" : perk.perk_active ? "利用可能" : "期間外"}
                            </Badge>
                          </div>
                          <p className="text-sm text-gray-500">
                            有効期間: {new Date(perk.perk_valid_from).toLocaleDateString('ja-JP')} ～{' '}
                            {new Date(perk.perk_valid_until).toLocaleDateString('ja-JP')}
                          </p>
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