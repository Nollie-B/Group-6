// Enhanced authentication system for F2C Solutions
// - Seeds an admin/admin user in localStorage
// - Handles login and signup form interactions on auth.html
// - Sets localStorage.loggedInUser when login succeeds

(function () {
  const USERS_KEY = 'pp_users'; // prefix to avoid collisions
  const LOGGED_IN_KEY = 'pp_loggedInUser';

  function readUsers() {
    try {
      const raw = localStorage.getItem(USERS_KEY);
      return raw ? JSON.parse(raw) : [];
    } catch (e) {
      console.error('Error reading users from localStorage', e);
      return [];
    }
  }

  function writeUsers(users) {
    localStorage.setItem(USERS_KEY, JSON.stringify(users));
  }

  function seedAdmin() {
    const users = readUsers();
    const hasAdmin = users.some(u => u.email === 'admin');
    if (!hasAdmin) {
      users.push({ email: 'admin', password: 'admin' });
      writeUsers(users);
      console.log('Seeded admin user (email: admin / password: admin)');
    }
  }

  function showMessage(container, text, type = 'info') {
    if (!container) {
      console.error('Message container not found');
      return;
    }
    
    container.textContent = text;
    container.classList.remove('success', 'error', 'info');
    container.classList.add(type);
    container.style.display = 'block';
    
    // Auto-hide after 5 seconds for error messages
    if (type === 'error') {
      setTimeout(() => {
        container.style.display = 'none';
      }, 5000);
    }
  }

  function clearMessage(container) {
    if (!container) return;
    container.textContent = '';
    container.classList.remove('success', 'error', 'info');
    container.style.display = 'none';
  }

  function setButtonLoading(button, isLoading) {
    if (!button) return;
    
    if (isLoading) {
      button.classList.add('loading');
      button.disabled = true;
    } else {
      button.classList.remove('loading');
      button.disabled = false;
    }
  }

  function handleLogin(e) {
    console.log('Login button clicked');
    
    const form = document.querySelector('.login-form');
    const button = document.querySelector('.login-btn');
    const messageContainer = document.querySelector('.login-message');
    
    if (!form || !button || !messageContainer) {
      console.error('Required elements not found for login');
      return;
    }

    const email = (form.querySelector('input[name="email"]') || {}).value?.trim() || '';
    const password = (form.querySelector('input[name="password"]') || {}).value || '';

    console.log('Login attempt:', { email, password: password ? '***' : 'empty' });

    // Clear previous messages
    clearMessage(messageContainer);
    setButtonLoading(button, true);

    // Validation
    if (!email || !password) {
      showMessage(messageContainer, 'Please enter email and password', 'error');
      setButtonLoading(button, false);
      return;
    }

    const users = readUsers();
    const user = users.find(u => u.email === email);
    
    if (!user) {
      showMessage(messageContainer, 'No account found for that email', 'error');
      setButtonLoading(button, false);
      return;
    }
    
    if (user.password !== password) {
      showMessage(messageContainer, 'Incorrect password', 'error');
      setButtonLoading(button, false);
      return;
    }

    // Success
    try {
      localStorage.setItem(LOGGED_IN_KEY, email);
      showMessage(messageContainer, 'Login successful — redirecting...', 'success');
      
      console.log('Login successful for user:', email);
      
      setTimeout(() => {
        // redirect to index.html in the html folder
        window.location.href = '../html/index.html';
      }, 1000);
      
    } catch (error) {
      console.error('Error saving login state:', error);
      showMessage(messageContainer, 'Login failed - storage error', 'error');
      setButtonLoading(button, false);
    }
  }

  function handleSignup(e) {
    console.log('Signup button clicked');
    
    const form = document.querySelector('.signup-form');
    const button = document.querySelector('.signup-btn');
    const messageContainer = document.querySelector('.signup-message');
    
    if (!form || !button || !messageContainer) {
      console.error('Required elements not found for signup');
      return;
    }

    const email = (form.querySelector('input[name="email"]') || {}).value?.trim() || '';
    const password = (form.querySelector('input[name="password"]') || {}).value || '';
    const confirm = (form.querySelector('input[name="confirm"]') || {}).value || '';

    console.log('Signup attempt:', { email, password: password ? '***' : 'empty', confirm: confirm ? '***' : 'empty' });

    // Clear previous messages
    clearMessage(messageContainer);
    setButtonLoading(button, true);

    // Validation
    if (!email || !password || !confirm) {
      showMessage(messageContainer, 'Please fill all fields', 'error');
      setButtonLoading(button, false);
      return;
    }
    
    if (password !== confirm) {
      showMessage(messageContainer, 'Passwords do not match', 'error');
      setButtonLoading(button, false);
      return;
    }

    if (password.length < 3) {
      showMessage(messageContainer, 'Password must be at least 3 characters', 'error');
      setButtonLoading(button, false);
      return;
    }

    const users = readUsers();
    if (users.some(u => u.email === email)) {
      showMessage(messageContainer, 'An account with that email already exists', 'error');
      setButtonLoading(button, false);
      return;
    }

    try {
      // Add new user
      users.push({ email, password });
      writeUsers(users);
      
      showMessage(messageContainer, 'Account created successfully! You can now login.', 'success');
      
      console.log('New user created:', email);
      
      // Switch to login view after delay
      setTimeout(() => {
        const toggle = document.getElementById('check');
        if (toggle) {
          toggle.checked = false;
          console.log('Switched to login view');
        }
        setButtonLoading(button, false);
      }, 1500);
      
    } catch (error) {
      console.error('Error creating user:', error);
      showMessage(messageContainer, 'Failed to create account - storage error', 'error');
      setButtonLoading(button, false);
    }
  }

  function handleFormSubmission(e) {
    // Prevent default form submission
    e.preventDefault();
    
    const form = e.target;
    if (form.classList.contains('login-form')) {
      handleLogin(e);
    } else if (form.classList.contains('signup-form')) {
      handleSignup(e);
    }
  }

  // Enhanced event listeners
  function initializeAuth() {
    console.log('Initializing authentication system...');
    
    seedAdmin();
    
    // Find all required elements
    const loginBtn = document.querySelector('.login-btn');
    const signupBtn = document.querySelector('.signup-btn');
    const loginForm = document.querySelector('.login-form');
    const signupForm = document.querySelector('.signup-form');
    
    console.log('Elements found:', {
      loginBtn: !!loginBtn,
      signupBtn: !!signupBtn,
      loginForm: !!loginForm,
      signupForm: !!signupForm
    });

    // Add click event listeners to buttons
    if (loginBtn) {
      loginBtn.addEventListener('click', handleLogin);
      console.log('Login button event listener added');
    }
    
    if (signupBtn) {
      signupBtn.addEventListener('click', handleSignup);
      console.log('Signup button event listener added');
    }

    // Add form submission handlers
    if (loginForm) {
      loginForm.addEventListener('submit', handleFormSubmission);
      console.log('Login form submission handler added');
    }
    
    if (signupForm) {
      signupForm.addEventListener('submit', handleFormSubmission);
      console.log('Signup form submission handler added');
    }

    // Add enter key handlers for inputs
    const inputs = document.querySelectorAll('.form-input');
    inputs.forEach(input => {
      input.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
          const form = this.closest('form');
          if (form) {
            e.preventDefault();
            handleFormSubmission(e);
          }
        }
      });
    });

    console.log('Authentication system initialized successfully');
  }

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeAuth);
  } else {
    initializeAuth();
  }

  // Also initialize immediately if DOM is already loaded
  if (document.readyState === 'complete') {
    initializeAuth();
  }

  // Expose functions for debugging
  window.authDebug = {
    readUsers,
    writeUsers,
    seedAdmin,
    handleLogin,
    handleSignup,
    showMessage,
    clearMessage
  };

})();