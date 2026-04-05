import api from './api';

export const storeService = {
  // 取得所有店家
  getStores: async () => {
    const response = await api.get('/stores');
    return response.data;
  },

  // 取得店家詳情
  getStoreById: async (storeId) => {
    const response = await api.get(`/stores/${storeId}`);
    return response.data;
  },

  // 取得店家菜單
  getStoreMenu: async (storeId) => {
    const response = await api.get(`/stores/${storeId}/menu`);
    return response.data;
  },
};

export default storeService;
