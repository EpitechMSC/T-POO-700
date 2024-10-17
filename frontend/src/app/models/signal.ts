export interface SignalModel {
  id: number;
  name: string;
  status: boolean;
}
export interface ApiResponse {
  data: SignalModel[]; // Array of SignalModel within the 'data' field
}
