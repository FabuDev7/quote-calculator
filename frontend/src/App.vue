<template>
  <div class="min-h-screen font-sans">
    <header class="p-4 border-b"><h1>Calcolatore di Preventivi</h1></header>
    <main class="p-4">
      <RouterView />
    </main>
  </div>
</template>
<script setup lang="ts">
</script>
<style>
body { margin: 0; }
.card { border: 1px solid #ddd; border-radius: 12px; padding: 16px; }
.grid { display: grid; gap: 12px; }
.grid-2 { grid-template-columns: 1fr 1fr; }
.grid-3 { grid-template-columns: repeat(3, 1fr); }
.btn { padding: 8px 12px; border-radius: 8px; border: 1px solid #333; cursor: pointer; }
.btn.primary { background: #111; color: #fff; border-color: #111; }
.badge { background: #f2f2f2; padding: 2px 8px; border-radius: 999px; }
</style>