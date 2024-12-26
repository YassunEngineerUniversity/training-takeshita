'use client'

import { useState } from 'react'
import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"

type CommentFormProps = {
  postId: string
}

export default function CommentForm({ postId }: CommentFormProps) {
  const [content, setContent] = useState('')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    // Implement comment creation logic here
    // Clear the form after successful comment creation
    setContent('')
  }

  return (
    <form onSubmit={handleSubmit} className="mt-4">
      <Textarea
        value={content}
        onChange={(e) => setContent(e.target.value)}
        placeholder="Add a comment..."
        className="mb-2"
      />
      <Button type="submit" disabled={content.length === 0}>Comment</Button>
    </form>
  )
}

