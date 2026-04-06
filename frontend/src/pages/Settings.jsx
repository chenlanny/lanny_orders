import React, { useState } from 'react';
import { Card, Form, Input, Button, message, Switch, Select, Divider, Modal } from 'antd';
import { LockOutlined, BellOutlined, SafetyOutlined, EyeInvisibleOutlined, EyeOutlined } from '@ant-design/icons';
import api from '../services/api';

const { Option } = Select;

const Settings = () => {
  const [form] = Form.useForm();
  const [passwordForm] = Form.useForm();
  const [loading, setLoading] = useState(false);
  const [passwordModalVisible, setPasswordModalVisible] = useState(false);
  const [notifications, setNotifications] = useState({
    orderCreated: true,
    orderDeadline: true,
    orderDelivered: false,
  });

  // 處理通知設定變更
  const handleNotificationChange = (key, value) => {
    setNotifications({
      ...notifications,
      [key]: value
    });
    message.success('通知設定已更新');
  };

  // 處理密碼變更
  const handlePasswordChange = async (values) => {
    try {
      if (values.newPassword !== values.confirmPassword) {
        message.error('新密碼與確認密碼不符');
        return;
      }

      // 檢查新密碼是否與舊密碼相同
      if (values.oldPassword === values.newPassword) {
        message.error('新密碼不能與目前密碼相同');
        return;
      }

      setLoading(true);
      
      // 呼叫密碼變更 API
      await api.post('/auth/change-password', {
        oldPassword: values.oldPassword,
        newPassword: values.newPassword
      });
      
      message.success('密碼變更成功，請使用新密碼重新登入');
      setPasswordModalVisible(false);
      passwordForm.resetFields();
    } catch (error) {
      console.error('密碼變更失敗:', error);
      const errorMsg = error.response?.data?.message || '密碼變更失敗';
      message.error(errorMsg);
    } finally {
      setLoading(false);
    }
  };

  // 處理一般設定儲存
  const handleSettingsSave = async (values) => {
    try {
      setLoading(true);
      // TODO: 實作儲存設定 API
      console.log('儲存設定:', values);
      message.success('設定已儲存');
    } catch (error) {
      console.error('儲存失敗:', error);
      message.error('儲存設定失敗');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ padding: '24px', maxWidth: '800px', margin: '0 auto' }}>
      {/* 安全性設定 */}
      <Card 
        title={
          <span>
            <SafetyOutlined style={{ marginRight: '8px' }} />
            安全性設定
          </span>
        } 
        variant="borderless"
      >
        <div style={{ marginBottom: '16px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <div style={{ fontWeight: 'bold', marginBottom: '4px' }}>密碼</div>
              <div style={{ color: '#666', fontSize: '14px' }}>定期更新密碼以確保帳號安全</div>
            </div>
            <Button 
              icon={<LockOutlined />}
              onClick={() => setPasswordModalVisible(true)}
            >
              變更密碼
            </Button>
          </div>
        </div>
      </Card>

      {/* 通知設定 - 暫時隱藏 */}
      {false && (
      <Card 
        title={
          <span>
            <BellOutlined style={{ marginRight: '8px' }} />
            通知設定
          </span>
        } 
        style={{ marginTop: '24px' }}
        variant="borderless"
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
          <div>
            <div style={{ fontWeight: 'bold', marginBottom: '4px' }}>訂單建立通知</div>
            <div style={{ color: '#666', fontSize: '14px' }}>當新的揪團建立時收到通知</div>
          </div>
          <Switch 
            checked={notifications.orderCreated}
            onChange={(checked) => handleNotificationChange('orderCreated', checked)}
          />
        </div>

        <Divider style={{ margin: '16px 0' }} />

        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
          <div>
            <div style={{ fontWeight: 'bold', marginBottom: '4px' }}>截止時間提醒</div>
            <div style={{ color: '#666', fontSize: '14px' }}>在訂單即將截止前收到提醒</div>
          </div>
          <Switch 
            checked={notifications.orderDeadline}
            onChange={(checked) => handleNotificationChange('orderDeadline', checked)}
          />
        </div>

        <Divider style={{ margin: '16px 0' }} />

        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <div style={{ fontWeight: 'bold', marginBottom: '4px' }}>送達通知</div>
            <div style={{ color: '#666', fontSize: '14px' }}>當訂單送達時收到通知</div>
          </div>
          <Switch 
            checked={notifications.orderDelivered}
            onChange={(checked) => handleNotificationChange('orderDelivered', checked)}
          />
        </div>
      </Card>
      )}

      {/* 介面設定 - 暫時隱藏 */}
      {false && (
      <Card 
        title="介面設定" 
        style={{ marginTop: '24px' }}
        variant="borderless"
      >
        <Form
          form={form}
          layout="vertical"
          initialValues={{
            language: 'zh-TW',
            pageSize: '10'
          }}
          onFinish={handleSettingsSave}
        >
          {/* 語言設定 - 隱藏 */}
          {false && (
          <Form.Item
            label="語言"
            name="language"
          >
            <Select>
              <Option value="zh-TW">繁體中文</Option>
              <Option value="zh-CN">簡體中文</Option>
              <Option value="en-US">English</Option>
            </Select>
          </Form.Item>
          )}

          <Form.Item
            label="每頁顯示筆數"
            name="pageSize"
          >
            <Select>
              <Option value="10">10 筆</Option>
              <Option value="20">20 筆</Option>
              <Option value="50">50 筆</Option>
              <Option value="100">100 筆</Option>
            </Select>
          </Form.Item>

          <Form.Item>
            <Button type="primary" htmlType="submit" loading={loading} block>
              儲存設定
            </Button>
          </Form.Item>
        </Form>
      </Card>
      )}

      {/* 密碼變更 Modal */}
      <Modal
        title="變更密碼"
        open={passwordModalVisible}
        onCancel={() => {
          setPasswordModalVisible(false);
          passwordForm.resetFields();
        }}
        footer={null}
      >
        <Form
          form={passwordForm}
          layout="vertical"
          onFinish={handlePasswordChange}
        >
          <Form.Item
            label="目前密碼"
            name="oldPassword"
            rules={[{ required: true, message: '請輸入目前密碼' }]}
          >
            <Input.Password 
              prefix={<LockOutlined />}
              placeholder="請輸入目前密碼"
              iconRender={visible => (visible ? <EyeOutlined /> : <EyeInvisibleOutlined />)}
            />
          </Form.Item>

          <Form.Item
            label="新密碼"
            name="newPassword"
            dependencies={['oldPassword']}
            rules={[
              { required: true, message: '請輸入新密碼' },
              { min: 6, message: '密碼長度至少 6 個字元' },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue('oldPassword') !== value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(new Error('新密碼不能與目前密碼相同'));
                },
              }),
            ]}
          >
            <Input.Password 
              prefix={<LockOutlined />}
              placeholder="請輸入新密碼（至少 6 個字元）"
              iconRender={visible => (visible ? <EyeOutlined /> : <EyeInvisibleOutlined />)}
            />
          </Form.Item>

          <Form.Item
            label="確認新密碼"
            name="confirmPassword"
            rules={[
              { required: true, message: '請再次輸入新密碼' },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue('newPassword') === value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(new Error('兩次輸入的密碼不一致'));
                },
              }),
            ]}
          >
            <Input.Password 
              prefix={<LockOutlined />}
              placeholder="請再次輸入新密碼"
              iconRender={visible => (visible ? <EyeOutlined /> : <EyeInvisibleOutlined />)}
            />
          </Form.Item>

          <Form.Item style={{ marginBottom: 0 }}>
            <Button type="primary" htmlType="submit" loading={loading} block>
              確認變更
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
};

export default Settings;
