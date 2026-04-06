import React, { useEffect, useState } from 'react';
import { Card, Row, Col, Button, Tag, Space, Empty, Spin, message } from 'antd';
import { PlusOutlined, ClockCircleOutlined, ShopOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { eventService } from '../services/eventService';
import dayjs from 'dayjs';

const Dashboard = () => {
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    loadEvents();
  }, []);

  const loadEvents = async () => {
    try {
      setLoading(true);
      const result = await eventService.getEvents('Open');
      if (result.success) {
        // 過濾：只顯示還有未截止店家的揪團
        const now = dayjs();
        const filteredEvents = (result.data || []).filter(event => {
          // 檢查是否還有未截止的店家
          if (!event.orderGroups || event.orderGroups.length === 0) return false;
          return event.orderGroups.some(group => dayjs(group.deadline).isAfter(now));
        });
        setEvents(filteredEvents);
      }
    } catch (error) {
      console.error('載入揪團失敗:', error);
      message.error('載入揪團失敗');
    } finally {
      setLoading(false);
    }
  };

  const getStatusTag = (status, event) => {
    // 如果所有店家都截止了，顯示「已截止」
    if (status === 'Open' && event && !hasAvailableStore(event)) {
      return <Tag color="orange">已截止</Tag>;
    }
    
    const statusMap = {
      'Open': { color: 'green', text: '進行中' },
      'Closed': { color: 'orange', text: '已結單' },
      'Delivered': { color: 'blue', text: '已送達' },
      'Cancelled': { color: 'red', text: '已取消' },
    };
    const config = statusMap[status] || { color: 'default', text: status };
    return <Tag color={config.color}>{config.text}</Tag>;
  };

  // 檢查是否還有可點餐的店家（未過截止時間）
  const hasAvailableStore = (event) => {
    if (!event.orderGroups || event.orderGroups.length === 0) return false;
    const now = dayjs();
    return event.orderGroups.some(group => dayjs(group.deadline).isAfter(now));
  };

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 24 }}>
        <h1 style={{ margin: 0 }}>進行中的揪團</h1>
        <Button 
          type="primary" 
          icon={<PlusOutlined />}
          size="large"
          onClick={() => navigate('/events/new')}
        >
          發起新揪團
        </Button>
      </div>

      {loading ? (
        <div style={{ textAlign: 'center', padding: '100px 0' }}>
          <Spin size="large" />
        </div>
      ) : events.length === 0 ? (
        <Empty 
          description="目前沒有進行中的揪團"
          image={Empty.PRESENTED_IMAGE_SIMPLE}
        >
          <Button type="primary" onClick={() => navigate('/events/new')}>
            立即發起揪團
          </Button>
        </Empty>
      ) : (
        <Row gutter={[16, 16]}>
          {events.map((event) => (
            <Col xs={24} sm={12} lg={8} key={event.eventId}>
              <Card
                hoverable
                onClick={() => navigate(`/events/${event.eventId}`)}
                style={{ height: '100%' }}
              >
                <Space direction="vertical" style={{ width: '100%' }} size="middle">
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <h3 style={{ margin: 0 }}>{event.title}</h3>
                    {getStatusTag(event.status, event)}
                  </div>

                  <div>
                    <div style={{ color: '#999', fontSize: 12, marginBottom: 8 }}>
                      <ClockCircleOutlined /> 發起時間: {dayjs(event.createdAt).format('YYYY-MM-DD HH:mm')}
                    </div>
                    
                    {event.orderGroups && event.orderGroups.length > 0 && (
                      <>
                        <div style={{ color: '#666', marginBottom: 8 }}>
                          <ShopOutlined /> 店家資訊：
                        </div>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                          {event.orderGroups.map((group, index) => {
                            const isExpired = dayjs(group.deadline).isBefore(dayjs());
                            const deadlineStr = dayjs(group.deadline).format('MM/DD HH:mm');
                            return (
                              <div 
                                key={index}
                                style={{ 
                                  display: 'flex', 
                                  alignItems: 'center', 
                                  justifyContent: 'space-between',
                                  padding: '4px 8px',
                                  background: isExpired ? '#f5f5f5' : '#e6f7ff',
                                  borderRadius: '4px',
                                  border: `1px solid ${isExpired ? '#d9d9d9' : '#91d5ff'}`,
                                  cursor: 'pointer'
                                }}
                                onClick={(e) => {
                                  e.stopPropagation();
                                  navigate(`/events/${event.eventId}?group=${group.groupId}`);
                                }}
                              >
                                <span style={{ 
                                  fontWeight: 500,
                                  color: isExpired ? '#999' : '#1890ff'
                                }}>
                                  {group.storeName || `店家 ${group.storeId}`}
                                </span>
                                <span style={{ 
                                  fontSize: 12,
                                  color: isExpired ? '#ff4d4f' : '#52c41a',
                                  display: 'flex',
                                  alignItems: 'center',
                                  gap: 4
                                }}>
                                  <ClockCircleOutlined />
                                  {deadlineStr}
                                  {isExpired && <Tag color="error" style={{ margin: 0, fontSize: 11 }}>已截止</Tag>}
                                </span>
                              </div>
                            );
                          })}
                        </div>
                      </>
                    )}
                  </div>

                  {event.notes && (
                    <div style={{ 
                      color: '#666', 
                      fontSize: 12,
                      padding: '8px',
                      background: '#f5f5f5',
                      borderRadius: '4px'
                    }}>
                      備註: {event.notes}
                    </div>
                  )}

                  {hasAvailableStore(event) ? (
                    <Button type="primary" block onClick={(e) => {
                      e.stopPropagation();
                      // 找到第一個未截止的店家
                      const now = dayjs();
                      const firstAvailableGroup = event.orderGroups.find(
                        group => dayjs(group.deadline).isAfter(now)
                      );
                      if (firstAvailableGroup) {
                        navigate(`/events/${event.eventId}?group=${firstAvailableGroup.groupId}`);
                      } else {
                        navigate(`/events/${event.eventId}`);
                      }
                    }}>
                      進入點餐
                    </Button>
                  ) : (
                    <Button block disabled onClick={(e) => e.stopPropagation()}>
                      已截單
                    </Button>
                  )}
                </Space>
              </Card>
            </Col>
          ))}
        </Row>
      )}
    </div>
  );
};

export default Dashboard;
