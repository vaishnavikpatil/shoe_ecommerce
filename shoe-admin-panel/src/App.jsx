import { useState } from 'react';
import './App.css';
import InventoryPage from './pages/invetory';
import {
  PendingPage,
  ProcessingPage,
  PackingPage,
  ShippingPage,
  DeliveryPage,
  CompletedPage,
  CancelledPage,
  ReturnsExchangesPage
} from './pages/pages';

function App() {
  const [selectedOption, setSelectedOption] = useState('Inventory');
  const [isOpen, setIsOpen] = useState(true);

  const toggleSidebar = () => {
    setIsOpen(!isOpen);
  };

  const renderContent = (option) => {
    switch(option) {
      case 'Inventory':
        return <InventoryPage />;
      case 'Pending Orders':
        return <PendingPage />;
      case 'In Processing':
        return <ProcessingPage />;
      case 'In Packing':
        return <PackingPage />;
      case 'In Shipping':
        return <ShippingPage />;
      case 'In Delivery':
        return <DeliveryPage />;
      case 'Completed Orders':
        return <CompletedPage />;
      case 'Cancelled Orders':
        return <CancelledPage />;
      case 'Returns & Exchanges':
        return <ReturnsExchangesPage />;
      default:
        return <div>Select an option</div>;
    }
  };

  // Custom SVG icons
  const icons = {
    'Inventory': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
        <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
      </svg>
    ),
    'Pending Orders': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <polyline points="9 11 12 14 22 4"></polyline>
        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
      </svg>
    ),
    'In Processing': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <circle cx="12" cy="12" r="10"></circle>
        <polyline points="12 6 12 12 16 14"></polyline>
      </svg>
    ),
    'In Packing': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
        <polyline points="3.29 7 12 12 20.71 7"></polyline>
        <line x1="12" y1="22" x2="12" y2="12"></line>
      </svg>
    ),
    'In Shipping': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <rect x="1" y="3" width="15" height="13"></rect>
        <polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon>
        <circle cx="5.5" cy="18.5" r="2.5"></circle>
        <circle cx="18.5" cy="18.5" r="2.5"></circle>
      </svg>
    ),
    'In Delivery': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <line x1="22" y1="2" x2="11" y2="13"></line>
        <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
      </svg>
    ),
    'Completed Orders': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
        <polyline points="22 4 12 14.01 9 11.01"></polyline>
      </svg>
    ),
    'Cancelled Orders': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <circle cx="12" cy="12" r="10"></circle>
        <line x1="15" y1="9" x2="9" y2="15"></line>
        <line x1="9" y1="9" x2="15" y2="15"></line>
      </svg>
    ),
    'Returns & Exchanges': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <polyline points="23 4 23 10 17 10"></polyline>
        <polyline points="1 20 1 14 7 14"></polyline>
        <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
      </svg>
    ),
    'Menu': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <line x1="3" y1="12" x2="21" y2="12"></line>
        <line x1="3" y1="6" x2="21" y2="6"></line>
        <line x1="3" y1="18" x2="21" y2="18"></line>
      </svg>
    ),
    'Close': (
      <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round">
        <line x1="18" y1="6" x2="6" y2="18"></line>
        <line x1="6" y1="6" x2="18" y2="18"></line>
      </svg>
    )
  };

  // Updated navigation options with new workflow stages
  const navigationOptions = [
    'Inventory', 
    'Pending Orders', 
    'In Processing', 
    'In Packing', 
    'In Shipping', 
    'In Delivery', 
    'Completed Orders', 
    'Cancelled Orders', 
    'Returns & Exchanges'
  ];

  return (
    <div style={{ display: 'flex', height: '100vh', fontFamily: 'Arial, sans-serif', backgroundColor: 'white' }}>
      {/* Sidebar */}
      <div style={{
        width: isOpen ? '240px' : '70px',
        backgroundColor: '#1A2530',
        color: 'white',
        transition: 'width 0.3s ease',
        display: 'flex',
        flexDirection: 'column',
        boxShadow: '2px 0 10px rgba(0, 0, 0, 0.1)',
        overflow: 'hidden',
        flexShrink: 0
      }}>
        {/* Sidebar Header */}
        <div style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          padding: '16px',
          borderBottom: '1px solid rgba(255, 255, 255, 0.1)'
        }}>
          {isOpen && (
            <h2 style={{ 
              margin: 0, 
              fontSize: '18px', 
              fontWeight: 'bold'
            }}>
              Order Management
            </h2>
          )}
          <button 
            onClick={toggleSidebar}
            style={{
              background: 'transparent',
              border: 'none',
              color: 'white',
              cursor: 'pointer',
              padding: '5px',
              borderRadius: '4px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center'
            }}
          >
            {isOpen ? icons['Close'] : icons['Menu']}
          </button>
        </div>

        {/* Sidebar Navigation */}
        <nav style={{ flex: 1, padding: '16px 0' }}>
          <ul style={{ listStyle: 'none', padding: 0, margin: 0 }}>
            {navigationOptions.map((option) => (
              <li key={option} style={{ margin: '0' }}>
                <a
                  href="#"
                  onClick={(e) => {
                    e.preventDefault();
                    setSelectedOption(option);
                  }}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    padding: '12px 16px',
                    textDecoration: 'none',
                    color: 'white',
                    backgroundColor: selectedOption === option ? 'rgba(255, 255, 255, 0.1)' : 'transparent',
                    borderLeft: selectedOption === option ? '4px solid white' : '4px solid transparent',
                    transition: 'background-color 0.2s',
                    whiteSpace: 'nowrap'
                  }}
                >
                  <span style={{ 
                    marginRight: '12px',
                    display: 'inline-flex',
                    alignItems: 'center',
                    justifyContent: 'center'
                  }}>
                    {icons[option]}
                  </span>
                  {isOpen && <span>{option}</span>}
                </a>
              </li>
            ))}
          </ul>
        </nav>

        {/* Sidebar Footer */}
        {isOpen && (
          <div style={{
            padding: '16px',
            borderTop: '1px solid rgba(255, 255, 255, 0.1)',
            fontSize: '12px',
            color: 'rgba(255, 255, 255, 0.7)'
          }}>
            © 2025 Order Management System
          </div>
        )}
      </div>

      {/* Main Content */}
      <div style={{ 
        flex: 1, 
        width: '100%',
        padding: '0',
        backgroundColor: 'white',
        overflow: 'auto',
        display: 'flex',
        flexDirection: 'column'
      }}>
        <div style={{ 
          padding: '20px 24px',
          borderBottom: '1px solid #e5e7eb',
          backgroundColor: 'white'
        }}>
          <h1 style={{ 
            fontSize: '24px', 
            fontWeight: 'bold', 
            margin: 0,
            color: '#1e293b'
          }}>
            {selectedOption}
          </h1>
        </div>
        <div style={{ 
          padding: '24px', 
          flex: 1, 
          width: '100%', 
          backgroundColor: 'white',
          display: 'flex',
          flexDirection: 'column'
        }}>
          {renderContent(selectedOption)}
        </div>
      </div>
    </div>
  );
}

export default App;