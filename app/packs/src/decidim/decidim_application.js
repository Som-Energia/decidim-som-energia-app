// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack

import "src/consultations_question_requirements_validator";

// Load images
require.context("../../images", true);

const bindCasClientRoutes = () => {
  let locale = document.documentElement.getAttribute("lang") || "es";

  document.querySelectorAll('a[href*="/users/sign_in"]').forEach((element) => {
    element.setAttribute("href", `/users/auth/cas?locale=${locale}`);
    element.setAttribute("data-method", "post");
  });
  document.querySelectorAll('a[href*="/users/sign_up"]').forEach((element) => {
    element.setAttribute("href", `/users/auth/cas?locale=${locale}`);
  });
  document.querySelectorAll('a[href*="/users/sign_out"]').forEach((element) => {
    element.setAttribute("href", `/users/cas/sign_out?locale=${locale}`);
  });

  if (!document.querySelector('a[href*="/account"]') && !location.pathname.startsWith("/users")) {
    // Replace vote buttons
    document.querySelectorAll("button[type='submit']").forEach((element) => {
      const link = document.createElement("a");
      link.href = "/users/auth/cas";
      link.className = element.className;
      link.innerHTML = element.innerHTML;
      link.style.cursor = "pointer";
      link.setAttribute("data-method", "post");
      element.style.display = "none";
      element.parentNode.insertBefore(link, element.nextSibling);
    });
  }

  Rails.start();
}


document.addEventListener("DOMContentLoaded", bindCasClientRoutes);

