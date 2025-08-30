<template>
  <div class="grid grid-2">
    <div>
      <component :is="steps[step].cmp" />
      <div class="grid" style="margin-top: 12px">
        <button class="btn" :disabled="step===0" @click="step--">Indietro</button>
        <button class="btn primary" @click="next">{{ step < steps.length-1 ? 'Avanti' : 'Vai al riepilogo' }}</button>
      </div>
    </div>
    <aside class="card">
      <h3>Riepilogo live</h3>
      <div class="grid">
        <div><span class="badge">Base</span> € {{ store.totals.totalBase.toFixed(2) }}</div>
        <div><span class="badge">Standard</span> € {{ store.totals.totalStandard.toFixed(2) }}</div>
        <small>Moltiplicatore totale: {{ store.totals.multTotal.toFixed(2) }} (cap 1.50) · Buffer: {{ Math.round(store.input.bufferPct*100) }}%</small>
      </div>
    </aside>
  </div>
</template>
<script setup lang="ts">
import { ref } from 'vue'
import { useQuoteStore } from '../stores/quote.ts'
import StepOne from "../components/steps/StepOne.vue";
import StepTwo from "../components/steps/StepTwo.vue";
import StepThree from "../components/steps/StepThree.vue";
import StepFour from "../components/steps/StepFour.vue";

const store = useQuoteStore()
const step = ref(0)
const steps = [
  { key: 'profilo', cmp: StepOne },
  { key: 'extra', cmp: StepTwo },
  { key: 'moltiplicatori', cmp: StepThree },
  { key: 'riepilogo', cmp: StepFour },
]

function next() {
  if (step.value < steps.length - 1) step.value++
}
</script>