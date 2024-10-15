<script setup lang="ts">
import { onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthenticateStore } from './app/store/store';
import NavBar from './components/NavBar/NavBar.vue';

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
      router.push(`/users/${authStore.user.id}`);
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

const isAuthenticated = computed(() => !!authStore.user);
</script>

<template>
  <NavBar v-if="isAuthenticated" />
  <router-view />
</template>

<style scoped></style>
