"use client"

import { useState } from 'react'
import { Heart } from 'lucide-react'
import { Button } from './ui/button'

type HeartButtonProps = {
  postId: number
  initialLiked?: boolean
}

export function HeartButton({ postId, initialLiked }: HeartButtonProps) {
  const [isLiked, setIsLiked] = useState(initialLiked)
  const [isLoading, setIsLoading] = useState(false)

  const handleLikeClick = async () => {
    setIsLoading(true)
    try {
      const response = await fetch(`/api/posts/${postId}/like`, {
        method: isLiked ? 'DELETE' : 'POST',
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
        },
      })

      if (!response.ok) {
        throw new Error('いいねの処理に失敗しました')
      }

      setIsLiked(!isLiked)
    } catch (error) {
      console.error('いいねの処理中にエラーが発生しました:', error)
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <Button
      variant="ghost"
      size="sm"
      onClick={handleLikeClick}
      disabled={isLoading}
    >
      {isLiked ? (
        <Heart className="h-5 w-5 fill-red-500 text-red-500" />
      ) : (
        <Heart className="h-5 w-5" />
      )}
    </Button>
  )
}