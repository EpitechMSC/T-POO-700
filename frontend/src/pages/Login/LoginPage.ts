// src/pages/Login/LoginPage.ts
import { defineComponent, ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthenticateStore } from '../../app/store/store';

export default defineComponent({
  name: 'LoginPage',
  setup() {
    const email = ref('');
    const error = ref<string | null>(null);
    const authStore = useAuthenticateStore();
    const router = useRouter();

    const handleLogin = async () => {
      error.value = null;
      try {
        const userId = await authStore.login(email.value);
        router.push(`/users/${userId}`);
      } catch (err) {
        error.value = 'Adresse email invalide ou échec de la connexion';
        console.error('Login failed:', err);
      }
    };

    return {
      email,
      error,
      handleLogin,
    };
  },
});
