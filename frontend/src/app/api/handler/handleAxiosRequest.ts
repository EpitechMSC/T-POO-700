import { InternalAxiosRequestConfig } from 'axios';
import { useAuthenticateStore } from '../../store/store';

export const handleAxiosRequest = async (
  config: InternalAxiosRequestConfig
): Promise<InternalAxiosRequestConfig> => {
  const authenticateStore = useAuthenticateStore();
  const token = authenticateStore.token;
  const csrf_token = authenticateStore.csrf_token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  if (csrf_token) {
    config.headers['X-CSRF-TOKEN'] = csrf_token;
  }

  return config;
};
