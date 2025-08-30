<template>
  <div class="page" v-if="record">
    <div class="toolbar no-print">
      <button class="btn" @click="goHome">← Torna al wizard</button>
      <button class="btn" @click="window.print()">Stampa / PDF</button>
      <span class="muted">Link pubblico: {{ publicUrl }}</span>
    </div>

    <header class="header">
      <div>
        <h1>Preventivo</h1>
        <p class="muted">Slug: {{ slug }} · Data: {{ createdAt }}</p>
      </div>
      <div class="issuer">
        <strong>{{ issuer.name }}</strong>
        <small>{{ issuer.email }}</small>
      </div>
    </header>

    <section class="summary">
      <div class="card">
        <h2>Totali</h2>
        <div class="grid grid-2">
          <div>
            <h3>Opzione Base</h3>
            <p class="price">€ {{ totals.totalBase.toFixed(2) }}</p>
            <ul>
              <li>Base: € {{ totals.base.toFixed(2) }}</li>
              <li>Extra: € {{ totals.extraValue.toFixed(2) }}</li>
              <li>Fee: € {{ totals.feesTotal.toFixed(2) }}</li>
              <li>Buffer: {{ Math.round(input.bufferPct*100) }}%</li>
            </ul>
          </div>
          <div>
            <h3>Opzione Standard</h3>
            <p class="price">€ {{ totals.totalStandard.toFixed(2) }}</p>
            <ul>
              <li>Pre-fattori: € {{ totals.preFactorsBase.toFixed(2) }}</li>
              <li>Moltiplicatore totale: × {{ totals.multTotal.toFixed(2) }} (cap 1.50)</li>
              <li>Buffer: {{ Math.round(input.bufferPct*100) }}%</li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <section class="breakdown">
      <h2>Dettagli</h2>
      <table class="table">
        <tbody>
        <tr><th>Modello</th><td>{{ input.model }}</td></tr>
        <tr v-if="input.model==='HOURLY'"><th>Tariffa oraria</th><td>€ {{ (input.rateHourly||0).toFixed(2) }}</td></tr>
        <tr v-if="input.model==='HOURLY'"><th>Ore stimate</th><td>{{ (input.hours||0) }}</td></tr>
        <tr v-if="input.model==='DAY'"><th>Tariffa giornaliera</th><td>€ {{ (input.dayRate||0).toFixed(2) }}</td></tr>
        <tr v-if="input.model==='DAY'"><th>Giorni stimati</th><td>{{ (input.days||0) }}</td></tr>
        <tr v-if="input.model==='FORFAIT'"><th>Forfait base</th><td>€ {{ (input.forfaitBase||0).toFixed(2) }}</td></tr>
        <tr><th>Ore extra</th><td>
          Sopralluogo {{ input.extraHours.sopralluogo||0 }}h · Call {{ input.extraHours.call||0 }}h · Setup {{ input.extraHours.setup||0 }}h · Altro {{ input.extraHours.custom||0 }}h
        </td></tr>
        <tr><th>Fee</th><td>
          Trasferte € {{ input.fees.trasferte||0 }} · Licenze € {{ input.fees.licenze||0 }} · Consumabili € {{ input.fees.consumabili||0 }} · Noleggi € {{ input.fees.noleggi||0 }} · Altro € {{ input.fees.altro||0 }}
        </td></tr>
        <tr><th>Moltiplicatori</th><td>Urgenza × {{ input.multipliers.urg }} · Complessità × {{ input.multipliers.cplx }} · Rischio × {{ input.multipliers.risk }}</td></tr>
        <tr><th>Buffer</th><td>{{ Math.round(input.bufferPct*100) }}%</td></tr>
        </tbody>
      </table>
      <p class="muted">Nota: il buffer copre contingenze operative minori. Offerta valida 14 giorni.</p>
    </section>
  </div>
  <div v-else class="page">
    <p class="muted">Caricamento… oppure preventivo non trovato. Torna al wizard e crea un link pubblico.</p>
  </div>
</template>
<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getQuote } from '../lib/db.ts'
import { computeTotals } from '../lib/pricing.ts'
import type { QuoteInput } from '../types.ts'

const route = useRoute();
const router = useRouter();
const slug = String(route.params.slug || '')
const record = ref<{ input: QuoteInput; createdAt: string } | null>(null)

onMounted(() => {
  const data = getQuote(slug)
  if (!data) return
  record.value = data
})

const input = computed(() => (record.value?.input as QuoteInput) || {
  model: 'HOURLY', bufferPct: 0, extraHours: {sopralluogo:0,call:0,setup:0,custom:0}, fees: {trasferte:0,licenze:0,consumabili:0,noleggi:0,altro:0}, multipliers: {urg:1,cplx:1,risk:1}
} as QuoteInput)
const totals = computed(() => computeTotals(input.value))
const createdAt = computed(() => record.value?.createdAt || '')
const publicUrl = window.location.href

const issuer = { name: 'Tuo Nome / Studio', email: 'you@example.com' }

function goHome(){ router.push('/') }
</script>
<style scoped>
.page { max-width: 900px; margin: 0 auto; padding: 16px; }
.header { display:flex; align-items:center; justify-content:space-between; border-bottom:1px solid #e5e5e5; padding-bottom:8px; margin-bottom:12px; }
.toolbar { display:flex; gap:8px; align-items:center; justify-content:flex-start; margin-bottom:12px; }
.summary .price { font-size: 28px; margin: 4px 0; }
.table { width:100%; border-collapse: collapse; }
.table th, .table td { border-bottom:1px solid #eee; text-align:left; padding:6px 4px; }
.muted { color:#666; }
@media print {
  .no-print { display:none !important; }
  .page { width: 210mm; min-height: 297mm; padding: 15mm; }
  .card { border: none; box-shadow: none; padding: 0; }
}
</style>