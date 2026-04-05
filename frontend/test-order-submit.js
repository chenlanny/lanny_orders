// 測試訂單提交 API
// 在瀏覽器的 Console 中執行此腳本

console.log('=== 訂單提交測試 ===');

// 1. 檢查購物車內容
const cartStore = JSON.parse(localStorage.getItem('cart-storage'));
console.log('購物車狀態:', cartStore);

if (!cartStore || !cartStore.state || !cartStore.state.items || cartStore.state.items.length === 0) {
    console.error('❌ 購物車是空的！請先加入商品。');
} else {
    console.log('✅ 購物車有', cartStore.state.items.length, '個商品');
    console.log('商品詳情:', cartStore.state.items);
    
    // 2. 檢查資料格式
    const firstItem = cartStore.state.items[0];
    console.log('\n第一個商品檢查:');
    console.log('- groupId:', firstItem.groupId, typeof firstItem.groupId);
    console.log('- itemId:', firstItem.itemId, typeof firstItem.itemId);
    console.log('- sizeCode:', firstItem.sizeCode, typeof firstItem.sizeCode);
    console.log('- quantity:', firstItem.quantity, typeof firstItem.quantity);
    console.log('- customOptions:', firstItem.customOptions);
    console.log('- toppings:', firstItem.toppings);
    console.log('- note:', firstItem.note);
    
    // 3. 模擬轉換後的資料
    const transformedToppings = firstItem.toppings ? firstItem.toppings.map(t => t.name) : [];
    console.log('\n轉換後的配料:', transformedToppings);
    
    // 4. 建立請求資料
    const requestData = {
        groupId: firstItem.groupId,
        items: cartStore.state.items.map(item => ({
            itemId: item.itemId,
            sizeCode: item.sizeCode,
            quantity: item.quantity,
            customOptions: item.customOptions || '',
            toppings: item.toppings ? item.toppings.map(t => t.name) : [],
            note: item.note || ''
        }))
    };
    
    console.log('\n準備送出的請求資料:');
    console.log(JSON.stringify(requestData, null, 2));
}

console.log('\n=== 如何手動測試 ===');
console.log('1. 複製上面的「準備送出的請求資料」');
console.log('2. 在 Network 標籤中找到失敗的請求');
console.log('3. 右鍵 > Copy > Copy as fetch');
console.log('4. 貼到 Console，修改 body 為上面的資料');
console.log('5. 執行並查看回應');
