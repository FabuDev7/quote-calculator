import { describe, expect, it } from 'vitest'
import { computeTotals } from './pricing.ts'

describe('pricing engine', () => {
    it('calcola Base vs Standard con cap 1.5', () => {
        const out = computeTotals({
            model: 'HOURLY', rateHourly: 60, hours: 10, bufferPct: 0.1,
            extraHours: { sopralluogo: 1, call: 0, setup: 0, custom: 0 },
            fees: { trasferte: 20, licenze: 0, consumabili: 0, noleggi: 0, altro: 0 },
            multipliers: { urg: 1.3, cplx: 1.2, risk: 1.15 }
        } as any)
        expect(out.totalBase).toBeGreaterThan(0)
        expect(out.multTotal).toBe(1.5) // cap
        expect(out.totalStandard).toBeGreaterThan(out.totalBase)
    })

    it('applica buffer dopo i moltiplicatori', () => {
        const a = computeTotals({ model: 'HOURLY', rateHourly: 100, hours: 1, bufferPct: 0.1, extraHours: { sopralluogo:0,call:0,setup:0,custom:0 }, fees: { trasferte:0,licenze:0,consumabili:0,noleggi:0,altro:0 }, multipliers: { urg:1, cplx:1, risk:1 } })
        expect(a.totalBase).toBeCloseTo(110)
    })
})