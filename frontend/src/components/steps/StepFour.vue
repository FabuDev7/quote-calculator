<template>
  <div class="grid grid-2">
    <div class="card">
      <h3>Opzione Base</h3>
      <p>Moltiplicatori esclusi. Buffer incluso.</p>
      <p class="badge">Totale</p>
      <h2>€ {{ store.totals.totalBase.toFixed(2) }}</h2>
      <details>
        <summary>Breakdown</summary>
        <ul>
          <li>Base: € {{ store.totals.base.toFixed(2) }}</li>
          <li>Extra: € {{ store.totals.extraValue.toFixed(2) }}</li>
          <li>Fee: € {{ store.totals.feesTotal.toFixed(2) }}</li>
          <li>Buffer: {{ Math.round(store.input.bufferPct*100) }}%</li>
        </ul>
      </details>
    </div>
    <div class="card">
      <h3>Opzione Standard</h3>
      <p>Con urgenza/complessità/rischio selezionati. Buffer incluso.</p>
      <p class="badge">Totale</p>
      <h2>€ {{ store.totals.totalStandard.toFixed(2) }}</h2>
      <details>
        <summary>Breakdown</summary>
        <ul>
          <li>Pre-fattori: € {{ store.totals.preFactorsBase.toFixed(2) }}</li>
          <li>Moltiplicatore totale: × {{ store.totals.multTotal.toFixed(2) }}</li>
          <li>Buffer: {{ Math.round(store.input.bufferPct*100) }}%</li>
        </ul>
      </details>
    </div>
    <div class="card" style="grid-column: 1 / -1;">
      <h3>Azioni</h3>
      <div class="grid">
        <button class="btn" @click="createPublic(false)">Crea link pubblico</button>
        <button class="btn primary" @click="createPublic(true)">Apri vista stampa / PDF</button>
      </div>
      <p v-if="lastUrl" class="muted" style="margin-top:8px">Link creato: <a :href="lastUrl" target="_blank">{{ lastUrl }}</a></p>
    </div>
  </div>
</template>
<script setup lang="ts">
import {ref} from 'vue'
import {useRouter} from 'vue-router'
import {useQuoteStore} from '../../stores/quote.ts'
import {saveQuote} from '../../lib/db.ts'

const store = useQuoteStore()
const router = useRouter()
const lastUrl = ref('')

function createPublic(openPrint: boolean){
  const { slug } = saveQuote(store.input)
  // eslint-disable-next-line no-undef
  lastUrl.value = `${window.location.origin}/q/${slug}`
  if(openPrint){
    router.push({ path: `/q/${slug}` })
    // la stampa la farà l'utente dal pulsante nella pagina pubblica
  }
}
</script>
