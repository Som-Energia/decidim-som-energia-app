const bindCasClientRoutes = () => {
  let locale = document.documentElement.getAttribute("lang") || "es";

  document.addEventListener("click", (evt) => {
    if (evt.target.matches('a[href*="/users/sign_in"], a[href*="/users/sign_up"]')) {
      evt.preventDefault();
      window.location.href = `/users/cas/sign_in?locale=${locale}`;
    }
  });
  let signOut = document.querySelector('a[href*="/users/sign_out"]')
  if (signOut) {
    signOut.setAttribute("href", `/users/cas/sign_out?locale=${locale}`);
  }
}

document.addEventListener("DOMContentLoaded", bindCasClientRoutes);
