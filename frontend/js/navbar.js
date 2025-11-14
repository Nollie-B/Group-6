// navbar.js — small helper to set active nav item, position indicator, and handle simple dropdown/resize
(function () {
  function setActiveNav() {
    const links = document.querySelectorAll('.navbar-nav .nav-link');
    if (!links.length) return;

    // Derive current file name
    const path = window.location.pathname || '';
    const current = path.split('/').pop() || 'index.html';

    let activeEl = null;
    links.forEach((a) => {
      const href = a.getAttribute('href') || '';
      // Compare only filename portion
      const hrefFile = href.split('/').pop();
      if (hrefFile === current) {
        a.classList.add('active');
        activeEl = a;
      } else {
        a.classList.remove('active');
      }
    });

    positionIndicator(activeEl || links[0]);
  }

  function positionIndicator(el) {
    const indicator = document.querySelector('.nav-indicator');
    const nav = document.querySelector('.navbar-nav');
    if (!indicator || !nav || !el) return;

    // Calculate offset relative to nav container
    const navRect = nav.getBoundingClientRect();
    const elRect = el.getBoundingClientRect();
    const left = elRect.left - navRect.left + nav.scrollLeft;
    const width = elRect.width;

    indicator.style.transform = `translateX(${left}px)`;
    indicator.style.width = `${width}px`;
    indicator.style.opacity = '1';
  }

  function attachNavHandlers() {
    const links = document.querySelectorAll('.navbar-nav .nav-link');
    links.forEach((a) => {
      a.addEventListener('click', (e) => {
        // let navigation happen normally — but update active state for smooth indicator movement
        setTimeout(() => setActiveNav(), 10);
      });

      // update indicator on mouseover for a nice hover effect
      a.addEventListener('mouseenter', () => positionIndicator(a));
    });

    const nav = document.querySelector('.navbar-nav');
    if (nav) {
      nav.addEventListener('mouseleave', () => setActiveNav());
    }

    window.addEventListener('resize', () => setActiveNav());
  }

  // Small accessibility enhancement: keyboard support
  function attachKeyboardSupport() {
    const links = Array.from(document.querySelectorAll('.navbar-nav .nav-link'));
    links.forEach((link, idx) => {
      link.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowRight') {
          e.preventDefault();
          const next = links[(idx + 1) % links.length];
          next.focus();
          positionIndicator(next);
        } else if (e.key === 'ArrowLeft') {
          e.preventDefault();
          const prev = links[(idx - 1 + links.length) % links.length];
          prev.focus();
          positionIndicator(prev);
        }
      });
    });
  }

  // Run on DOM ready
  function init() {
    // Create indicator element if missing
    let indicator = document.querySelector('.nav-indicator');
    const nav = document.querySelector('.navbar-nav');
    if (nav && !indicator) {
      indicator = document.createElement('div');
      indicator.className = 'nav-indicator';
      // place indicator as first child of nav's parent so positioning is relative to nav
      nav.parentElement.appendChild(indicator);
    }

    setActiveNav();
    attachNavHandlers();
    attachKeyboardSupport();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
