import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import PostList from '@/components/PostList'

export default function PostTabs() {

    return (
        <Tabs defaultValue="all" className="w-full mt-8">
            <TabsList>
                <TabsTrigger value="all">All Posts</TabsTrigger>
                <TabsTrigger value="following">Following</TabsTrigger>
                <TabsTrigger value="mine">My Posts</TabsTrigger>
            </TabsList>
            <TabsContent value="all">
                <PostList />
            </TabsContent>
            <TabsContent value="following">
                <PostList />
            </TabsContent>
            <TabsContent value="mine">
                <PostList />
            </TabsContent>
        </Tabs>
    )
}
