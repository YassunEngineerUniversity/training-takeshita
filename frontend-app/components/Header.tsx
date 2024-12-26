'use client'

import { useRouter } from 'next/navigation'
import { Button } from "@/components/ui/button"

export default function Header() {
  const router = useRouter()
  const username = "CurrentUser" // This should be fetched from your auth state

  const handleLogout = () => {
    // Implement logout logic here
    router.push('/login')
  }

  return (
    <header className="bg-white shadow-md">
      <div className="container mx-auto px-4 py-4 flex justify-between items-center">
        <h1 className="text-xl font-bold">Twitter Clone</h1>
        <div className="flex items-center space-x-4">
          <span>{username}</span>
          <Button onClick={handleLogout}>Logout</Button>
        </div>
      </div>
    </header>
  )
}

