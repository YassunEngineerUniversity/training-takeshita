'use client'

import { useState, useEffect } from 'react'
import { useInView } from 'react-intersection-observer'
import Post, { type PostProps } from './Post'

interface PostListProps {
  apiUrl: string
}

export default function PostList({ apiUrl }: PostListProps) {
  const [posts, setPosts] = useState<PostProps[]>([])
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(true)
  const [isLoading, setIsLoading] = useState(false)
  const { ref, inView } = useInView()

  const fetchPosts = async () => {
    if (isLoading || !hasMore) return
    
    setIsLoading(true)
    try {
      const response = await fetch(`${apiUrl}?page=${page}`, {
        method: 'GET',
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
        }
      })
      const data = await response.json()
      
      if (Array.isArray(data) && data.length > 0) {
        setPosts(prev => [...prev, ...data])
        setPage(prev => prev + 1)
      } else {
        setHasMore(false)
      }
    } catch (error) {
      console.error('投稿の取得に失敗しました:', error)
    } finally {
      setIsLoading(false)
    }
  }

  useEffect(() => {
    if (inView) {
      fetchPosts()
    }
  }, [inView])

  // // apiUrlが変更されたら状態をリセット
  // useEffect(() => {
  //   setPosts([])
  //   setPage(1)
  //   setHasMore(true)
  // }, [apiUrl])

  return (
    <div className="space-y-4">
      {posts.map((post) => (
        <Post
          key={post.id}
          id={post.id}
          content={post.content}
          user_id={post.user_id}
          user_name={post.user_name}
          created_at={post.created_at}
          updated_at={post.updated_at}
          liked={post.liked}
        />
      ))}
      {hasMore && (
        <div ref={ref} className="h-10 flex items-center justify-center">
          {isLoading ? '読み込み中...' : ''}
        </div>
      )}
    </div>
  )
}
