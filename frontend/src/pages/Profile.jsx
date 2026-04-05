import React, { useState } from 'react';
import { Card, Form, Input, Button, message, Divider, Avatar, Upload } from 'antd';
import { UserOutlined, MailOutlined, PhoneOutlined, HomeOutlined, UploadOutlined } from '@ant-design/icons';
import { useAuthStore } from '../store/authStore';

const Profile = () => {
  const { user } = useAuthStore();
  const [form] = Form.useForm();
  const [loading, setLoading] = useState(false);

  // 初始化表單值
  const initialValues = {
    name: user?.name || '',
    email: user?.email || '',
    phone: user?.phone || '',
    department: user?.department || '',
  };

  const handleSubmit = async (values) => {
    try {
      setLoading(true);
      // TODO: 實作更新個人資料 API
      console.log('更新個人資料:', values);
      message.success('個人資料更新成功');
    } catch (error) {
      console.error('更新失敗:', error);
      message.error('更新個人資料失敗');
    } finally {
      setLoading(false);
    }
  };

  const handleUploadAvatar = (info) => {
    if (info.file.status === 'done') {
      message.success('頭像上傳成功');
    } else if (info.file.status === 'error') {
      message.error('頭像上傳失敗');
    }
  };

  return (
    <div style={{ padding: '24px', maxWidth: '800px', margin: '0 auto' }}>
      <Card title="個人資料" bordered={false}>
        {/* 頭像區域 */}
        <div style={{ textAlign: 'center', marginBottom: '24px' }}>
          <Avatar size={100} icon={<UserOutlined />} style={{ marginBottom: '16px' }} />
          <div>
            <Upload
              showUploadList={false}
              onChange={handleUploadAvatar}
              beforeUpload={(file) => {
                const isImage = file.type.startsWith('image/');
                if (!isImage) {
                  message.error('只能上傳圖片檔案！');
                }
                const isLt2M = file.size / 1024 / 1024 < 2;
                if (!isLt2M) {
                  message.error('圖片大小不能超過 2MB！');
                }
                return isImage && isLt2M;
              }}
            >
              <Button icon={<UploadOutlined />} type="link">
                更換頭像
              </Button>
            </Upload>
          </div>
        </div>

        <Divider />

        {/* 基本資料表單 */}
        <Form
          form={form}
          layout="vertical"
          initialValues={initialValues}
          onFinish={handleSubmit}
        >
          <Form.Item
            label="姓名"
            name="name"
            rules={[{ required: true, message: '請輸入姓名' }]}
          >
            <Input prefix={<UserOutlined />} placeholder="請輸入姓名" />
          </Form.Item>

          <Form.Item
            label="Email"
            name="email"
            rules={[
              { required: true, message: '請輸入 Email' },
              { type: 'email', message: '請輸入有效的 Email' }
            ]}
          >
            <Input prefix={<MailOutlined />} placeholder="請輸入 Email" />
          </Form.Item>

          <Form.Item
            label="電話"
            name="phone"
          >
            <Input prefix={<PhoneOutlined />} placeholder="請輸入電話" />
          </Form.Item>

          <Form.Item
            label="部門"
            name="department"
          >
            <Input prefix={<HomeOutlined />} placeholder="請輸入部門" />
          </Form.Item>

          <Divider />

          <Form.Item>
            <Button type="primary" htmlType="submit" loading={loading} block>
              儲存變更
            </Button>
          </Form.Item>
        </Form>
      </Card>

      {/* 帳號資訊 */}
      <Card title="帳號資訊" style={{ marginTop: '24px' }} bordered={false}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '12px' }}>
          <span style={{ color: '#666' }}>角色:</span>
          <span>{user?.role === 'Admin' ? '管理員' : '一般使用者'}</span>
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between' }}>
          <span style={{ color: '#666' }}>帳號狀態:</span>
          <span style={{ color: '#52c41a' }}>啟用中</span>
        </div>
      </Card>
    </div>
  );
};

export default Profile;
