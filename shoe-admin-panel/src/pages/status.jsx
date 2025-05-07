import React, { useEffect, useState } from 'react';
import { getOrders } from '../api/Order';

// Shared styles
const styles = {
  cell: { border: '1px solid #e5e7eb', padding: '8px 16px', color: '#000000' },
  header: { border: '1px solid #e5e7eb', padding: '8px 16px', fontWeight: 'bold', backgroundColor: '#f0f0f0', color: '#000000' },
  button: { padding: '8px 16px', borderRadius: '0.5rem', border: 'none', cursor: 'pointer', fontWeight: 'bold' },
  badge: (bg, color, border) => ({
    backgroundColor: bg,
    color: color,
    border: `1px solid ${border}`,
    padding: '4px 12px',
    borderRadius: '4px',
    display: 'inline-block',
    fontWeight: 'bold'
  })
};

// Status colors mapping
const statusColors = {
  pending: { bg: '#fff7ed', color: '#ea580c', border: '#fed7aa' },
  accepted: { bg: '#ecfdf5', color: '#059669', border: '#a7f3d0' },
  processing: { bg: '#f0f9ff', color: '#0284c7', border: '#bae6fd' },
  transit: { bg: '#f5f3ff', color: '#7c3aed', border: '#ddd6fe' },
  shipped: { bg: '#eef2ff', color: '#4f46e5', border: '#c7d2fe' },
  delivered: { bg: '#f0fdf4', color: '#15803d', border: '#86efac' },
  cancelled: { bg: '#fef2f2', color: '#b91c1c', border: '#fecaca' },
  exchange: { bg: '#fef2f2', color: '#c2410c', border: '#fed7aa' },
  return: { bg: '#fff1f2', color: '#9f1239', border: '#fecdd3' }
};

// Helper component for info fields
const InfoField = ({ label, value }) => (
  <div>
    <p style={{ margin: '4px 0', color: '#6b7280' }}>{label}</p>
    <p style={{ margin: '4px 0', fontWeight: 'bold', color: '#000000' }}>{value}</p>
  </div>
);

