'use client'

import Link from "next/link";
import { Tabs, TabsList, TabsTrigger } from "./ui/tabs";
import { usePathname } from "next/navigation";

export default function PageNav() {
  const pathname = usePathname()

  return (
    <Tabs defaultValue={pathname} className="max-w-[500px]">
      <TabsList>
        <TabsTrigger value="/deposit" asChild>
          <Link href="/deposit">Deposit</Link>
        </TabsTrigger>
        <TabsTrigger value="/swap" asChild>
          <Link href="/swap">Swap</Link>
        </TabsTrigger>
        <TabsTrigger value="/add-liquidity" asChild>
          <Link href="/add-liquidity">Add Liquidity</Link>
        </TabsTrigger>
        <TabsTrigger value="/remove-liquidity" asChild>
          <Link href="/remove-liquidity">Remove Liquidity</Link>
        </TabsTrigger>
        <TabsTrigger value="/withdraw" asChild>
          <Link href="/withdraw">Withdraw</Link>
        </TabsTrigger>
      </TabsList>
    </Tabs>
  )
}