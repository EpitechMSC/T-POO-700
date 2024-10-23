import { InternalAxiosRequestConfig } from 'axios';
import axios from 'axios';

let requestBuffer: any[] = [];

export const handleRequestWhenOffline = async (
  config: InternalAxiosRequestConfig
): Promise<InternalAxiosRequestConfig> => {
  if (window.navigator.onLine === false) {
    return new Promise(() => {
      console.log(JSON.stringify(config));
      requestBuffer.push({ config });
      localStorage.setItem('requestBuffer', JSON.stringify(requestBuffer));
    });
  }

  return config;
};

export function executeBufferedRequests() {
  requestBuffer = JSON.parse(localStorage.getItem('requestBuffer') || '[]');
  while (requestBuffer.length > 0) {
    const { config } = requestBuffer.shift();
    axios(config)
      .then(() => {
        console.log('Resolved');
      })
      .catch(() => {
        console.log('Rejected');
      });
  }
  localStorage.removeItem('requestBuffer');
}
