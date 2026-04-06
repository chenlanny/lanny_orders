import React, { useState, useEffect } from 'react';
import { Card, Row, Col, Statistic, Table, Progress, Tag, Select, Spin, message, Empty, Divider } from 'antd';
import { 
  TrophyOutlined, 
  ShoppingOutlined, 
  DollarOutlined, 
  ShopOutlined,
  TeamOutlined,
  RiseOutlined
} from '@ant-design/icons';
import statsService from '../services/statsService';
import { useAuthStore } from '../store/authStore';

const { Option } = Select;

const Stats = () => {
  const { user } = useAuthStore();
  const [loading, setLoading] = useState(true);
  const [popularItems, setPopularItems] = useState([]);
  const [personalStats, setPersonalStats] = useState(null);
  const [departmentRanking, setDepartmentRanking] = useState([]);
  const [monthlyTrend, setMonthlyTrend] = useState([]);
  const [timeRange, setTimeRange] = useState(30);

  const isAdmin = user?.role === 'Admin';

  useEffect(() => {
    loadAllStats();
  }, [timeRange]);

  const loadAllStats = async () => {
    try {
      setLoading(true);
      
      // 載入熱門品項
      const popularResult = await statsService.getPopularItems(timeRange);
      if (popularResult.success) {
        setPopularItems(popularResult.data || []);
      }

      // 載入個人統計
      const personalResult = await statsService.getPersonalStats(timeRange);
      if (personalResult.success) {
        setPersonalStats(personalResult.data);
      }

      // 載入月度趨勢
      const trendResult = await statsService.getMonthlyTrend(6);
      if (trendResult.success) {
        setMonthlyTrend(trendResult.data || []);
      }

      // 管理員載入部門排行
      if (isAdmin) {
        const deptResult = await statsService.getDepartmentRanking(timeRange);
        if (deptResult.success) {
          setDepartmentRanking(deptResult.data || []);
        }
      }
    } catch (error) {
      console.error('載入統計數據失敗:', error);
      message.error('載入統計數據失敗');
    } finally {
      setLoading(false);
    }
  };

  // 熱門品項表格欄位
  const popularColumns = [
    {
      title: '排名',
      key: 'rank',
      width: 70,
      render: (_, __, index) => {
        const colors = ['#FFD700', '#C0C0C0', '#CD7F32'];
        const color = index < 3 ? colors[index] : '#666';
        return (
          <span style={{ fontSize: 18, fontWeight: 'bold', color }}>
            {index + 1}
          </span>
        );
      },
    },
    {
      title: '品項',
      dataIndex: 'itemName',
      key: 'itemName',
    },
    {
      title: '店家',
      dataIndex: 'storeName',
      key: 'storeName',
      render: (text) => <Tag color="blue">{text}</Tag>,
    },
    {
      title: '訂購次數',
      dataIndex: 'orderCount',
      key: 'orderCount',
      sorter: (a, b) => a.orderCount - b.orderCount,
    },
    {
      title: '總金額',
      dataIndex: 'totalAmount',
      key: 'totalAmount',
      render: (value) => `$${value.toFixed(1)}`,
      sorter: (a, b) => a.totalAmount - b.totalAmount,
    },
    {
      title: '訂單數',
      dataIndex: 'orderTimes',
      key: 'orderTimes',
    },
  ];

  // 最愛品項表格欄位
  const favoriteColumns = [
    {
      title: '品項',
      dataIndex: 'itemName',
      key: 'itemName',
    },
    {
      title: '店家',
      dataIndex: 'storeName',
      key: 'storeName',
    },
    {
      title: '訂購次數',
      dataIndex: 'orderCount',
      key: 'orderCount',
    },
    {
      title: '總消費',
      dataIndex: 'totalAmount',
      key: 'totalAmount',
      render: (value) => `$${value.toFixed(1)}`,
    },
  ];

  // 部門排行表格欄位
  const departmentColumns = [
    {
      title: '排名',
      key: 'rank',
      width: 70,
      render: (_, __, index) => (
        <span style={{ fontSize: 16, fontWeight: 'bold' }}>
          {index + 1}
        </span>
      ),
    },
    {
      title: '部門',
      dataIndex: 'departmentName',
      key: 'departmentName',
      render: (text) => <Tag color="purple">{text}</Tag>,
    },
    {
      title: '總消費',
      dataIndex: 'totalAmount',
      key: 'totalAmount',
      render: (value) => `$${value.toFixed(1)}`,
      sorter: (a, b) => a.totalAmount - b.totalAmount,
    },
    {
      title: '訂單數',
      dataIndex: 'totalOrders',
      key: 'totalOrders',
    },
    {
      title: '人數',
      dataIndex: 'userCount',
      key: 'userCount',
    },
    {
      title: '人均消費',
      dataIndex: 'averagePerPerson',
      key: 'averagePerPerson',
      render: (value) => `$${value.toFixed(1)}`,
      sorter: (a, b) => a.averagePerPerson - b.averagePerPerson,
    },
  ];

  // 月度趨勢表格欄位（飲料、便當分類）
  const monthlyColumns = [
    {
      title: '月份',
      key: 'month',
      render: (_, record) => `${record.year}/${String(record.month).padStart(2, '0')}`,
      fixed: 'left',
      width: 100,
      onHeaderCell: () => ({
        style: {
          backgroundColor: '#fafafa',
          fontWeight: 'bold',
        },
      }),
    },
    {
      title: (
        <span style={{ fontSize: 16, fontWeight: 'bold' }}>
          🥤 飲料
        </span>
      ),
      onHeaderCell: () => ({
        style: {
          backgroundColor: '#e6f7ff',
          borderLeft: '3px solid #1890ff',
          fontWeight: 'bold',
        },
      }),
      children: [
        {
          title: '訂單數',
          dataIndex: 'drinkOrderCount',
          key: 'drinkOrderCount',
          align: 'center',
          render: (value) => value || 0,
          onHeaderCell: () => ({
            style: {
              backgroundColor: '#f0f9ff',
            },
          }),
        },
        {
          title: '總消費金額（含外送）',
          dataIndex: 'drinkAmount',
          key: 'drinkAmount',
          align: 'right',
          render: (value) => `$${(value || 0).toFixed(1)}`,
          onHeaderCell: () => ({
            style: {
              backgroundColor: '#f0f9ff',
            },
          }),
        },
        {
          title: '外送費',
          dataIndex: 'drinkDeliveryFee',
          key: 'drinkDeliveryFee',
          align: 'right',
          render: (value) => `$${(value || 0).toFixed(1)}`,
          onHeaderCell: () => ({
            style: {
              backgroundColor: '#f0f9ff',
              color: '#1890ff',
            },
          }),
        },
      ],
    },
    {
      title: (
        <span style={{ fontSize: 16, fontWeight: 'bold' }}>
          🍱 便當
        </span>
      ),
      onHeaderCell: () => ({
        style: {
          backgroundColor: '#fff7e6',
          borderLeft: '3px solid #fa8c16',
          fontWeight: 'bold',
        },
      }),
      children: [
        {
          title: '訂單數',
          dataIndex: 'lunchOrderCount',
          key: 'lunchOrderCount',
          align: 'center',
          render: (value) => value || 0,
          onHeaderCell: () => ({
            style: {
              backgroundColor: '#fffbf0',
            },
          }),
        },
        {
          title: '總消費金額（含外送）',
          dataIndex: 'lunchAmount',
          key: 'lunchAmount',
          align: 'right',
          render: (value) => `$${(value || 0).toFixed(1)}`,
          onHeaderCell: () => ({
            style: {
              backgroundColor: '#fffbf0',
            },
          }),
        },
        {
          title: '外送費',
          dataIndex: 'lunchDeliveryFee',
          key: 'lunchDeliveryFee',
          align: 'right',
          render: (value) => `$${(value || 0).toFixed(1)}`,
          onHeaderCell: () => ({
            style: {
              backgroundColor: '#fffbf0',
              color: '#fa8c16',
            },
          }),
        },
      ],
    },
    {
      title: (
        <span style={{ fontSize: 16, fontWeight: 'bold' }}>
          📊 總計
        </span>
      ),
      onHeaderCell: () => ({
        style: {
          backgroundColor: '#fff1f0',
          borderLeft: '3px solid #ff4d4f',
          fontWeight: 'bold',
        },
      }),
      children: [
        {
          title: '訂單數',
          dataIndex: 'totalOrderCount',
          key: 'totalOrderCount',
          align: 'center',
          render: (value) => <strong>{value || 0}</strong>,
          onHeaderCell: () => ({
            style: {
              backgroundColor: '#fff5f5',
            },
          }),
        },
        {
          title: '總消費金額（含外送）',
          dataIndex: 'totalAmount',
          key: 'totalAmount',
          align: 'right',
          render: (value) => <strong style={{ color: '#ff4d4f' }}>${(value || 0).toFixed(1)}</strong>,
          onHeaderCell: () => ({
            style: {
              backgroundColor: '#fff5f5',
            },
          }),
        },
        {
          title: '外送費',
          dataIndex: 'totalDeliveryFee',
          key: 'totalDeliveryFee',
          align: 'right',
          render: (value) => <strong style={{ color: '#ff4d4f' }}>${(value || 0).toFixed(1)}</strong>,
          onHeaderCell: () => ({
            style: {
              backgroundColor: '#fff5f5',
              color: '#ff4d4f',
            },
          }),
        },
      ],
    },
  ];

  if (loading) {
    return (
      <div style={{ textAlign: 'center', padding: '100px 0' }}>
        <Spin size="large" />
        <p style={{ marginTop: 16 }}>載入統計數據中...</p>
      </div>
    );
  }

  return (
    <div>
      {/* 時間範圍選擇 */}
      <Card style={{ marginBottom: 16 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <h2 style={{ margin: 0 }}>📊 統計分析</h2>
          <Select
            value={timeRange}
            onChange={setTimeRange}
            style={{ width: 150 }}
          >
            <Option value={7}>最近 7 天</Option>
            <Option value={30}>最近 30 天</Option>
            <Option value={90}>最近 90 天</Option>
            <Option value={180}>最近 180 天</Option>
          </Select>
        </div>
      </Card>

      {/* 個人統計卡片 */}
      {personalStats && (
        <Row gutter={16} style={{ marginBottom: 16 }}>
          <Col xs={24} sm={12} lg={6}>
            <Card>
              <Statistic
                title="總消費金額"
                value={personalStats.totalAmount}
                precision={1}
                prefix={<DollarOutlined />}
                suffix="元"
                valueStyle={{ color: '#FF6B6B' }}
              />
            </Card>
          </Col>
          <Col xs={24} sm={12} lg={6}>
            <Card>
              <Statistic
                title="訂單數量"
                value={personalStats.totalOrders}
                prefix={<ShoppingOutlined />}
                suffix="筆"
                valueStyle={{ color: '#3f8600' }}
              />
            </Card>
          </Col>
          <Col xs={24} sm={12} lg={6}>
            <Card>
              <Statistic
                title="品項總數"
                value={personalStats.totalItems}
                prefix={<ShopOutlined />}
                suffix="項"
                valueStyle={{ color: '#1890ff' }}
              />
            </Card>
          </Col>
          <Col xs={24} sm={12} lg={6}>
            <Card>
              <Statistic
                title="平均每單"
                value={personalStats.averageAmount}
                precision={1}
                prefix={<RiseOutlined />}
                suffix="元"
                valueStyle={{ color: '#FF8C42' }}
              />
            </Card>
          </Col>
        </Row>
      )}

      {/* 熱門品項排行 - 飲料 */}
      <Card 
        title={
          <span>
            <TrophyOutlined style={{ marginRight: 8, color: '#FFD700' }} />
            🥤 飲料熱門排行 TOP 10
          </span>
        }
        style={{ marginBottom: 16 }}
      >
        {popularItems.filter(item => item.category === 'Drink').length > 0 ? (
          <Table
            dataSource={popularItems.filter(item => item.category === 'Drink').slice(0, 10)}
            columns={popularColumns}
            rowKey="itemId"
            pagination={false}
          />
        ) : (
          <Empty description="暫無數據" />
        )}
      </Card>

      {/* 熱門品項排行 - 便當 */}
      <Card 
        title={
          <span>
            <TrophyOutlined style={{ marginRight: 8, color: '#52C41A' }} />
            🍱 便當熱門排行 TOP 10
          </span>
        }
        style={{ marginBottom: 16 }}
      >
        {popularItems.filter(item => item.category === 'Lunch').length > 0 ? (
          <Table
            dataSource={popularItems.filter(item => item.category === 'Lunch').slice(0, 10)}
            columns={popularColumns}
            rowKey="itemId"
            pagination={false}
          />
        ) : (
          <Empty description="暫無數據" />
        )}
      </Card>

      {/* 分隔線：區分全公司統計和個人分析 */}
      <Divider 
        style={{ 
          margin: '32px 0',
          borderColor: '#1890ff',
          borderWidth: 2
        }}
      >
        <span style={{
          fontSize: 18,
          fontWeight: 'bold',
          color: '#1890ff',
          padding: '0 16px'
        }}>
          📊 個人消費分析
        </span>
      </Divider>

      {/* 我的最愛品項 - 獨立一行 */}
      <Card 
        title="❤️ 我的最愛品項 TOP 5" 
        style={{ marginBottom: 16 }}
      >
        {personalStats?.favoriteItems && personalStats.favoriteItems.length > 0 ? (
          <Table
            dataSource={personalStats.favoriteItems}
            columns={favoriteColumns}
            rowKey={(record) => `${record.itemName}_${record.storeName}`}
            pagination={false}
            size="small"
          />
        ) : (
          <Empty description="暫無數據" />
        )}
      </Card>

      {/* 店家消費分布 - 飲料和便當並排 */}
      <Row gutter={16}>
        {/* 店家分布 - 飲料 */}
        <Col xs={24} lg={12}>
          <Card 
            title="🥤 飲料店消費分布" 
            style={{ marginBottom: 16 }}
          >
            {personalStats?.storeDistribution && 
             personalStats.storeDistribution.filter(s => s.category === 'Drink').length > 0 ? (
              <div>
                {personalStats.storeDistribution
                  .filter(store => store.category === 'Drink')
                  .sort((a, b) => b.orderCount - a.orderCount)
                  .map((store, index) => (
                  <div key={index} style={{ marginBottom: 16 }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
                      <span style={{ fontWeight: 500 }}>{store.storeName}</span>
                      <span>
                        <span style={{ color: '#FF6B6B', fontWeight: 'bold' }}>
                          ${store.totalAmount.toFixed(1)}
                        </span>
                        <span style={{ color: '#999', marginLeft: 8 }}>
                          ({store.orderCount} 單)
                        </span>
                      </span>
                    </div>
                    <Progress 
                      percent={store.percentage} 
                      strokeColor={{
                        '0%': '#FFB75E',
                        '100%': '#FF6B6B',
                      }}
                    />
                  </div>
                ))}
              </div>
            ) : (
              <Empty description="暫無數據" />
            )}
          </Card>
        </Col>

        {/* 店家分布 - 便當 */}
        <Col xs={24} lg={12}>
          <Card 
            title="🍱 便當店消費分布" 
            style={{ marginBottom: 16 }}
          >
            {personalStats?.storeDistribution && 
             personalStats.storeDistribution.filter(s => s.category === 'Lunch').length > 0 ? (
              <div>
                {personalStats.storeDistribution
                  .filter(store => store.category === 'Lunch')
                  .sort((a, b) => b.orderCount - a.orderCount)
                  .map((store, index) => (
                  <div key={index} style={{ marginBottom: 16 }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
                      <span style={{ fontWeight: 500 }}>{store.storeName}</span>
                      <span>
                        <span style={{ color: '#FF6B6B', fontWeight: 'bold' }}>
                          ${store.totalAmount.toFixed(1)}
                        </span>
                        <span style={{ color: '#999', marginLeft: 8 }}>
                          ({store.orderCount} 單)
                        </span>
                      </span>
                    </div>
                    <Progress 
                      percent={store.percentage} 
                      strokeColor={{
                        '0%': '#52C41A',
                        '100%': '#389E0D',
                      }}
                    />
                  </div>
                ))}
              </div>
            ) : (
              <Empty description="暫無數據" />
            )}
          </Card>
        </Col>
      </Row>

      {/* 每月消費趨勢 */}
      {monthlyTrend.length > 0 && (
        <Card 
          title="📈 每月消費趨勢"
          style={{ marginBottom: 16 }}
        >
          <Table
            dataSource={monthlyTrend}
            columns={monthlyColumns}
            rowKey={(record) => `${record.year}-${record.month}`}
            pagination={false}
          />
        </Card>
      )}

      {/* 部門排行（僅管理員） */}
      {isAdmin && (
        <>
          <Divider style={{ margin: '48px 0 32px 0', borderColor: '#ff4d4f', borderWidth: 2 }}>
            <span style={{ fontSize: 18, fontWeight: 'bold', color: '#ff4d4f' }}>
              🏢 部門消費統計
            </span>
          </Divider>
          <Card 
            title={
              <span>
                <TeamOutlined style={{ marginRight: 8, color: '#1890ff' }} />
                部門消費排行榜
              </span>
            }
            style={{ marginBottom: 16 }}
          >
            {departmentRanking.length > 0 ? (
              <Table
                dataSource={departmentRanking}
                columns={departmentColumns}
                rowKey="departmentName"
                pagination={false}
              />
            ) : (
              <Empty description="暫無部門數據" />
          )}
          </Card>
        </>
      )}
    </div>
  );
};

export default Stats;
