import { create } from 'zustand';

export const useCartStore = create((set) => ({
  items: [],
  
  // 添加品項到購物車
  addItem: (item) => set((state) => {
    const existingItemIndex = state.items.findIndex(
      (i) => i.itemId === item.itemId && 
             i.sizeCode === item.sizeCode && 
             JSON.stringify(i.toppings) === JSON.stringify(item.toppings) &&
             i.customOptions === item.customOptions
    );
    
    if (existingItemIndex >= 0) {
      // 如果已存在相同配置的品項，增加數量
      const newItems = [...state.items];
      newItems[existingItemIndex].quantity += item.quantity;
      return { items: newItems };
    } else {
      // 否則添加新品項
      return { items: [...state.items, item] };
    }
  }),
  
  // 移除品項
  removeItem: (index) => set((state) => ({
    items: state.items.filter((_, i) => i !== index)
  })),
  
  // 清空購物車
  clearCart: () => set({ items: [] }),
  
  // 更新品項數量
  updateQuantity: (index, quantity) => set((state) => {
    if (quantity <= 0) {
      return { items: state.items.filter((_, i) => i !== index) };
    }
    const newItems = [...state.items];
    newItems[index].quantity = quantity;
    return { items: newItems };
  }),
  
  // 計算總價
  getTotal: () => {
    const state = useCartStore.getState();
    return state.items.reduce((total, item) => {
      return total + (item.unitPrice * item.quantity);
    }, 0);
  },
}));

export default useCartStore;
