import React, { useState, useEffect } from 'react';
import { 
  Table, 
  Button, 
  Modal, 
  Form, 
  Input, 
  Select, 
  Space, 
  message,
  Popconfirm,
  Tag
} from 'antd';
import { 
  PlusOutlined, 
  EditOutlined, 
  DeleteOutlined 
} from '@ant-design/icons';
import api from '../services/api';

const { Option } = Select;

const StoreManagement = () => {
  const [stores, setStores] = useState([]);
  const [loading, setLoading] = useState(false);
  const [modalVisible, setModalVisible] = useState(false);
  const [editingStore, setEditingStore] = useState(null);
  const [form] = Form.useForm();

  useEffect(() => {
    loadStores();
  }, []);

  const loadStores = async () => {
    try {
      setLoading(true);
      const response = await api.get('/stores');
      setStores(response.data.data || []);
    } catch (error) {
      message.error('載入店家列表失敗');
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const handleAdd = () => {
    setEditingStore(null);
    form.resetFields();
    setModalVisible(true);
  };

  const handleEdit = (record) => {
    setEditingStore(record);
    form.setFieldsValue({
      name: record.storeName,
      category: record.category,
      phone: record.phone,
      address: record.address,
    });
    setModalVisible(true);
  };

  const handleDelete = async (storeId) => {
    try {
      await api.delete(`/stores/${storeId}`);
      message.success('店家刪除成功');
      loadStores();
    } catch (error) {
      const errMsg = error.response?.data?.message || '刪除失敗';
      message.error(errMsg);
    }
  };

  const handleSubmit = async () => {
    try {
      const values = await form.validateFields();
      
      if (editingStore) {
        // 更新
        await api.put(`/stores/${editingStore.storeId}`, values);
        message.success('店家更新成功');
      } else {
        // 新增
        await api.post('/stores', values);
        message.success('店家創建成功');
      }
      
      setModalVisible(false);
      loadStores();
    } catch (error) {
      if (error.errorFields) {
        return; // 表單驗證錯誤
      }
      const errMsg = error.response?.data?.message || '操作失敗';
      message.error(errMsg);
    }
  };

  const columns = [
    {
      title: '店家ID',
      dataIndex: 'storeId',
      key: 'storeId',
      width: 80,
    },
    {
      title: '店家名稱',
      dataIndex: 'storeName',
      key: 'storeName',
    },
    {
      title: '類別',
      dataIndex: 'category',
      key: 'category',
      render: (category) => (
        <Tag color={category === 'Drink' ? 'blue' : 'green'}>
          {category === 'Drink' ? '飲料' : '便當'}
        </Tag>
      ),
    },
    {
      title: '電話',
      dataIndex: 'phone',
      key: 'phone',
    },
    {
      title: '地址',
      dataIndex: 'address',
      key: 'address',
    },
    {
      title: '操作',
      key: 'actions',
      width: 150,
      render: (_, record) => (
        <Space>
          <Button 
            type="link" 
            icon={<EditOutlined />}
            onClick={() => handleEdit(record)}
          >
            編輯
          </Button>
          <Popconfirm
            title="確定要刪除此店家嗎？"
            description="刪除後無法恢復"
            onConfirm={() => handleDelete(record.storeId)}
            okText="確定"
            cancelText="取消"
          >
            <Button 
              type="link" 
              danger
              icon={<DeleteOutlined />}
            >
              刪除
            </Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div>
      <div style={{ marginBottom: 16, display: 'flex', justifyContent: 'space-between' }}>
        <h2>店家管理</h2>
        <Button 
          type="primary" 
          icon={<PlusOutlined />}
          onClick={handleAdd}
        >
          新增店家
        </Button>
      </div>

      <Table
        columns={columns}
        dataSource={stores}
        rowKey="storeId"
        loading={loading}
      />

      <Modal
        title={editingStore ? '編輯店家' : '新增店家'}
        open={modalVisible}
        onOk={handleSubmit}
        onCancel={() => setModalVisible(false)}
        okText="確定"
        cancelText="取消"
      >
        <Form
          form={form}
          layout="vertical"
        >
          <Form.Item
            name="name"
            label="店家名稱"
            rules={[{ required: true, message: '請輸入店家名稱' }]}
          >
            <Input placeholder="例如：50嵐" />
          </Form.Item>

          <Form.Item
            name="category"
            label="類別"
            rules={[{ required: true, message: '請選擇類別' }]}
          >
            <Select placeholder="請選擇類別">
              <Option value="Drink">飲料</Option>
              <Option value="Lunch">便當</Option>
            </Select>
          </Form.Item>

          <Form.Item
            name="phone"
            label="電話"
            rules={[
              { pattern: /^[\d-()]+$/, message: '請輸入有效的電話號碼' }
            ]}
          >
            <Input placeholder="例如：02-1234-5678" />
          </Form.Item>

          <Form.Item
            name="address"
            label="地址"
          >
            <Input.TextArea 
              placeholder="店家地址" 
              rows={2}
            />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
};

export default StoreManagement;
