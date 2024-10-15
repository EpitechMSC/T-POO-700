import { defineComponent, ref } from 'vue';
import { useRouter } from 'vue-router';
import { useUsersStore } from '../../app/store/store';
import BaseInput from '../../components/Inputs/BaseInput/BaseInput.vue';
import BaseButton from '../../components/Buttons/BaseButton/BaseButton.vue';

export default defineComponent({
  name: 'RegisterPage',
  components: {
    BaseInput,
    BaseButton,
  },
  setup() {
    const username = ref('');
    const email = ref('');
    const error = ref<string | null>(null);
    const router = useRouter();
    const usersStore = useUsersStore();

    const handleRegister = async () => {
      error.value = null;

      if (!username.value || !email.value) {
        error.value = 'Tous les champs sont obligatoires.';
        return;
      }

      try {
        await usersStore.createUser({
          username: username.value,
          email: email.value,
        });

        router.push('/login');
      } catch (err: any) {
        error.value = err.message || "Erreur lors de l'enregistrement.";
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
