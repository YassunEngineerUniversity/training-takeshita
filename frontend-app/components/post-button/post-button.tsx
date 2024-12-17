"use client"

import React, { useState } from 'react'

import { Button } from "@/components/ui/button"
import { Card, CardContent } from '@/components/ui/card'
import {
Dialog,
DialogContent,
DialogDescription,
DialogFooter,
DialogHeader,
DialogTitle,
DialogTrigger,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { TaxonomyCombobox } from "./taxonomy-combobox"
import { LocationCombobox } from "./location-combobox";
import { Dropzone } from './drop-zone'
import { ImageUp } from "lucide-react"

export type ComboboxProps = {
    value: string;
    onChange: (value: string) => void;
}

export function PostButton() {

    const [comment, setComment] = useState('')
    const [taxonomy, setTaxonomy] = useState('')
    const [location, setLocation] = useState('')

    const handleSubmit = async () => {
        try {
            const response = await fetch('process.env.API_ENDPOINT', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    comment,
                    taxonomy,
                    location
                })
            })

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`)
            }

            const data = await response.json()
            console.log('投稿成功:', data)
            // 成功時の処理（例：ダイアログを閉じる、フォームをリセットするなど）
        } catch (error) {
            console.error('投稿エラー:', error)
            // エラー時の処理（例：エラーメッセージを表示するなど）
        }
    }

    return(         
        <div className="flex items-center justify-center">
            <Dialog>
                <DialogTrigger asChild>
                    <Button  variant="outline" className="flex gap-2 px-4 py-6">
                        <ImageUp className="h-8 w-8" />
                        <div className="hidden md:block">
                            投稿を作成
                        </div>
                    </Button>
                </DialogTrigger>

                <DialogContent className="w-full max-w-xl">
                    <DialogHeader>
                        <DialogTitle>投稿を作成</DialogTitle>
                    </DialogHeader>
                    <div className="grid gap-4">
                        <div className="grid gap-4">
                            <div className="grid gap-2">
                                <Label htmlFor="width">画像</Label>
                                <Card className='h-72 w-full'>
                                    <CardContent className='h-full p-0'>
                                        <Dropzone/>
                                    </CardContent>
                                </Card>
                            </div>
                            <div className="grid gap-2">
                                <Label htmlFor="width">コメント</Label>
                                <Textarea value={comment} onChange={(e) => setComment(e.target.value)}/>
                            </div>
                            <div className="grid gap-2">
                                <Label htmlFor="width">分類</Label>
                                <TaxonomyCombobox value={taxonomy} onChange={setTaxonomy}/>
                            </div>
                            <div className="grid gap-2">
                                <Label htmlFor="width">撮影地</Label>
                                <LocationCombobox value={location} onChange={setLocation}/>
                            </div>
                        </div>
                        <div className='w-full flex justify-center'>
                            <Button  variant="outline" onClick={handleSubmit} className='w-24'>投稿 !</Button>
                        </div>
                    </div>
                </DialogContent>
            </Dialog>
        </div>
    )
}