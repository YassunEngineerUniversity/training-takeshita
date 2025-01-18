import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

export default function ErrorDisplay({ message }: { message: string }) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Card className="bg-red-50 border-red-200">
          <CardHeader>
            <CardTitle className="text-red-800">Error</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-red-600">{message}</p>
          </CardContent>
        </Card>
      </div>
    )
  }
