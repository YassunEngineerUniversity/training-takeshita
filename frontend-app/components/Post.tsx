import Link from 'next/link'

export type PostProps = {
  post: {
    id: number
    content: string
    user_id: number
    user_name: string
    created_at: string
    updated_at: string
  }
}

export default function Post({ post }: PostProps) {
  return (
    <Link href={`/post/${post.id}`}>
      <div className="border p-4 rounded-md">
        <div className="flex flex-col gap-2">
          <p><strong>Content:</strong> {post.content}</p>
          <p><strong>User ID:</strong> {post.user_id}</p>
          <Link href={`/user/${post.user_id}`} className="font-bold hover:underline">
            <p><strong>User Name:</strong> {post.user_name}</p>
          </Link>
          <p><strong>Updated at:</strong> {new Date(post.created_at).toLocaleString()}</p>
          <p><strong>Updated at:</strong> {new Date(post.updated_at).toLocaleString()}</p>
        </div>
      </div>
    </Link>

  )
}
