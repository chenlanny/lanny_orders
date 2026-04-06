import React from 'react';
import { Layout as AntLayout } from 'antd';
import { Outlet } from 'react-router-dom';
import Header from './Header';
import Sidebar from './Sidebar';

const { Content, Sider } = AntLayout;

const Layout = () => {
  return (
    <AntLayout style={{ minHeight: '100vh', background: '#FFF9F0' }}>
      <Header />
      <AntLayout>
        <Sider width={220} style={{ background: 'transparent' }}>
          <Sidebar />
        </Sider>
        <AntLayout style={{ padding: '24px', background: '#FFF9F0' }}>
          <Content
            style={{
              background: '#fff',
              padding: 24,
              margin: 0,
              minHeight: 280,
              borderRadius: '12px',
              boxShadow: '0 2px 8px rgba(255, 140, 66, 0.1)',
            }}
          >
            <Outlet />
          </Content>
        </AntLayout>
      </AntLayout>
    </AntLayout>
  );
};

export default Layout;
