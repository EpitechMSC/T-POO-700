import { createApp } from 'vue';
import { createPinia } from 'pinia';
import App from './App.vue';
import router from './app/router/router';
import './style.css';
import Toast from 'vue-toastification'
import 'vue-toastification/dist/index.css'


const app = createApp(App);

app.use(router);
app.use(Toast)
app.use(createPinia());

app.mount('#app');
