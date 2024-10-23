import { requests, responseBody } from '../config/axiosConfig';
import { Contrat } from '../../models/contrat';
import { PaginatedResult } from '../../models/pagination';
import axios from 'axios';

const Contrats = {
  list: (params: URLSearchParams): Promise<PaginatedResult<Contrat[]>> =>
    axios
      .get<PaginatedResult<Contrat[]>>('contrats', { params })
      .then(responseBody),
  getContratSummary: (id: number): Promise<Contrat> =>
    requests.get(`contrats/${id}`),
};

export default Contrats;
