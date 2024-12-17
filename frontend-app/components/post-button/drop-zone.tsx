"use client"

import React, { useCallback } from 'react'
import { useDropzone } from 'react-dropzone'
import { Image } from "lucide-react"

export function Dropzone() {
    const onDrop = useCallback((acceptedFiles: File[]) => {
        console.log('受け取ったファイル:', acceptedFiles);
    }, [])
    const {getRootProps, getInputProps, isDragActive} = useDropzone({onDrop})
  
    return (
        <div {...getRootProps()} 
            className={`flex flex-col items-center justify-center h-full w-full
            ${isDragActive ? 'bg-accent text-accent-foreground' : ''}`}>
            <input {...getInputProps()} />
            <div className="flex flex-col items-center">
                <Image className="h-16 w-16 mb-4" />
            </div>
            <div >画像をドラッグアンドドロップ</div>
            <div>または</div>
            <div>コンピューターから選択</div>
        </div>
    )
}