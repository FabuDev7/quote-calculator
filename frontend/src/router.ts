import { createRouter, createWebHistory } from 'vue-router'
import Wizard from './views/Wizard.vue'
import PublicQuote from './views/PublicQuote.vue'

export default createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/', component: Wizard },
        { path: '/q/:slug', component: PublicQuote },
    ],
})