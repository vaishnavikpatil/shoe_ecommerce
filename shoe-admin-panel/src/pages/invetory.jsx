import React, { useEffect, useState } from 'react';
import { getProducts, addProduct, updateProduct, removeProduct, bulkUploadProducts } from '../api/Product';

// Shared styles (matching OrderStatus component)
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
  }),
  // Input field styles with white background and increased spacing
  input: {
    width: '100%',
    padding: '8px 12px',
    borderRadius: '6px',
    border: '1px solid #e5e7eb',
    backgroundColor: '#ffffff',
    color: '#000000'  // Explicitly set text color to black
  },
  textarea: {
    width: '100%',
    padding: '8px 12px',
    borderRadius: '6px',
    border: '1px solid #e5e7eb',
    backgroundColor: '#ffffff',
    resize: 'vertical',
    color: '#000000'  // Explicitly set text color to black
  },
  formGroup: {
    marginBottom: '40px'  // Extra spacing between form rows
  },
  label: {
    display: 'block',
    marginBottom: '16px', // Space between label and input
    fontWeight: '500',
    color: '#374151'
  },
  // Modal content styles for better spacing
  modalContent: {
    padding: '40px 40px 20px 40px', // More top/side padding, less bottom
    overflowY: 'auto',
    color: '#000000',
    flex: '1'
  },
  // Modal grid layout
  modalGrid: {
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: '60px',  // Increased space between columns
    marginBottom: '40px'
  }
};

