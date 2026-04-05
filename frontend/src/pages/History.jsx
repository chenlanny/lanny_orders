import React from 'react';
import { Empty, Button } from 'antd';
import { useNavigate } from 'react-router-dom';

const History = () => {
  const navigate = useNavigate();

  return (
    <div style={{ textAlign: 'center', padding: '100px 0' }}>
      <Empty 
        description="歷史訂單功能開發中"
        image={Empty.PRESENTED_IMAGE_SIMPLE}
      >
        <Button type="primary" onClick={() => navigate('/dashboard')}>
          返回首頁
        </Button>
      </Empty>
    </div>
  );
};

export default History;
