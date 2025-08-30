<template>
  <div class="card grid">
    <h2>Step 2 — Extra & Fee</h2>

    <fieldset class="card">
      <legend>Ore extra</legend>
      <label>Sopralluogo (h) <input type="number" v-model.number="store.input.extraHours.sopralluogo" min="0" step="0.5"/></label>
      <label>Call/Allineamento (h) <input type="number" v-model.number="store.input.extraHours.call" min="0" step="0.5"/></label>
      <label>Setup attrezzatura (h) <input type="number" v-model.number="store.input.extraHours.setup" min="0" step="0.5"/></label>
      <label>Altro (h) <input type="number" v-model.number="store.input.extraHours.custom" min="0" step="0.5"/></label>
    </fieldset>

    <fieldset class="card">
      <legend>Spese vive (€)</legend>
      <label>Trasferte <input type="number" v-model.number="store.input.fees.trasferte" min="0"/></label>
      <label>Licenze e diritti <input type="number" v-model.number="store.input.fees.licenze" min="0"/></label>
      <label>Consumabili & props <input type="number" v-model.number="store.input.fees.consumabili" min="0"/></label>
      <label>Noleggi & Location <input type="number" v-model.number="store.input.fees.noleggi" min="0"/></label>
      <label>Altro <input type="number" v-model.number="store.input.fees.altro" min="0"/></label>
    </fieldset>
  </div>
</template>
<script setup lang="ts">
import { useQuoteStore } from '../../stores/quote.ts'
const store = useQuoteStore()
</script>