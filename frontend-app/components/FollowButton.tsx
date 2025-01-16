'use client'

import { useState } from 'react'
import { useAuth } from '@/contexts/AuthContext';
import { Button } from "@/components/ui/button"

interface FollowButtonProps {
  userId: number
  initialFollowed: boolean
}

export default function FollowButton({ userId, initialFollowed }: FollowButtonProps) {
    const { user } = useAuth();
    const [followed, setFollowed] = useState(initialFollowed)
    if (user?.id === userId) return

    const handleFollowToggle = async () => {
        try {
            const response = await fetch(`/api/users/${userId}/follow`, {
            method: followed ? 'DELETE' : 'POST',
            })

            if (!response.ok) {
            throw new Error('Failed to update follow status')
            }

            setFollowed(!followed)
        } catch (err) {
            console.error('Error updating follow status:', err)
            // Here you might want to show an error message to the user
        }
    }
    return (
        <Button className='hover:bg-primary/50' onClick={handleFollowToggle}>
            {followed ? 'フォロー解除' : 'フォロー'}
        </Button>
    )
}