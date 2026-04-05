import React from 'react';
import { Layout as AntLayout, Menu, Avatar, Dropdown, Button } from 'antd';
import { 
  UserOutlined, 
  LogoutOutlined, 
  SettingOutlined,
  ShoppingCartOutlined 
} from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
import { useCartStore } from '../../store/cartStore';

const { Header: AntHeader } = AntLayout;

const Header = () => {
  const navigate = useNavigate();
  const { user, logout } = useAuthStore();
  const { items } = useCartStore();
  
  const cartItemCount = items.reduce((sum, item) => sum + item.quantity, 0);

  const userMenuItems = [
    {
      key: 'profile',
      icon: <UserOutlined />,
      label: '個人資料',
      onClick: () => navigate('/profile'),
    },
    {
      key: 'settings',
      icon: <SettingOutlined />,
      label: '設定',
      onClick: () => navigate('/settings'),
    },
    {
      type: 'divider',
    },
    {
      key: 'logout',
      icon: <LogoutOutlined />,
      label: '登出',
      onClick: () => {
        logout();
        navigate('/login');
      },
    },
  ];

  return (
    <AntHeader 
      style={{ 
        background: '#fff', 
        padding: '0 24px', 
        display: 'flex', 
        justifyContent: 'space-between',
        alignItems: 'center',
        boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center' }}>
        <h2 style={{ margin: 0, cursor: 'pointer' }} onClick={() => navigate('/dashboard')}>
          🥤 智慧訂購系統
        </h2>
      </div>

      <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
        <Button 
          type="text" 
          icon={<ShoppingCartOutlined />}
          onClick={() => navigate('/cart')}
          style={{ position: 'relative' }}
        >
          購物車
          {cartItemCount > 0 && (
            <span style={{
              position: 'absolute',
              top: 0,
              right: 0,
              background: '#ff4d4f',
              color: 'white',
              borderRadius: '10px',
              padding: '0 6px',
              fontSize: '12px',
              minWidth: '20px',
              textAlign: 'center'
            }}>
              {cartItemCount}
            </span>
          )}
        </Button>

        <Dropdown menu={{ items: userMenuItems }} placement="bottomRight">
          <div style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '8px' }}>
            <Avatar icon={<UserOutlined />} />
            <span>{user?.name || '使用者'}</span>
          </div>
        </Dropdown>
      </div>
    </AntHeader>
  );
};

export default Header;
