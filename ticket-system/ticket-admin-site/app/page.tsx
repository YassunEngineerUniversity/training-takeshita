"use client"

import { useState } from "react"
import { zodResolver } from "@hookform/resolvers/zod"
import { useForm } from "react-hook-form"
import * as z from "zod"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import { useUser } from "@/lib/context/user-context"

const formSchema = z.object({
  email: z.string().email("正しいメールアドレスを入力してください"),
  password: z.string().min(8, "パスワードは8文字以上である必要があります"),
})

export default function Home() {
  const { user, setUser, isLoading } = useUser()
  const router = useRouter()
  const [isLoggingIn, setIsLoggingIn] = useState(false)
  const [loginError, setLoginError] = useState<string | null>(null)

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      email: "",
      password: "",
    },
  })

  async function onSubmit(values: z.infer<typeof formSchema>) {
    setIsLoggingIn(true)
    setLoginError(null)
    
    try {
      const response = await fetch('/api/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': process.env.NEXT_PUBLIC_API_KEY || '',
        },
        body: JSON.stringify(values),
      })

      const data = await response.json()

      if (response.ok && !data.error) {
        setUser(data)
        window.location.reload() // ページを完全にリロード
      } else {
        setLoginError("メールアドレスまたはパスワードが誤っています")
      }
    } catch (error) {
      console.error('ログインエラー:', error)
      setLoginError("ログイン処理中にエラーが発生しました")
    } finally {
      setIsLoggingIn(false)
    }
  }

  if (isLoading) {
    return <div className="flex min-h-screen items-center justify-center">読み込み中...</div>
  }

  if (user) {
    return (
      <main className="flex min-h-screen flex-col items-center justify-center p-24">
        <h2 className="text-2xl font-bold mb-4">ようこそ {user.name} さん</h2>
        <p>左上のメニューから操作を選択してください</p>
      </main>
    )
  }

  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="w-full max-w-md space-y-8">
        <div className="text-center">
          <h2 className="text-2xl font-bold">ログイン</h2>
          <p className="mt-2 text-gray-600">アカウント情報を入力してください</p>
        </div>
        
        {loginError && (
          <div className="p-4 mb-4 text-sm text-red-800 bg-red-50 rounded-lg">
            {loginError}
          </div>
        )}
        
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
            <FormField
              control={form.control}
              name="email"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>メールアドレス</FormLabel>
                  <FormControl>
                    <Input placeholder="example@example.com" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="password"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>パスワード</FormLabel>
                  <FormControl>
                    <Input type="password" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <Button 
              type="submit" 
              className="w-full" 
              disabled={isLoggingIn}
            >
              {isLoggingIn ? "ログイン中..." : "ログイン"}
            </Button>
          </form>
        </Form>
      </div>
    </main>
  )
}
