'use client'

import { useState, useEffect } from 'react'
import { useParams } from 'next/navigation'
import Post from '@/components/Post'
import CommentForm from '@/components/CommentForm'
import CommentList from '@/components/CommentList'

export default function PostDetail() {
  const { id } = useParams()
  const [post, setPost] = useState(null)

  useEffect(() => {
    // Fetch post details
    const fetchPost = async () => {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_ENDPOINT}/posts/${id}`)
      const data = await response.json()
      setPost(data)
    }
    fetchPost()
  }, [id])

  const handleLike = async () => {
    // Implement like logic here
  }

  if (!post) return <div>Loading...</div>

  return (
    <div>
      <Post post={post} onLike={handleLike} />
      <CommentForm postId={id as string} />
      <CommentList postId={id as string} />
    </div>
  )
}

