// Simple NoSQL-like localStorage helpers for per-user data
(function() {
  const LOGGED_IN_KEY = 'pp_loggedInUser';

  function sanitizeKeyPart(s) {
    if (!s) return 'anon';
    return String(s).replace(/[^a-zA-Z0-9_-]/g, '_');
  }

  function getCurrentUser() {
    return localStorage.getItem(LOGGED_IN_KEY) || null;
  }

  function inventoryKeyFor(user) {
    const u = user || getCurrentUser();
    return `inventory_${sanitizeKeyPart(u)}`;
  }

  function readInventory() {
    const key = inventoryKeyFor();
    try {
      return JSON.parse(localStorage.getItem(key)) || [];
    } catch (e) {
      console.error('readInventory parse error', e);
      return [];
    }
  }

  function writeInventory(items) {
    const key = inventoryKeyFor();
    localStorage.setItem(key, JSON.stringify(items || []));
  }

  function readMarketplace() {
    try {
      return JSON.parse(localStorage.getItem('marketplaceItems')) || [];
    } catch (e) {
      console.error('readMarketplace parse error', e);
      return [];
    }
  }

  function writeMarketplace(items) {
    localStorage.setItem('marketplaceItems', JSON.stringify(items || []));
  }

  function addMarketplaceListing(listing) {
    const items = readMarketplace();
    const owner = getCurrentUser();
    listing.owner = owner;
    items.push(listing);
    writeMarketplace(items);
    return listing;
  }

  // Export helpers
  window.F2CDB = {
    getCurrentUser,
    readInventory,
    writeInventory,
    readMarketplace,
    writeMarketplace,
    addMarketplaceListing
  };

})();