function OrderStatus({ 
  statusType, 
  title, 
  description,
  filterCondition,
  actionConfig,
  handleSubmit
}) {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [comment, setComment] = useState('');
  const [stats, setStats] = useState({ total: 0, filtered: 0 });
  const [updateSuccess, setUpdateSuccess] = useState(false);
  const [updateError, setUpdateError] = useState(null);

  useEffect(() => {
    fetchOrders();
  }, []);

  const fetchOrders = async () => {
    try {
      setLoading(true);
      const response = await getOrders();
      if (response && response.data) {
        const ordersData = response.data;
        setOrders(ordersData);
        
        const filteredCount = ordersData.filter(filterCondition).length;
        setStats({
          total: ordersData.length,
          filtered: filteredCount
        });
      }
    } catch (err) {
      setError("Failed to load orders");
    } finally {
      setLoading(false);
    }
  };

  const filteredOrders = orders.filter(filterCondition);

  const handleActionClick = (order, e) => {
    if (e) e.stopPropagation();
    setSelectedOrder(order);
    setComment('');
    setShowModal(true);
    setUpdateSuccess(false);
    setUpdateError(null);
  };

  const handleClose = () => {
    setShowModal(false);
    setSelectedOrder(null);
    setComment('');
    setUpdateSuccess(false);
    setUpdateError(null);
  };

  const handleOrderSubmit = async () => {
    if (!selectedOrder || !actionConfig || !actionConfig.updates) return;
    
    try {
      // Just pass the orderId and comment to the parent component
      await handleSubmit(selectedOrder._id, comment);
      
      // Update UI state on success
      setUpdateSuccess(true);
      setUpdateError(null);
      
      // Refresh the orders list
      fetchOrders();
      
      // Close modal after short delay
      setTimeout(() => {
        handleClose();
      }, 2000);
      
    } catch (err) {
      setUpdateError(err.message || "Failed to update order");
      setUpdateSuccess(false);
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    return new Date(dateString).toLocaleString('en-IN', {
      year: 'numeric', month: 'short', day: 'numeric',
      hour: '2-digit', minute: '2-digit'
    });
  };

  const getTotalItems = (items) => {
    if (!items || !Array.isArray(items)) return 0;
    return items.reduce((total, item) => total + (item.quantity || 0), 0);
  };

  const formatAddress = (address) => {
    if (!address) return 'N/A';
    
    const parts = [];
    if (address.name) parts.push(address.name);
    if (address.street) parts.push(address.street);
    
    const cityParts = [];
    if (address.city) cityParts.push(address.city);
    if (address.state) cityParts.push(address.state);
    if (address.postalCode) cityParts.push(address.postalCode);
    
    if (cityParts.length > 0) {
      parts.push(cityParts.join(', '));
    }
    
    return parts.join(', ') || 'N/A';
  };

  const getStatusDisplay = (order) => {
    if (order.isCancelled) return { text: "Cancelled", ...statusColors.cancelled };
    if (order.isDelivered) return { text: "Delivered", ...statusColors.delivered };
    if (order.isShipped) return { text: "Shipped", ...statusColors.shipped };
    if (order.isInTransit) return { text: "In Transit", ...statusColors.transit };
    if (order.isInProcess) return { text: "Processing", ...statusColors.processing };
    if (order.isOrderAccepted) return { text: "Accepted", ...statusColors.accepted };
    if (order.isExchangeRequest) return { text: "Exchange Requested", ...statusColors.exchange };
    if (order.isReturnRequest) return { text: "Return Requested", ...statusColors.return };
    return { text: "Pending", ...statusColors.pending };
  };

  if (loading) return <div style={{ padding: '20px', color: '#000000', width: '100%', backgroundColor: 'white' }}>Loading orders...</div>;
  if (error) return <div style={{ padding: '20px', color: '#ef4444', width: '100%', backgroundColor: 'white' }}>Error: {error}</div>;

  return (
    <div style={{ width: '100%', backgroundColor: 'white', minHeight: '100%' }}>
      <div style={{ display: 'flex', gap: '16px', marginBottom: '20px' }}>
        <div style={{ 
          padding: '16px', 
          backgroundColor: '#f9fafb', 
          borderRadius: '8px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <p style={{ margin: '0 0 4px 0', color: '#6b7280', fontSize: '0.875rem' }}>Total Orders</p>
          <p style={{ margin: 0, fontWeight: 'bold', fontSize: '1.5rem', color: '#000000' }}>{stats.total}</p>
        </div>
        
        <div style={{ 
          padding: '16px', 
          backgroundColor: statusColors[statusType]?.bg || '#f9fafb', 
          borderRadius: '8px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <p style={{ margin: '0 0 4px 0', color: '#6b7280', fontSize: '0.875rem' }}>{title || 'Orders'}</p>
          <p style={{ 
            margin: 0, 
            fontWeight: 'bold', 
            fontSize: '1.5rem',
            color: statusColors[statusType]?.color || '#000000'
          }}>{stats.filtered}</p>
        </div>
      </div>
      
      <p style={{ fontSize: '0.9rem', color: '#6b7280', marginBottom: '20px' }}>
        {description || `Manage ${title || 'orders'}. Click on any order to view details.`}
      </p>

      <div style={{ overflowX: 'auto', width: '100%' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', minWidth: '800px' }}>
          <thead>
            <tr>
              <th style={styles.header}>Order ID</th>
              <th style={styles.header}>Date</th>
              <th style={styles.header}>Customer</th>
              <th style={styles.header}>Address</th>
              <th style={styles.header}>Items</th>
              <th style={styles.header}>Amount</th>
              <th style={styles.header}>Status</th>
              <th style={styles.header}>Action</th>
            </tr>
          </thead>
          <tbody>
            {filteredOrders.length === 0 ? (
              <tr>
                <td colSpan="8" style={{ ...styles.cell, textAlign: 'center', padding: '24px' }}>
                  No orders found
                </td>
              </tr>
            ) : (
              filteredOrders.map(order => {
                const status = getStatusDisplay(order);
                
                return (
                  <tr 
                    key={order._id} 
                    onClick={() => handleActionClick(order)}
                    style={{ cursor: 'pointer' }}
                  >
                    <td style={{ ...styles.cell, fontWeight: '500' }}>{order._id}</td>
                    <td style={styles.cell}>{formatDate(order.createdAt)}</td>
                    <td style={styles.cell}>{order.address?.name || 'N/A'}</td>
                    <td style={styles.cell}>{formatAddress(order.address)}</td>
                    <td style={{ ...styles.cell, textAlign: 'center' }}>{getTotalItems(order.items)}</td>
                    <td style={{ ...styles.cell, fontWeight: '500' }}>${order.totalAmount || 0}</td>
                    <td style={styles.cell}>
                      <div style={styles.badge(status.bg, status.color, status.border)}>
                        {status.text}
                      </div>
                    </td>
                    <td style={styles.cell}>
                      <button
                        onClick={(e) => handleActionClick(order, e)}
                        style={{
                          ...styles.button,
                          backgroundColor: actionConfig?.buttonColor || '#3b82f6',
                          color: 'white'
                        }}
                      >
                        {actionConfig?.buttonText || 'View'}
                      </button>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>

      {showModal && selectedOrder && (
        <div style={{ 
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.5)',
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          zIndex: 100
        }}>
          <div style={{ 
            backgroundColor: 'white', 
            borderRadius: '8px',
            width: '90%',
            maxWidth: '800px',
            maxHeight: '90vh',
            overflow: 'hidden',
            display: 'flex',
            flexDirection: 'column'
          }}>
            <div style={{ 
              padding: '16px 24px',
              borderBottom: '1px solid #e5e7eb',
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              backgroundColor: '#f9fafb'
            }}>
              <h2 style={{ margin: 0, fontSize: '1.25rem', fontWeight: 'bold', color: '#000000' }}>
                {actionConfig?.modalTitle || 'Order Details'}
              </h2>
              <div style={{
                ...styles.badge(
                  getStatusDisplay(selectedOrder).bg,
                  getStatusDisplay(selectedOrder).color,
                  getStatusDisplay(selectedOrder).border
                ),
                fontSize: '0.875rem'
              }}>
                {getStatusDisplay(selectedOrder).text}
              </div>
            </div>
            
            <div style={{ 
              padding: '24px',
              overflowY: 'auto',
              color: '#000000',
              flex: '1'
            }}>
              {updateSuccess && (
                <div style={{
                  padding: '12px 16px',
                  backgroundColor: '#f0fdf4',
                  color: '#15803d',
                  borderRadius: '6px',
                  marginBottom: '16px',
                  border: '1px solid #86efac'
                }}>
                  Order updated successfully!
                </div>
              )}
              
              {updateError && (
                <div style={{
                  padding: '12px 16px',
                  backgroundColor: '#fef2f2',
                  color: '#b91c1c',
                  borderRadius: '6px',
                  marginBottom: '16px',
                  border: '1px solid #fecaca'
                }}>
                  {updateError}
                </div>
              )}
              
              <div style={{ 
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fill, minmax(180px, 1fr))',
                gap: '16px',
                marginBottom: '24px'
              }}>
                <InfoField label="Order ID" value={selectedOrder._id} />
                <InfoField label="Date" value={formatDate(selectedOrder.createdAt)} />
                <InfoField label="Payment" value={selectedOrder.paymentMode || 'N/A'} />
                <InfoField label="Total" value={`$${selectedOrder.totalAmount || 0}`} />
                <InfoField label="Customer" value={selectedOrder.address?.name || 'N/A'} />
              </div>
              
              <div style={{ marginBottom: '24px' }}>
                <h3 style={{ fontSize: '1rem', marginBottom: '8px', color: '#000000' }}>Delivery Address</h3>
                <div style={{ 
                  padding: '12px',
                  backgroundColor: '#f9fafb',
                  borderRadius: '6px',
                  border: '1px solid #e5e7eb',
                  color: '#000000'
                }}>
                  <p style={{ margin: '0 0 4px 0', fontWeight: 'bold' }}>
                    {selectedOrder.address?.name || 'N/A'}
                  </p>
                  <p style={{ margin: '0 0 4px 0' }}>
                    {selectedOrder.address?.street || 'N/A'}
                  </p>
                  <p style={{ margin: '0' }}>
                    {formatAddress(selectedOrder.address)}
                  </p>
                </div>
              </div>
              
              <div style={{ marginBottom: '24px' }}>
                <h3 style={{ fontSize: '1rem', marginBottom: '8px', color: '#000000' }}>Order Items</h3>
                <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                  <thead>
                    <tr>
                      <th style={{ padding: '8px', textAlign: 'left', backgroundColor: '#f9fafb', border: '1px solid #e5e7eb', color: '#000000' }}>Product</th>
                      <th style={{ padding: '8px', textAlign: 'center', backgroundColor: '#f9fafb', border: '1px solid #e5e7eb', color: '#000000' }}>Qty</th>
                      <th style={{ padding: '8px', textAlign: 'right', backgroundColor: '#f9fafb', border: '1px solid #e5e7eb', color: '#000000' }}>Price</th>
                      <th style={{ padding: '8px', textAlign: 'right', backgroundColor: '#f9fafb', border: '1px solid #e5e7eb', color: '#000000' }}>Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {selectedOrder.items && selectedOrder.items.map((item, idx) => (
                      <tr key={idx}>
                        <td style={{ padding: '8px', border: '1px solid #e5e7eb', color: '#000000' }}>
                          {item.productId || item.product || 'Product'}
                        </td>
                        <td style={{ padding: '8px', textAlign: 'center', border: '1px solid #e5e7eb', color: '#000000' }}>
                          {item.quantity || 0}
                        </td>
                        <td style={{ padding: '8px', textAlign: 'right', border: '1px solid #e5e7eb', color: '#000000' }}>
                          ${item.price || 0}
                        </td>
                        <td style={{ padding: '8px', textAlign: 'right', fontWeight: 'bold', border: '1px solid #e5e7eb', color: '#000000' }}>
                          ${(item.price * item.quantity).toFixed(2) || 0}
                        </td>
                      </tr>
                    ))}
                    <tr>
                      <td colSpan="3" style={{ padding: '8px', textAlign: 'right', fontWeight: 'bold', border: '1px solid #e5e7eb', color: '#000000' }}>
                        Total:
                      </td>
                      <td style={{ padding: '8px', textAlign: 'right', fontWeight: 'bold', border: '1px solid #e5e7eb', color: '#000000' }}>
                        ${selectedOrder.totalAmount || 0}
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              
              {actionConfig && actionConfig.commentField && (
                <div style={{ marginTop: '16px' }}>
                  <h3 style={{ fontSize: '1rem', marginBottom: '8px', color: '#000000' }}>
                    {actionConfig.commentLabel || 'Comment'}
                  </h3>
                  <textarea
                    value={comment}
                    onChange={(e) => setComment(e.target.value)}
                    placeholder={`Add ${actionConfig.commentLabel || 'comment'}...`}
                    style={{
                      width: '100%',
                      padding: '8px 12px',
                      borderRadius: '6px',
                      border: '1px solid #e5e7eb',
                      minHeight: '80px',
                      color: '#000000',
                      backgroundColor: 'white'
                    }}
                  />
                </div>
              )}
              
              {selectedOrder.orderAcceptanceComment && (
                <div style={{ marginTop: '16px' }}>
                  <h3 style={{ fontSize: '1rem', marginBottom: '8px', color: '#000000' }}>Acceptance Notes</h3>
                  <div style={{
                    padding: '12px',
                    backgroundColor: '#f9fafb',
                    borderRadius: '6px',
                    border: '1px solid #e5e7eb',
                    color: '#000000'
                  }}>
                    {selectedOrder.orderAcceptanceComment || "No comment provided."}
                  </div>
                </div>
              )}
              
              {selectedOrder.inProcessComment && (
                <div style={{ marginTop: '16px' }}>
                  <h3 style={{ fontSize: '1rem', marginBottom: '8px', color: '#000000' }}>Processing Notes</h3>
                  <div style={{
                    padding: '12px',
                    backgroundColor: '#f9fafb',
                    borderRadius: '6px',
                    border: '1px solid #e5e7eb',
                    color: '#000000'
                  }}>
                    {selectedOrder.inProcessComment || "No comment provided."}
                  </div>
                </div>
              )}
              
              {selectedOrder.inTransitComment && (
                <div style={{ marginTop: '16px' }}>
                  <h3 style={{ fontSize: '1rem', marginBottom: '8px', color: '#000000' }}>Transit Notes</h3>
                  <div style={{
                    padding: '12px',
                    backgroundColor: '#f9fafb',
                    borderRadius: '6px',
                    border: '1px solid #e5e7eb',
                    color: '#000000'
                  }}>
                    {selectedOrder.inTransitComment || "No comment provided."}
                  </div>
                </div>
              )}
              
              {selectedOrder.shippedComment && (
                <div style={{ marginTop: '16px' }}>
                  <h3 style={{ fontSize: '1rem', marginBottom: '8px', color: '#000000' }}>Shipping Notes</h3>
                  <div style={{
                    padding: '12px',
                    backgroundColor: '#f9fafb',
                    borderRadius: '6px',
                    border: '1px solid #e5e7eb',
                    color: '#000000'
                  }}>
                    {selectedOrder.shippedComment || "No comment provided."}
                  </div>
                </div>
              )}
              
              {selectedOrder.deliveredComment && (
                <div style={{ marginTop: '16px' }}>
                  <h3 style={{ fontSize: '1rem', marginBottom: '8px', color: '#000000' }}>Delivery Notes</h3>
                  <div style={{
                    padding: '12px',
                    backgroundColor: '#f9fafb',
                    borderRadius: '6px',
                    border: '1px solid #e5e7eb',
                    color: '#000000'
                  }}>
                    {selectedOrder.deliveredComment || "No comment provided."}
                  </div>
                </div>
              )}
              
              {selectedOrder.exchangeComment && (
                <div style={{ marginTop: '16px' }}>
                  <h3 style={{ fontSize: '1rem', marginBottom: '8px', color: '#000000' }}>Exchange Notes</h3>
                  <div style={{
                    padding: '12px',
                    backgroundColor: '#f9fafb',
                    borderRadius: '6px',
                    border: '1px solid #e5e7eb',
                    color: '#000000'
                  }}>
                    {selectedOrder.exchangeComment || "No comment provided."}
                  </div>
                </div>
              )}
              
              {selectedOrder.returnComment && (
                <div style={{ marginTop: '16px' }}>
                  <h3 style={{ fontSize: '1rem', marginBottom: '8px', color: '#000000' }}>Return Notes</h3>
                  <div style={{
                    padding: '12px',
                    backgroundColor: '#f9fafb',
                    borderRadius: '6px',
                    border: '1px solid #e5e7eb',
                    color: '#000000'
                  }}>
                    {selectedOrder.returnComment || "No comment provided."}
                  </div>
                </div>
              )}
            </div>
            
            <div style={{
              padding: '16px 24px',
              borderTop: '1px solid #e5e7eb',
              display: 'flex',
              justifyContent: 'flex-end',
              gap: '12px',
              backgroundColor: '#f9fafb',
              position: 'sticky',
              bottom: 0
            }}>
              <button
                onClick={handleClose}
                style={{
                  ...styles.button,
                  backgroundColor: '#6b7280',
                  color: 'white'
                }}
              >
                Cancel
              </button>
              {actionConfig && actionConfig.updates && (
                <button
                  onClick={handleOrderSubmit}
                  style={{
                    ...styles.button,
                    backgroundColor: actionConfig.buttonColor || '#3b82f6',
                    color: 'white'
                  }}
                >
                  {actionConfig.buttonText || 'Submit'}
                </button>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default OrderStatus;