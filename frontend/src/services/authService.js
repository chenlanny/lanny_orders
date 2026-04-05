import api from './api';

export const authService = {
  // 登入
  login: async (email, password) => {
    const response = await api.post('/auth/login', { email, password });
    if (response.data.success && response.data.data.token) {
      localStorage.setItem('token', response.data.data.token);
      localStorage.setItem('user', JSON.stringify(response.data.data.user));
    }
    return response.data;
  },

  // 註冊
  register: async (userData) => {
    const response = await api.post('/auth/register', userData);
    return response.data;
  },

  // 登出
  logout: () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
  },

  // 取得當前用戶資訊
  getCurrentUser: () => {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
  },

  // 檢查是否已登入
  isAuthenticated: () => {
    return !!localStorage.getItem('token');
  },
};

export default authService;
