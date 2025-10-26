function loadComponent(elementId, componentPath) {
  fetch(componentPath)
    .then((response) => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.text();
    })
    .then((html) => {
      const element = document.getElementById(elementId);
      if (element) {
        element.innerHTML = html;
      } else {
        console.error(`Element with id '${elementId}' not found`);
      }
    })
    .catch((error) => {
      console.error("Error loading component:", error);
    });
}
