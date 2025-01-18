'use client'

import { useState, useEffect } from 'react'
import Post, {type PostProps} from './Post'

interface PostListProps {
  apiUrl: string
}


export default function PostList({ apiUrl }: PostListProps) {
  
  const [posts, setPosts] = useState<PostProps[]>([])

  useEffect(() => {
    (async () => {
      try {
        const response = await fetch(apiUrl, {
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
  }, [apiUrl])

  return (
    <div className="space-y-4">
      {posts.map((post) => (
        <Post
          key={post.id}
          id ={post.id}
          content={post.content}
          user_id={post.user_id}
          user_name={post.user_name}
          created_at={post.created_at}
          updated_at={post.updated_at}
          liked={post.liked}
        />
      ))}
    </div>
  )
}
