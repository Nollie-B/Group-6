function loadComponent(elementId, componentPath) {
  return new Promise((resolve, reject) => {
    fetch(componentPath)
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.text();
      })
      .then((html) => {
        const element = document.getElementById(elementId);
        if (!element) {
          console.error(`Element with id '${elementId}' not found`);
          reject(new Error(`Element with id '${elementId}' not found`));
          return;
        }

        // Parse the fetched HTML so we can execute any <script> tags it contains.
        const tmp = document.createElement('div');
        tmp.innerHTML = html;

        // Extract and execute scripts (external and inline)
        const scripts = Array.from(tmp.querySelectorAll('script'));
        scripts.forEach((s) => s.parentNode && s.parentNode.removeChild(s));

        // Insert the non-script HTML into the element
        element.innerHTML = tmp.innerHTML;

        // Now load external scripts and evaluate inline scripts
        scripts.forEach((s) => {
          if (s.src) {
            const script = document.createElement('script');
            script.src = s.src;
            script.async = false;
            document.body.appendChild(script);
          } else if (s.textContent) {
            try {
              // Execute inline script in global scope
              (0, eval)(s.textContent);
            } catch (e) {
              console.error('Error executing inline script from component:', e);
            }
          }
        });
        
        console.log(`Component '${elementId}' loaded successfully`);
        // Dispatch a component-loaded event for in-page navigation hooks
        try {
          document.dispatchEvent(new CustomEvent('f2c:component-loaded', { detail: { elementId: elementId, componentPath: componentPath } }));
        } catch (e) {}
        resolve();
      })
      .catch((error) => {
        console.error('Error loading component:', error);
        reject(error);
      });
  });
}
