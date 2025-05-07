import React, { useState } from 'react';
import OrderStatus from './status';
import { updateOrder } from '../api/Order';

// 1. Pending Orders Page
export function PendingPage() {
  const handleSubmit = async (orderId, comment) => {
    try {
      const updateData = { 
        isOrderAccepted: true,
        orderAcceptanceComment: comment.trim(),
        status: "Accepted"
      };
      
      return await updateOrder(orderId, updateData);
    } catch (error) {
      console.error("Failed to accept order:", error);
      throw error;
    }
  };

  return (
    <OrderStatus
      statusType="pending"
      title="Pending Orders"
      description="Accept new orders to begin processing them."
      filterCondition={(order) => !order.isOrderAccepted && !order.isCancelled}
      actionConfig={{
        buttonText: "Accept Order",
        buttonColor: "#f59e0b",
        modalTitle: "Accept Order",
        commentField: "orderAcceptanceComment",
        commentLabel: "Acceptance Notes",
        updates: { isOrderAccepted: true },
      }}
      handleSubmit={handleSubmit}
    />
  );
}

// 2. In Processing Page
export function ProcessingPage() {
  const handleSubmit = async (orderId, comment) => {
    try {
      const updateData = { 
        isInProcess: true,
        inProcessComment: comment.trim(),
        status: "Processing"
      };
      
      return await updateOrder(orderId, updateData);
    } catch (error) {
      console.error("Failed to process order:", error);
      throw error;
    }
  };

  return (
    <OrderStatus
      statusType="processing"
      title="In Processing"
      description="Orders that are currently being processed and prepared for shipping."
      filterCondition={(order) => order.isOrderAccepted && !order.isInProcess && !order.isCancelled}
      actionConfig={{
        buttonText: "Mark as Processing",
        buttonColor: "#0284c7",
        modalTitle: "Process Order",
        commentField: "inProcessComment",
        commentLabel: "Processing Notes",
        updates: { isInProcess: true }
      }}
      handleSubmit={handleSubmit}
    />
  );
}

// 3. In Packing Page
export function PackingPage() {
  const handleSubmit = async (orderId, comment) => {
    try {
      const updateData = { 
        isInTransit: true,
        inTransitComment: comment.trim(),
        status: "Packing" 
      };
      
      return await updateOrder(orderId, updateData);
    } catch (error) {
      console.error("Failed to mark order in packing:", error);
      throw error;
    }
  };

  return (
    <OrderStatus
      statusType="transit"
      title="In Packing"
      description="Orders that are being packed and prepared for shipping."
      filterCondition={(order) => order.isInProcess && !order.isInTransit && !order.isCancelled}
      actionConfig={{
        buttonText: "Mark as Packing",
        buttonColor: "#7c3aed",
        modalTitle: "Order In Packing",
        commentField: "inTransitComment",
        commentLabel: "Packing Notes",
        updates: { isInTransit: true }
      }}
      handleSubmit={handleSubmit}
    />
  );
}

// 4. In Shipping Page
export function ShippingPage() {
  const handleSubmit = async (orderId, comment) => {
    try {
      const updateData = { 
        isShipped: true,
        shippedComment: comment.trim(),
        status: "Shipping"
      };
      
      return await updateOrder(orderId, updateData);
    } catch (error) {
      console.error("Failed to mark order as shipping:", error);
      throw error;
    }
  };

  return (
    <OrderStatus
      statusType="shipped"
      title="In Shipping"
      description="Orders that have been sent out for delivery."
      filterCondition={(order) => order.isInTransit && !order.isShipped && !order.isCancelled}
      actionConfig={{
        buttonText: "Mark as Shipping",
        buttonColor: "#4f46e5",
        modalTitle: "Ship Order",
        commentField: "shippedComment",
        commentLabel: "Shipping Notes",
        updates: { isShipped: true }
      }}
      handleSubmit={handleSubmit}
    />
  );
}

// 5. In Delivery Page
export function DeliveryPage() {
  const handleSubmit = async (orderId, comment) => {
    try {
      const updateData = { 
        isDelivered: true,
        deliveredComment: comment.trim(),
        status: "Delivered"
      };
      
      return await updateOrder(orderId, updateData);
    } catch (error) {
      console.error("Failed to mark order as delivered:", error);
      throw error;
    }
  };

  return (
    <OrderStatus
      statusType="delivered"
      title="In Delivery"
      description="Orders that are out for final delivery to customers."
      filterCondition={(order) => order.isShipped && !order.isDelivered && !order.isCancelled}
      actionConfig={{
        buttonText: "Mark as Delivered",
        buttonColor: "#15803d",
        modalTitle: "Delivery Confirmation",
        commentField: "deliveredComment",
        commentLabel: "Delivery Notes",
        updates: { isDelivered: true }
      }}
      handleSubmit={handleSubmit}
    />
  );
}

// 6. Completed Orders Page
export function CompletedPage() {
  // View only - no submission needed
  const handleSubmit = async () => {
    // This page is view-only
    return null;
  };

  return (
    <OrderStatus
      statusType="delivered"
      title="Completed Orders"
      description="All orders that have been successfully delivered to customers."
      filterCondition={(order) => order.isDelivered && !order.isCancelled}
      actionConfig={{
        buttonText: "View Details",
        buttonColor: "#6b7280",
        modalTitle: "Completed Order",
        commentField: null,
        updates: null
      }}
      handleSubmit={handleSubmit}
    />
  );
}

