const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    items: [
      {
        product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
        quantity: Number,
        price: Number
      }
    ],
    totalAmount: { type: Number },
    address: {
      street: String,
      city: String,
      state: String,
      postalCode: String,
      country: String
    },
    paymentMode: { type: String, enum: ['COD', 'CARD', 'UPI'], required: true },
    status: {
      type: String,
      enum: ['pending', 'processing', 'shipped', 'delivered', 'completed', 'cancelled'],
      default: 'pending'
    },
    cancellationReason: { type: String }
  },
  { timestamps: true }
);

module.exports = mongoose.model('Order', orderSchema);
