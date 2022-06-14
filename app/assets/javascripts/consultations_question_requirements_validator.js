$(() => {
  if($(".js-card-grouped-response").length > 0) {
    let $form = $('*[data-enforce-special-requirements="true"]');
    let groupNeedAnswer = () => {
      return $(".js-card-grouped-response.js-group-not-answered");
    };
    let $sumbitButton = $form.find("#vote_button").first();
    let $groupNotAnsweredAlert = $(".js-all-groups-not-answered")
    let disableSubmitBtn = () => {
      $sumbitButton.addClass("disabled");
      $groupNotAnsweredAlert.removeClass("hide");
    };

    let enableSubmitBtn = () => {
      $sumbitButton.removeClass("disabled");
      $groupNotAnsweredAlert.addClass("hide");
    };

    let validateGroups = () => {
      let $inputs = $form.find("input:radio");
      $inputs.each(function(){
        let radioGroupName = $(this).attr("name");
        let radioGroup = "input:radio[name='"+radioGroupName+"']:checked";
        let $group = $(this).closest(".js-card-grouped-response").first();

        if (!$(radioGroup).val()) {
          $group.removeClass("a-form-success");
          $group.addClass("js-group-not-answered");
        } else {
          $group.addClass("a-form-success");
          $group.removeClass("js-group-not-answered");
        }
      });

      if(groupNeedAnswer().length == 0){
        enableSubmitBtn();
      } else {
        disableSubmitBtn();
      }
    };

    $form.find("input:radio").on("click", function(ev) {
      validateGroups();
    });

    validateGroups();

    $sumbitButton.on("click", function(ev) {
      let groupNeedAnswer = $(".js-card-grouped-response.js-group-not-answered");
      if(groupNeedAnswer.length > 0){
        ev.stopImmediatePropagation();
        ev.preventDefault();
      }
    });
  }
});


