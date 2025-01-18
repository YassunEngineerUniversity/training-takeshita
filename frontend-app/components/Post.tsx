import Link from 'next/link'
import { HeartButton } from './HeartButton'
import { CommentDialog } from './CommentDialog'

export interface PostProps {
    id: number
    content: string
    user_id: number
    user_name: string
    created_at: string
    updated_at: string
    liked: boolean
}

export default function Post(post: PostProps) {
  return (
      <div className="border p-4 rounded-md">
        <div className="flex flex-col gap-2">
          <p><strong>User ID:</strong> {post.user_id}</p>
          <Link href={`/user/${post.user_id}`} className="font-bold hover:underline">
            <p><strong>User Name:</strong> {post.user_name}</p>
          </Link>
          <Link href={`/post/${post.id}`}>
            <p><strong>Content:</strong> {post.content}</p>
            <p><strong>Updated at:</strong> {new Date(post.created_at).toLocaleString()}</p>
            <p><strong>Updated at:</strong> {new Date(post.updated_at).toLocaleString()}</p>
          </Link>
          <div className='flex gap-2'>
            <HeartButton postId={post.id} initialLiked={post.liked}/>
            <CommentDialog postId={post.id} />
          </div>
        </div>       
      </div>
  )
}
