import { AxiosResponse } from 'axios';
import { PaginatedResult } from '../../models/pagination';

const sleep = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export const handleAxiosResponse = async <T>(
  response: AxiosResponse<T>
): Promise<AxiosResponse<T | PaginatedResult<T>>> => {
  if (import.meta.env.NODE_ENV === 'development') await sleep(1000);

  const paginationHeader = response.headers['pagination'];
  if (paginationHeader) {
    const paginatedData: PaginatedResult<T> = new PaginatedResult(
      response.data,
      JSON.parse(paginationHeader)
    );

    return {
      ...response,
      data: paginatedData,
    } as AxiosResponse<PaginatedResult<T>>;
  }

  return response;
};
