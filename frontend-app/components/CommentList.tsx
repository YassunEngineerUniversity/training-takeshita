'use client'

import { useState, useEffect } from 'react'

type CommentType = {
  id: string
  content: string
  author: {
    id: string
    name: string
  }
}

type CommentListProps = {
  postId: string
}

export default function CommentList({ postId }: CommentListProps) {
  const [comments, setComments] = useState<CommentType[]>([])

  useEffect(() => {
    // Fetch comments
    const fetchComments = async () => {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_ENDPOINT}/posts/${postId}/comments`)
      const data = await response.json()
      setComments(data)
    }
    fetchComments()
  }, [postId])

  return (
    <div className="mt-4 space-y-2">
      {comments.map(comment => (
        <div key={comment.id} className="border p-2 rounded-md">
          <p className="font-bold">{comment.author.name}</p>
          <p>{comment.content}</p>
        </div>
      ))}
    </div>
  )
}