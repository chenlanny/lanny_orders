import React from 'react';
import { List, Button, InputNumber, Tag, Space, Empty } from 'antd';
import { DeleteOutlined } from '@ant-design/icons';
import { useCartStore } from '../../store/cartStore';

const ShoppingCart = () => {
  const { items, removeItem, updateQuantity, getTotal } = useCartStore();

  if (items.length === 0) {
    return <Empty description="購物車是空的" image={Empty.PRESENTED_IMAGE_SIMPLE} />;
  }

  return (
    <div>
      <List
        dataSource={items}
        renderItem={(item, index) => (
          <List.Item
            key={index}
            extra={
              <Button 
                type="text" 
                danger 
                icon={<DeleteOutlined />}
                onClick={() => removeItem(index)}
              />
            }
          >
            <List.Item.Meta
              title={
                <Space>
                  <span>{item.itemName}</span>
                  <Tag color="blue">{item.sizeName}</Tag>
                </Space>
              }
              description={
                <Space direction="vertical" size="small">
                  {item.customOptions && (
                    <div style={{ fontSize: 12, color: '#999' }}>
                      {item.customOptions}
                    </div>
                  )}
                  {item.toppings && item.toppings.length > 0 && (
                    <div style={{ fontSize: 12 }}>
                      加料: {item.toppings.map(t => `${t.name} (+$${t.price})`).join(', ')}
                    </div>
                  )}
                  {item.note && (
                    <div style={{ fontSize: 12, color: '#666' }}>
                      備註: {item.note}
                    </div>
                  )}
                  <Space>
                    <span>數量:</span>
                    <InputNumber
                      value={item.quantity}
                      onChange={(value) => updateQuantity(index, value)}
                      min={1}
                      max={99}
                      size="small"
                    />
                  </Space>
                  <div style={{ fontWeight: 'bold', color: '#ff4d4f' }}>
                    ${item.unitPrice} × {item.quantity} = ${item.subTotal}
                  </div>
                </Space>
              }
            />
          </List.Item>
        )}
      />
      
      <div style={{ 
        marginTop: 16, 
        padding: '16px 0', 
        borderTop: '2px solid #f0f0f0',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center'
      }}>
        <span style={{ fontSize: 18, fontWeight: 'bold' }}>總計:</span>
        <span style={{ fontSize: 24, fontWeight: 'bold', color: '#ff4d4f' }}>
          ${getTotal()}
        </span>
      </div>
    </div>
  );
};

export default ShoppingCart;
