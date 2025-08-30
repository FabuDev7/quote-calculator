import type { QuoteInput, Totals } from '../types.ts'

const to2 = (n: number) => Math.round(n * 100) / 100

function productWithCap(urg: number, cplx: number, risk: number, cap = 1.5) {
    const p = (urg || 1) * (cplx || 1) * (risk || 1)
    return Math.min(p, cap)
}

export function computeTotals(input: QuoteInput): Totals {
    const rateHourlyRef = input.model === 'FORFAIT' || input.model === 'DAY' ? (input.rateHourly || 0) : (input.rateHourly || 0)
    const base =
        input.model === 'HOURLY'
            ? (input.rateHourly || 0) * (input.hours || 0)
            : input.model === 'DAY'
                ? (input.dayRate || 0) * (input.days || 0)
                : (input.forfaitBase || 0)

    const extraHours = (input.extraHours?.sopralluogo || 0) + (input.extraHours?.call || 0) + (input.extraHours?.setup || 0) + (input.extraHours?.custom || 0)
    const extraValue = extraHours * (rateHourlyRef || 0)
    const feesTotal = (input.fees?.trasferte || 0) + (input.fees?.licenze || 0) + (input.fees?.consumabili || 0) + (input.fees?.noleggi || 0) + (input.fees?.altro || 0)

    const preFactorsBase = base + extraValue + feesTotal
    const multTotal = productWithCap(input.multipliers?.urg || 1, input.multipliers?.cplx || 1, input.multipliers?.risk || 1)

    const standardPre = preFactorsBase * multTotal
    const totalStandard = to2(standardPre * (1 + (input.bufferPct || 0)))
    const totalBase = to2(preFactorsBase * (1 + (input.bufferPct || 0)))

    return { base: to2(base), extraValue: to2(extraValue), feesTotal: to2(feesTotal), multTotal: to2(multTotal), preFactorsBase: to2(preFactorsBase), totalBase, totalStandard }
}