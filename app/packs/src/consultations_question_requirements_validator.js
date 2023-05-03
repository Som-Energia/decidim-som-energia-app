document.addEventListener("DOMContentLoaded", () => {
  let form = document.querySelector('*[data-enforce-special-requirements="true"]');
  if (document.querySelectorAll(".js-card-grouped-response").length > 0 && form) {
    // Select all groups that still need an answer
    let groupNeedAnswer = () => {
      return document.querySelectorAll(".js-card-grouped-response.js-group-not-answered");
    };

    // Cache the submit button and "all groups not answered" alert
    let submitButton = form.querySelector("#vote_button");
    let groupNotAnsweredAlert = document.querySelector(".js-all-groups-not-answered");

    // Disable the submit button and show the alert
    let disableSubmitBtn = () => {
      submitButton.classList.add("disabled");
      groupNotAnsweredAlert.classList.remove("hide");
    };

    // Enable the submit button and hide the alert
    let enableSubmitBtn = () => {
      submitButton.classList.remove("disabled");
      groupNotAnsweredAlert.classList.add("hide");
    };

    // Validate each group of radio buttons and update the UI accordingly
    let validateGroups = () => {
      let inputs = form.querySelectorAll("input[type='radio']");

      inputs.forEach(function(input) {
        let radioGroupName = input.getAttribute("name");
        let radioGroup = `input[type='radio'][name='${radioGroupName}']:checked`;
        let group = input.closest(".js-card-grouped-response");

        if (document.querySelector(radioGroup)) {
          group.classList.add("a-form-success");
          group.classList.remove("js-group-not-answered");
        } else {
          group.classList.remove("a-form-success");
          group.classList.add("js-group-not-answered");
        }
      });

      // If there are no groups that still need an answer, enable the submit button
      if (groupNeedAnswer().length === 0) {
        enableSubmitBtn();
      } else {
        disableSubmitBtn();
      }
    };

    // Validate groups when a radio button is clicked
    form.querySelectorAll("input[type='radio']").forEach(function(input) {
      input.addEventListener("click", validateGroups);
    });

    // Initial validation
    validateGroups();

    // Check if any groups still need an answer when the submit button is clicked
    submitButton.addEventListener("click", (ev) => {
      let groupNotAnswered = document.querySelectorAll(".js-card-grouped-response.js-group-not-answered");
      if (groupNotAnswered.length > 0) {
        ev.stopImmediatePropagation();
        ev.preventDefault();
      }
    });
  }
});
