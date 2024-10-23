import { defineComponent, ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthenticateStore } from '../../app/store/store';
import BaseInput from '../../components/Inputs/BaseInput/BaseInput.vue';
import BaseButton from '../../components/Buttons/BaseButton/BaseButton.vue';
import { Credentials } from '../../app/models/authentication';


export default defineComponent({
  name: 'LoginPage',
  components: {
    BaseInput,
    BaseButton,
  },
  setup() {
    const email = ref('');
    const password = ref(''); // Ajout du mot de passe
    const error = ref<string | null>(null);
    const authStore = useAuthenticateStore();
    const router = useRouter();

    const handleLogin = async () => {
      error.value = null;

      const credentials: Credentials = {
        email: email.value,
        password: password.value,
      };

      try {
        const userId = await authStore.login(credentials); // Passer les credentials au store
        router.push(`/users/${userId}`);
      } catch (err) {
        error.value = 'Email ou mot de passe invalide ou échec de la connexion';
        console.error('Login failed:', err);
      }
    };

    return {
      email,
      password, // Ajout de la variable mot de passe
      error,
      handleLogin,
    };
  },
});
