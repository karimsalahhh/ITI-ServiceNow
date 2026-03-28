async function loadPartial(selector, filePath) {
  const container = document.querySelector(selector);
  if (container === null) return;

  const response = await fetch(filePath);
  container.innerHTML = await response.text();
}

function getBasePath() {
  const currentPath = window.location.pathname.toLowerCase();
  if (currentPath.includes("/pages/")) return "..";
  return ".";
}

function normalizeLocalLinks(basePath) {
  const localNodes = document.querySelectorAll("[href^='/'], [src^='/']");

  localNodes.forEach(function (node) {
    if (node.hasAttribute("href")) {
      const href = node.getAttribute("href");
      node.setAttribute("href", `${basePath}${href}`);
    }

    if (node.hasAttribute("src")) {
      const src = node.getAttribute("src");
      node.setAttribute("src", `${basePath}${src}`);
    }
  });
}

function getCurrentNavKey() {
  const currentPath = window.location.pathname.toLowerCase();

  if (currentPath === "/" || currentPath.endsWith("/index.html")) return "home";
  else if (currentPath.endsWith("/pages/shop.html")) return "shop";
  else if (currentPath.endsWith("/pages/health.html")) return "health";
  else if (currentPath.endsWith("/pages/home_kitchen.html"))
    return "essentials";
  else if (currentPath.endsWith("/pages/offers.html")) return "offers";
  else if (currentPath.endsWith("/pages/about.html")) return "about";
  else if (currentPath.endsWith("/pages/contact.html")) return "contact";

  return "";
}

function highlightActiveNav() {
  const activeKey = getCurrentNavKey();
  if (activeKey === "") return;

  document.querySelectorAll(".js-nav-link").forEach(function (link) {
    if (link.dataset.nav !== activeKey) return;

    link.classList.add("active", "fw-bold", "text-success");
    link.setAttribute("aria-current", "page");

    // Only add underline style for the desktop nav items
    if (link.classList.contains("nav-link")) {
      link.classList.add("border-bottom", "border-2", "border-success");
    }
  });
}

async function startLayout() {
  const basePath = getBasePath();

  await loadPartial("#site-header", `${basePath}/partials/header.html`);
  await loadPartial("#site-footer", `${basePath}/partials/footer.html`);
  normalizeLocalLinks(basePath);

  highlightActiveNav();
}

startLayout();

