'use client'

import Link from 'next/link'

interface CommentProps {
  comment: {
    id: number
    content: string
    user_id: number
    user_name: string
    created_at: string
    updated_at: string
  }
}

export interface CommentListProps {
  comments: {
    id: number
    content: string
    user_id: number
    user_name: string
    created_at: string
    updated_at: string
  }[]
}

function Comment({ comment }: CommentProps) {
  return (
      <div className="border p-4 rounded-md">
        <div className="flex flex-col gap-2">
          <p><strong>User ID:</strong> {comment.user_id}</p>
          <Link href={`/user/${comment.user_id}`} className="font-bold hover:underline">
            <p><strong>User Name:</strong> {comment.user_name}</p>
          </Link>
            <p><strong>Content:</strong> {comment.content}</p>
            <p><strong>Updated at:</strong> {new Date(comment.created_at).toLocaleString()}</p>
            <p><strong>Updated at:</strong> {new Date(comment.updated_at).toLocaleString()}</p>
        </div>       
      </div>
  )
}

export default function CommentList({ comments }: CommentListProps) {
  return (
    <div className="mt-4 space-y-2">
      {comments.map((comment) => (
        <Comment comment={comment} key={comment.id} />
      ))}
    </div>
  )
}