"use client"

import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "./ui/card";
import { Input } from "./ui/input";
import { Button } from "./ui/button";
import { FormProvider, useForm } from "react-hook-form";
import { useChainId } from "wagmi";
import { PairTokens } from "@/lib/constants";
import { FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from "./ui/form";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./ui/select";

const commitments = [
  {
    hash: '0x123',
    token: "QUOTE",
    amount: 10,
    secret: 'faffew'
  }
]

export default function WithdrawForm() {
  const chainId = useChainId()

  const tokens = PairTokens[chainId]
  
  const form = useForm({
    defaultValues: {
      commitment: '',
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
            <CardTitle className="text-2xl">Withdraw</CardTitle>
            <CardDescription>
              Select your deposit commitment to withdraw
            </CardDescription>
          </CardHeader>
          <CardContent className="grid gap-4">
            <FormField
              name="commitment"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Deposit commitment</FormLabel>
                  <FormControl>
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <SelectTrigger>
                        <SelectValue placeholder="Select a deposit commitment" />
                      </SelectTrigger>
                      <SelectContent>
                        {commitments.map((commitment, i) => (
                          <SelectItem key={i} value={commitment.hash}>
                            <div className="grid grid-cols-[1fr_auto] gap-2 items-center">
                              <div>
                                {commitment.amount} {commitment.token}
                              </div>
                              <div className="w-fit border p-1">
                                {commitment.secret}
                              </div>
                            </div>
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
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
