import React from 'react';
import { Menu } from 'antd';
import { 
  DashboardOutlined,
  ShoppingOutlined,
  HistoryOutlined,
  BarChartOutlined,
  ShopOutlined,
  SettingOutlined,
  UnorderedListOutlined,
  TeamOutlined
} from '@ant-design/icons';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';

const Sidebar = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useAuthStore();
  
  const isAdmin = user?.role === 'Admin';

  const menuItems = [
    {
      key: '/dashboard',
      icon: <DashboardOutlined />,
      label: '首頁',
    },
    {
      key: '/events/new',
      icon: <ShoppingOutlined />,
      label: '發起揪團',
    },
    {
      key: '/history',
      icon: <HistoryOutlined />,
      label: '歷史訂單',
    },
    {
      key: '/stats',
      icon: <BarChartOutlined />,
      label: '統計分析',
    },
    ...(isAdmin ? [
      {
        type: 'divider',
      },
      {
        key: '/admin',
        icon: <SettingOutlined />,
        label: '管理後台',
        children: [
          {
            key: '/admin/stores',
            icon: <ShopOutlined />,
            label: '店家管理',
          },
          {
            key: '/admin/menu',
            icon: <UnorderedListOutlined />,
            label: '菜單管理',
          },
          {
            key: '/admin/events',
            icon: <ShoppingOutlined />,
            label: '揪團管理',
          },
          {
            key: '/admin/users',
            icon: <TeamOutlined />,
            label: '帳號人員管理',
          },
        ],
      },
    ] : []),
  ];

  const handleMenuClick = ({ key }) => {
    navigate(key);
  };

  return (
    <div style={{
      height: '100%',
      background: 'linear-gradient(180deg, #FFF5E6 0%, #FFE8CC 100%)',
      borderRight: '1px solid #FFD4A3'
    }}>
      <Menu
        mode="inline"
        selectedKeys={[location.pathname]}
        style={{ 
          height: '100%', 
          borderRight: 0,
          background: 'transparent',
          fontSize: '16px'
        }}
        items={menuItems}
        onClick={handleMenuClick}
        theme="light"
      />
      <style>
        {`
          .ant-menu-item-selected {
            background: linear-gradient(135deg, #FFB75E 0%, #FF8C42 100%) !important;
            color: #fff !important;
            font-weight: bold;
          }
          .ant-menu-item-selected .anticon {
            color: #fff !important;
          }
          .ant-menu-item:hover {
            background: rgba(255, 183, 94, 0.2) !important;
            color: #FF6B6B;
          }
          .ant-menu-submenu-selected > .ant-menu-submenu-title {
            color: #FF6B6B !important;
            font-weight: bold;
          }
          .ant-menu-item {
            margin: 4px 8px !important;
            border-radius: 8px !important;
            transition: all 0.3s ease;
          }
          .ant-menu-submenu {
            margin: 4px 8px !important;
          }
          .ant-menu-submenu-title {
            border-radius: 8px !important;
            margin: 0 !important;
          }
        `}
      </style>
    </div>
  );
};

export default Sidebar;
