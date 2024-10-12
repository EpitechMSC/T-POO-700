import { InternalAxiosRequestConfig } from 'axios';
import { useAuthenticateStore } from '../../store/store';

export const handleAxiosRequest = async (
  config: InternalAxiosRequestConfig
): Promise<InternalAxiosRequestConfig> => {
  const authenticateStore = useAuthenticateStore();
  const token = authenticateStore.token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  return config;
};
