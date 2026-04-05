import React, { useState, useEffect } from 'react';
import { Form, Input, Button, Card, Select, DatePicker, InputNumber, Space, message, Spin } from 'antd';
import { MinusCircleOutlined, PlusOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { eventService } from '../services/eventService';
import { storeService } from '../services/storeService';
import dayjs from 'dayjs';

const CreateEvent = () => {
  const [form] = Form.useForm();
  const [loading, setLoading] = useState(false);
  const [stores, setStores] = useState([]);
  const [loadingStores, setLoadingStores] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    loadStores();
  }, []);

  const loadStores = async () => {
    try {
      setLoadingStores(true);
      const result = await storeService.getStores();
      if (result.success) {
        setStores(result.data || []);
      }
    } catch (error) {
      console.error('載入店家失敗:', error);
      message.error('載入店家失敗');
    } finally {
      setLoadingStores(false);
    }
  };

  const onFinish = async (values) => {
    try {
      setLoading(true);
      
      // 格式化資料
      const eventData = {
        title: values.title,
        notes: values.notes || '',
        orderGroups: values.orderGroups.map(group => ({
          storeId: group.storeId,
          deadline: group.deadline.toISOString(),
          deliveryFee: group.deliveryFee || 0,
        })),
      };

      const result = await eventService.createEvent(eventData);
      
      if (result.success) {
        message.success('揪團發起成功！');
        navigate('/dashboard');
      } else {
        message.error(result.message || '發起失敗');
      }
    } catch (error) {
      console.error('發起揪團失敗:', error);
      message.error(error.response?.data?.message || '發起失敗，請稍後再試');
    } finally {
      setLoading(false);
    }
  };

  if (loadingStores) {
    return (
      <div style={{ textAlign: 'center', padding: '100px 0' }}>
        <Spin size="large" />
      </div>
    );
  }

  return (
    <div style={{ maxWidth: 800, margin: '0 auto' }}>
      <h1>發起新揪團</h1>
      
      <Card>
        <Form
          form={form}
          layout="vertical"
          onFinish={onFinish}
          initialValues={{
            orderGroups: [{ deliveryFee: 0 }],
          }}
        >
          <Form.Item
            label="揪團名稱"
            name="title"
            rules={[{ required: true, message: '請輸入揪團名稱' }]}
          >
            <Input placeholder="例：下午茶揪團" size="large" />
          </Form.Item>

          <Form.Item
            label="備註"
            name="notes"
          >
            <Input.TextArea 
              placeholder="例：記得帶環保杯" 
              rows={2}
            />
          </Form.Item>

          <div style={{ marginBottom: 16 }}>
            <h3>店家設定</h3>
            <p style={{ color: '#999', fontSize: 12 }}>可同時選擇多家店家</p>
          </div>

          <Form.List name="orderGroups">
            {(fields, { add, remove }) => (
              <>
                {fields.map(({ key, name, ...restField }) => (
                  <Card 
                    key={key} 
                    size="small" 
                    style={{ marginBottom: 16, background: '#fafafa' }}
                    extra={
                      fields.length > 1 ? (
                        <MinusCircleOutlined
                          onClick={() => remove(name)}
                          style={{ color: '#ff4d4f' }}
                        />
                      ) : null
                    }
                  >
                    <Form.Item
                      {...restField}
                      label="店家"
                      name={[name, 'storeId']}
                      rules={[{ required: true, message: '請選擇店家' }]}
                    >
                      <Select placeholder="請選擇店家" size="large">
                        {stores.map((store) => (
                          <Select.Option key={store.storeId} value={store.storeId}>
                            {store.storeName} ({store.category === 'Drink' ? '飲料' : store.category === 'Lunch' ? '便當' : '其他'})
                          </Select.Option>
                        ))}
                      </Select>
                    </Form.Item>

                    <Form.Item
                      {...restField}
                      label="截止時間"
                      name={[name, 'deadline']}
                      rules={[{ required: true, message: '請選擇截止時間' }]}
                    >
                      <DatePicker 
                        showTime 
                        format="YYYY-MM-DD HH:mm"
                        placeholder="選擇截止時間"
                        style={{ width: '100%' }}
                        size="large"
                        disabledDate={(current) => current && current < dayjs().startOf('day')}
                      />
                    </Form.Item>

                    <Form.Item
                      {...restField}
                      label="外送費"
                      name={[name, 'deliveryFee']}
                      tooltip="設定為 0 表示無外送費"
                    >
                      <InputNumber
                        min={0}
                        placeholder="外送費"
                        style={{ width: '100%' }}
                        size="large"
                        addonAfter="元"
                      />
                    </Form.Item>
                  </Card>
                ))}
                
                <Form.Item>
                  <Button 
                    type="dashed" 
                    onClick={() => add({ deliveryFee: 0 })} 
                    block
                    icon={<PlusOutlined />}
                  >
                    新增店家
                  </Button>
                </Form.Item>
              </>
            )}
          </Form.List>

          <Form.Item>
            <Space>
              <Button type="primary" htmlType="submit" loading={loading} size="large">
                發起揪團
              </Button>
              <Button onClick={() => navigate('/dashboard')} size="large">
                取消
              </Button>
            </Space>
          </Form.Item>
        </Form>
      </Card>
    </div>
  );
};

export default CreateEvent;
