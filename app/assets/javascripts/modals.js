// Open Modal on click event handler
attachModalHandler = function() {
  modal = $(this).data("js-modal-target");
  $(modal).modal_show();
  return false;
};

// send data handler for modal form
ajaxSendModalHandler = function() {
//  console.log("ajax:send");
// hide the close button in the modal header when sending data
  $(this).parents(".modal-content").find(".modal-header button.close").hide();
};

// complete request handler for modal form
ajaxCompleteModalHandler = function() {
//  console.log("ajax:complete");
// show the close button in the modal header when the request is complete
  $(this).parents(".modal-content").find(".modal-header button.close").show();
};

$(document).on("click", "a[data-js-modal-target]", attachModalHandler);
$(document).on("ajax:send", "form[data-js-modal-form]", ajaxSendModalHandler);
$(document).on("ajax:complete", "form[data-js-modal-form]", ajaxCompleteModalHandler);

// Override confirm event to show modal form instead of the default confirmation dialog
$(document).on("confirm", "button[data-js-modal-confirm]", function (event) {
  var element = $(event.target);
  var modal = $(element.data("js-modal-confirm"));
  var message = element.data("confirm");

  // clear form input elements
//  modal.clear_form_fields();

  //  Remove flash messages
  $(".flash_message").remove();

  // Show modal
  modal.modal({show: true});

  // User hits Save
  $("button[data-js-modal-submit]", modal).unbind("click").click(function(){
    // Remove data-confirm
    element.data("confirm", null);
    // Re-click link
    element.trigger("click.rails");
    // Restore data-confirm
    element.data("confirm", message);
    modal.modal("hide");
  });
  // Prevent rails from popping up a browser box, we've already done the work
  return false;
});

// Library of functions for modals
(function($) {

  $.fn.modal_clear_errors = function(){
    // remove Alert message
    $("#alert_message", this).remove();

    // clear error state
    this.clear_form_errors();
  };

  // show modal and display errors
  $.fn.modal_error = function(errors, message){
    // Clear modal from previous errors and alert messages
    this.modal_clear_errors();

    // show alert message - optional
    if (message) this.show_alert_message(message, "warning");

    // reder error messages
    this.render_form_errors( errors );
  };

  // show modal and display failure message
  $.fn.modal_failure = function(message){
    // Clear modal from previous errors and alert messages
    this.modal_clear_errors();

    // show Alert message
    this.show_alert_message(message, "danger");
  };

  // show modal and reset previous errors
  $.fn.modal_show = function(){
    // clear error state
    this.modal_clear_errors();

    // clear form input elements
    this.clear_form_fields();

    // Enable Save button
    btn = $("[data-js-modal-submit]", this);
    caption = btn.data("js-modal-submit");
    caption = ( caption == null ? "Save changes" : caption);
    btn.removeAttr("disabled")
      .attr("data-disable-with","Submitting...")
      .val(caption);

    // show modal and prevent closing the modal when clicking outside of it
    // or pressing the escape button
    this.modal({show: true,
                backdrop: "static",
                keyboard: false
              });

  };

  // show modal with the success message
  $.fn.modal_success = function(message){
    // clear error state
    this.modal_clear_errors();

    // show Alert message
    this.show_alert_message(message, "success");

    // disable Save button
    btn = $("[data-js-modal-submit]", this);
    caption = btn.data("js-modal-submit");
    caption = ( caption == null ? "Save changes" : caption);
    btn.removeAttr("data-disable-with")
      .attr("disabled","disabled")
      .val(caption);

    // show modal just in case it was closed
    this.modal("show");
  };

  // show alert message
  $.fn.show_alert_message = function(message, type){
    div = $('<div class="alert" id="alert_message"></div>');
    div.addClass("alert-" + type);
    div.html("<strong>" + message + "</strong>");
    $(".modal-body", this).prepend(div);
  };

  // render errors on form
  $.fn.render_form_errors = function(errors){
    form = $("form[data-model]", this);
    model = form.data("model");

    // show error messages in input form-group help-block
    $.each(errors, function(field, messages){
      $input = $('input[name="' + model + '[' + field + ']"]', form);
      $input.closest(".form-group").addClass("has-error").find(".help-block").html( messages.join(" and ") + ".");
    });
  };

  // clear previous errors from form
  $.fn.clear_form_errors = function(){
    form = $("form[data-model]", this);
    $(".form-group.has-error", form).each(function(){
      $(".help-block", $(this)).html("");
      $(this).removeClass("has-error");
    });
  }

  // reset data form
  $.fn.clear_form_fields = function(){
    $("form[data-model]", this).trigger("reset");
  }

}(jQuery));
