import cors from 'cors'
import express from 'express'

function parseOrigins(value: string | undefined) {
  if (!value) return undefined
  const origins = value
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean)
  if (origins.length === 0) return undefined
  return origins
}

export function createApp() {
  const app = express()

  app.use(
    cors({
      origin: parseOrigins(process.env.CORS_ORIGIN) ?? true,
    }),
  )
  app.use(express.json({ limit: '1mb' }))

  app.get('/health', (_req, res) => {
    res.status(200).json({ ok: true })
  })

  app.use((_req, res) => {
    res.status(404).json({ error: 'not_found' })
  })

  return app
}
