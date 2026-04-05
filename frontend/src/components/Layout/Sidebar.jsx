import React from 'react';
import { Menu } from 'antd';
import { 
  DashboardOutlined,
  ShoppingOutlined,
  HistoryOutlined,
  BarChartOutlined,
  ShopOutlined,
  SettingOutlined,
  UnorderedListOutlined
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
        ],
      },
    ] : []),
  ];

  const handleMenuClick = ({ key }) => {
    navigate(key);
  };

  return (
    <Menu
      mode="inline"
      selectedKeys={[location.pathname]}
      style={{ height: '100%', borderRight: 0 }}
      items={menuItems}
      onClick={handleMenuClick}
    />
  );
};

export default Sidebar;
