import React, { useState } from 'react';
import { Card, Button, InputNumber, Select, Checkbox, Input, Space, message, Modal } from 'antd';
import { ShoppingCartOutlined, PlusOutlined } from '@ant-design/icons';
import { useCartStore } from '../../store/cartStore';

const MenuItemCard = ({ item, groupId, disabled }) => {
  const [modalVisible, setModalVisible] = useState(false);
  const [selectedSize, setSelectedSize] = useState(null);
  const [quantity, setQuantity] = useState(1);
  const [sweetness, setSweetness] = useState('');
  const [temperature, setTemperature] = useState('');
  const [toppings, setToppings] = useState([]);
  const [note, setNote] = useState('');
  const { addItem } = useCartStore();

  // 解析價格規則 - 修正欄位名稱和格式
  const priceRules = item.priceRules ? JSON.parse(item.priceRules) : {};
  // 將簡單的 {中杯:50, 大杯:55} 轉換為數組格式
  const sizeOptions = Object.entries(priceRules).map(([sizeName, price]) => ({
    code: sizeName,
    name: sizeName,
    price: price
  }));
  
  // 解析選項
  const options = item.options ? JSON.parse(item.options) : null;

  const handleOpenModal = () => {
    if (sizeOptions.length > 0) {
      setSelectedSize(sizeOptions[0].code);
    }
    if (options) {
      if (options.sweetness && options.sweetness.length > 0) {
        setSweetness(options.sweetness[0]);
      }
      if (options.temperature && options.temperature.length > 0) {
        setTemperature(options.temperature[0]);
      }
    }
    setModalVisible(true);
  };

  const handleAddToCart = () => {
    if (!selectedSize) {
      message.warning('請選擇尺寸');
      return;
    }

    // 計算價格
    const sizeOption = sizeOptions.find(opt => opt.code === selectedSize);
    const basePrice = sizeOption ? sizeOption.price : 0;
    
    let toppingPrice = 0;
    const selectedToppings = [];
    if (options && options.toppings && toppings.length > 0) {
      toppings.forEach(toppingName => {
        const topping = options.toppings.find(t => t.name === toppingName);
        if (topping) {
          toppingPrice += topping.price;
          selectedToppings.push({
            name: topping.name,
            price: topping.price,
          });
        }
      });
    }

    const unitPrice = basePrice + toppingPrice;
    const subTotal = unitPrice * quantity;

    // 建立客製化選項字串
    let customOptions = [];
    if (sweetness) customOptions.push(sweetness);
    if (temperature) customOptions.push(temperature);

    const cartItem = {
      groupId,
      itemId: item.menuItemId,
      itemName: item.itemName,
      sizeCode: selectedSize,
      sizeName: sizeOption ? sizeOption.name : '',
      quantity,
      customOptions: customOptions.join(','),
      toppings: selectedToppings,
      note,
      basePrice,
      toppingPrice,
      unitPrice,
      subTotal,
    };

    addItem(cartItem);
    message.success('已加入購物車');
    setModalVisible(false);
    resetForm();
  };

  const resetForm = () => {
    setQuantity(1);
    setSweetness('');
    setTemperature('');
    setToppings([]);
    setNote('');
  };

  const getCurrentPrice = () => {
    if (!selectedSize) return 0;
    const sizeOption = sizeOptions.find(opt => opt.code === selectedSize);
    let price = sizeOption ? sizeOption.price : 0;
    
    if (options && options.toppings && toppings.length > 0) {
      toppings.forEach(toppingName => {
        const topping = options.toppings.find(t => t.name === toppingName);
        if (topping) {
          price += topping.price;
        }
      });
    }
    
    return price;
  };

  return (
    <>
      <Card
        hoverable={!disabled}
        cover={
          item.imageUrl ? (
            <img alt={item.itemName} src={item.imageUrl} style={{ height: 180, objectFit: 'cover' }} />
          ) : (
            <div style={{ height: 180, background: '#f0f0f0', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <ShoppingCartOutlined style={{ fontSize: 48, color: '#999' }} />
            </div>
          )
        }
      >
        <Card.Meta
          title={item.itemName}
          description={
            <div>
              {item.category && <div style={{ color: '#999', fontSize: 12 }}>{item.category}</div>}
              {sizeOptions.length > 0 && (
                <div style={{ marginTop: 8, fontWeight: 'bold', color: '#ff4d4f' }}>
                  ${sizeOptions[0].price}
                  {sizeOptions.length > 1 && ' 起'}
                </div>
              )}
            </div>
          }
        />
        <Button 
          type="primary" 
          block 
          icon={<PlusOutlined />}
          onClick={handleOpenModal}
          disabled={disabled || !item.isAvailable}
          style={{ marginTop: 12 }}
        >
          {disabled ? '已截止' : item.isAvailable ? '加入購物車' : '已售完'}
        </Button>
      </Card>

      <Modal
        title={item.itemName}
        open={modalVisible}
        onCancel={() => {
          setModalVisible(false);
          resetForm();
        }}
        width={500}
        footer={[
          <Button key="back" onClick={() => setModalVisible(false)}>
            取消
          </Button>,
          <Button key="submit" type="primary" onClick={handleAddToCart}>
            加入購物車 ${getCurrentPrice() * quantity}
          </Button>,
        ]}
      >
        <Space direction="vertical" style={{ width: '100%' }} size="middle">
          {/* 尺寸選擇 */}
          {sizeOptions.length > 0 && (
            <div>
              <div style={{ marginBottom: 8 }}>
                <span style={{ color: '#ff4d4f' }}>*</span> 尺寸/份量:
              </div>
              <Select
                value={selectedSize}
                onChange={setSelectedSize}
                style={{ width: '100%' }}
                size="large"
              >
                {sizeOptions.map(opt => (
                  <Select.Option key={opt.code} value={opt.code}>
                    {opt.name} - ${opt.price}
                  </Select.Option>
                ))}
              </Select>
            </div>
          )}

          {/* 甜度選擇 */}
          {options && options.sweetness && options.sweetness.length > 0 && (
            <div>
              <div style={{ marginBottom: 8 }}>
                甜度:
              </div>
              <Select
                value={sweetness}
                onChange={setSweetness}
                style={{ width: '100%' }}
                size="large"
                placeholder="請選擇"
              >
                {options.sweetness.map(opt => (
                  <Select.Option key={opt} value={opt}>{opt}</Select.Option>
                ))}
              </Select>
            </div>
          )}

          {/* 溫度選擇 */}
          {options && options.temperature && options.temperature.length > 0 && (
            <div>
              <div style={{ marginBottom: 8 }}>
                溫度:
              </div>
              <Select
                value={temperature}
                onChange={setTemperature}
                style={{ width: '100%' }}
                size="large"
                placeholder="請選擇"
              >
                {options.temperature.map(opt => (
                  <Select.Option key={opt} value={opt}>{opt}</Select.Option>
                ))}
              </Select>
            </div>
          )}

          {/* 加料選擇 */}
          {options && options.toppings && options.toppings.length > 0 && (
            <div>
              <div style={{ marginBottom: 8 }}>
                加料:
              </div>
              <Checkbox.Group 
                value={toppings} 
                onChange={(values) => {
                  setToppings(values);
                }}
                style={{ width: '100%' }}
              >
                <Space direction="vertical" style={{ width: '100%' }}>
                  {options.toppings.map(opt => (
                    <Checkbox key={opt.name} value={opt.name}>
                      {opt.name} (+${opt.price})
                    </Checkbox>
                  ))}
                </Space>
              </Checkbox.Group>
            </div>
          )}

          {/* 備註 */}
          <div>
            <div style={{ marginBottom: 8 }}>備註:</div>
            <Input.TextArea
              value={note}
              onChange={(e) => setNote(e.target.value)}
              placeholder="例：去冰"
              rows={2}
            />
          </div>

          {/* 數量 */}
          <div>
            <div style={{ marginBottom: 8 }}>數量:</div>
            <InputNumber
              value={quantity}
              onChange={setQuantity}
              min={1}
              max={99}
              style={{ width: '100%' }}
              size="large"
            />
          </div>

          {/* 價格明細 */}
          <div style={{ background: '#f5f5f5', padding: 12, borderRadius: 4 }}>
            <div>基礎價格: ${selectedSize ? sizeOptions.find(opt => opt.code === selectedSize)?.price || 0 : 0}</div>
            {toppings.length > 0 && options && options.toppings && (
              <div>
                加料費用: +${toppings.reduce((sum, name) => {
                  const topping = options.toppings.find(t => t.name === name);
                  return sum + (topping ? topping.price : 0);
                }, 0)}
              </div>
            )}
            <div style={{ fontWeight: 'bold', fontSize: 16, marginTop: 8 }}>
              單價合計: ${getCurrentPrice()}
            </div>
          </div>
        </Space>
      </Modal>
    </>
  );
};

export default MenuItemCard;
