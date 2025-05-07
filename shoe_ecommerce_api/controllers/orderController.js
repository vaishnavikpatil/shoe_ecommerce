const Cart = require('../models/Cart');
const Order = require('../models/Order');
const Product = require('../models/Product');

// Add product to cart
const addToCart = async (req, res) => {
  const userId = req.user.id;
  const { productId, quantity, size } = req.body;

  if (!productId || !quantity || !size) {
    return res.status(400).json({ error: 'Product, quantity, and size are required' });
  }

  const product = await Product.findById(productId);
  if (!product) return res.status(400).json({ error: 'Invalid product ID' });

  let cart = await Cart.findOne({ user: userId });

  if (!cart) {
    cart = await Cart.create({
      user: userId,
      products: [{ product: productId, quantity, size }]
    });
  } else {
    const existing = cart.products.find(
      p => p.product.toString() === productId && p.size === size
    );

    if (existing) {
      existing.quantity += quantity;
    } else {
      cart.products.push({ product: productId, quantity, size });
    }
    await cart.save();
  }

  res.status(200).json({ message: 'Product added to cart', data: cart });
};

// Remove product from cart
const removeFromCart = async (req, res) => {
  const userId = req.user.id;
  const { productId } = req.params;

  let cart = await Cart.findOne({ user: userId });
  if (!cart) return res.status(404).json({ error: 'Cart not found' });

  cart.products = cart.products.filter(p => p.product.toString() !== productId);
  await cart.save();

  res.status(200).json({ message: 'Product removed from cart', data: cart });
};

// Get cart items
const getCart = async (req, res) => {
  const userId = req.user.id;
  const cart = await Cart.findOne({ user: userId }).populate('products.product');
  if (!cart) return res.status(200).json({ message: 'Cart is empty', data: [] });

  res.status(200).json({ message: 'Cart retrieved successfully', data: cart });
};

// Place order
const placeOrder = async (req, res) => {
  const userId = req.user.id;
  const {
    address,
    paymentMode,

    isOrderAccepted = false,
    orderAcceptanceComment = '',
    isInProcess = false,
    inProcessComment = '',
    isInTransit = false,
    inTransitComment = '',
    isShipped = false,
    shippedComment = '',
    isDelivered = false,
    deliveredComment = '',
    isCancelled = false,
    cancelledComment = '',
    isExchangeRequest = false,
    exchangeComment = '',
    isExchangePickup = false,
    isReturnRequest = false,
    returnComment = '',
    isRefundInitiate = false,
    isReturnPicked = false
  } = req.body;

  if (!address || !paymentMode) {
    return res.status(400).json({ error: 'Address and payment mode required' });
  }

  const cart = await Cart.findOne({ user: userId }).populate('products.product');
  if (!cart || cart.products.length === 0) {
    return res.status(400).json({ error: 'Cart is empty' });
  }

  const items = cart.products.map(p => {
    if (!p.product) return null;
    return {
      product: p.product._id,
      quantity: p.quantity,
      price: p.product.price
    };
  }).filter(item => item !== null);

  const totalAmount = items.reduce((sum, item) => sum + item.price * item.quantity, 0);

  const order = await Order.create({
    user: userId,
    items,
    totalAmount,
    address,
    paymentMode,

    isOrderAccepted,
    orderAcceptanceComment,
    isInProcess,
    inProcessComment,
    isInTransit,
    inTransitComment,
    isShipped,
    shippedComment,
    isDelivered,
    deliveredComment,
    isCancelled,
    cancelledComment,
    isExchangeRequest,
    exchangeComment,
    isExchangePickup,
    isReturnRequest,
    returnComment,
    isRefundInitiate,
    isReturnPicked
  });

  await Cart.findOneAndDelete({ user: userId });

  res.status(201).json({ message: 'Order placed successfully', data: order });
};

// Get logged-in user's orders
const getMyOrders = async (req, res) => {
  const userId = req.user.id;
  const orders = await Order.find({ user: userId }).sort({ createdAt: -1 });

  res.status(200).json({ message: 'Orders retrieved successfully', data: orders });
};

// Cancel order
const cancelOrder = async (req, res) => {
  const userId = req.user.id;
  const { orderId, reason } = req.body;

  const order = await Order.findOne({ _id: orderId, user: userId });
  if (!order) return res.status(404).json({ error: 'Order not found' });

  if (order.status === 'cancelled' || order.status === 'completed') {
    return res.status(400).json({ error: 'Order cannot be cancelled' });
  }

  order.status = 'cancelled';
  order.isCancelled = true;
  order.cancelledComment = reason;
  await order.save();

  res.status(200).json({ message: 'Order cancelled successfully', data: order });
};

// Update order (for tracking updates)
const updateOrder = async (req, res) => {
  try {
    const { orderId } = req.params;
    const updates = req.body;

    const order = await Order.findByIdAndUpdate(orderId, updates, { new: true });
    if (!order) return res.status(404).json({ error: 'Order not found' });

    res.status(200).json({ message: 'Order updated successfully', data: order });
  } catch (err) {
    res.status(500).json({ error: 'Failed to update order' });
  }
};

// Get all orders
const getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find().sort({ createdAt: -1 });
    res.status(200).json({ message: 'All orders retrieved', data: orders });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch orders' });
  }
};


module.exports = {
  addToCart,
  removeFromCart,
  getCart,
  placeOrder,
  getMyOrders,
  cancelOrder,
  updateOrder,
  getAllOrders,

};
