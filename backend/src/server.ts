import 'dotenv/config'
import { createApp } from './app'

function parsePort(value: string | undefined) {
  const port = Number(value)
  if (!Number.isFinite(port) || port <= 0) return 3001
  return port
}

const port = parsePort(process.env.PORT)
const app = createApp()

app.listen(port, () => {
  console.log(`API listening on http://localhost:${port}`)
})
