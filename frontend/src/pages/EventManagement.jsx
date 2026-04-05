import React, { useState, useEffect } from 'react';
import { 
  Table, 
  Button, 
  Modal, 
  DatePicker, 
  Space, 
  message,
  Tag,
  Card,
  Descriptions
} from 'antd';
import { 
  ClockCircleOutlined,
  CheckCircleOutlined 
} from '@ant-design/icons';
import api from '../services/api';
import dayjs from 'dayjs';

const EventManagement = () => {
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(false);
  const [modalVisible, setModalVisible] = useState(false);
  const [selectedGroup, setSelectedGroup] = useState(null);
  const [newDeadline, setNewDeadline] = useState(null);

  useEffect(() => {
    loadEvents();
  }, []);

  const loadEvents = async () => {
    try {
      setLoading(true);
      const response = await api.get('/events');
      setEvents(response.data.data || []);
    } catch (error) {
      message.error('載入揪團列表失敗');
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateDeadline = (group) => {
    setSelectedGroup(group);
    setNewDeadline(dayjs(group.deadline));
    setModalVisible(true);
  };

  const handleSubmit = async () => {
    if (!newDeadline) {
      message.warning('請選擇新的截止時間');
      return;
    }

    try {
      await api.put(`/events/groups/${selectedGroup.groupId}/deadline`, {
        deadline: newDeadline.toISOString()
      });
      message.success('截止時間更新成功');
      setModalVisible(false);
      loadEvents();
    } catch (error) {
      message.error(error.response?.data?.message || '更新失敗');
    }
  };

  const expandedRowRender = (event) => {
    const columns = [
      {
        title: '店家',
        dataIndex: 'storeName',
        key: 'storeName',
      },
      {
        title: '類別',
        dataIndex: 'category',
        key: 'category',
        render: (category) => (
          <Tag color={category === 'Drink' ? 'blue' : 'green'}>
            {category === 'Drink' ? '飲料' : '便當'}
          </Tag>
        ),
      },
      {
        title: '外送費',
        dataIndex: 'deliveryFee',
        key: 'deliveryFee',
        render: (deliveryFee) => `$${deliveryFee}`,
      },
      {
        title: '截止時間',
        dataIndex: 'deadline',
        key: 'deadline',
        render: (deadline) => dayjs(deadline).format('YYYY-MM-DD HH:mm'),
      },
      {
        title: '狀態',
        dataIndex: 'status',
        key: 'status',
        render: (status) => {
          const isOpen = status === 'Open';
          return (
            <Tag color={isOpen ? 'green' : 'red'} icon={isOpen ? <CheckCircleOutlined /> : <ClockCircleOutlined />}>
              {isOpen ? '可點餐' : '已截止'}
            </Tag>
          );
        },
      },
      {
        title: '操作',
        key: 'action',
        render: (_, group) => {
          const isOpen = group.status === 'Open';
          return isOpen ? (
            <Button 
              type="link"
              icon={<ClockCircleOutlined />}
              onClick={() => handleUpdateDeadline(group)}
            >
              提早截止
            </Button>
          ) : (
            <span style={{ color: '#999' }}>已截止</span>
          );
        },
      },
    ];

    return (
      <Table
        columns={columns}
        dataSource={event.orderGroups}
        pagination={false}
        rowKey="groupId"
      />
    );
  };

  const columns = [
    {
      title: '揪團名稱',
      dataIndex: 'title',
      key: 'title',
    },
    {
      title: '訂購類型',
      dataIndex: 'orderType',
      key: 'orderType',
    },
    {
      title: '發起人',
      dataIndex: 'creatorName',
      key: 'creatorName',
    },
    {
      title: '狀態',
      dataIndex: 'status',
      key: 'status',
      render: (status) => (
        <Tag color={status === 'Open' ? 'green' : 'orange'}>
          {status === 'Open' ? '進行中' : '已結單'}
        </Tag>
      ),
    },
    {
      title: '店家數',
      key: 'storeCount',
      render: (_, record) => record.orderGroups?.length || 0,
    },
    {
      title: '參與人數',
      dataIndex: 'totalParticipants',
      key: 'totalParticipants',
    },
  ];

  return (
    <div>
      <Card style={{ marginBottom: 16 }}>
        <h2>揪團管理</h2>
        <p style={{ color: '#666' }}>
          管理進行中的揪團，可以提早設定店家的截止時間
        </p>
      </Card>

      <Table
        columns={columns}
        dataSource={events}
        rowKey="eventId"
        loading={loading}
        expandable={{
          expandedRowRender,
          rowExpandable: (record) => record.orderGroups?.length > 0,
        }}
      />

      <Modal
        title="更新截止時間"
        open={modalVisible}
        onOk={handleSubmit}
        onCancel={() => setModalVisible(false)}
        okText="確定"
        cancelText="取消"
      >
        {selectedGroup && (
          <>
            <Descriptions column={1} bordered size="small" style={{ marginBottom: 16 }}>
              <Descriptions.Item label="店家">
                {selectedGroup.storeName}
              </Descriptions.Item>
              <Descriptions.Item label="外送費">
                ${selectedGroup.deliveryFee}
              </Descriptions.Item>
              <Descriptions.Item label="目前截止時間">
                {dayjs(selectedGroup.deadline).format('YYYY-MM-DD HH:mm')}
              </Descriptions.Item>
            </Descriptions>

            <div style={{ marginTop: 16 }}>
              <label style={{ display: 'block', marginBottom: 8 }}>新截止時間：</label>
              <DatePicker
                showTime
                format="YYYY-MM-DD HH:mm"
                value={newDeadline}
                onChange={setNewDeadline}
                disabledDate={(current) => {
                  // 不能選擇過去的日期
                  return current && current < dayjs().startOf('day');
                }}
                disabledTime={(current) => {
                  // 如果是今天，不能選擇已過的時間
                  if (current && current.isSame(dayjs(), 'day')) {
                    const now = dayjs();
                    return {
                      disabledHours: () => Array.from({length: now.hour()}, (_, i) => i),
                      disabledMinutes: (selectedHour) => {
                        if (selectedHour === now.hour()) {
                          return Array.from({length: now.minute()}, (_, i) => i);
                        }
                        return [];
                      },
                    };
                  }
                  return {};
                }}
                style={{ width: '100%' }}
              />
              <p style={{ color: '#999', fontSize: 12, marginTop: 8 }}>
                提示：截止時間只能提早，不能延後
              </p>
            </div>
          </>
        )}
      </Modal>
    </div>
  );
};

export default EventManagement;
