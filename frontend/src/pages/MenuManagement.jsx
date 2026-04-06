import React, { useState, useEffect } from 'react';
import { 
  Select, 
  Table, 
  Button, 
  Modal, 
  Form, 
  Input, 
  InputNumber,
  Switch, 
  Space, 
  message,
  Popconfirm,
  Tag,
  Card,
  Row,
  Col,
  Divider
} from 'antd';
import { 
  PlusOutlined, 
  EditOutlined, 
  DeleteOutlined,
  MinusCircleOutlined
} from '@ant-design/icons';
import api from '../services/api';

const { Option } = Select;

const MenuManagement = () => {
  const [stores, setStores] = useState([]);
  const [selectedStoreId, setSelectedStoreId] = useState(null);
  const [menuItems, setMenuItems] = useState([]);
  const [loading, setLoading] = useState(false);
  const [modalVisible, setModalVisible] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [form] = Form.useForm();

  useEffect(() => {
    loadStores();
  }, []);

  useEffect(() => {
    if (selectedStoreId) {
      loadMenuItems();
    }
  }, [selectedStoreId]);

  const loadStores = async () => {
    try {
      const response = await api.get('/stores');
      setStores(response.data.data || []);
      if (response.data.data?.length > 0) {
        setSelectedStoreId(response.data.data[0].storeId);
      }
    } catch (error) {
      message.error('載入店家列表失敗');
    }
  };

  const loadMenuItems = async () => {
    try {
      setLoading(true);
      const response = await api.get(`/stores/${selectedStoreId}/menu/all`);
      setMenuItems(response.data.data || []);
    } catch (error) {
      message.error('載入菜單失敗');
    } finally {
      setLoading(false);
    }
  };

  const handleAdd = () => {
    setEditingItem(null);
    form.resetFields();
    // 設置默認值
    form.setFieldsValue({
      isAvailable: true,
      prices: [
        { sizeName: '中杯', price: 50 },
        { sizeName: '大杯', price: 60 }
      ],
      sweetnessOptions: ['正常', '少糖', '半糖', '微糖', '無糖'],
      temperatureOptions: ['正常冰', '少冰', '微冰', '去冰', '溫', '熱'],
      toppings: [
        { name: '珍珠', price: 10 },
        { name: '波霸', price: 10 }
      ]
    });
    setModalVisible(true);
  };

  const handleEdit = (record) => {
    setEditingItem(record);
    
    // 解析 JSON 資料為友善的表單格式
    let prices = [];
    let sweetnessOptions = [];
    let temperatureOptions = [];
    let toppings = [];
    
    try {
      const priceRules = JSON.parse(record.priceRules);
      prices = Object.entries(priceRules).map(([sizeName, price]) => ({
        sizeName,
        price
      }));
    } catch (e) {
      console.error('解析價格規則失敗:', e);
    }
    
    try {
      if (record.options) {
        const options = JSON.parse(record.options);
        sweetnessOptions = options.sweetness || [];
        temperatureOptions = options.temperature || [];
        toppings = options.toppings || [];
      }
    } catch (e) {
      console.error('解析選項失敗:', e);
    }
    
    form.setFieldsValue({
      itemName: record.itemName,
      category: record.category,
      prices,
      sweetnessOptions,
      temperatureOptions,
      toppings,
      isAvailable: record.isAvailable,
    });
    setModalVisible(true);
  };

  const handleDelete = async (menuItemId) => {
    try {
      await api.delete(`/stores/menu/${menuItemId}`);
      message.success('菜單項目刪除成功');
      loadMenuItems();
    } catch (error) {
      message.error(error.response?.data?.message || '刪除失敗');
    }
  };

  const handleSubmit = async () => {
    try {
      const values = await form.validateFields();
      
      // 將友善的表單資料轉換為 JSON 格式
      const priceRules = {};
      if (values.prices && values.prices.length > 0) {
        values.prices.forEach(item => {
          if (item && item.sizeName && item.price) {
            priceRules[item.sizeName] = item.price;
          }
        });
      }
      
      const options = {
        sweetness: values.sweetnessOptions || [],
        temperature: values.temperatureOptions || [],
        toppings: values.toppings || []
      };
      
      const payload = {
        itemName: values.itemName,
        category: values.category,
        priceRules: JSON.stringify(priceRules),
        options: JSON.stringify(options),
        isAvailable: values.isAvailable
      };
      
      if (Object.keys(priceRules).length === 0) {
        message.error('請至少設定一個價格');
        return;
      }
      
      if (editingItem) {
        await api.put(`/stores/menu/${editingItem.menuItemId}`, payload);
        message.success('菜單更新成功');
      } else {
        await api.post(`/stores/${selectedStoreId}/menu`, payload);
        message.success('菜單創建成功');
      }
      
      setModalVisible(false);
      loadMenuItems();
    } catch (error) {
      if (error.errorFields) {
        return;
      }
      message.error(error.response?.data?.message || '操作失敗');
    }
  };

  const columns = [
    {
      title: '序號',
      dataIndex: 'menuItemId',
      width: 60,
      render: (_, __, index) => index + 1,
    },
    {
      title: '品項名稱',
      dataIndex: 'itemName',
    },
    {
      title: '類別',
      dataIndex: 'category',
    },
    {
      title: '價格',
      dataIndex: 'priceRules',
      render: (priceRules) => {
        try {
          const prices = JSON.parse(priceRules);
          return Object.entries(prices).map(([size, price]) => (
            <Tag key={size}>{size}: ${price}</Tag>
          ));
        } catch {
          return priceRules;
        }
      },
    },
    {
      title: '狀態',
      dataIndex: 'isAvailable',
      render: (isAvailable) => (
        <Tag color={isAvailable ? 'green' : 'red'}>
          {isAvailable ? '上架' : '下架'}
        </Tag>
      ),
    },
    {
      title: '操作',
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
            title="確定要刪除此菜單嗎？"
            onConfirm={() => handleDelete(record.menuItemId)}
          >
            <Button type="link" danger icon={<DeleteOutlined />}>
              刪除
            </Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div>
      <Card style={{ marginBottom: 16 }}>
        <Space style={{ width: '100%', justifyContent: 'space-between' }}>
          <div>
            <span style={{ marginRight: 16 }}>選擇店家：</span>
            <Select
              style={{ width: 200 }}
              value={selectedStoreId}
              onChange={setSelectedStoreId}
            >
              {stores.map(store => (
                <Option key={store.storeId} value={store.storeId}>
                  {store.storeName}
                </Option>
              ))}
            </Select>
          </div>
          <Button 
            type="primary" 
            icon={<PlusOutlined />}
            onClick={handleAdd}
            disabled={!selectedStoreId}
          >
            新增菜單
          </Button>
        </Space>
      </Card>

      <Table
        columns={columns}
        dataSource={menuItems}
        rowKey="menuItemId"
        loading={loading}
      />

      <Modal
        title={editingItem ? '編輯菜單' : '新增菜單'}
        open={modalVisible}
        onOk={handleSubmit}
        onCancel={() => setModalVisible(false)}
        width={700}
        okText="確定"
        cancelText="取消"
      >
        <Form form={form} layout="vertical">
          <Form.Item
            name="itemName"
            label="品項名稱"
            rules={[{ required: true, message: '請輸入品項名稱' }]}
          >
            <Input placeholder="例如：珍珠奶茶" />
          </Form.Item>

          <Form.Item
            name="category"
            label="類別"
            rules={[{ required: true, message: '請輸入類別' }]}
          >
            <Input placeholder="例如：奶茶、綠茶、果茶" />
          </Form.Item>

          <Divider orientation="left">價格設定</Divider>
          
          <Form.List name="prices">
            {(fields, { add, remove }) => (
              <>
                {fields.map(({ key, name, ...restField }) => (
                  <Row key={key} gutter={16} style={{ marginBottom: 8 }}>
                    <Col span={10}>
                      <Form.Item
                        {...restField}
                        name={[name, 'sizeName']}
                        rules={[{ required: true, message: '請輸入尺寸名稱' }]}
                      >
                        <Input placeholder="尺寸 (如：中杯、大杯)" />
                      </Form.Item>
                    </Col>
                    <Col span={10}>
                      <Form.Item
                        {...restField}
                        name={[name, 'price']}
                        rules={[{ required: true, message: '請輸入價格' }]}
                      >
                        <InputNumber
                          placeholder="價格（元）"
                          min={0}
                          style={{ width: '100%' }}
                        />
                      </Form.Item>
                    </Col>
                    <Col span={4}>
                      <MinusCircleOutlined 
                        onClick={() => remove(name)}
                        style={{ fontSize: 20, color: '#ff4d4f', marginTop: 8 }}
                      />
                    </Col>
                  </Row>
                ))}
                <Form.Item>
                  <Button
                    type="dashed"
                    onClick={() => add()}
                    block
                    icon={<PlusOutlined />}
                  >
                    新增價格選項
                  </Button>
                </Form.Item>
              </>
            )}
          </Form.List>

          <Divider orientation="left">甜度選項</Divider>
          
          <Form.Item
            name="sweetnessOptions"
            label="甜度選項"
            tooltip="輸入後按 Enter 新增"
          >
            <Select
              mode="tags"
              placeholder="例如：正常、少糖、半糖、微糖、無糖"
              style={{ width: '100%' }}
            />
          </Form.Item>

          <Divider orientation="left">溫度選項</Divider>
          
          <Form.Item
            name="temperatureOptions"
            label="溫度選項"
            tooltip="輸入後按 Enter 新增"
          >
            <Select
              mode="tags"
              placeholder="例如：正常冰、少冰、微冰、去冰、溫、熱"
              style={{ width: '100%' }}
            />
          </Form.Item>

          <Divider orientation="left">配料選項</Divider>
          
          <Form.List name="toppings">
            {(fields, { add, remove }) => (
              <>
                {fields.map(({ key, name, ...restField }) => (
                  <Row key={key} gutter={16} style={{ marginBottom: 8 }}>
                    <Col span={10}>
                      <Form.Item
                        {...restField}
                        name={[name, 'name']}
                        rules={[{ required: true, message: '請輸入配料名稱' }]}
                      >
                        <Input placeholder="配料名稱 (如：珍珠、椰果)" />
                      </Form.Item>
                    </Col>
                    <Col span={10}>
                      <Form.Item
                        {...restField}
                        name={[name, 'price']}
                        rules={[{ required: true, message: '請輸入加價金額' }]}
                      >
                        <InputNumber
                          placeholder="加價金額（元）"
                          min={0}
                          style={{ width: '100%' }}
                        />
                      </Form.Item>
                    </Col>
                    <Col span={4}>
                      <MinusCircleOutlined 
                        onClick={() => remove(name)}
                        style={{ fontSize: 20, color: '#ff4d4f', marginTop: 8 }}
                      />
                    </Col>
                  </Row>
                ))}
                <Form.Item>
                  <Button
                    type="dashed"
                    onClick={() => add()}
                    block
                    icon={<PlusOutlined />}
                  >
                    新增配料選項
                  </Button>
                </Form.Item>
              </>
            )}
          </Form.List>

          <Divider />

          <Form.Item
            name="isAvailable"
            label="是否上架"
            valuePropName="checked"
          >
            <Switch checkedChildren="上架" unCheckedChildren="下架" />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
};

export default MenuManagement;
