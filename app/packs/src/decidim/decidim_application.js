// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack

import "src/consultations_question_requirements_validator";

// Load images
require.context("../../images", true);

$(function(){
  bindCasClientRoutes();
});

function bindCasClientRoutes(){
  var locale = $(document.documentElement).attr("lang") || "es";

  $(document).on("click","a[href*='/users/sign_in'], a[href*='/users/sign_up']", function(e){
    e.preventDefault();
    window.location.href = '/users/cas/sign_in?locale='+locale;
  });
  $("a[href*='/users/sign_out']").attr('href', '/users/cas/sign_out?locale='+locale);
}


