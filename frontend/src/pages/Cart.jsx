import React from 'react';
import { Card, Button, Space, Divider, Typography, Alert } from 'antd';
import { useNavigate } from 'react-router-dom';
import { ArrowLeftOutlined, ShoppingOutlined } from '@ant-design/icons';
import ShoppingCart from '../components/Order/ShoppingCart';
import { useCartStore } from '../store/cartStore';

const { Title } = Typography;

const Cart = () => {
  const navigate = useNavigate();
  const { items, clearCart } = useCartStore();

  const handleBackToDashboard = () => {
    navigate('/dashboard');
  };

  const handleContinueShopping = () => {
    navigate('/dashboard');
  };

  const handleClearCart = () => {
    clearCart();
  };

  return (
    <div style={{ padding: '24px' }}>
      <Card>
        <Space direction="vertical" size="large" style={{ width: '100%' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <Space>
              <Button 
                icon={<ArrowLeftOutlined />} 
                onClick={handleBackToDashboard}
              >
                返回
              </Button>
              <Title level={3} style={{ margin: 0 }}>
                🛒 我的購物車
              </Title>
            </Space>
            
            {items.length > 0 && (
              <Button 
                danger 
                onClick={handleClearCart}
              >
                清空購物車
              </Button>
            )}
          </div>

          <Divider />

          {items.length === 0 && (
            <Alert
              message="購物車是空的"
              description="前往揪團活動頁面，選擇店家開始點餐吧！"
              type="info"
              showIcon
              action={
                <Button 
                  type="primary" 
                  icon={<ShoppingOutlined />}
                  onClick={handleContinueShopping}
                >
                  開始點餐
                </Button>
              }
            />
          )}

          <ShoppingCart />

          {items.length > 0 && (
            <>
              <Divider />
              
              <div style={{ textAlign: 'center' }}>
                <Space size="large">
                  <Button 
                    size="large" 
                    onClick={handleContinueShopping}
                  >
                    繼續購物
                  </Button>
                  
                  <Alert
                    type="warning"
                    showIcon
                    message="請注意"
                    description="購物車商品尚未送出訂單，請前往揪團活動頁面完成提交"
                    style={{ marginTop: 16 }}
                  />
                </Space>
              </div>
            </>
          )}
        </Space>
      </Card>
    </div>
  );
};

export default Cart;
