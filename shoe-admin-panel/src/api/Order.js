import axios from 'axios';

// Add timestamp to logs for easier tracking
const logWithTimestamp = (message, data) => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${message}`, data || '');
};

export const getOrders = async () => {
  logWithTimestamp('Fetching orders - START');
  try {

    const response = await axios.get('baseurl/orders/orders/all', {});

    return response.data;
  } catch (error) {
    
    if (error.response) {

    } else if (error.request) {
      logWithTimestamp('No response received, request made:', error.request);
    } else {
      logWithTimestamp('Error setting up request:', error.message);
    }
    throw error;
  } finally {
    logWithTimestamp('Fetching orders - END');
  }
};

export const updateOrder = async (orderId, updates) => {
  logWithTimestamp(`Updating order ${orderId} - START`, updates);
  try {
    logWithTimestamp(`Making PATCH request to: baseurl/orders/${orderId}`, updates);
    const response = await axios.patch(`baseurl/orders/${orderId}`, updates);
    logWithTimestamp('PATCH response received:', response.status);
    logWithTimestamp('Update Response:', response.data);
    return response.data;
  } catch (error) {
    logWithTimestamp(`Error updating order ${orderId}:`, error);
    if (error.response) {
      logWithTimestamp('Response status:', error.response.status);
      logWithTimestamp('Response data:', error.response.data);
    } else if (error.request) {
      logWithTimestamp('No response received, request made:', error.request);
    } else {
      logWithTimestamp('Error setting up request:', error.message);
    }
    throw error;
  } finally {
    logWithTimestamp(`Updating order ${orderId} - END`);
  }
};