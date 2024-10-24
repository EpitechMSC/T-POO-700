import axios, { InternalAxiosRequestConfig } from 'axios';
import loki from 'lokijs';

let db = new loki('offlineRequests.db', {
  autoload: true,
  autosave: true,
  autosaveInterval: 5000,
  autoloadCallback: loadRequestBuffer,
});

let requestBuffer: any[] = [];

function loadRequestBuffer() {
  let bufferCollection = db.getCollection('requestBuffer');

  if (bufferCollection === null) {
    bufferCollection = db.addCollection('requestBuffer');
  } else {
    requestBuffer = bufferCollection.find();
  }

  console.log('Request buffer loaded from LokiJS.');
}

function saveRequestBuffer() {
  const bufferCollection = db.getCollection('requestBuffer');
  bufferCollection.clear();
  requestBuffer.forEach(
    req => bufferCollection.find(req) ?? bufferCollection.insert(req)
  );
  db.saveDatabase();
}

export const handleRequestWhenOffline = async (
  config: InternalAxiosRequestConfig
): Promise<InternalAxiosRequestConfig> => {
  if (window.navigator.onLine === false) {
    return new Promise(() => {
      requestBuffer.push({ config });
      saveRequestBuffer();
    });
  }

  return config;
};

export function executeBufferedRequests() {
  console.log('Executing buffered requests');
  const bufferCollection = db.getCollection('requestBuffer');
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

  bufferCollection.clear();
  db.saveDatabase();
}
