const mongoose = require('mongoose');

const CartSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  products: [
    {
      product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },  // Reference to the Product model
      quantity: { type: Number, default: 1 },
      size: { type: String }
    }
  ]
});

const Cart = mongoose.model('Cart', CartSchema);
module.exports = Cart;
