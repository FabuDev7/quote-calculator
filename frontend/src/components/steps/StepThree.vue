<template>
  <div class="card grid">
    <h2>Step 3 — Moltiplicatori</h2>
    <div class="grid grid-3">
      <div class="card">
        <strong>Urgenza</strong>
        <label><input type="radio" name="urg" value="1" v-model.number="store.input.multipliers.urg"/> Nessuna</label>
        <label><input type="radio" name="urg" value="1.2" v-model.number="store.input.multipliers.urg"/> < 72h</label>
        <label><input type="radio" name="urg" value="1.3" v-model.number="store.input.multipliers.urg"/> < 48h</label>
        <label><input type="radio" name="urg" value="1.5" v-model.number="store.input.multipliers.urg"/> Notte/Weekend</label>
      </div>
      <div class="card">
        <strong>Complessità</strong>
        <label><input type="radio" name="cplx" value="1" v-model.number="store.input.multipliers.cplx"/> Bassa</label>
        <label><input type="radio" name="cplx" value="1.05" v-model.number="store.input.multipliers.cplx"/> Media-bassa</label>
        <label><input type="radio" name="cplx" value="1.1" v-model.number="store.input.multipliers.cplx"/> Media</label>
        <label><input type="radio" name="cplx" value="1.2" v-model.number="store.input.multipliers.cplx"/> Alta</label>
      </div>
      <div class="card">
        <strong>Rischio/Usura</strong>
        <label><input type="radio" name="risk" value="1" v-model.number="store.input.multipliers.risk"/> Nessuno</label>
        <label><input type="radio" name="risk" value="1.05" v-model.number="store.input.multipliers.risk"/> Moderato</label>
        <label><input type="radio" name="risk" value="1.15" v-model.number="store.input.multipliers.risk"/> Alto</label>
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