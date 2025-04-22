const mongoose = require('mongoose');

const productSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    description: { type: String },
    brandname: { type: String, required: true },
    price: { type: Number, required: true },
    images: [{ type: String }],
    sizes: [{ type: String }],
    color: [{ type: String }],
    category: { type: String, required: true },
    stock: { type: Number, default: 0 },
    ratings: {
      averageRating: { type: Number, default: 0 },
      ratingCount: { type: Number, default: 0 }
    },
    discount: { type: Number, default: 0 },
    isFeatured: { type: Boolean, default: false },
    isActive: { type: Boolean, default: true },
    isPopular: { type: Boolean, default: false },
    isNew: { type: Boolean, default: false },
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
  },
  { timestamps: true }
);

module.exports = mongoose.model('Product', productSchema);
