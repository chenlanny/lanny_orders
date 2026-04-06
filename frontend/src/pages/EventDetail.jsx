import React, { useEffect, useState } from 'react';
import { 
  Card, 
  Tabs, 
  Button, 
  Space, 
  Tag, 
  message, 
  Spin, 
  Empty,
  Modal,
  Descriptions
} from 'antd';
import { 
  ShoppingCartOutlined, 
  ClockCircleOutlined,
  ShopOutlined,
  CheckCircleOutlined 
} from '@ant-design/icons';
import { useParams, useNavigate, useSearchParams } from 'react-router-dom';
import dayjs from 'dayjs';
import { eventService } from '../services/eventService';
import { storeService } from '../services/storeService';
import { orderService } from '../services/orderService';
import { useCartStore } from '../store/cartStore';
import MenuItemCard from '../components/Menu/MenuItemCard';
import ShoppingCart from '../components/Order/ShoppingCart';

const EventDetail = () => {
  const { eventId } = useParams();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const [event, setEvent] = useState(null);
  const [loading, setLoading] = useState(true);
  const [menuData, setMenuData] = useState({});
  const [loadingMenu, setLoadingMenu] = useState({});
  const [activeTab, setActiveTab] = useState(null);
  const [cartVisible, setCartVisible] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const { items, clearCart } = useCartStore();

  useEffect(() => {
    loadEventDetail();
  }, [eventId]);

  const loadEventDetail = async () => {
    try {
      setLoading(true);
      const result = await eventService.getEventById(eventId);
      if (result.success && result.data) {
        setEvent(result.data);
        if (result.data.orderGroups && result.data.orderGroups.length > 0) {
          // 檢查 URL 參數中是否指定了店家
          const groupIdFromUrl = searchParams.get('group');
          const targetGroup = groupIdFromUrl 
            ? result.data.orderGroups.find(g => g.groupId.toString() === groupIdFromUrl)
            : null;
          
          // 如果 URL 中指定的店家存在，使用它；否則使用第一個未截止的店家
          let initialGroup = targetGroup;
          if (!initialGroup) {
            // 找第一個未截止的店家
            const now = dayjs();
            initialGroup = result.data.orderGroups.find(
              g => dayjs(g.deadline).isAfter(now)
            ) || result.data.orderGroups[0]; // 如果都截止了，還是用第一個
          }
          setActiveTab(initialGroup.groupId.toString());
          // 載入指定店家的菜單
          loadStoreMenu(initialGroup.storeId, initialGroup.groupId);
        }
      }
    } catch (error) {
      console.error('載入揪團詳情失敗:', error);
      message.error('載入失敗');
    } finally {
      setLoading(false);
    }
  };

  const loadStoreMenu = async (storeId, groupId) => {
    if (menuData[groupId]) return; // 已載入

    try {
      setLoadingMenu(prev => ({ ...prev, [groupId]: true }));
      const result = await storeService.getStoreMenu(storeId);
      if (result.success) {
        setMenuData(prev => ({ ...prev, [groupId]: result.data || [] }));
      }
    } catch (error) {
      console.error('載入菜單失敗:', error);
      message.error('載入菜單失敗');
    } finally {
      setLoadingMenu(prev => ({ ...prev, [groupId]: false }));
    }
  };

  const handleTabChange = (key) => {
    setActiveTab(key);
    const group = event.orderGroups.find(g => g.groupId.toString() === key);
    if (group) {
      loadStoreMenu(group.storeId, group.groupId);
    }
  };

  const handleSubmitOrder = async () => {
    if (items.length === 0) {
      message.warning('購物車是空的');
      return;
    }

    try {
      setSubmitting(true);
      
      console.log('=== 開始提交訂單 ===');
      console.log('購物車商品:', items);
      
      // 按 groupId 分組
      const ordersByGroup = items.reduce((acc, item) => {
        if (!acc[item.groupId]) {
          acc[item.groupId] = [];
        }
        acc[item.groupId].push(item);
        return acc;
      }, {});

      console.log('按群組分組後:', ordersByGroup);

      // 提交每個 group 的訂單
      for (const [groupId, groupItems] of Object.entries(ordersByGroup)) {
        const orderData = {
          groupId: parseInt(groupId),
          items: groupItems.map(item => ({
            itemId: item.itemId,
            sizeCode: item.sizeCode,
            quantity: item.quantity,
            customOptions: item.customOptions || '',
            toppings: item.toppings ? item.toppings.map(t => t.name) : [],  // 只傳送配料名稱
            note: item.note || '',
          })),
        };

        console.log(`提交群組 ${groupId} 的訂單:`, orderData);
        
        try {
          const response = await orderService.submitOrder(eventId, orderData);
          console.log('訂單提交成功:', response);
        } catch (err) {
          console.error(`群組 ${groupId} 訂單提交失敗:`, err.response || err);
          throw err; // 重新拋出錯誤以便外層 catch 捕獲
        }
      }

      message.success('訂單提交成功！');
      clearCart();
      setCartVisible(false);
      
    } catch (error) {
      console.error('提交訂單失敗 - 完整錯誤:', error);
      console.error('錯誤回應:', error.response);
      console.error('錯誤資料:', error.response?.data);
      
      const errorMsg = error.response?.data?.message 
        || error.response?.data?.error
        || error.message 
        || '提交訂單失敗';
      
      message.error(errorMsg);
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div style={{ textAlign: 'center', padding: '100px 0' }}>
        <Spin size="large" />
      </div>
    );
  }

  if (!event) {
    return <Empty description="找不到該揪團" />;
  }

  const cartItemCount = items.reduce((sum, item) => sum + item.quantity, 0);

  return (
    <div>
      <Card style={{ marginBottom: 16 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
          <div>
            <h1 style={{ marginBottom: 8 }}>{event.title}</h1>
            <Space>
              {(() => {
                // 檢查是否所有店家都截止了
                const now = dayjs();
                const allExpired = event.orderGroups && event.orderGroups.length > 0 &&
                  event.orderGroups.every(group => dayjs(group.deadline).isBefore(now));
                const isOpen = event.status === 'Open' && !allExpired;
                return (
                  <Tag color={isOpen ? 'green' : 'orange'}>
                    {isOpen ? '進行中' : '已截止'}
                  </Tag>
                );
              })()}
              <span style={{ color: '#999' }}>
                <ClockCircleOutlined /> 發起於 {dayjs(event.createdAt).format('YYYY-MM-DD HH:mm')}
              </span>
            </Space>
            {event.notes && (
              <div style={{ marginTop: 12, padding: 8, background: '#f5f5f5', borderRadius: 4 }}>
                備註: {event.notes}
              </div>
            )}
          </div>
          <Space>
            <Button 
              type="primary"
              icon={<ShoppingCartOutlined />}
              onClick={() => setCartVisible(true)}
            >
              購物車 ({cartItemCount})
            </Button>
            <Button onClick={() => navigate(`/events/${eventId}/summary`)}>
              查看分帳明細
            </Button>
          </Space>
        </div>
      </Card>

      {event.orderGroups && event.orderGroups.length > 0 ? (
        <Card>
          <Tabs 
            activeKey={activeTab}
            onChange={handleTabChange}
            items={event.orderGroups.map((group) => ({
              key: group.groupId.toString(),
              label: (
                <span>
                  <ShopOutlined /> {group.storeName || `店家 ${group.storeId}`}
                </span>
              ),
              children: (
                <div>
                  <Descriptions bordered column={3} style={{ marginBottom: 16 }}>
                    <Descriptions.Item label="截止時間">
                      {dayjs(group.deadline).format('YYYY-MM-DD HH:mm')}
                    </Descriptions.Item>
                    <Descriptions.Item label="外送費">
                      {group.deliveryFee ? `$${group.deliveryFee}` : '免運'}
                    </Descriptions.Item>
                    <Descriptions.Item label="狀態">
                      {(() => {
                        const now = dayjs();
                        const isPastDeadline = dayjs(group.deadline).isBefore(now);
                        const isOpen = group.status === 'Open' && !isPastDeadline;
                        return (
                          <Tag color={isOpen ? 'green' : 'orange'}>
                            {isOpen ? '可點餐' : '已截止'}
                          </Tag>
                        );
                      })()}
                    </Descriptions.Item>
                  </Descriptions>

                  {loadingMenu[group.groupId] ? (
                    <div style={{ textAlign: 'center', padding: '50px 0' }}>
                      <Spin />
                    </div>
                  ) : menuData[group.groupId] && menuData[group.groupId].length > 0 ? (
                    <div style={{
                      display: 'grid',
                      gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))',
                      gap: '16px',
                    }}>
                      {menuData[group.groupId].map((item) => {
                        // 檢查是否已截止
                        const now = dayjs();
                        const isPastDeadline = dayjs(group.deadline).isBefore(now);
                        const isDisabled = group.status !== 'Open' || isPastDeadline;
                        
                        return (
                          <MenuItemCard 
                            key={item.menuItemId} 
                            item={item}
                            groupId={group.groupId}
                            disabled={isDisabled}
                          />
                        );
                      })}
                    </div>
                  ) : (
                    <Empty description="該店家尚無菜單品項" />
                  )}
                </div>
              ),
            }))}
          />
        </Card>
      ) : (
        <Empty description="該揪團沒有店家" />
      )}

      <Modal
        title="購物車"
        open={cartVisible}
        onCancel={() => setCartVisible(false)}
        width={700}
        footer={[
          <Button key="back" onClick={() => setCartVisible(false)}>
            繼續購物
          </Button>,
          <Button 
            key="submit" 
            type="primary" 
            loading={submitting}
            onClick={handleSubmitOrder}
            disabled={items.length === 0}
            icon={<CheckCircleOutlined />}
          >
            確認送出訂單
          </Button>,
        ]}
      >
        <ShoppingCart />
      </Modal>
    </div>
  );
};

export default EventDetail;
