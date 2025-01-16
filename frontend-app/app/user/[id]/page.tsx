'use client'

import { useParams } from 'next/navigation'
import { useState, useEffect } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Avatar, AvatarFallback } from "@/components/ui/avatar"
import { Skeleton } from "@/components/ui/skeleton"
import Post from "@/components/Post"
import FollowButton from '@/components/FollowButton'


interface UserInfo {
  user_id: number
  name: string
  registration_date: string
  followed: boolean
}

interface UserData {
  user_info: UserInfo
  posts_info: {
    id: number
    content: string
    user_id: number
    user_name: string
    created_at: string
    updated_at: string
    liked: boolean
  }[]
}

export default function UserDetailContent() {
  const { id } = useParams()
  const [userData, setUserData] = useState<UserData | null>(null)
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const fetchUserData = async () => {
      setIsLoading(true)
      setError(null)
      try {
        const response = await fetch(`/api/users/${id}/`)
        if (!response.ok) {
          throw new Error('Failed to fetch user data')
        }
        const data: UserData = await response.json()
        setUserData(data)
      } catch (err) {
        setError(err instanceof Error ? err.message : 'An error occurred')
      } finally {
        setIsLoading(false)
      }
    }

    fetchUserData()
  }, [id])

  if (isLoading) {
    return <LoadingSkeleton />
  }

  if (error) {
    return <ErrorDisplay message={error} />
  }

  if (!userData) {
    return <ErrorDisplay message="No user data found" />
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <UserInfoCard userInfo={userData.user_info} />
      <div>
        {userData.posts_info.map((post, index) => (
          <Post key={index} post={post} />
        ))}
      </div>
    </div>
  )
}

function UserInfoCard({ userInfo }: { userInfo: UserInfo }) {
  return (
    <Card className="mb-8">
      <CardHeader className="flex flex-row items-center gap-4">
        <Avatar className="h-16 w-16">
          <AvatarFallback>{userInfo.name.charAt(0)}</AvatarFallback>
        </Avatar>
        <div>
          <div>User ID: {userInfo.user_id}</div>
          <CardTitle>{userInfo.name}</CardTitle>
          <p className="text-sm text-muted-foreground">
            Joined {new Date(userInfo.registration_date).toLocaleDateString()}
          </p>
        </div>
        <div>
          <FollowButton 
            userId={userInfo.user_id} 
            initialFollowed={userInfo.followed}
          />
        </div>
      </CardHeader>
    </Card>
  )
}

function LoadingSkeleton() {
  return (
    <div className="container mx-auto px-4 py-8">
      <Card className="mb-8">
        <CardHeader className="flex flex-row items-center gap-4">
          <Skeleton className="h-16 w-16 rounded-full" />
          <div className="space-y-2">
            <Skeleton className="h-4 w-[200px]" />
            <Skeleton className="h-4 w-[150px]" />
          </div>
        </CardHeader>
      </Card>
      <div className="space-y-4">
        <Skeleton className="h-8 w-[150px]" />
        {[1, 2, 3].map((i) => (
          <Card key={i}>
            <CardContent className="pt-6">
              <Skeleton className="h-4 w-full mb-2" />
              <Skeleton className="h-4 w-full mb-2" />
              <Skeleton className="h-4 w-2/3" />
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  )
}

function ErrorDisplay({ message }: { message: string }) {
  return (
    <div className="container mx-auto px-4 py-8">
      <Card className="bg-red-50 border-red-200">
        <CardHeader>
          <CardTitle className="text-red-800">Error</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-red-600">{message}</p>
        </CardContent>
      </Card>
    </div>
  )
}

