import React from 'react';
import { Layout as AntLayout, Menu, Avatar, Dropdown } from 'antd';
import { 
  UserOutlined, 
  LogoutOutlined, 
  LockOutlined
} from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';

const { Header: AntHeader } = AntLayout;

const Header = () => {
  const navigate = useNavigate();
  const { user, logout } = useAuthStore();

  const userMenuItems = [
    {
      key: 'profile',
      icon: <UserOutlined />,
      label: '個人資料',
      onClick: () => navigate('/profile'),
    },
    {
      key: 'settings',
      icon: <LockOutlined />,
      label: '密碼變更',
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
        background: 'linear-gradient(135deg, #FFB75E 0%, #ED8F03 50%, #FF6B6B 100%)', 
        padding: '0 24px', 
        display: 'flex', 
        justifyContent: 'space-between',
        alignItems: 'center',
        boxShadow: '0 4px 12px rgba(255, 107, 107, 0.3)',
        height: '64px'
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        <div style={{ 
          fontSize: '33px',
          filter: 'drop-shadow(0 2px 4px rgba(0,0,0,0.2))'
        }}>
          🥤🍔🍕
        </div>
        <h2 
          style={{ 
            margin: 0, 
            cursor: 'pointer',
            fontSize: '25px',
            fontWeight: 'bold',
            color: '#fff',
            textShadow: '0 2px 4px rgba(0,0,0,0.2)'
          }} 
          onClick={() => navigate('/dashboard')}
        >
          餐飲訂購系統
        </h2>
      </div>

      <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
        <Dropdown menu={{ items: userMenuItems }} placement="bottomRight">
          <div style={{ 
            cursor: 'pointer', 
            display: 'flex', 
            alignItems: 'center', 
            gap: '8px',
            padding: '8px 16px',
            background: 'rgba(255, 255, 255, 0.2)',
            borderRadius: '20px',
            backdropFilter: 'blur(10px)',
            transition: 'all 0.3s ease'
          }}>
            <Avatar 
              icon={<UserOutlined />} 
              style={{ 
                background: '#fff',
                color: '#FF8C42'
              }}
            />
            <span style={{ 
              color: '#fff',
              fontWeight: '500',
              textShadow: '0 1px 2px rgba(0,0,0,0.2)'
            }}>
              {user?.name || '使用者'}
            </span>
          </div>
        </Dropdown>
      </div>
    </AntHeader>
  );
};

export default Header;
