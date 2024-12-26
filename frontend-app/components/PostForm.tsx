'use client'

import { useState } from 'react'
import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"

export default function PostForm() {
  const [content, setContent] = useState('')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    // Implement post creation logic here
    // Clear the form after successful post creation
    setContent('')
  }

  return (
    <form onSubmit={handleSubmit} className="mb-8">
      <Textarea
        value={content}
        onChange={(e) => setContent(e.target.value)}
        placeholder="What's happening?"
        maxLength={120}
        className="mb-2"
      />
      <Button type="submit" disabled={content.length === 0}>Post</Button>
    </form>
  )
}

