'use client'

import { useState, useEffect } from 'react'
import { useParams } from 'next/navigation'
import { Button } from "@/components/ui/button"
import PostList from '@/components/PostList'

export default function UserDetail() {
  const { id } = useParams()
  const [user, setUser] = useState(null)
  const [isFollowing, setIsFollowing] = useState(false)

  useEffect(() => {
    // Fetch user details
    const fetchUser = async () => {
      const response = await fetch(`/api/users/${id}`)
      const data = await response.json()
      setUser(data)
      setIsFollowing(data.isFollowing)
    }
    fetchUser()
  }, [id])

  const handleFollow = async () => {
    // Implement follow/unfollow logic here
    setIsFollowing(!isFollowing)
  }

  if (!user) return <div>Loading...</div>

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">{user.name}</h1>
      <Button onClick={handleFollow}>
        {isFollowing ? 'Unfollow' : 'Follow'}
      </Button>
      <h2 className="text-xl font-semibold mt-8 mb-4">User's Posts</h2>
      <PostList type="user" userId={id as string} />
    </div>
  )
}

