<script setup lang="ts">
import { onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthenticateStore } from './app/store/store';

const router = useRouter();
const authStore = useAuthenticateStore();

onMounted(async () => {
  const token = localStorage.getItem('token');
  if (token) {
    authStore.setToken(token);
    try {
      await authStore.fetchUser();
      if (!authStore.user) {
        throw new Error('Utilisateur non trouvé');
      }
    } catch (error) {
      console.error('Erreur lors de la récupération de l utilisateur:', error);
      localStorage.removeItem('token');
      authStore.logout();
      router.push('/login');
    }
  } else {
    router.push('/login');
  }
});
</script>

<template>
  <router-view />
</template>

<style scoped></style>
