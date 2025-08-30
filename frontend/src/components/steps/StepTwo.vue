<template>
  <div class="card grid">
    <h2>Step 2 — Extra & Fee</h2>

    <fieldset class="card">
      <legend>Ore extra</legend>
      <label>Sopralluogo (h) <input v-model.number="store.input.extraHours.sopralluogo" type="number" min="0" step="0.5"/></label>
      <label>Call/Allineamento (h) <input v-model.number="store.input.extraHours.call" type="number" min="0" step="0.5"/></label>
      <label>Setup attrezzatura (h) <input v-model.number="store.input.extraHours.setup" type="number" min="0" step="0.5"/></label>
      <label>Altro (h) <input v-model.number="store.input.extraHours.custom" type="number" min="0" step="0.5"/></label>
    </fieldset>

    <fieldset class="card">
      <legend>Spese vive (€)</legend>
      <label>Trasferte <input v-model.number="store.input.fees.trasferte" type="number" min="0"/></label>
      <label>Licenze e diritti <input v-model.number="store.input.fees.licenze" type="number" min="0"/></label>
      <label>Consumabili & props <input v-model.number="store.input.fees.consumabili" type="number" min="0"/></label>
      <label>Noleggi & Location <input v-model.number="store.input.fees.noleggi" type="number" min="0"/></label>
      <label>Altro <input v-model.number="store.input.fees.altro" type="number" min="0"/></label>
    </fieldset>
  </div>
</template>
<script setup lang="ts">
import { useQuoteStore } from '../../stores/quote.ts'
const store = useQuoteStore()
</script>
