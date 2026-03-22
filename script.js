const form = document.getElementById("signup-form");
const status = document.getElementById("form-status");

if (form instanceof HTMLFormElement && status instanceof HTMLElement) {
  form.addEventListener("submit", (event) => {
    event.preventDefault();

    const formData = new FormData(form);
    const email = String(formData.get("email") || "").trim();

    if (!email) {
      status.textContent = "Please enter your email address.";
      return;
    }

    status.textContent = "Subscription received. Thank you!";
    form.reset();
  });
}
