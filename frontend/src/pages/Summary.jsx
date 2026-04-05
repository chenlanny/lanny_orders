import React, { useEffect, useState } from 'react';
import { Card, Spin, Empty, message, Table, Tag, Descriptions, Button } from 'antd';
import { DownloadOutlined } from '@ant-design/icons';
import { useParams } from 'react-router-dom';
import { eventService } from '../services/eventService';
import dayjs from 'dayjs';

const Summary = () => {
  const { eventId } = useParams();
  const [summary, setSummary] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadSummary();
  }, [eventId]);

  const loadSummary = async () => {
    try {
      setLoading(true);
      const result = await eventService.getSummary(eventId);
      if (result.success) {
        setSummary(result.data);
      }
    } catch (error) {
      console.error('載入分帳明細失敗:', error);
      message.error('載入失敗');
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div style={{ textAlign: 'center', padding: '100px 0' }}>
        <Spin size="large" />
      </div>
    );
  }

  if (!summary) {
    return <Empty description="找不到分帳明細" />;
  }

  // 用戶總結表格欄位
  const userColumns = [
    {
      title: '姓名',
      dataIndex: 'userName',
      key: 'userName',
    },
    {
      title: '部門',
      dataIndex: 'department',
      key: 'department',
    },
    {
      title: '品項金額',
      dataIndex: 'itemTotal',
      key: 'itemTotal',
      render: (value) => `$${value}`,
    },
    {
      title: '外送費分攤',
      dataIndex: 'deliveryFeeTotal',
      key: 'deliveryFeeTotal',
      render: (value) => `$${value}`,
    },
    {
      title: '應付總額',
      dataIndex: 'totalDue',
      key: 'totalDue',
      render: (value) => <span style={{ fontWeight: 'bold', color: '#ff4d4f' }}>${value}</span>,
    },
  ];

  return (
    <div>
      <Card style={{ marginBottom: 16 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <h1 style={{ marginBottom: 8 }}>分帳明細 - {summary.title}</h1>
            <Tag color={summary.status === 'Open' ? 'green' : 'orange'}>
              {summary.status === 'Open' ? '進行中' : '已結單'}
            </Tag>
          </div>
          <Button type="primary" icon={<DownloadOutlined />}>
            匯出 Excel
          </Button>
        </div>
      </Card>

      <Card title="揪團資訊" style={{ marginBottom: 16 }}>
        <Descriptions column={2}>
          <Descriptions.Item label="發起時間">
            {dayjs(summary.createdAt).format('YYYY-MM-DD HH:mm')}
          </Descriptions.Item>
          {summary.closedAt && (
            <Descriptions.Item label="結單時間">
              {dayjs(summary.closedAt).format('YYYY-MM-DD HH:mm')}
            </Descriptions.Item>
          )}
          <Descriptions.Item label="總金額">
            <span style={{ fontSize: 20, fontWeight: 'bold', color: '#ff4d4f' }}>
              ${summary.grandTotal}
            </span>
          </Descriptions.Item>
        </Descriptions>
      </Card>

      {/* 店家明細 */}
      {summary.storeSummaries && summary.storeSummaries.map((store, storeIndex) => (
        <Card 
          key={storeIndex}
          title={`${store.storeName} (${store.storeCategory === 'Drink' ? '飲料' : '便當'})`}
          style={{ marginBottom: 16 }}
        >
          <Descriptions column={3} style={{ marginBottom: 16 }} bordered>
            <Descriptions.Item label="外送費">${store.deliveryFee}</Descriptions.Item>
            <Descriptions.Item label="訂餐人數">{store.participantCount} 人</Descriptions.Item>
            <Descriptions.Item label="本店總額">
              <span style={{ fontWeight: 'bold', color: '#ff4d4f' }}>${store.total}</span>
            </Descriptions.Item>
          </Descriptions>

          {store.userSummaries && store.userSummaries.map((user, userIndex) => (
            <Card 
              key={userIndex}
              type="inner"
              title={`${user.userName} (${user.department})`}
              extra={<span style={{ fontSize: 16, fontWeight: 'bold', color: '#ff4d4f' }}>應付: ${user.totalDue}</span>}
              style={{ marginBottom: 12 }}
            >
              {user.items && user.items.map((item, itemIndex) => (
                <div key={itemIndex} style={{ marginBottom: 8, padding: 8, background: '#fafafa', borderRadius: 4 }}>
                  <div style={{ fontWeight: 'bold' }}>
                    • {item.itemName} ({item.sizeName}) × {item.quantity}
                  </div>
                  {item.customOptions && (
                    <div style={{ fontSize: 12, color: '#666', marginLeft: 16 }}>
                      {item.customOptions}
                    </div>
                  )}
                  {item.toppings && item.toppings.length > 0 && (
                    <div style={{ fontSize: 12, color: '#666', marginLeft: 16 }}>
                      加料: {item.toppings.map(t => `${t.name} (+$${t.price})`).join(', ')}
                    </div>
                  )}
                  <div style={{ marginLeft: 16, marginTop: 4 }}>
                    小計: ${item.subTotal}
                  </div>
                </div>
              ))}
              <div style={{ marginTop: 8, paddingTop: 8, borderTop: '1px solid #eee' }}>
                <div>品項小計: ${user.itemTotal}</div>
                <div>外送費分攤: ${user.deliveryFeeShare}</div>
                <div style={{ fontWeight: 'bold', fontSize: 16, marginTop: 4 }}>
                  本店小計: ${user.totalDue}
                </div>
              </div>
            </Card>
          ))}
        </Card>
      ))}

      {/* 用戶總結表 */}
      <Card title="用戶總結">
        <Table
          dataSource={summary.userTotals}
          columns={userColumns}
          rowKey="userId"
          pagination={false}
          summary={(pageData) => {
            const totalItem = pageData.reduce((sum, record) => sum + record.itemTotal, 0);
            const totalDelivery = pageData.reduce((sum, record) => sum + record.deliveryFeeTotal, 0);
            const totalDue = pageData.reduce((sum, record) => sum + record.totalDue, 0);

            return (
              <Table.Summary.Row style={{ background: '#fafafa', fontWeight: 'bold' }}>
                <Table.Summary.Cell index={0} colSpan={2}>總計</Table.Summary.Cell>
                <Table.Summary.Cell index={2}>${totalItem}</Table.Summary.Cell>
                <Table.Summary.Cell index={3}>${totalDelivery}</Table.Summary.Cell>
                <Table.Summary.Cell index={4}>
                  <span style={{ color: '#ff4d4f', fontSize: 16 }}>${totalDue}</span>
                </Table.Summary.Cell>
              </Table.Summary.Row>
            );
          }}
        />
      </Card>
    </div>
  );
};

export default Summary;
