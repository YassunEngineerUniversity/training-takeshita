'use client'

import { useState } from 'react'
import { MessageCircle } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"

export function CommentDialog({ postId }: { postId: number }) {
    const [comment, setComment] = useState('')
    const [isSubmitting, setIsSubmitting] = useState(false)
  
    const handleSubmit = async (e: React.FormEvent) => {
      e.preventDefault()
      setIsSubmitting(true)
      try {
        const response = await fetch(`/api/posts/${postId}/comments`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ "comment": { "content": comment } }),
        })
        if (!response.ok) {
          throw new Error('Failed to post comment')
        }
        setComment('')
        // Here you might want to update the UI to show the new comment
      } catch (error) {
        console.error('Error posting comment:', error)
        // Here you might want to show an error message to the user
      } finally {
        setIsSubmitting(false)
      }
    }
  
    return (
      <Dialog>
        <DialogTrigger asChild>
            <MessageCircle className="h-6 w-6" />
        </DialogTrigger>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>コメントを投稿</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleSubmit}>
            <Textarea
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              placeholder="Write your comment here..."
              maxLength={120}
              className="mb-4"
            />
            <Button type="submit" disabled={isSubmitting || comment.length === 0}>
              {isSubmitting ? 'Posting...' : 'Post Comment'}
            </Button>
          </form>
        </DialogContent>
      </Dialog>
    )
  }