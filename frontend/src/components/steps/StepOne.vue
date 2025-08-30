<template>
  <div class="card grid">
    <h2>Step 1 — Profilo</h2>
    <label>Professione
      <select v-model="store.input.profession">
        <option value="developer">Developer</option>
        <option value="creator">Content Creator</option>
      </select>
    </label>
    <label>Modello tariffario
      <select v-model="store.input.model">
        <option value="HOURLY">Oraria</option>
        <option value="DAY">Day rate</option>
        <option value="FORFAIT">Forfait</option>
      </select>
    </label>

    <template v-if="store.input.model==='HOURLY'">
      <label>Tariffa oraria (€) <input v-model.number="store.input.rateHourly" type="number" min="0" /></label>
      <label>Ore stimate <input v-model.number="store.input.hours" type="number" min="0" step="0.5" /></label>
    </template>
    <template v-else-if="store.input.model==='DAY'">
      <label>Tariffa giornaliera (€) <input v-model.number="store.input.dayRate" type="number" min="0" /></label>
      <label>Giorni stimati <input v-model.number="store.input.days" type="number" min="0" step="0.5" /></label>
    </template>
    <template v-else>
      <label>Forfait base (€) <input v-model.number="store.input.forfaitBase" type="number" min="0" /></label>
      <label>Tariffa oraria di riferimento (€) <input v-model.number="store.input.rateHourly" type="number" min="0" /></label>
    </template>

    <label>Buffer (%) <input type="number" :value="bufferPctInt" min="0" max="20" @input="onBuffer($event)" /></label>
  </div>
</template>
<script setup lang="ts">
import { computed } from 'vue'
import { useQuoteStore } from '../../stores/quote.ts'
const store = useQuoteStore()

const bufferPctInt = computed(() => Math.round((store.input.bufferPct || 0) * 100))
// eslint-disable-next-line no-undef
function onBuffer(e: Event){
  // eslint-disable-next-line no-undef
  const v = Number((e.target as HTMLInputElement).value || 0)
  store.input.bufferPct = Math.max(0, Math.min(20, v)) / 100
}
</script>
