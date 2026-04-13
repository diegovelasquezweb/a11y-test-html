#!/usr/bin/env bash
set -e

REPO="diegovelasquezweb/a11y-test-html"
BRANCH="feat/expand-site-with-contact-and-services"

cd "$(dirname "$0")"

echo "→ Closing open PRs..."
gh pr list --repo "$REPO" --state open --json number --jq '.[].number' | while read n; do
  gh pr close "$n" --repo "$REPO" 2>/dev/null && echo "  closed #$n"
done

echo "→ Deleting remote branches (except master)..."
git fetch --prune 2>/dev/null
git branch -r | grep "origin/" | grep -v "origin/master\|origin/HEAD" | sed 's|origin/||' | while read b; do
  git push origin --delete "$b" 2>/dev/null && echo "  deleted remote: $b"
done

echo "→ Switching to master..."
git checkout master

echo "→ Deleting local branches (except master)..."
git branch | grep -v "master" | while read b; do
  git branch -D "$b" 2>/dev/null && echo "  deleted local: $b"
done

echo "→ Creating fresh branch..."
git checkout -b "$BRANCH"

echo "→ Writing files..."

cat > index.html << 'HTML'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>A11y Test Site</title>
    <link rel="stylesheet" href="./style.css" />
  </head>
  <body>
    <a href="#main" class="sr-only">Skip to main content</a>
    <nav aria-label="Primary">
      <a href="index.html">Home</a>
      <a href="about.html">About</a>
      <a href="services.html">Services</a>
      <a href="contact.html">Contact</a>
    </nav>
    <main id="main" class="page">
      <h1>Welcome</h1>
      <p>This is the home page of the a11y test site.</p>
      <img src="hero.png" alt="Team working on accessibility" />

      <img src="decorative-banner.png" />

      <p style="color: #ccc;">This text has insufficient color contrast.</p>

      <h3>Our Mission</h3>
      <p>We build accessible experiences for everyone.</p>

      <a href="/more"></a>

      <p lang="xx">Some content in an unrecognized language.</p>
    </main>
    <script src="./script.js"></script>
  </body>
</html>
HTML

cat > about.html << 'HTML'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>About</title>
    <link rel="stylesheet" href="./style.css" />
  </head>
  <body>
    <a href="#main" class="sr-only">Skip to main content</a>
    <nav aria-label="Primary">
      <a href="index.html">Home</a>
      <a href="about.html">About</a>
      <a href="services.html">Services</a>
      <a href="contact.html">Contact</a>
    </nav>
    <main id="main" class="page">
      <h1>About Us</h1>
      <p>Founded in 2020, we are a team of engineers and designers passionate about the open web.</p>

      <p>Read more on the <a href="https://www.w3.org/WAI/" target="_blank">W3C WAI website</a>.</p>

      <button style="outline: none; padding: 8px 16px;">Learn more</button>

      <div role="button">Click me</div>

      <iframe src="https://example.com" width="300" height="200"></iframe>

      <table>
        <tr>
          <td>Name</td>
          <td>Role</td>
        </tr>
        <tr>
          <td>Alice</td>
          <td>Engineer</td>
        </tr>
      </table>
    </main>
    <script src="./script.js"></script>
  </body>
</html>
HTML

cat > services.html << 'HTML'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Services</title>
    <link rel="stylesheet" href="./style.css" />
  </head>
  <body>
    <a href="#main" class="sr-only">Skip to main content</a>
    <nav aria-label="Primary">
      <a href="index.html">Home</a>
      <a href="about.html">About</a>
      <a href="services.html">Services</a>
      <a href="contact.html">Contact</a>
    </nav>
    <main id="main" class="page">
      <h1>Services</h1>
      <p>We offer accessibility audits, remediation, and training.</p>

      <div onMouseOver="showTooltip(this)" style="display:inline-block; padding:8px; background:#eee;">Hover for info</div>

      <button accesskey="s" type="button">Save</button>

      <a href="/info" aria-hidden="true">More info</a>

      <button type="button"><span aria-hidden="true">×</span></button>

      <section id="info"><p>Section one</p></section>
      <section id="info"><p>Section two</p></section>
    </main>
    <script src="./script.js"></script>
  </body>
</html>
HTML

cat > contact.html << 'HTML'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Contact</title>
    <link rel="stylesheet" href="./style.css" />
  </head>
  <body>
    <a href="#main" class="sr-only">Skip to main content</a>
    <nav aria-label="Primary">
      <a href="index.html">Home</a>
      <a href="about.html">About</a>
      <a href="services.html">Services</a>
      <a href="contact.html">Contact</a>
    </nav>
    <main id="main" class="page">
      <h1>Contact Us</h1>

      <h2></h2>

      <ul>
        <div>Phone: 555-0100</div>
        <div>Email: hello@example.com</div>
      </ul>

      <form>
        <select>
          <option value="">Choose a topic</option>
          <option value="support">Support</option>
          <option value="sales">Sales</option>
        </select>

        <input type="text" placeholder="Your name" />
        <input type="email" placeholder="Your email" />
        <textarea placeholder="Your message"></textarea>
        <button type="submit">Send</button>
      </form>
    </main>
    <script src="./script.js"></script>
  </body>
</html>
HTML

cat > script.js << 'JS'
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

function showTooltip(el) {
  el.setAttribute("title", "More information about this service");
}

const router = {
  push(path) {
    history.pushState({}, "", path);
  },
};

router.push("/services");

screen.orientation.lock("portrait");
JS

echo "→ Committing..."
git add index.html about.html services.html contact.html script.js
git commit -m "feat: expand site with contact form, services, and about pages"

echo "→ Pushing..."
git push origin "$BRANCH"

echo ""
echo "✓ Done. Create your PR at:"
echo "  https://github.com/$REPO/compare/$BRANCH"