// 7. Cancelled Page
export function CancelledPage() {
  // View only - no submission needed
  const handleSubmit = async () => {
    // This page is view-only
    return null;
  };

  return (
    <OrderStatus
      statusType="cancelled"
      title="Cancelled Orders"
      description="View all cancelled orders."
      filterCondition={(order) => order.isCancelled}
      actionConfig={{
        buttonText: "View Details",
        buttonColor: "#6b7280",
        modalTitle: "Cancelled Order",
        commentField: null,
        updates: null
      }}
      handleSubmit={handleSubmit}
    />
  );
}

// 8. Returns & Exchanges Page
export function ReturnsExchangesPage() {
  const handleSubmit = async (orderId, comment) => {
    try {
      // Check if it's a return or exchange based on the order data
      const isReturn = window.confirm("Is this a return? Click OK for Return, Cancel for Exchange");
      
      const updateData = isReturn 
        ? { 
            isReturnPicked: true,
            returnComment: comment.trim(),
            status: "Return Processing"
          }
        : {
            isExchangePickup: true,
            exchangeComment: comment.trim(),
            status: "Exchange Processing"
          };
      
      return await updateOrder(orderId, updateData);
    } catch (error) {
      console.error("Failed to process return/exchange:", error);
      throw error;
    }
  };

  return (
    <OrderStatus
      statusType="return"
      title="Returns & Exchanges"
      description="Process customer returns and exchanges in one place."
      filterCondition={(order) => order.isReturnRequest || order.isExchangeRequest}
      actionConfig={{
        buttonText: "Process Request",
        buttonColor: "#9f1239",
        modalTitle: "Return/Exchange Request",
        commentField: "returnExchangeComment",
        commentLabel: "Processing Notes",
        updates: { isProcessing: true }
      }}
      handleSubmit={handleSubmit}
    />
  );
}

// Main Order Dashboard component with updated navigation
export function OrderDashboard() {
  const [activeTab, setActiveTab] = useState('pending');
  
  const tabStyle = {
    padding: '12px 20px',
    cursor: 'pointer',
    borderRadius: '8px 8px 0 0',
    fontWeight: '500',
    transition: 'all 0.2s ease'
  };

  const activeTabStyle = {
    ...tabStyle,
    backgroundColor: '#f8fafc',
    borderBottom: '3px solid #3b82f6',
    color: '#3b82f6',
    fontWeight: 'bold'
  };

  const inactiveTabStyle = {
    ...tabStyle,
    backgroundColor: '#f1f5f9',
    borderBottom: '1px solid #e2e8f0',
    color: '#64748b',
    hover: {
      backgroundColor: '#f8fafc',
      color: '#3b82f6'
    }
  };
  
  // Updated tabs with workflow stages
  const tabs = {
    pending: <PendingPage />,
    processing: <ProcessingPage />,
    packing: <PackingPage />,
    shipping: <ShippingPage />,
    delivery: <DeliveryPage />,
    completed: <CompletedPage />,
    cancelled: <CancelledPage />,
    returns: <ReturnsExchangesPage />
  };
  
  // Updated tab names to reflect the workflow
  const tabNames = {
    pending: 'Pending Orders',
    processing: 'In Processing',
    packing: 'In Packing',
    shipping: 'In Shipping',
    delivery: 'In Delivery',
    completed: 'Completed Orders',
    cancelled: 'Cancelled Orders',
    returns: 'Returns & Exchanges'
  };
  
  return (
    <div style={{ 
      maxWidth: '1200px', 
      margin: '0 auto', 
      padding: '20px',
      backgroundColor: '#ffffff',
      color: '#000000',
      fontFamily: 'system-ui, -apple-system, sans-serif'
    }}>
      <h1 style={{ fontSize: '1.875rem', fontWeight: 'bold', marginBottom: '24px', color: '#111827' }}>
        Order Management
      </h1>
      
      <div style={{ 
        display: 'flex', 
        flexWrap: 'wrap',
        gap: '4px',
        borderBottom: '1px solid #e5e7eb',
        marginBottom: '20px'
      }}>
        {Object.keys(tabs).map((tab) => (
          <div 
            key={tab}
            onClick={() => setActiveTab(tab)}
            style={activeTab === tab ? activeTabStyle : inactiveTabStyle}
            onMouseOver={(e) => {
              if (activeTab !== tab) {
                e.currentTarget.style.backgroundColor = inactiveTabStyle.hover.backgroundColor;
                e.currentTarget.style.color = inactiveTabStyle.hover.color;
              }
            }}
            onMouseOut={(e) => {
              if (activeTab !== tab) {
                e.currentTarget.style.backgroundColor = inactiveTabStyle.backgroundColor;
                e.currentTarget.style.color = inactiveTabStyle.color;
              }
            }}
          >
            {tabNames[tab]}
          </div>
        ))}
      </div>
      
      <div style={{ 
        backgroundColor: '#f8fafc',
        padding: '20px',
        borderRadius: '8px',
        minHeight: '500px'
      }}>
        {tabs[activeTab]}
      </div>
    </div>
  );
}

export default OrderDashboard;