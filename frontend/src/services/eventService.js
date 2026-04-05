import api from './api';

export const eventService = {
  // 取得所有揪團
  getEvents: async (status = 'Open') => {
    const response = await api.get('/events', { params: { status } });
    return response.data;
  },

  // 取得揪團詳情
  getEventById: async (eventId) => {
    const response = await api.get(`/events/${eventId}`);
    return response.data;
  },

  // 發起揪團
  createEvent: async (eventData) => {
    const response = await api.post('/events', eventData);
    return response.data;
  },

  // 結單
  closeEvent: async (eventId) => {
    const response = await api.post(`/events/${eventId}/close`);
    return response.data;
  },

  // 取消揪團
  deleteEvent: async (eventId) => {
    const response = await api.delete(`/events/${eventId}`);
    return response.data;
  },

  // 取得分帳明細
  getSummary: async (eventId) => {
    const response = await api.get(`/events/${eventId}/summary`);
    return response.data;
  },
};

export default eventService;
