"use client"

import { useEffect, useState } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Checkbox } from "@/components/ui/checkbox"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { PlusCircle, X, CalendarIcon } from "lucide-react"
import { Calendar } from "@/components/ui/calendar"
import { format } from "date-fns"
import { ja } from "date-fns/locale"
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover"
import { cn } from "@/lib/utils"

interface TicketType {
  id: number
  name: string
  event_id: number
  entrance_id: number
  created_at: string
  updated_at: string
}

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
  ticket_user_name: string
  ticket_type: TicketType
  perks_data?: Perk[]
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
  const [performanceId, setPerformanceId] = useState<string>('')
  const [eventIds, setEventIds] = useState<string[]>([''])
  const [ticketAgencyIds, setTicketAgencyIds] = useState<string[]>([''])
  const [startDate, setStartDate] = useState<Date | undefined>(undefined)
  const [endDate, setEndDate] = useState<Date | undefined>(undefined)

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

  // 日付を "YYYY-MM-DD HH:MM:SS" 形式にフォーマットする関数
  const formatDateToQueryParam = (date: Date | undefined): string | null => {
    if (!date) return null;
    return format(date, "yyyy-MM-dd HH:mm:ss");
  };

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

      // 興行IDが有効な数値かチェック
      const validPerformanceId = performanceId.trim() !== '' && !isNaN(Number(performanceId)) && Number(performanceId) > 0 
        ? Number(performanceId) 
        : null;

      // クエリパラメーターを構築
      const params = new URLSearchParams();
      
      if (includeNotUsedTickets) {
        params.append('not_used_ticket', 'true');
      }
      
      // 興行IDを追加
      if (validPerformanceId) {
        params.append('performance_id', validPerformanceId.toString());
      }
      
      // 各イベントIDを個別のパラメーターとして追加
      validEventIds.forEach(id => {
        params.append('event_ids[]', id.toString());
      });
      
      // 各プレイガイドIDを個別のパラメーターとして追加
      validTicketAgencyIds.forEach(id => {
        params.append('ticket_agency_ids[]', id.toString());
      });

      // 開始日時と終了日時を追加
      const formattedStartDate = formatDateToQueryParam(startDate);
      if (formattedStartDate) {
        params.append('start_time', formattedStartDate);
      }

      const formattedEndDate = formatDateToQueryParam(endDate);
      if (formattedEndDate) {
        params.append('end_time', formattedEndDate);
      }

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

  // チケットを使用する関数
  const handleUseTicket = async (ticketId: number) => {
    try {
      const response = await fetch(`/api/admin/tickets/${ticketId}/use`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': process.env.NEXT_PUBLIC_API_KEY || '',
        },
      });

      if (!response.ok) {
        throw new Error('チケットの使用に失敗しました');
      }

      // 成功したら予約データを再取得
      fetchReservations();
    } catch (error) {
      console.error('チケット使用エラー:', error);
      setError(error instanceof Error ? error.message : 'チケットの使用中にエラーが発生しました');
    }
  };

  // 特典を使用する関数
  const handleUsePerk = async (ticketId: number, perkId: number) => {
    try {
      const response = await fetch(`/api/admin/tickets/${ticketId}/perks/${perkId}/use`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': process.env.NEXT_PUBLIC_API_KEY || '',
        },
      });

      if (!response.ok) {
        throw new Error('特典の使用に失敗しました');
      }

      // 成功したら予約データを再取得
      fetchReservations();
    } catch (error) {
      console.error('特典使用エラー:', error);
      setError(error instanceof Error ? error.message : '特典の使用中にエラーが発生しました');
    }
  };

  useEffect(() => {
    fetchReservations()
  }, [includeNotUsedTickets, performanceId, eventIds, ticketAgencyIds, startDate, endDate])

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
            <div className="text-sm font-medium">興行ID</div>
            <div className="flex items-center">
              <Input
                type="number"
                placeholder="興行ID"
                value={performanceId}
                onChange={(e) => setPerformanceId(e.target.value)}
                className="w-24"
                min="1"
              />
            </div>
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

          <div className="flex flex-col gap-2">
            <div className="text-sm font-medium">開催期間</div>
            <div className="flex items-center gap-2">
              <div className="grid gap-2">
                <Popover>
                  <PopoverTrigger asChild>
                    <Button
                      variant={"outline"}
                      className={cn(
                        "w-[140px] justify-start text-left font-normal",
                        !startDate && "text-muted-foreground"
                      )}
                    >
                      <CalendarIcon className="mr-2 h-4 w-4" />
                      {startDate ? format(startDate, "yyyy/MM/dd", { locale: ja }) : "開始日"}
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto p-0">
                    <Calendar
                      mode="single"
                      selected={startDate}
                      onSelect={setStartDate}
                      initialFocus
                    />
                  </PopoverContent>
                </Popover>
              </div>
              <span>〜</span>
              <div className="grid gap-2">
                <Popover>
                  <PopoverTrigger asChild>
                    <Button
                      variant={"outline"}
                      className={cn(
                        "w-[140px] justify-start text-left font-normal",
                        !endDate && "text-muted-foreground"
                      )}
                    >
                      <CalendarIcon className="mr-2 h-4 w-4" />
                      {endDate ? format(endDate, "yyyy/MM/dd", { locale: ja }) : "終了日"}
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto p-0">
                    <Calendar
                      mode="single"
                      selected={endDate}
                      onSelect={setEndDate}
                      initialFocus
                    />
                  </PopoverContent>
                </Popover>
              </div>
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
                            <div className="flex items-center gap-2">
                              <Badge variant={ticket.used ? "secondary" : "default"}>
                                {ticket.used ? "使用済み" : "未使用"}
                              </Badge>
                              {!ticket.used && (
                                <Button 
                                  variant="outline" 
                                  size="sm"
                                  onClick={() => handleUseTicket(ticket.id)}
                                >
                                  使用する
                                </Button>
                              )}
                            </div>
                          </div>
                          
                          {ticket.perks_data && ticket.perks_data.length > 0 && (
                            <div className="mt-3 pt-3 border-t">
                              <p className="text-sm text-gray-500 mb-2">特典情報</p>
                              <div className="space-y-2">
                                {ticket.perks_data.map((perk) => (
                                  <div
                                    key={perk.perk_id}
                                    className="border p-3 rounded-lg"
                                  >
                                    <div className="flex items-center justify-between mb-2">
                                      <p className="font-medium">{perk.perk_name}</p>
                                      <div className="flex items-center gap-2">
                                        <Badge variant={perk.perk_used ? "secondary" : perk.perk_active ? "default" : "outline"}>
                                          {perk.perk_used ? "使用済み" : perk.perk_active ? "利用可能" : "期間外"}
                                        </Badge>
                                        {!perk.perk_used && perk.perk_active && (
                                          <Button 
                                            variant="outline" 
                                            size="sm"
                                            onClick={() => handleUsePerk(ticket.id, perk.perk_id)}
                                          >
                                            使用する
                                          </Button>
                                        )}
                                      </div>
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