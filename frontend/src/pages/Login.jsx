import React, { useState } from 'react';
import { Form, Input, Button, Card, message } from 'antd';
import { UserOutlined, LockOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { authService } from '../services/authService';
import { useAuthStore } from '../store/authStore';

const Login = () => {
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  const { setUser } = useAuthStore();

  const onFinish = async (values) => {
    try {
      setLoading(true);
      const result = await authService.login(values.email, values.password);
      
      if (result.success) {
        setUser(result.data.user);
        message.success('登入成功！');
        navigate('/dashboard');
      } else {
        message.error(result.message || '登入失敗');
      }
    } catch (error) {
      console.error('登入錯誤:', error);
      message.error(error.response?.data?.message || '登入失敗，請檢查帳號密碼');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #FFB75E 0%, #ED8F03 50%, #FF6B6B 100%)',
      position: 'relative',
      overflow: 'hidden',
    }}>
      {/* 裝飾性背景圖案 */}
      <div style={{
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        opacity: 0.1,
        backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v6h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`,
      }} />
      
      {/* 漂浮的裝飾圓圈 */}
      <div style={{
        position: 'absolute',
        width: '300px',
        height: '300px',
        borderRadius: '50%',
        background: 'rgba(255, 255, 255, 0.1)',
        top: '-100px',
        left: '-100px',
        animation: 'float 6s ease-in-out infinite',
      }} />
      <div style={{
        position: 'absolute',
        width: '200px',
        height: '200px',
        borderRadius: '50%',
        background: 'rgba(255, 255, 255, 0.08)',
        bottom: '-50px',
        right: '-50px',
        animation: 'float 8s ease-in-out infinite',
      }} />
      <div style={{
        position: 'absolute',
        width: '150px',
        height: '150px',
        borderRadius: '50%',
        background: 'rgba(255, 255, 255, 0.12)',
        top: '20%',
        right: '10%',
        animation: 'float 7s ease-in-out infinite',
      }} />
      
      <style>
        {`
          @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
          }
        `}
      </style>

      <Card 
        style={{ 
          width: 420,
          boxShadow: '0 20px 60px rgba(0,0,0,0.3)',
          borderRadius: '20px',
          position: 'relative',
          zIndex: 1,
          background: 'rgba(255, 255, 255, 0.95)',
          backdropFilter: 'blur(10px)',
        }}
      >
        <div style={{ textAlign: 'center', marginBottom: 32 }}>
          <div style={{ 
            fontSize: 65, 
            marginBottom: 16,
            filter: 'drop-shadow(0 4px 8px rgba(0,0,0,0.1))'
          }}>
            🥤🍔🍕
          </div>
          <h1 style={{ 
            fontSize: 33, 
            marginBottom: 8,
            background: 'linear-gradient(135deg, #FF6B6B 0%, #ED8F03 100%)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            fontWeight: 'bold',
          }}>
            餐飲訂購系統
          </h1>
          <p style={{ 
            color: '#666',
            fontSize: 15,
            margin: 0,
          }}>
            開心訂購，輕鬆點餐，才有動力繼續 🎉
          </p>
        </div>

        <Form
          name="login"
          onFinish={onFinish}
          autoComplete="off"
          size="large"
        >
          <Form.Item
            name="email"
            rules={[
              { required: true, message: '請輸入Email' },
              { type: 'email', message: '請輸入有效的Email格式' }
            ]}
          >
            <Input 
              prefix={<UserOutlined style={{ color: '#FF8C42' }} />} 
              placeholder="請輸入您的 Email"
              style={{
                borderRadius: '8px',
                padding: '12px',
                fontSize: '16px',
              }}
            />
          </Form.Item>

          <Form.Item
            name="password"
            rules={[{ required: true, message: '請輸入密碼' }]}
          >
            <Input.Password
              prefix={<LockOutlined style={{ color: '#FF8C42' }} />}
              placeholder="請輸入您的密碼"
              style={{
                borderRadius: '8px',
                padding: '12px',
                fontSize: '16px',
              }}
            />
          </Form.Item>

          <Form.Item>
            <Button 
              type="primary" 
              htmlType="submit" 
              loading={loading}
              block
              style={{ 
                height: 48,
                fontSize: 17,
                fontWeight: 'bold',
                background: 'linear-gradient(135deg, #FF6B6B 0%, #ED8F03 100%)',
                border: 'none',
                borderRadius: '8px',
                boxShadow: '0 4px 15px rgba(255, 107, 107, 0.4)',
              }}
            >
              立即登入
            </Button>
          </Form.Item>
        </Form>

        <div style={{ 
          textAlign: 'center', 
          color: '#999', 
          fontSize: 13,
          marginTop: 16,
          padding: '12px',
          background: '#f5f5f5',
          borderRadius: '8px',
        }}>
          💡 測試帳號: admin@company.com / admin999
        </div>
      </Card>
    </div>
  );
};

export default Login;
