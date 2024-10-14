export interface WorkingTime {
  id: number;
  start: string;
  end: string;
  user: number;
}

export interface WorkingTimeStats {
  worked_today: number;
  worked_this_week: number;
  total_days_worked: number;
  worked_this_month: number;
  worked_last_month: number;
  percentage_change: number;
}
