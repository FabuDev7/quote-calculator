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
      <label>Tariffa oraria (€) <input type="number" v-model.number="store.input.rateHourly" min="0" /></label>
      <label>Ore stimate <input type="number" v-model.number="store.input.hours" min="0" step="0.5" /></label>
    </template>
    <template v-else-if="store.input.model==='DAY'">
      <label>Tariffa giornaliera (€) <input type="number" v-model.number="store.input.dayRate" min="0" /></label>
      <label>Giorni stimati <input type="number" v-model.number="store.input.days" min="0" step="0.5" /></label>
    </template>
    <template v-else>
      <label>Forfait base (€) <input type="number" v-model.number="store.input.forfaitBase" min="0" /></label>
      <label>Tariffa oraria di riferimento (€) <input type="number" v-model.number="store.input.rateHourly" min="0" /></label>
    </template>

    <label>Buffer (%) <input type="number" :value="bufferPctInt" @input="onBuffer($event)" min="0" max="20" /></label>
  </div>
</template>
<script setup lang="ts">
import { computed } from 'vue'
import { useQuoteStore } from '../../stores/quote.ts'
const store = useQuoteStore()
const bufferPctInt = computed(() => Math.round((store.input.bufferPct || 0) * 100))
function onBuffer(e: Event){
  const v = Number((e.target as HTMLInputElement).value || 0)
  store.input.bufferPct = Math.max(0, Math.min(20, v)) / 100
}
</script>