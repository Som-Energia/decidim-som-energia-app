const bindCasClientRoutes = () => {
  let locale = document.documentElement.getAttribute("lang") || "es";

  document.querySelectorAll('a[href*="/users/sign_in"]').forEach((element) => {
    element.setAttribute("href", `/users/cas/sign_in?locale=${locale}`);
  });
  document.querySelectorAll('a[href*="/users/sign_up"]').forEach((element) => {
    element.setAttribute("href", `/users/cas/sign_in?locale=${locale}`);
  });
  document.querySelectorAll('a[href*="/users/sign_out"]').forEach((element) => {
    element.setAttribute("href", `/users/cas/sign_out?locale=${locale}`);
  });
}

document.addEventListener("DOMContentLoaded", bindCasClientRoutes);
