"use client"

import Link from "next/link"
import { usePathname, useRouter } from "next/navigation"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { useUser } from "@/lib/context/user-context"

export function Header() {
  const pathname = usePathname()
  const router = useRouter()
  const { user, setUser } = useUser()

  const handleLogout = async () => {
    try {
      const response = await fetch('/api/login', {
        method: 'DELETE',
        headers: {
          'x-api-key': process.env.NEXT_PUBLIC_API_KEY || '',
        },
      })

      if (!response.ok) {
        throw new Error('ログアウトに失敗しました')
      }

      setUser(null)
      router.refresh()
    } catch (error) {
      console.error('ログアウトエラー:', error)
    }
  }

  return (
    <header className="w-full border-b">
      <div className="container mx-auto px-4 py-4">
        <div className="flex items-center justify-between">
          <Link href="/" className="hover:opacity-80 transition-opacity">
            <h1 className="text-2xl font-bold">チケット販売サイト</h1>
          </Link>
          <div className="flex items-center gap-6">
            <nav className="flex gap-4">
              <Link
                href="/reservations"
                className={cn(
                  "px-4 py-2 hover:text-primary transition-colors",
                  pathname === "/reservations" ? "border-b-2 border-primary" : ""
                )}
              >
                予約一覧
              </Link>
              <Link
                href="/tickets"
                className={cn(
                  "px-4 py-2 hover:text-primary transition-colors",
                  pathname === "/tickets" ? "border-b-2 border-primary" : ""
                )}
              >
                チケット一覧
              </Link>
            </nav>
            {user ? (
              <div className="flex items-center gap-4 ml-4">
                <div className="flex items-center gap-2">
                  <span className="text-sm font-medium bg-gray-100 px-3 py-1 rounded-full">
                    {user.name}
                  </span>
                  <Button 
                    variant="outline" 
                    size="sm" 
                    onClick={handleLogout}
                  >
                    ログアウト
                  </Button>
                </div>
              </div>
            ) : (
              <div className="ml-4">
                <Link href="/">
                  <Button variant="outline" size="sm">
                    ログイン
                  </Button>
                </Link>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  )
} 