function InventoryPage() {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showBulkUploadModal, setShowBulkUploadModal] = useState(false);
  const [selectedProduct, setSelectedProduct] = useState(null);
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    brandname: '',
    price: '',
    category: '',
    stock: '',
    sizes: [],
    color: [],
    discount: '0',
    isFeatured: false,
    isActive: true,
    isPopular: false,
    isNew: false
  });
  const [bulkFile, setBulkFile] = useState(null);
  const [actionSuccess, setActionSuccess] = useState(null);
  const [actionError, setActionError] = useState(null);
  const [stats, setStats] = useState({ total: 0, active: 0 });

  // Fetch products when the component mounts
  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      setLoading(true);
      const response = await getProducts();
      if (response && response.data) {
        const productsData = response.data;
        setProducts(productsData);
        
        // Calculate stats
        const activeCount = productsData.filter(p => p.isActive).length;
        setStats({
          total: productsData.length,
          active: activeCount
        });
      }
    } catch (err) {
      console.error("Error fetching products:", err);
      setError("Failed to load products");
    } finally {
      setLoading(false);
    }
  };

  // Handle form input changes
  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    
    if (type === 'checkbox') {
      setFormData({ ...formData, [name]: checked });
    } else if (name === 'sizes' || name === 'color') {
      // Handle arrays (comma-separated values)
      setFormData({ ...formData, [name]: value.split(',').map(item => item.trim()) });
    } else {
      setFormData({ ...formData, [name]: value });
    }
  };

  // Open add product modal
  const handleAddProduct = () => {
    // Reset form data
    setFormData({
      name: '',
      description: '',
      brandname: '',
      price: '',
      category: '',
      stock: '',
      sizes: [],
      color: [],
      discount: '0',
      isFeatured: false,
      isActive: true,
      isPopular: false,
      isNew: false
    });
    setActionSuccess(null);
    setActionError(null);
    setShowAddModal(true);
  };

  // Open edit product modal
  const handleEditProduct = (product) => {
    setSelectedProduct(product);
    
    setFormData({
      name: product.name || '',
      description: product.description || '',
      brandname: product.brandname || '',
      price: product.price?.toString() || '',
      category: product.category || '',
      stock: product.stock?.toString() || '',
      sizes: product.sizes || [],
      color: product.color || [],
      discount: product.discount?.toString() || '0',
      isFeatured: product.isFeatured || false,
      isActive: product.isActive !== false, // default to true if undefined
      isPopular: product.isPopular || false,
      isNew: product.isNew || false
    });
    setActionSuccess(null);
    setActionError(null);
    setShowEditModal(true);
  };

  // Handle delete product confirmation
  const handleDeleteProduct = async (product) => {
    if (window.confirm(`Are you sure you want to delete ${product.name}?`)) {
      try {
        await removeProduct(product._id);
        setActionSuccess(`Product "${product.name}" deleted successfully`);
        // Refresh the product list
        fetchProducts();
      } catch (err) {
        console.error("Error deleting product:", err);
        setActionError(`Failed to delete product: ${err.message || 'Unknown error'}`);
      }
    }
  };

  // Submit new product
  const handleSubmitAdd = async (e) => {
    e.preventDefault();
    
    try {
      // Prepare data for API
      const productData = {
        ...formData,
        price: parseFloat(formData.price),
        stock: parseInt(formData.stock),
        discount: parseFloat(formData.discount)
      };

      // Call the addProduct API function
      const result = await addProduct(productData);
      
      setActionSuccess('Product added successfully');
      setShowAddModal(false);
      fetchProducts(); // Refresh the list
    } catch (err) {
      console.error("Error adding product:", err);
      setActionError(`Failed to add product: ${err.message || 'Unknown error'}`);
    }
  };

  // Submit edit product
  const handleSubmitEdit = async (e) => {
    e.preventDefault();
    
    if (!selectedProduct) return;
    
    try {
      // Prepare data for API
      const productData = {
        ...formData,
        price: parseFloat(formData.price),
        stock: parseInt(formData.stock),
        discount: parseFloat(formData.discount)
      };

      await updateProduct(selectedProduct._id, productData);
      setActionSuccess('Product updated successfully');
      setShowEditModal(false);
      fetchProducts(); // Refresh the list
    } catch (err) {
      console.error("Error updating product:", err);
      setActionError(`Failed to update product: ${err.message || 'Unknown error'}`);
    }
  };

  // Close modal
  const handleClose = () => {
    setShowAddModal(false);
    setShowEditModal(false);
    setShowBulkUploadModal(false);
    setSelectedProduct(null);
    setActionSuccess(null);
    setActionError(null);
  };

  // Handle bulk file upload
  const handleFileChange = (e) => {
    setBulkFile(e.target.files[0]);
  };

  // Submit bulk upload
  const handleBulkUpload = async (e) => {
    e.preventDefault();
    
    if (!bulkFile) {
      setActionError('Please select a file');
      return;
    }
    
    try {
      const formData = new FormData();
      formData.append('file', bulkFile);
      
      // Call the bulkUploadProducts API function
      const result = await bulkUploadProducts(formData);
      
      setActionSuccess('Products uploaded successfully');
      setShowBulkUploadModal(false);
      fetchProducts(); // Refresh the list
    } catch (err) {
      console.error("Error uploading products:", err);
      setActionError(`Failed to upload products: ${err.message || 'Unknown error'}`);
    }
  };

  // Status badge for Active/Inactive
  const getStatusBadge = (isActive) => {
    return isActive 
      ? { bg: '#ecfdf5', color: '#059669', border: '#a7f3d0', text: 'Active' }
      : { bg: '#f9fafb', color: '#6b7280', border: '#e5e7eb', text: 'Inactive' };
  };

  if (loading) return <div style={{ padding: '20px', color: '#000000' }}>Loading products...</div>;
  if (error) return <div style={{ padding: '20px', color: '#ef4444' }}>{error}</div>;

  return (
    <div style={{ width: '100%' }}>
      {/* Stats Cards */}
      <div style={{ display: 'flex', gap: '16px', marginBottom: '20px' }}>
        <div style={{ 
          padding: '16px', 
          backgroundColor: '#f9fafb', 
          borderRadius: '8px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <p style={{ margin: '0 0 4px 0', color: '#6b7280', fontSize: '0.875rem' }}>Total Products</p>
          <p style={{ margin: 0, fontWeight: 'bold', fontSize: '1.5rem', color: '#000000' }}>{stats.total}</p>
        </div>
        
        <div style={{ 
          padding: '16px', 
          backgroundColor: '#ecfdf5',
          borderRadius: '8px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <p style={{ margin: '0 0 4px 0', color: '#6b7280', fontSize: '0.875rem' }}>Active Products</p>
          <p style={{ 
            margin: 0, 
            fontWeight: 'bold', 
            fontSize: '1.5rem',
            color: '#059669'
          }}>{stats.active}</p>
        </div>
      </div>
      
      <p style={{ fontSize: '0.9rem', color: '#6b7280', marginBottom: '20px' }}>
        Manage your product inventory. Add, edit, or remove products as needed.
      </p>

      {/* Action Buttons */}
      <div style={{ marginBottom: '24px' }}>
        <button
          onClick={handleAddProduct}
          style={{
            ...styles.button,
            backgroundColor: '#3b82f6',
            color: 'white',
            marginRight: '12px'
          }}
        >
          + Add Product
        </button>
        <button
          onClick={() => setShowBulkUploadModal(true)}
          style={{
            ...styles.button,
            backgroundColor: '#3b82f6',
            color: 'white'
          }}
        >
          + Bulk Upload
        </button>
      </div>
      
      {/* Success and Error Messages */}
      {actionSuccess && (
        <div style={{
          padding: '12px 16px',
          backgroundColor: '#f0fdf4',
          color: '#15803d',
          borderRadius: '6px',
          marginBottom: '16px',
          border: '1px solid #86efac'
        }}>
          {actionSuccess}
        </div>
      )}
      
      {actionError && (
        <div style={{
          padding: '12px 16px',
          backgroundColor: '#fef2f2',
          color: '#b91c1c',
          borderRadius: '6px',
          marginBottom: '16px',
          border: '1px solid #fecaca'
        }}>
          {actionError}
        </div>
      )}

      {/* Products Table */}
      <div style={{ overflowX: 'auto', width: '100%' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', minWidth: '800px' }}>
          <thead>
            <tr>
            <th style={styles.header}>Sr. No.</th>
              <th style={styles.header}>ID</th>
              <th style={styles.header}>Product Name</th>
              <th style={styles.header}>Brand</th>
              <th style={styles.header}>Price</th>
              <th style={styles.header}>Category</th>
              <th style={styles.header}>Stock</th>
              <th style={styles.header}>Status</th>
              <th style={styles.header}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {products.length === 0 ? (
              <tr>
                <td colSpan="8" style={{ ...styles.cell, textAlign: 'center', padding: '24px' }}>
                  No products found
                </td>
              </tr>
            ) : (
              products.map((product, index) => {
                const status = getStatusBadge(product.isActive);
                
                return (
                  <tr key={product._id}>
                    <td style={{ ...styles.cell, fontWeight: '500' }}>{index + 1}</td>
                    <td style={{ ...styles.cell, fontWeight: '500' }}>{product._id}</td>
                    <td style={styles.cell}>{product.name}</td>
                    <td style={styles.cell}>{product.brandname}</td>   
                    <td style={{ ...styles.cell, fontWeight: '500' }}>${product.price}</td>
                    <td style={styles.cell}>{product.category}</td>
                    <td style={{ ...styles.cell, textAlign: 'center' }}>{product.stock}</td>
                    <td style={styles.cell}>
                      <div style={styles.badge(status.bg, status.color, status.border)}>
                        {status.text}
                      </div>
                    </td>
                    <td style={styles.cell}>
                      <button
                        onClick={() => handleEditProduct(product)}
                        style={{
                          ...styles.button,
                          backgroundColor: '#3b82f6',
                          color: 'white',
                          marginRight: '8px',
                          padding: '6px 12px'
                        }}
                      >
                        Edit
                      </button>
                      <button
                        onClick={() => handleDeleteProduct(product)}
                        style={{
                          ...styles.button,
                          backgroundColor: '#ef4444',
                          color: 'white',
                          padding: '6px 12px'
                        }}
                      >
                        Delete
                      </button>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>

      {/* Add Product Modal */}
      {showAddModal && (
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
            {/* Modal Header */}
            <div style={{ 
              padding: '16px 24px',
              borderBottom: '1px solid #e5e7eb',
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              backgroundColor: '#f9fafb'
            }}>
              <h2 style={{ margin: 0, fontSize: '1.25rem', fontWeight: 'bold', color: '#000000' }}>
                Add Product
              </h2>
              <button
                onClick={handleClose}
                style={{ 
                  background: 'none',
                  border: 'none',
                  fontSize: '1.5rem',
                  color: '#6b7280',
                  cursor: 'pointer'
                }}
              >
                ×
              </button>
            </div>
            
            {/* Modal Body */}
            <div style={styles.modalContent}>
              <form onSubmit={handleSubmitAdd}>
                <div style={styles.modalGrid}>
                  {/* Left Column */}
                  <div>
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Product Name*
                      </label>
                      <input
                        type="text"
                        name="name"
                        value={formData.name}
                        onChange={handleInputChange}
                        required
                        style={styles.input}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Brand*
                      </label>
                      <input
                        type="text"
                        name="brandname"
                        value={formData.brandname}
                        onChange={handleInputChange}
                        required
                        style={styles.input}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Price*
                      </label>
                      <input
                        type="number"
                        name="price"
                        value={formData.price}
                        onChange={handleInputChange}
                        required
                        min="0"
                        step="0.01"
                        style={styles.input}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Category*
                      </label>
                      <input
                        type="text"
                        name="category"
                        value={formData.category}
                        onChange={handleInputChange}
                        required
                        style={styles.input}
                      />
                    </div>
                  </div>
                  
                  {/* Right Column */}
                  <div>
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Description
                      </label>
                      <textarea
                        name="description"
                        value={formData.description}
                        onChange={handleInputChange}
                        rows="4"
                        style={styles.textarea}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Stock*
                      </label>
                      <input
                        type="number"
                        name="stock"
                        value={formData.stock}
                        onChange={handleInputChange}
                        required
                        min="0"
                        style={styles.input}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Sizes (comma-separated)
                      </label>
                      <input
                        type="text"
                        name="sizes"
                        value={Array.isArray(formData.sizes) ? formData.sizes.join(', ') : formData.sizes}
                        onChange={handleInputChange}
                        placeholder="7, 8, 9, 10, 11"
                        style={styles.input}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Colors (comma-separated)
                      </label>
                      <input
                        type="text"
                        name="color"
                        value={Array.isArray(formData.color) ? formData.color.join(', ') : formData.color}
                        onChange={handleInputChange}
                        placeholder="Grey, Pink, White"
                        style={styles.input}
                      />
                    </div>
                  </div>
                </div>
                
                {/* Checkboxes at bottom */}
                <div style={{ display: 'flex', gap: '20px', marginBottom: '20px' }}>
                  <div>
                    <label style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#374151' }}>
                      <input
                        type="checkbox"
                        name="isActive"
                        checked={formData.isActive}
                        onChange={handleInputChange}
                      />
                      Active
                    </label>
                  </div>
                  <div>
                    <label style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#374151' }}>
                      <input
                        type="checkbox"
                        name="isFeatured"
                        checked={formData.isFeatured}
                        onChange={handleInputChange}
                      />
                      Featured
                    </label>
                  </div>
                </div>
              </form>
            </div>
            
            {/* Modal Footer */}
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
              <button
                onClick={handleSubmitAdd}
                style={{
                  ...styles.button,
                  backgroundColor: '#3b82f6',
                  color: 'white'
                }}
              >
                Add Product
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Edit Product Modal - Same structure as Add Product modal */}
      {showEditModal && selectedProduct && (
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
            {/* Modal Header */}
            <div style={{ 
              padding: '16px 24px',
              borderBottom: '1px solid #e5e7eb',
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              backgroundColor: '#f9fafb'
            }}>
              <h2 style={{ margin: 0, fontSize: '1.25rem', fontWeight: 'bold', color: '#000000' }}>
                Edit Product
              </h2>
              <button
                onClick={handleClose}
                style={{ 
                  background: 'none',
                  border: 'none',
                  fontSize: '1.5rem',
                  color: '#6b7280',
                  cursor: 'pointer'
                }}
              >
                ×
              </button>
            </div>
            
            {/* Modal Body */}
            <div style={styles.modalContent}>
              <form onSubmit={handleSubmitEdit}>
                <div style={styles.modalGrid}>
                  {/* Left Column */}
                  <div>
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Product Name*
                      </label>
                      <input
                        type="text"
                        name="name"
                        value={formData.name}
                        onChange={handleInputChange}
                        required
                        style={styles.input}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Brand*
                      </label>
                      <input
                        type="text"
                        name="brandname"
                        value={formData.brandname}
                        onChange={handleInputChange}
                        required
                        style={styles.input}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Price*
                      </label>
                      <input
                        type="number"
                        name="price"
                        value={formData.price}
                        onChange={handleInputChange}
                        required
                        min="0"
                        step="0.01"
                        style={styles.input}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Category*
                      </label>
                      <input
                        type="text"
                        name="category"
                        value={formData.category}
                        onChange={handleInputChange}
                        required
                        style={styles.input}
                      />
                    </div>
                  </div>
                  
                  {/* Right Column */}
                  <div>
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Description
                      </label>
                      <textarea
                        name="description"
                        value={formData.description}
                        onChange={handleInputChange}
                        rows="4"
                        style={styles.textarea}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Stock*
                      </label>
                      <input
                        type="number"
                        name="stock"
                        value={formData.stock}
                        onChange={handleInputChange}
                        required
                        min="0"
                        style={styles.input}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Sizes (comma-separated)
                      </label>
                      <input
                        type="text"
                        name="sizes"
                        value={Array.isArray(formData.sizes) ? formData.sizes.join(', ') : formData.sizes}
                        onChange={handleInputChange}
                        placeholder="7, 8, 9, 10, 11"
                        style={styles.input}
                      />
                    </div>
                    
                    <div style={styles.formGroup}>
                      <label style={styles.label}>
                        Colors (comma-separated)
                      </label>
                      <input
                        type="text"
                        name="color"
                        value={Array.isArray(formData.color) ? formData.color.join(', ') : formData.color}
                        onChange={handleInputChange}
                        placeholder="Grey, Pink, White"
                        style={styles.input}
                      />
                    </div>
                  </div>
                </div>
                
                {/* Checkboxes at bottom */}
                <div style={{ display: 'flex', gap: '20px', marginBottom: '20px' }}>
                  <div>
                    <label style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#374151' }}>
                      <input
                        type="checkbox"
                        name="isActive"
                        checked={formData.isActive}
                        onChange={handleInputChange}
                      />
                      Active
                    </label>
                  </div>
                  <div>
                    <label style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#374151' }}>
                      <input
                        type="checkbox"
                        name="isFeatured"
                        checked={formData.isFeatured}
                        onChange={handleInputChange}
                      />
                      Featured
                    </label>
                  </div>
                </div>
              </form>
            </div>
            
            {/* Modal Footer */}
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
              <button
                onClick={handleSubmitEdit}
                style={{
                  ...styles.button,
                  backgroundColor: '#3b82f6',
                  color: 'white'
                }}
              >
                Save Changes
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Bulk Upload Modal */}
      {showBulkUploadModal && (
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
            maxWidth: '600px',
            overflow: 'hidden',
            display: 'flex',
            flexDirection: 'column'
          }}>
            {/* Modal Header */}
            <div style={{ 
              padding: '16px 24px',
              borderBottom: '1px solid #e5e7eb',
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              backgroundColor: '#f9fafb'
            }}>
              <h2 style={{ margin: 0, fontSize: '1.25rem', fontWeight: 'bold', color: '#000000' }}>
                Bulk Upload Products
              </h2>
              <button
                onClick={handleClose}
                style={{ 
                  background: 'none',
                  border: 'none',
                  fontSize: '1.5rem',
                  color: '#6b7280',
                  cursor: 'pointer'
                }}
              >
                ×
              </button>
            </div>
            
            {/* Modal Body */}
            <div style={styles.modalContent}>
              <div style={{ marginBottom: '20px' }}>
                <p style={{ marginBottom: '12px', color: '#4b5563' }}>
                  Upload a CSV file containing product information. The file should have the following columns:
                </p>
                <div style={{ 
                  padding: '12px',
                  backgroundColor: '#f9fafb',
                  borderRadius: '6px',
                  border: '1px solid #e5e7eb',
                  fontFamily: 'monospace',
                  fontSize: '0.875rem',
                  overflowX: 'auto',
                  color: '#4b5563'
                }}>
                  name, description, brandname, price, category, stock, sizes, color, discount, isFeatured, isActive, isPopular, isNew
                </div>
                <p style={{ marginTop: '12px', color: '#4b5563' }}>
                  You can <a href="#" style={{ color: '#3b82f6', textDecoration: 'none' }}>download a template</a> to get started.
                </p>
              </div>
              
              <div style={styles.formGroup}>
                <label style={styles.label}>
                  Upload CSV File
                </label>
                <input
                  type="file"
                  accept=".csv"
                  onChange={handleFileChange}
                  style={styles.input}
                />
              </div>
            </div>
            
            {/* Modal Footer */}
            <div style={{
              padding: '16px 24px',
              borderTop: '1px solid #e5e7eb',
              display: 'flex',
              justifyContent: 'flex-end',
              gap: '12px',
              backgroundColor: '#f9fafb'
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
              <button
                onClick={handleBulkUpload}
                style={{
                  ...styles.button,
                  backgroundColor: '#3b82f6',
                  color: 'white'
                }}
              >
                Upload Products
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default InventoryPage;