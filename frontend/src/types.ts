export type Model = 'HOURLY' | 'DAY' | 'FORFAIT'
export type Profession = 'developer' | 'creator'

export interface ExtraHours { sopralluogo: number; call: number; setup: number; custom: number }
export interface Fees { trasferte: number; licenze: number; consumabili: number; noleggi: number; altro: number }
export interface Multipliers { urg: number; cplx: number; risk: number }

export interface QuoteInput {
    model: Model
    profession: Profession
    rateHourly?: number
    hours?: number
    dayRate?: number
    days?: number
    forfaitBase?: number
    bufferPct: number
    extraHours: ExtraHours
    fees: Fees
    multipliers: Multipliers
}

export interface Totals {
    base: number
    extraValue: number
    feesTotal: number
    multTotal: number
    preFactorsBase: number
    totalBase: number
    totalStandard: number
}