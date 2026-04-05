import api from './api';

export const orderService = {
  // 取得所有訂單
  getOrders: async (eventId) => {
    const response = await api.get(`/events/${eventId}/orders`);
    return response.data;
  },

  // 取得我的訂單
  getMyOrders: async (eventId) => {
    const response = await api.get(`/events/${eventId}/my-orders`);
    return response.data;
  },

  // 提交訂單
  submitOrder: async (eventId, orderData) => {
    const response = await api.post(`/events/${eventId}/orders`, orderData);
    return response.data;
  },

  // 修改訂單
  updateOrder: async (orderId, orderData) => {
    const response = await api.put(`/orders/${orderId}`, orderData);
    return response.data;
  },

  // 取消訂單
  deleteOrder: async (orderId) => {
    const response = await api.delete(`/orders/${orderId}`);
    return response.data;
  },
};

export default orderService;
