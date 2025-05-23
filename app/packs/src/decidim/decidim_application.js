// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack

import "src/consultations_question_requirements_validator";

// Load images
require.context("../../images", true);

const bindCasClientRoutes = () => {
  let locale = document.documentElement.getAttribute("lang") || "es";

  document.querySelectorAll('a[href*="/users/sign_in"]').forEach((element) => {
    element.setAttribute("href", `/users/cas/sign_in?locale=${locale}`);
    element.setAttribute("data-method", "post");
  });
  document.querySelectorAll('a[href*="/users/sign_up"]').forEach((element) => {
    element.setAttribute("href", `/users/cas/sign_in?locale=${locale}`);
  });
  document.querySelectorAll('a[href*="/users/sign_out"]').forEach((element) => {
    element.setAttribute("href", `/users/cas/sign_out?locale=${locale}`);
  });
  Rails.start();
}


document.addEventListener("DOMContentLoaded", bindCasClientRoutes);