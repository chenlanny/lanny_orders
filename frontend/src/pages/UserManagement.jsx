import React, { useState, useEffect } from 'react';
import { Card, Table, Tag, Space, message, Button, Modal, Form, Input, Switch, Select, Popconfirm } from 'antd';
import { UserOutlined, EditOutlined, DeleteOutlined, LockOutlined, PlusOutlined } from '@ant-design/icons';
import dayjs from 'dayjs';
import api from '../services/api';

const { Option } = Select;

const UserManagement = () => {
  const [loading, setLoading] = useState(false);
  const [users, setUsers] = useState([]);
  const [editModalVisible, setEditModalVisible] = useState(false);
  const [createModalVisible, setCreateModalVisible] = useState(false);
  const [passwordModalVisible, setPasswordModalVisible] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [form] = Form.useForm();
  const [createForm] = Form.useForm();
  const [passwordForm] = Form.useForm();

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = async () => {
    try {
      setLoading(true);
      const response = await api.get('/users');
      setUsers(response.data.data || []);
    } catch (error) {
      message.error('載入用戶列表失敗');
      console.error('載入用戶列表失敗:', error);
    } finally {
      setLoading(false);
    }
  };

  const showEditModal = (user) => {
    setSelectedUser(user);
    form.setFieldsValue({
      name: user.name,
      email: user.email,
      department: user.department,
      role: user.role,
      isActive: user.isActive
    });
    setEditModalVisible(true);
  };

  const showPasswordModal = (user) => {
    setSelectedUser(user);
    passwordForm.resetFields();
    setPasswordModalVisible(true);
  };

  const showCreateModal = () => {
    createForm.resetFields();
    createForm.setFieldsValue({ role: 'User' }); // 預設為一般用戶
    setCreateModalVisible(true);
  };

  const handleCreateUser = async () => {
    try {
      const values = await createForm.validateFields();
      await api.post('/users', values);
      message.success('新增用戶成功');
      setCreateModalVisible(false);
      loadUsers();
    } catch (error) {
      if (error.response?.data?.message) {
        message.error(error.response.data.message);
      } else if (!error.errorFields) {
        message.error('新增用戶失敗');
      }
      console.error('新增用戶失敗:', error);
    }
  };

  const handleUpdateUser = async () => {
    try {
      const values = await form.validateFields();
      await api.put(`/users/${selectedUser.userId}`, values);
      message.success('用戶資訊更新成功');
      setEditModalVisible(false);
      loadUsers();
    } catch (error) {
      if (error.response?.data?.message) {
        message.error(error.response.data.message);
      } else if (!error.errorFields) {
        message.error('更新用戶資訊失敗');
      }
      console.error('更新用戶資訊失敗:', error);
    }
  };

  const handleResetPassword = async () => {
    try {
      const values = await passwordForm.validateFields();
      await api.put(`/users/${selectedUser.userId}/reset-password`, {
        newPassword: values.newPassword
      });
      message.success('密碼重置成功');
      setPasswordModalVisible(false);
    } catch (error) {
      if (!error.errorFields) {
        message.error('重置密碼失敗');
      }
      console.error('重置密碼失敗:', error);
    }
  };

  const handleDeleteUser = async (userId) => {
    try {
      await api.delete(`/users/${userId}`);
      message.success('用戶已停用');
      loadUsers();
    } catch (error) {
      if (error.response?.data?.message) {
        message.error(error.response.data.message);
      } else {
        message.error('停用用戶失敗');
      }
      console.error('停用用戶失敗:', error);
    }
  };

  const getRoleTag = (role) => {
    const roleConfig = {
      'Admin': { color: 'red', text: '管理員' },
      'User': { color: 'blue', text: '一般用戶' }
    };
    const config = roleConfig[role] || { color: 'default', text: role };
    return <Tag color={config.color}>{config.text}</Tag>;
  };

  const columns = [
    {
      title: 'ID',
      dataIndex: 'userId',
      key: 'userId',
      width: 70,
    },
    {
      title: '姓名',
      dataIndex: 'name',
      key: 'name',
      width: 120,
    },
    {
      title: 'Email',
      dataIndex: 'email',
      key: 'email',
      width: 200,
    },
    {
      title: '部門',
      dataIndex: 'department',
      key: 'department',
      width: 120,
      render: (text) => text || '-',
    },
    {
      title: '角色',
      dataIndex: 'role',
      key: 'role',
      width: 100,
      render: (role) => getRoleTag(role),
    },
    {
      title: '狀態',
      dataIndex: 'isActive',
      key: 'isActive',
      width: 90,
      render: (isActive) => (
        <Tag color={isActive ? 'success' : 'default'}>
          {isActive ? '啟用' : '停用'}
        </Tag>
      ),
    },
    {
      title: '註冊時間',
      dataIndex: 'createdAt',
      key: 'createdAt',
      width: 130,
      render: (date) => dayjs(date).format('YYYY-MM-DD'),
    },
    {
      title: '最後登入',
      dataIndex: 'lastLoginAt',
      key: 'lastLoginAt',
      width: 150,
      render: (date) => date ? dayjs(date).format('YYYY-MM-DD HH:mm') : '-',
    },
    {
      title: '操作',
      key: 'action',
      width: 200,
      fixed: 'right',
      render: (_, record) => (
        <Space size="small">
          <Button
            type="link"
            size="small"
            icon={<EditOutlined />}
            onClick={() => showEditModal(record)}
          >
            編輯
          </Button>
          <Button
            type="link"
            size="small"
            icon={<LockOutlined />}
            onClick={() => showPasswordModal(record)}
          >
            重置密碼
          </Button>
          <Popconfirm
            title="確定要停用此用戶嗎？"
            description="停用後該用戶將無法登入系統"
            onConfirm={() => handleDeleteUser(record.userId)}
            okText="確定"
            cancelText="取消"
          >
            <Button
              type="link"
              size="small"
              danger
              icon={<DeleteOutlined />}
            >
              停用
            </Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: '24px' }}>
      <Card
        title={
          <Space>
            <UserOutlined />
            <span>帳號人員管理</span>
          </Space>
        }
        extra={
          <Space>
            <Button
              type="primary"
              icon={<PlusOutlined />}
              onClick={showCreateModal}
            >
              新增用戶
            </Button>
            <Button onClick={loadUsers}>刷新</Button>
          </Space>
        }
      >
        <Table
          columns={columns}
          dataSource={users}
          rowKey="userId"
          loading={loading}
          scroll={{ x: 1200 }}
          pagination={{
            pageSize: 20,
            showSizeChanger: true,
            showTotal: (total) => `共 ${total} 筆`,
          }}
        />
      </Card>

      {/* 編輯用戶 Modal */}
      <Modal
        title={`編輯用戶 - ${selectedUser?.name}`}
        open={editModalVisible}
        onOk={handleUpdateUser}
        onCancel={() => setEditModalVisible(false)}
        width={600}
        okText="保存"
        cancelText="取消"
      >
        <Form
          form={form}
          layout="vertical"
          style={{ marginTop: 24 }}
        >
          <Form.Item
            label="姓名"
            name="name"
            rules={[{ required: true, message: '請輸入姓名' }]}
          >
            <Input placeholder="請輸入姓名" />
          </Form.Item>

          <Form.Item
            label="Email"
            name="email"
            rules={[
              { required: true, message: '請輸入 Email' },
              { type: 'email', message: 'Email 格式不正確' }
            ]}
          >
            <Input placeholder="請輸入 Email" />
          </Form.Item>

          <Form.Item
            label="部門"
            name="department"
          >
            <Input placeholder="請輸入部門（選填）" />
          </Form.Item>

          <Form.Item
            label="角色"
            name="role"
            rules={[{ required: true, message: '請選擇角色' }]}
          >
            <Select>
              <Option value="User">一般用戶</Option>
              <Option value="Admin">管理員</Option>
            </Select>
          </Form.Item>

          <Form.Item
            label="啟用狀態"
            name="isActive"
            valuePropName="checked"
          >
            <Switch checkedChildren="啟用" unCheckedChildren="停用" />
          </Form.Item>
        </Form>
      </Modal>

      {/* 重置密碼 Modal */}
      <Modal
        title={`重置密碼 - ${selectedUser?.name}`}
        open={passwordModalVisible}
        onOk={handleResetPassword}
        onCancel={() => setPasswordModalVisible(false)}
        okText="確定重置"
        cancelText="取消"
      >
        <Form
          form={passwordForm}
          layout="vertical"
          style={{ marginTop: 24 }}
        >
          <Form.Item
            label="新密碼"
            name="newPassword"
            rules={[
              { required: true, message: '請輸入新密碼' },
              { min: 6, message: '密碼長度至少 6 個字元' }
            ]}
          >
            <Input.Password placeholder="請輸入新密碼（至少 6 個字元）" />
          </Form.Item>

          <Form.Item
            label="確認密碼"
            name="confirmPassword"
            dependencies={['newPassword']}
            rules={[
              { required: true, message: '請確認新密碼' },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue('newPassword') === value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(new Error('兩次密碼輸入不一致'));
                },
              }),
            ]}
          >
            <Input.Password placeholder="請再次輸入新密碼" />
          </Form.Item>
        </Form>
      </Modal>

      {/* 新增用戶 Modal */}
      <Modal
        title="新增用戶"
        open={createModalVisible}
        onOk={handleCreateUser}
        onCancel={() => setCreateModalVisible(false)}
        width={600}
        okText="確定新增"
        cancelText="取消"
      >
        <Form
          form={createForm}
          layout="vertical"
          style={{ marginTop: 24 }}
          initialValues={{ role: 'User' }}
        >
          <Form.Item
            label="姓名"
            name="name"
            rules={[{ required: true, message: '請輸入姓名' }]}
          >
            <Input placeholder="請輸入姓名" />
          </Form.Item>

          <Form.Item
            label="Email"
            name="email"
            rules={[
              { required: true, message: '請輸入 Email' },
              { type: 'email', message: 'Email 格式不正確' }
            ]}
          >
            <Input placeholder="請輸入 Email" />
          </Form.Item>

          <Form.Item
            label="密碼"
            name="password"
            rules={[
              { required: true, message: '請輸入密碼' },
              { min: 6, message: '密碼長度至少 6 個字元' }
            ]}
          >
            <Input.Password placeholder="請輸入密碼（至少 6 個字元）" />
          </Form.Item>

          <Form.Item
            label="確認密碼"
            name="confirmPassword"
            dependencies={['password']}
            rules={[
              { required: true, message: '請確認密碼' },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue('password') === value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(new Error('兩次密碼輸入不一致'));
                },
              }),
            ]}
          >
            <Input.Password placeholder="請再次輸入密碼" />
          </Form.Item>

          <Form.Item
            label="部門"
            name="department"
          >
            <Input placeholder="請輸入部門（選填）" />
          </Form.Item>

          <Form.Item
            label="角色"
            name="role"
            rules={[{ required: true, message: '請選擇角色' }]}
          >
            <Select>
              <Option value="User">一般用戶</Option>
              <Option value="Admin">管理員</Option>
            </Select>
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
};

export default UserManagement;
