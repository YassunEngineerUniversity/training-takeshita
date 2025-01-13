'use client'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { Button } from "@/components/ui/button"
import { useAuth } from '@/contexts/AuthContext';

export default function Header() {
  const router = useRouter()
  const { user } = useAuth();

  const handleLogin = () => {
    // Implement logout logic here
    router.push('/login')
  }

  // const handleLogout = () => {
  //   // Implement logout logic here
  //   router.push('/login')
  // }

  return (
    <header className="bg-white shadow-md">
      <div className="container mx-auto px-4 py-4 flex justify-between items-center">
        <h1 className="text-xl font-bold">Twitter Clone</h1>
        {user ? (
          <div className="flex items-center space-x-4">
            <Link href={`/user/${user.id}`} className="font-bold hover:underline">
              <span>{user.name}</span>
            </Link>
            <Button onClick={handleLogin}>Logout</Button>
          </div>
        ) : (
          <Button onClick={handleLogin}>Login</Button>
        )}
      </div>
    </header>
  )
}

