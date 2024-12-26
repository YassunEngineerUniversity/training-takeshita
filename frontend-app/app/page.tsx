// 'use client'


// import { cookies } from "next/headers";

import PostForm from '@/components/PostForm'

import PostTabs from "@/components/PostTabs";


export default function Home() {
  return (
    <div>
      <PostForm />
      <PostTabs />
    </div>
  )
}

