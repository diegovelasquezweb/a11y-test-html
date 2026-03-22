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
