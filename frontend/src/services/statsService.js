import api from './api';

export const statsService = {
  // 取得熱門品項
  getPopularItems: async (days = 30) => {
    const response = await api.get('/stats/popular-items', { params: { days } });
    return response.data;
  },

  // 取得個人統計
  getPersonalStats: async (days = 30) => {
    const response = await api.get('/stats/personal', { params: { days } });
    return response.data;
  },

  // 取得部門排行（管理員）
  getDepartmentRanking: async (days = 30) => {
    const response = await api.get('/stats/department-ranking', { params: { days } });
    return response.data;
  },

  // 取得月度趨勢
  getMonthlyTrend: async (months = 6) => {
    const response = await api.get('/stats/monthly-trend', { params: { months } });
    return response.data;
  },
};

export default statsService;
