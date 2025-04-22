const mongoose = require('mongoose');

const addressSchema = new mongoose.Schema(
  {
    street: { type: String, default: null },
    city: { type: String, default: null },
    state: { type: String, default: null },
    postalCode: { type: String, default: null },
    country: { type: String, default: null }
  },
  { _id: false }
);

const userSchema = new mongoose.Schema(
  {
    userName: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    phone: { type: String, default: null },
    addresses: { type: [addressSchema], default: [] },
    profileImage: { type: String, default: null },
    fullName: { type: String, default: null },
    gender: { type: String, default: null },
    dob: { type: Date, default: null }
  },
  { timestamps: true }
);

module.exports = mongoose.model('User', userSchema);
