'use client'
import { useEffect } from 'react'
import Post from './Post'

export type PostData = {
  id: number
  content: string
  user_id: number
  created_at: string
  updated_at: string
}

export default function PostList() {
  let posts: PostData[] = []

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
        // APIレスポンスが配列であることを確認
        posts = Array.isArray(data) ? data : []
      } catch (error) {
        console.error('投稿の取得に失敗しました:', error)
      }        
    })()
  }, [])

  return (
    <div className="space-y-4">
      {posts.map((post) => (
        <Post
          key={post.id}
          id={post.id}
          content={post.content}
          userId={post.user_id}
          createdAt={post.created_at}
          updatedAt={post.updated_at}
        />
      ))}
    </div>
  )
}
