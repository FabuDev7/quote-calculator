<template>
  <div class="card grid">
    <h2>Step 3 — Moltiplicatori</h2>
    <div class="grid grid-3">
      <div class="card">
        <strong>Urgenza</strong>
        <label><input v-model.number="store.input.multipliers.urg" type="radio" name="urg" value="1"/> Nessuna</label>
        <label><input v-model.number="store.input.multipliers.urg" type="radio" name="urg" value="1.2"/> &lt; 72h</label>
        <label><input v-model.number="store.input.multipliers.urg" type="radio" name="urg" value="1.3"/> &lt; 48h</label>
        <label><input v-model.number="store.input.multipliers.urg" type="radio" name="urg" value="1.5"/> Notte/Weekend</label>
      </div>
      <div class="card">
        <strong>Complessità</strong>
        <label><input v-model.number="store.input.multipliers.cplx" type="radio" name="cplx" value="1"/> Bassa</label>
        <label><input v-model.number="store.input.multipliers.cplx" type="radio" name="cplx" value="1.05"/> Media-bassa</label>
        <label><input v-model.number="store.input.multipliers.cplx" type="radio" name="cplx" value="1.1"/> Media</label>
        <label><input v-model.number="store.input.multipliers.cplx" type="radio" name="cplx" value="1.2"/> Alta</label>
      </div>
      <div class="card">
        <strong>Rischio/Usura</strong>
        <label><input v-model.number="store.input.multipliers.risk" type="radio" name="risk" value="1"/> Nessuno</label>
        <label><input v-model.number="store.input.multipliers.risk" type="radio" name="risk" value="1.05"/> Moderato</label>
        <label><input v-model.number="store.input.multipliers.risk" type="radio" name="risk" value="1.15"/> Alto</label>
      </div>
    </div>
    <p>
      Moltiplicatore totale: <strong>{{ store.totals.multTotal.toFixed(2) }}</strong> (cap 1.50)
    </p>
  </div>
</template>
<script setup lang="ts">
import { useQuoteStore } from '../../stores/quote.ts'
const store = useQuoteStore()
</script>
