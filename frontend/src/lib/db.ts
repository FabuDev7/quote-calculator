import type { QuoteInput } from '../types.ts'
import { makeSlug } from './slug.ts'

interface SavedQuote { slug: string; createdAt: string; input: QuoteInput }
const KEY = 'quotes.v1'

function readAll(): SavedQuote[] {
    try {
        return JSON.parse(localStorage.getItem(KEY) || '[]')
    } catch {
        return []
    }
}

function writeAll(list: SavedQuote[]) { localStorage.setItem(KEY, JSON.stringify(list)) }

export function saveQuote(input: QuoteInput): { slug: string } {
    const list = readAll()
    const slug = makeSlug()
    const createdAt = new Date().toISOString().slice(0,10)
    // clona per rimuovere la reattività di Pinia ed avere un JSON pulito
    const plain: QuoteInput = JSON.parse(JSON.stringify(input))
    list.push({ slug, createdAt, input: plain })
    writeAll(list)
    return { slug }
}

export function getQuote(slug: string): { input: QuoteInput; createdAt: string } | null {
    const list = readAll()
    const found = list.find(q => q.slug === slug)
    return found ? { input: found.input, createdAt: found.createdAt } : null
}