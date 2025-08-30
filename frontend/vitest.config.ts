import { defineConfig } from 'vitest/config'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  test: {
    environment: 'jsdom',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'lcov'], // text per CI log, lcov per strumenti esterni
      exclude: ['node_modules/', 'dist/', 'coverage/', '.vite/']
    }
  }
})
