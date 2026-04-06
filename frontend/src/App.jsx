import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useAuthStore } from './store/authStore';
import Layout from './components/Layout/Layout';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import CreateEvent from './pages/CreateEvent';
import EventDetail from './pages/EventDetail';
import Summary from './pages/Summary';
import History from './pages/History';
import Stats from './pages/Stats';
import Cart from './pages/Cart';
import Profile from './pages/Profile';
import Settings from './pages/Settings';
import StoreManagement from './pages/StoreManagement';
import MenuManagement from './pages/MenuManagement';
import EventManagement from './pages/EventManagement';
import UserManagement from './pages/UserManagement';

// 受保護的路由組件
const ProtectedRoute = ({ children }) => {
  const { isAuthenticated } = useAuthStore();
  
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }
  
  return children;
};

// 管理員路由組件
const AdminRoute = ({ children }) => {
  const { isAuthenticated, user } = useAuthStore();
  
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }
  
  if (user?.role !== 'Admin') {
    return <Navigate to="/dashboard" replace />;
  }
  
  return children;
};

function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      
      <Route path="/" element={
        <ProtectedRoute>
          <Layout />
        </ProtectedRoute>
      }>
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="dashboard" element={<Dashboard />} />
        <Route path="cart" element={<Cart />} />
        <Route path="profile" element={<Profile />} />
        <Route path="settings" element={<Settings />} />
        <Route path="events/new" element={<CreateEvent />} />
        <Route path="events/:eventId" element={<EventDetail />} />
        <Route path="events/:eventId/summary" element={<Summary />} />
        <Route path="history" element={<History />} />
        <Route path="stats" element={<Stats />} />
        
        {/* 管理員路由 */}
        <Route path="admin/stores" element={<AdminRoute><StoreManagement /></AdminRoute>} />
        <Route path="admin/menu" element={<AdminRoute><MenuManagement /></AdminRoute>} />
        <Route path="admin/events" element={<AdminRoute><EventManagement /></AdminRoute>} />
        <Route path="admin/users" element={<AdminRoute><UserManagement /></AdminRoute>} />
      </Route>

      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
  );
}

export default App;
