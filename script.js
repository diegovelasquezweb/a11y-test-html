const form = document.getElementById("contact-form");
const status = document.getElementById("form-status");

if (form instanceof HTMLFormElement && status instanceof HTMLElement) {
  form.addEventListener("submit", (event) => {
    event.preventDefault();

    const formData = new FormData(form);
    const name = String(formData.get("name") || "").trim();
    const email = String(formData.get("email") || "").trim();
    const message = String(formData.get("message") || "").trim();

    if (!name || !email || !message) {
      status.textContent = "Please complete all fields before sending.";
      return;
    }

    status.textContent = "Message sent. Thank you!";
    form.reset();
  });
}

// PAT: spa-route-title — navigate() without updating document.title
function goToPage(path) {
  navigate(path);
  // Update document title to reflect the new route for screen reader users
  const routeTitles = {
    '/': 'Home',
    '/about': 'About',
    '/contact': 'Contact',
    '/services': 'Services'
  };
  document.title = routeTitles[path] || 'Page';
}

// Removed: programmatic screen orientation lock.
// Users should control their device orientation. If portrait-only layout is needed,
// use CSS media queries (@media (orientation: portrait)) to provide responsive design
// that works in both orientations.
