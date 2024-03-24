"use client"

import { ConnectKitButton } from "connectkit";

export default function PageHeader() {
  return (
    <header className="sticky top-0 flex h-16 items-center justify-between gap-4 border-b bg-background px-4 md:px-6">
      <h1 className="text-3xl font-bold">
        (∩^o^)⊃━☆ﾟ.*･｡
      </h1>
      <ConnectKitButton theme="soft"/>
    </header>
  )
}
