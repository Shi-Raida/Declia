import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

serve(async (req: Request) => {
  const { name } = await req.json().catch(() => ({ name: null }))

  const data = {
    message: `Hello ${name ?? 'World'}!`,
    timestamp: new Date().toISOString(),
    project: 'declia',
  }

  return new Response(JSON.stringify(data), {
    headers: { 'Content-Type': 'application/json' },
    status: 200,
  })
})
