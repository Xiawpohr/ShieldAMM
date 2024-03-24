import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

import Web3Provider from "../components/provider/web3-provider"
import PageHeader from "@/components/page-header";
import PageNav from "@/components/page-nav";
import PageSider from "@/components/page-sider";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
});

export const metadata: Metadata = {
  title: "ShieldAMM",
  description: "Private DEX allowa users to trade assets without revealing the accounts that the assets originate from.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Web3Provider>
          <PageHeader />
          <div className="flex flex-col items-center gap-6 p-6">
            <PageNav />
            {children}
          </div>
        </Web3Provider>
      </body>
    </html>
  );
}
