"use client"

import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "./ui/card";
import { Input } from "./ui/input";
import { Button } from "./ui/button";
import { FormProvider, useForm } from "react-hook-form";
import { FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from "./ui/form";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./ui/select";
import { useChainId } from "wagmi";
import { PairTokens } from "@/lib/constants"

export default function DepositForm() {
  const chainId = useChainId()

  const tokens = PairTokens[chainId]
  
  const form = useForm({
    defaultValues: {
      token: tokens[0].address,
      amount: '',
      secret: '',
    }
  })

  const onSubmit = form.handleSubmit((data) => {
    console.log(data)
  })
  
  return (
    <FormProvider {...form}>
      <form onSubmit={onSubmit}>
        <Card className="w-full max-w-sm">
          <CardHeader>
            <CardTitle className="text-2xl">Deposit</CardTitle>
            <CardDescription>
              Deposit token with secret to shield your account before swapping tokens
            </CardDescription>
          </CardHeader>
          <CardContent className="grid gap-4">
            <FormField
              name="token"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Token</FormLabel>
                  <FormControl>
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <SelectTrigger>
                        <SelectValue placeholder="Select a token" />
                      </SelectTrigger>
                      <SelectContent>
                        {tokens.map((token, i) => (
                          <SelectItem key={i} value={token.address}>{token.name}</SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </FormControl>
                  <FormDescription />
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              name="amount"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Amount</FormLabel>
                  <FormControl>
                    <Input {...field} type="number" required />
                  </FormControl>
                  <FormDescription />
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              name="secret"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Secret</FormLabel>
                  <FormControl>
                    <Input {...field} type="text" required />
                  </FormControl>
                  <FormDescription />
                  <FormMessage />
                </FormItem>
              )}
            />
          </CardContent>
          <CardFooter>
            <Button className="w-full">Send</Button>
          </CardFooter>
        </Card>
      </form>
    </FormProvider>
  )
}
