import { defineComponent, ref } from 'vue';
import { useRouter, Router } from 'vue-router';
import { useUsersStore } from '../../app/store/store';
import { UserPayload } from '../../app/models/user';
import BaseInput from '../../components/Inputs/BaseInput/BaseInput.vue';
import BaseButton from '../../components/Buttons/BaseButton/BaseButton.vue';

export default defineComponent({
  name: 'RegisterPage',
  components: {
    BaseInput,
    BaseButton,
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
        error.value = 'All fields are required.';
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
          error.value = err.message || 'Error. Please try again.';
        } else {
          error.value = 'Unknown error';
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
