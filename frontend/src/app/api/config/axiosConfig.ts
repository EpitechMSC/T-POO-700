import axios, { AxiosResponse } from 'axios';
import { handleAxiosResponse } from '../handler/handleAxiosResponse';
import { handleAxiosRequest } from '../handler/handleAxiosRequest';
import { handleRequestWhenOffline } from '../handler/handleRequestWhenOffline';

axios.defaults.baseURL = import.meta.env.VITE_API_BASE_URL;

export const responseBody = <T>(response: AxiosResponse<T>) => response.data;

axios.interceptors.response.use(response => handleAxiosResponse(response));
axios.interceptors.request.use(config => handleRequestWhenOffline(config));
axios.interceptors.request.use(config => handleAxiosRequest(config));

const requests = {
  get: <T>(url: string) => axios.get<T>(url).then(responseBody),
  post: <T>(url: string, body: object) =>
    axios.post<T>(url, body).then(responseBody),
  put: <T>(url: string, body: object) =>
    axios.put<T>(url, body).then(responseBody),
  delete: <T>(url: string) => axios.delete<T>(url).then(responseBody),
};

export { requests };
