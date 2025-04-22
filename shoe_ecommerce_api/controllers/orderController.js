const Cart = require('../models/Cart')
const Order = require('../models/Order')
const Product = require('../models/Product')

// Add product to cart
const addToCart = async (req, res) => {
  const userId = req.user.id;
  const { productId, quantity, size } = req.body;

  console.log(req.body); // Log the request body for debugging

  if (!productId || !quantity || !size) {
    return res.status(400).json({ error: 'Product, quantity, and size are required' });
  }

  const product = await Product.findById(productId);
  if (!product) {
    return res.status(400).json({ error: 'Invalid product ID' });
  }

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
// Remove product from cart
const removeFromCart = async (req, res) => {
  const userId = req.user.id;
  const { productId } = req.params; 

  let cart = await Cart.findOne({ user: userId });
  if (!cart) return res.status(404).json({ error: 'Cart not found' });

  // Filter the products array to remove the specified product
  cart.products = cart.products.filter(p => p.product.toString() !== productId);
  await cart.save();

  res.status(200).json({ message: 'Product removed from cart', data: cart });
};


// Get cart items
const getCart = async (req, res) => {
  const userId = req.user.id
  const cart = await Cart.findOne({ user: userId }).populate('products.product')

  if (!cart) return res.status(200).json({ message: 'Cart is empty', data: [] })

  res.status(200).json({ message: 'Cart retrieved successfully', data: cart })
}

// Place order
const placeOrder = async (req, res) => {
  const userId = req.user.id;
  const { address, paymentMode } = req.body;

  if (!address || !paymentMode) {
    return res.status(400).json({ error: 'Address and payment mode required' });
  }

  const cart = await Cart.findOne({ user: userId }).populate('products.product');

  // Debugging log to inspect cart and populated products
  console.log(cart);  // Check if products are populated correctly

  if (!cart || cart.products.length === 0) {
    return res.status(400).json({ error: 'Cart is empty' });
  }

  const items = cart.products.map(p => {
    if (!p.product) {
      console.log(`Product missing for cart item: ${JSON.stringify(p)}`);
      return null;
    }
    return {
      product: p.product._id,  // Ensure that we have the correct product ID
      quantity: p.quantity,
      price: p.product.price
    };
  }).filter(item => item !== null);  // Remove any null items

  // Log items to ensure they're populated correctly
  console.log(items);

  if (items.length === 0) {
    return res.status(400).json({ error: 'Invalid items in cart' });
  }

  const totalAmount = items.reduce((sum, item) => sum + item.price * item.quantity, 0);

  const order = await Order.create({
    user: userId,
    items,
    totalAmount,
    address,
    paymentMode,
    status: 'pending'
  });

  await Cart.findOneAndDelete({ user: userId });

  res.status(201).json({ message: 'Order placed successfully', data: order });
};


// Get all user orders
const getMyOrders = async (req, res) => {
  const userId = req.user.id
  const orders = await Order.find({ user: userId }).sort({ createdAt: -1 })

  res.status(200).json({
    message: 'Orders retrieved successfully',
    data: orders
  })
}

// Cancel order
const cancelOrder = async (req, res) => {
  const userId = req.user.id
  const { orderId, reason } = req.body

  const order = await Order.findOne({ _id: orderId, user: userId })
  if (!order) return res.status(404).json({ error: 'Order not found' })

  if (order.status === 'cancelled' || order.status === 'completed')
    return res.status(400).json({ error: 'Order cannot be cancelled' })

  order.status = 'cancelled'
  order.cancellationReason = reason
  await order.save()

  res.status(200).json({ message: 'Order cancelled successfully', data: order })
}

module.exports = {
  addToCart,
  removeFromCart,
  getCart,
  placeOrder,
  getMyOrders,
  cancelOrder
}
