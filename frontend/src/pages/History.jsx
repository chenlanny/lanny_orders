import React, { useState, useEffect } from 'react';
import { Card, Table, Tag, Space, message, Button, Descriptions, Modal, Empty } from 'antd';
import { ShoppingOutlined, ClockCircleOutlined, CheckCircleOutlined, EyeOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import dayjs from 'dayjs';
import api from '../services/api';
import { useAuthStore } from '../store/authStore';

const History = () => {
  const navigate = useNavigate();
  const { user } = useAuthStore();
  const [loading, setLoading] = useState(false);
  const [orders, setOrders] = useState([]);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [detailModalVisible, setDetailModalVisible] = useState(false);

  useEffect(() => {
    loadOrderHistory();
  }, []);

  const loadOrderHistory = async () => {
    try {
      setLoading(true);
      const response = await api.get('/userorders/history', {
        params: {
          pageSize: 100,
          page: 1
        }
      });
      
      // 將訂單項目按 eventId + storeName 分組
      const rawOrders = response.data.data || [];
      console.log('=== 原始訂單數據 ===');
      console.log('總筆數:', rawOrders.length);
      console.log('詳細數據:', rawOrders);
      
      const groupedOrders = {};
      
      rawOrders.forEach(order => {
        const key = `${order.eventId}_${order.storeName}`;
        console.log(`處理訂單: ${order.itemName}, Key: ${key}`);
        
        if (!groupedOrders[key]) {
          console.log(`創建新分組: ${key}`);
          groupedOrders[key] = {
            orderId: key,
            eventId: order.eventId,
            eventTitle: order.eventTitle,
            storeName: order.storeName,
            orderDate: order.orderDate,
            eventStatus: order.eventStatus,
            items: [],
            totalAmount: 0
          };
        }
        
        // 添加品項到該店家訂單
        groupedOrders[key].items.push({
          orderItemId: order.orderItemId,
          itemName: order.itemName,
          size: order.size,
          quantity: order.quantity,
          sweetness: order.sweetness,
          temperature: order.temperature,
          toppings: order.toppings,
          unitPrice: order.unitPrice,
          subTotal: order.subTotal,
          remarks: order.remarks
        });
        
        groupedOrders[key].totalAmount += order.subTotal;
        console.log(`${key} 目前品項數: ${groupedOrders[key].items.length}`);
      });
      
      // 轉換為陣列並按時間排序
      const ordersArray = Object.values(groupedOrders)
        .sort((a, b) => dayjs(b.orderDate).unix() - dayjs(a.orderDate).unix());
      
      console.log('=== 分組後的訂單 ===');
      console.log('總分組數:', ordersArray.length);
      ordersArray.forEach(order => {
        console.log(`${order.eventTitle} - ${order.storeName}: ${order.items.length} 個品項, 總金額: $${order.totalAmount}`);
        console.log('  品項列表:', order.items.map(i => i.itemName).join(', '));
      });
      
      setOrders(ordersArray);
    } catch (error) {
      message.error('載入歷史訂單失敗');
      console.error('載入歷史訂單失敗:', error);
    } finally {
      setLoading(false);
    }
  };

  const showOrderDetail = (order) => {
    setSelectedOrder(order);
    setDetailModalVisible(true);
  };

  const getStatusTag = (status) => {
    const statusMap = {
      '進行中': { color: 'blue', icon: <ClockCircleOutlined /> },
      '已結束': { color: 'green', icon: <CheckCircleOutlined /> },
      '已截止': { color: 'orange', icon: <ClockCircleOutlined /> },
      '已取消': { color: 'red', icon: <ClockCircleOutlined /> }
    };
    const config = statusMap[status] || { color: 'default', icon: null };
    return <Tag color={config.color} icon={config.icon}>{status}</Tag>;
  };

  const formatToppings = (toppings) => {
    if (!toppings) return '-';
    try {
      const toppingList = JSON.parse(toppings);
      return toppingList.join('、');
    } catch {
      return toppings;
    }
  };

  const columns = [
    {
      title: '訂單時間',
      dataIndex: 'orderDate',
      key: 'orderDate',
      width: 160,
      render: (date) => dayjs(date).format('YYYY-MM-DD HH:mm'),
      sorter: (a, b) => dayjs(a.orderDate).unix() - dayjs(b.orderDate).unix(),
      defaultSortOrder: 'descend',
    },
    {
      title: '揪團活動',
      dataIndex: 'eventTitle',
      key: 'eventTitle',
      render: (title, record) => (
        <a onClick={() => navigate(`/events/${record.eventId}`)}>{title}</a>
      ),
    },
    {
      title: '店家',
      dataIndex: 'storeName',
      key: 'storeName',
    },
    {
      title: '品項數量',
      key: 'itemCount',
      width: 100,
      align: 'center',
      render: (_, record) => `${record.items.length} 項`,
    },
    {
      title: '總金額',
      dataIndex: 'totalAmount',
      key: 'totalAmount',
      width: 120,
      align: 'right',
      render: (total) => <span style={{ fontWeight: 'bold', color: '#ff4d4f' }}>${total}</span>,
    },
    {
      title: '操作',
      key: 'action',
      width: 100,
      render: (_, record) => (
        <Button 
          type="link" 
          icon={<EyeOutlined />}
          onClick={() => {
            // 管理員查看分帳明細（所有人訂單），普通用戶查看個人訂單詳情
            if (user?.role === 'Admin') {
              navigate(`/events/${record.eventId}/summary`);
            } else {
              showOrderDetail(record);
            }
          }}
        >
          {user?.role === 'Admin' ? '分帳明細' : '詳情'}
        </Button>
      ),
    },
  ];

  // 計算統計數據
  const totalOrders = orders.length; // 店家訂單數
  const totalAmount = orders.reduce((sum, order) => sum + order.totalAmount, 0);
  const eventCount = new Set(orders.map(o => o.eventId)).size;

  return (
    <div style={{ padding: '24px' }}>
      <Card 
        title={
          <Space>
            <ShoppingOutlined />
            <span>歷史訂單</span>
          </Space>
        }
        extra={
          <Space>
            <span>訂單總數：{totalOrders}</span>
            <span>參與揪團：{eventCount} 次</span>
            <span>累計消費：${totalAmount}</span>
          </Space>
        }
      >
        {totalOrders === 0 ? (
          <Empty 
            description="尚無訂單記錄"
            image={Empty.PRESENTED_IMAGE_SIMPLE}
          >
            <Button type="primary" onClick={() => navigate('/dashboard')}>
              前往首頁下單
            </Button>
          </Empty>
        ) : (
          <Table
            columns={columns}
            dataSource={orders}
            rowKey="orderId"
            loading={loading}
            pagination={{
              pageSize: 20,
              showTotal: (total) => `共 ${total} 筆店家訂單`,
              showSizeChanger: true,
              pageSizeOptions: ['10', '20', '50', '100'],
            }}
          />
        )}
      </Card>

      {/* 訂單詳情 Modal */}
      <Modal
        title="訂單詳情"
        open={detailModalVisible}
        onCancel={() => setDetailModalVisible(false)}
        footer={[
          <Button key="close" onClick={() => setDetailModalVisible(false)}>
            關閉
          </Button>,
          <Button 
            key="event" 
            type="primary" 
            onClick={() => {
              navigate(`/events/${selectedOrder?.eventId}`);
              setDetailModalVisible(false);
            }}
          >
            查看揪團
          </Button>,
        ]}
        width={700}
      >
        {selectedOrder && (
          <div>
            <Descriptions bordered column={2} style={{ marginBottom: 16 }}>
              <Descriptions.Item label="訂單時間" span={2}>
                {dayjs(selectedOrder.orderDate).format('YYYY-MM-DD HH:mm:ss')}
              </Descriptions.Item>
              <Descriptions.Item label="揪團活動" span={2}>
                <Space>
                  {selectedOrder.eventTitle}
                  {getStatusTag(selectedOrder.eventStatus)}
                </Space>
              </Descriptions.Item>
              <Descriptions.Item label="店家" span={2}>
                {selectedOrder.storeName}
              </Descriptions.Item>
            </Descriptions>

            <h4 style={{ marginTop: 16, marginBottom: 12 }}>訂購品項</h4>
            {selectedOrder.items.map((item, index) => (
              <Card 
                key={item.orderItemId}
                size="small" 
                style={{ marginBottom: 8 }}
                title={`${index + 1}. ${item.itemName}`}
                extra={<span style={{ fontWeight: 'bold', color: '#ff4d4f' }}>${item.subTotal}</span>}
              >
                <Descriptions bordered column={2} size="small">
                  <Descriptions.Item label="規格">{item.size || '-'}</Descriptions.Item>
                  <Descriptions.Item label="數量">{item.quantity}</Descriptions.Item>
                  {item.sweetness && (
                    <Descriptions.Item label="甜度">{item.sweetness}</Descriptions.Item>
                  )}
                  {item.temperature && (
                    <Descriptions.Item label="冰量">{item.temperature}</Descriptions.Item>
                  )}
                  {item.toppings && (
                    <Descriptions.Item label="加料" span={2}>
                      {formatToppings(item.toppings)}
                    </Descriptions.Item>
                  )}
                  {item.remarks && (
                    <Descriptions.Item label="備註" span={2}>
                      {item.remarks}
                    </Descriptions.Item>
                  )}
                  <Descriptions.Item label="單價">
                    ${item.unitPrice}
                  </Descriptions.Item>
                  <Descriptions.Item label="小計">
                    <span style={{ fontWeight: 'bold', color: '#ff4d4f' }}>
                      ${item.subTotal}
                    </span>
                  </Descriptions.Item>
                </Descriptions>
              </Card>
            ))}

            <div style={{ 
              marginTop: 16, 
              padding: 12, 
              background: '#f5f5f5', 
              borderRadius: 4,
              textAlign: 'right'
            }}>
              <span style={{ fontSize: 16, fontWeight: 'bold' }}>
                本次訂單總金額: <span style={{ color: '#ff4d4f', fontSize: 18 }}>${selectedOrder.totalAmount}</span>
              </span>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
};

export default History;
