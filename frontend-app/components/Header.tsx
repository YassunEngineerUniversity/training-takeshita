'use client'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { Button } from "@/components/ui/button"
import { useAuth } from '@/contexts/AuthContext';

export default function Header() {
  const router = useRouter()
  const { user } = useAuth();

  const handleLogout = async () => {
    try {
      const response = await fetch('/api/login', {
        method: 'DELETE',
      })
      
      if (!response.ok) {
        throw new Error('Logout failed')
      }
      
      // Redirect to login page
      router.push('/login')
    } catch (error) {
      console.error('Logout error:', error)
      // Here you might want to show an error message to the user
    } finally {
    }
  }

  return (
    <header className="bg-white shadow-md">
      <div className="container mx-auto px-4 py-4 flex justify-between items-center">
        <h1 className="text-xl font-bold">Twitter Clone</h1>
        {user ? (
          <div className="flex items-center space-x-4">
            <Link href={`/user/${user.id}`} className="font-bold hover:underline">
              <span>{user.name}</span>
            </Link>
            <Button onClick={handleLogout}>Logout</Button>
          </div>
        ) : (<></>)}
      </div>
    </header>
  )
}

