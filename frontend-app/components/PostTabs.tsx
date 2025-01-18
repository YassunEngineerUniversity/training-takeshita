import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import PostList from '@/components/PostList'

export default function PostTabs() {

    return (
        <Tabs defaultValue="all" className="w-full mt-8">
            <TabsList>
                <TabsTrigger value="all">すべての投稿</TabsTrigger>
                <TabsTrigger value="feed">フィード</TabsTrigger>
                <TabsTrigger value="mine">自分の投稿</TabsTrigger>
            </TabsList>
            <TabsContent value="all">
                <PostList apiUrl="/api/posts/all" />
            </TabsContent>
            <TabsContent value="feed">
                <PostList apiUrl="/api/posts" />
            </TabsContent>
            <TabsContent value="mine">
                <PostList apiUrl="/api/posts/mine" />
            </TabsContent>
        </Tabs>
    )
}
