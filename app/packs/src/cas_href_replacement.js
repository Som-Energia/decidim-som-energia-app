document.addEventListener('DOMContentLoaded', function() {
  bindCasClientRoutes();
});

function bindCasClientRoutes(){
  var locale = document.documentElement.getAttribute('lang') || 'es';

  document.addEventListener('click', function(e) {
    if (e.target.matches('a[href*="/users/sign_in"], a[href*="/users/sign_up"]')) {
      e.preventDefault();
      window.location.href = '/users/cas/sign_in?locale=' + locale;
    }
  });
  var sign_out = document.querySelector('a[href*="/users/sign_out"]')
  if (sign_out) {
    sign_out.setAttribute('href', '/users/cas/sign_out?locale=' + locale);
  }
}
