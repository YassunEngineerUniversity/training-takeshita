'use client'
import { useState, useEffect } from 'react'
import Post from './Post'

export type PostData = {
  id: number
  content: string
  user_id: number
  created_at: string
  updated_at: string
}

export default function PostList() {
  const [posts, setPosts] = useState<PostData[]>([])

  useEffect(() => {
    (async () => {
      try {
        const response = await fetch(`/api/posts?&page=1`, {
          method: 'GET',
          credentials: 'include', 
          headers: {
            'Content-Type': 'application/json',
          }
        })
        const data = await response.json()
        setPosts(Array.isArray(data) ? data : [])
      } catch (error) {
        console.error('投稿の取得に失敗しました:', error)
        setPosts([])
      }        
    })()
  }, [])

  return (
    <div className="space-y-4">
      {posts.map((post) => (
        <Post
          key={post.id}
          post={{
            id: post.id,
            content: post.content,
            user_id: post.user_id,
            created_at: post.created_at,
            updated_at: post.updated_at
          }}
        />
      ))}
    </div>
  )
}
