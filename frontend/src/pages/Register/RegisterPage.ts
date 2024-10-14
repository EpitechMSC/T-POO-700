import { defineComponent, ref } from 'vue';
import { useRouter, Router } from 'vue-router';
import { useUsersStore } from '../../app/store/store';
import { UserPayload } from '../../app/models/user';
import BaseInput from '../../components/Inputs/BaseInput/BaseInput.vue';

export default defineComponent({
  name: 'RegisterPage',
  components: {
    BaseInput,
  },
  setup() {
    const username = ref<string>('');
    const email = ref<string>('');
    const error = ref<string | null>(null);

    const router: Router = useRouter();

    const usersStore = useUsersStore();

    const handleRegister = async (): Promise<void> => {
      error.value = null;

      if (!username.value || !email.value) {
        error.value = 'Tous les champs sont obligatoires.';
        return;
      }

      try {
        await usersStore.createUser({
          username: username.value,
          email: email.value,
        } as UserPayload);

        router.push('/login');
      } catch (err: unknown) {
        if (err instanceof Error) {
          error.value =
            err.message ||
            "Erreur lors de l'enregistrement. Veuillez réessayer.";
        } else {
          error.value = "Erreur inconnue lors de l'enregistrement.";
        }
      }
    };

    return {
      username,
      email,
      error,
      handleRegister,
    };
  },
});
