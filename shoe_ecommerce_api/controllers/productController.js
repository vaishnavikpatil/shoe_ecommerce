const Product = require('../models/Product');
const { validateProduct } = require('../utils/validators');

// Add a new product
const addProduct = async (req, res) => {
  const error = validateProduct(req.body);
  if (error) {
    return res.status(400).json({ message: 'Validation failed', data: error });
  }

  const {
    name, description, brandname, price, images, sizes, color,
    category, stock, ratings, discount, isFeatured, isActive,
    isPopular, isNew, createdBy
  } = req.body;

  try {
    const product = await Product.create({
      name,
      description,
      brandname,
      price,
      images,
      sizes,
      color,
      category,
      stock,
      ratings,
      discount,
      isFeatured,
      isActive,
      isPopular,
      isNew,
      createdBy
    });

    res.status(201).json({
      message: 'Product added successfully',
      data: { productId: product._id }
    });
  } catch (err) {
    console.error('Error adding product:', err);
    res.status(500).json({ message: 'Failed to add product', error: err.message });
  }
};

// Update a product
const updateProduct = async (req, res) => {
  const { id } = req.params;
  const updateData = req.body;
  
  // Validate the update data
  const error = validateProduct(updateData);
  if (error) {
    return res.status(400).json({ message: 'Validation failed', data: error });
  }

  try {
    const updatedProduct = await Product.findByIdAndUpdate(
      id,
      updateData,
      { new: true }
    );

    if (!updatedProduct) {
      return res.status(404).json({ message: 'Product not found', data: {} });
    }

    res.status(200).json({
      message: 'Product updated successfully',
      data: updatedProduct
    });
  } catch (err) {
    console.error('Error updating product:', err);
    res.status(500).json({ message: 'Failed to update product', error: err.message });
  }
};

// Remove a product
const removeProduct = async (req, res) => {
  const { id } = req.params;

  try {
    const deletedProduct = await Product.findByIdAndDelete(id);
    
    if (!deletedProduct) {
      return res.status(404).json({ message: 'Product not found', data: {} });
    }

    res.status(200).json({
      message: 'Product removed successfully',
      data: { productId: id }
    });
  } catch (err) {
    console.error('Error removing product:', err);
    res.status(500).json({ message: 'Failed to remove product', error: err.message });
  }
};

// Get all products with optional pagination
const getProductList = async (req, res) => {
  const { page = 1, limit = 10 } = req.query;

  try {
    const products = await Product.find({})
      .skip((page - 1) * limit)
      .limit(Number(limit));

    res.status(200).json({
      message: 'Product list retrieved successfully',
      data: products
    });
  } catch (err) {
    res.status(500).json({ message: 'Error retrieving products', error: err.message });
  }
};

// Get product details by ID
const getProductDetails = async (req, res) => {
  const { id } = req.params;

  try {
    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found', data: {} });
    }

    res.status(200).json({
      message: 'Product details retrieved successfully',
      data: product
    });
  } catch (err) {
    res.status(500).json({ message: 'Error retrieving product', error: err.message });
  }
};

// Filter & sort products
const filterProduct = async (req, res) => {
  const query = {};

  if (req.query.brandname) query.brandname = req.query.brandname;
  if (req.query.size) query.sizes = req.query.size;
  if (req.query.color) query.color = req.query.color;
  if (req.query.category) query.category = req.query.category;
  if (req.query.minPrice || req.query.maxPrice) {
    query.price = {};
    if (req.query.minPrice) query.price.$gte = parseFloat(req.query.minPrice);
    if (req.query.maxPrice) query.price.$lte = parseFloat(req.query.maxPrice);
  }
  if (req.query.search) {
    query.name = { $regex: req.query.search, $options: 'i' };
  }

  const sort = {};
  if (req.query.sortBy) {
    if (req.query.sortBy === 'priceAsc') sort.price = 1;
    else if (req.query.sortBy === 'priceDesc') sort.price = -1;
  }

  try {
    const products = await Product.find(query).sort(sort);
    res.status(200).json({
      message: 'Filtered and sorted products retrieved successfully',
      data: products
    });
  } catch (error) {
    console.error('Error filtering products:', error);
    res.status(500).json({
      message: 'Error retrieving filtered products',
      data: error.message
    });
  }
};

