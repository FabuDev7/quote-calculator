import { defineStore } from 'pinia'
import type { QuoteInput } from '../types.ts'
import { computeTotals } from '../lib/pricing.ts'

export const useQuoteStore = defineStore('quote', {
    state: () => ({
        input: {
            model: 'HOURLY',
            rateHourly: 60,
            hours: 8,
            dayRate: 400,
            days: 1,
            forfaitBase: 0,
            bufferPct: 0.1,
            extraHours: { sopralluogo: 0, call: 0, setup: 0, custom: 0 },
            fees: { trasferte: 0, licenze: 0, consumabili: 0, noleggi: 0, altro: 0 },
            multipliers: { urg: 1, cplx: 1, risk: 1 },
        } as QuoteInput,
    }),
    getters: {
        totals: (s) => computeTotals(s.input),
    },
    actions: {
        reset() {
            this.input = { ...this.input, extraHours: { sopralluogo: 0, call: 0, setup: 0, custom: 0 }, fees: { trasferte: 0, licenze: 0, consumabili: 0, noleggi: 0, altro: 0 }, multipliers: { urg: 1, cplx: 1, risk: 1 } }
        },
    },
})