'use client'

import { useState, useEffect } from 'react'
import { useParams } from 'next/navigation'
import Post from '@/components/Post'
import type {PostData} from '@/components/PostList'
import CommentForm from '@/components/CommentForm'
import CommentList from '@/components/CommentList'

export default function PostDetail() {
  const { id } = useParams()
  const [post, setPost] = useState<PostData | undefined>(undefined)

  useEffect(() => {
    (async () => {
      try {
        const response = await fetch(`/api/posts/${id}`, {
          method: 'GET',
          credentials: 'include', 
          headers: {
            'Content-Type': 'application/json',
          }
        })
        const data = await response.json()
        setPost(data)
      } catch (error) {
        console.error('投稿の取得に失敗しました:', error)
        setPost(undefined)
      }        
    })()
  }, [id])


  const handleLike = async () => {
    // Implement like logic here
  }

  if (!post) return <div>Loading...</div>

  return (
    <div>
      <Post
        key={post.id}
        post={{
          id: post.id,
          content: post.content,
          user_id: post.user_id,
          user_name: post.user_name,
          created_at: post.created_at,
          updated_at: post.updated_at,
          liked: post.liked
        }}
      />
      {/* <CommentForm postId={post.id} />
      <CommentList postId={post.id} /> */}
    </div>
  )
}

