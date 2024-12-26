import Link from 'next/link'

type PostProps = {
  post: {
    id: number
    content: string
    user_id: number
    updated_at: string
  }
}

export default function Post({ post }: PostProps) {
  return (
    <div className="border p-4 rounded-md">
      <div className="flex flex-col gap-2">
        <p><strong>ID:</strong> {post.id}</p>
        <p><strong>Content:</strong> {post.content}</p>
        <p><strong>User ID:</strong> {post.user_id}</p>
        <p><strong>Updated at:</strong> {new Date(post.updated_at).toLocaleString()}</p>
      </div>
    </div>
  )
}