// Get popular products
const getPopularProducts = async (req, res) => {
  try {
    const products = await Product.find({ isPopular: true });
    res.status(200).json({
      message: 'Popular products retrieved successfully',
      data: products
    });
  } catch (err) {
    res.status(500).json({ message: 'Error retrieving popular products', error: err.message });
  }
};

// Get new arrival products
const getNewArrivals = async (req, res) => {
  try {
    const products = await Product.find({ isNew: true });
    res.status(200).json({
      message: 'New arrival products retrieved successfully',
      data: products
    });
  } catch (err) {
    res.status(500).json({ message: 'Error retrieving new arrivals', error: err.message });
  }
};

// Bulk upload products function (no external dependencies)
const bulkUploadProducts = async (req, res) => {
  try {
    // Check if request body contains products array
    if (!req.body.products || !Array.isArray(req.body.products) || req.body.products.length === 0) {
      return res.status(400).json({ message: 'Products array is required', data: null });
    }

    const products = req.body.products;
    const results = [];
    const errors = [];
    let processed = 0;
    let successful = 0;

    // Process each product in the array
    for (const productData of products) {
      processed++;
      
      try {
        // Validate required fields
        if (!productData.name || !productData.price) {
          errors.push(`Product ${processed}: Missing required fields (name or price)`);
          continue;
        }

        // Create clean product object with only the fields we want
        const cleanProduct = {
          name: productData.name,
          description: productData.description || '',
          brandname: productData.brandname || '',
          price: parseFloat(productData.price),
          images: Array.isArray(productData.images) ? productData.images : 
                 (typeof productData.images === 'string' ? productData.images.split(',').map(img => img.trim()) : []),
          sizes: Array.isArray(productData.sizes) ? productData.sizes : 
                (typeof productData.sizes === 'string' ? productData.sizes.split(',').map(size => size.trim()) : []),
          color: productData.color || '',
          category: productData.category || 'Uncategorized',
          stock: parseInt(productData.stock || 0, 10),
          ratings: productData.ratings || 0,
          discount: parseFloat(productData.discount || 0),
          isFeatured: productData.isFeatured === 'true' || productData.isFeatured === true || false,
          isActive: productData.isActive === 'true' || productData.isActive === true || true,
          isPopular: productData.isPopular === 'true' || productData.isPopular === true || false,
          isNew: productData.isNew === 'true' || productData.isNew === true || false,
          createdBy: productData.createdBy || 'bulk-upload'
        };

        // Optional validation
        const error = validateProduct(cleanProduct);
        if (error) {
          errors.push(`Product ${processed}: Validation failed - ${JSON.stringify(error)}`);
          continue;
        }

        results.push(cleanProduct);
        successful++;
      } catch (error) {
        errors.push(`Product ${processed}: ${error.message}`);
      }
    }

    // Insert all valid products into the database
    if (results.length > 0) {
      await Product.insertMany(results);
    }

    res.status(200).json({
      message: 'Bulk upload completed',
      data: {
        total: processed,
        successful,
        failed: processed - successful,
        errors: errors.length > 0 ? errors : null
      }
    });
  } catch (error) {
    console.error('Error in bulk upload:', error);
    res.status(500).json({ message: 'Server error during bulk upload', error: error.message });
  }
};

module.exports = {
  addProduct,
  updateProduct,
  removeProduct,
  getProductList,
  getProductDetails,
  filterProduct,
  getPopularProducts,
  getNewArrivals,
  bulkUploadProducts
};