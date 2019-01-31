$(document).ready(function() {
  var el = document.getElementById('returnsTable');
  //var ls_test = el.outerHTML;
  var $checkAllProducts = $('#checkAllProducts')

  enableDraws();

  $checkAllProducts.prop('checked', true); // check all checkboxes when page loads

  $(".chk_all").click(function() {

    var checkAll = $(".chk_all").prop('checked');
    if (checkAll) {
      $(".days_of_week").prop("checked", true);
    } else {
      $(".days_of_week").prop("checked", false);
    }

  });

  $(".chk_all_products").click(function() {

    var checkProducts = $(".chk_all_products").prop('checked');
    if (checkProducts) {
      $(".product_selectors").prop("checked", true);
      filterProducts();
    } else {
      $(".product_selectors").prop("checked", false);
      filterProducts();
    }

  });

  $('.draw_inputs, .return_inputs').change(function() {
    changed_draw_returns(this);
  });

  $('.zero_draw_reason_code').change(function() {
    var draw_input = $(this).siblings('.draw_inputs');
    changed_draw_returns(draw_input);
  });

  $('[data-toggle="popover"]').popover({
    placement: 'top',
    trigger: 'hover'
  });

  suppresslocation();

  // Disable Save button on modal show event if affidavit is not signed
  $("#Affidavit").on("show.bs.modal", function() {
    $("#affidavit_save_button").prop("disabled", !$("#affidavit_signed").prop('checked'));
  });

  // Enable/disable Save button if affidavit is signed/unsigned
  $("#affidavit_signed").on("click", function() {
    $("#affidavit_save_button").prop("disabled", !this.checked);
  });

});

function filterProducts() {
  var input, filter, table, tr, td, i, checked;
  products = document.getElementsByName('product_search');

  for (var i = 0; i < products.length; ++i) {
    if (products[i].checked) {
      showrows(products[i].value.toUpperCase())
    } else {
      hiderows(products[i].value.toUpperCase())
    }
  }
  suppresslocationafterfilter();
};

function freezeFrozen() {
  var input_cells_to_freeze = $(".frozen")
  for (var i = input_cells_to_freeze.length - 1; i >= 0; i--) {
    $(input_cells_to_freeze[i]).prop('disabled', true);
  }
};

function suppresslocation() {
  var tablex = document.getElementById('returnsTable');
  var rowCount = tablex.rows.length;
  var strprvloc = "";
  var strloc = "";
  //start table rows from i because the row 0 is the table header row - ignore the first row
  for (var i = 1; i < rowCount; i++) {
    strloc = tablex.rows[i].cells[0].innerText;
    tablex.rows[i].dataset.location = tablex.rows[i].cells[0].innerHTML;
    if (strloc == strprvloc)
      tablex.rows[i].cells[0].innerHTML = "";
    else
      strprvloc = strloc;
  }
}

function suppresslocationafterfilter() {
  var tablex = document.getElementById('returnsTable');
  var rowCount = tablex.rows.length;
  var strprvloc = "";
  var strloc = "";
  //start table rows from i because the row 0 is the table header row - ignore the first row
  for (var i = 1; i < rowCount; i++) {
    el = tablex.rows[i];
    tablex.rows[i].cells[0].innerHTML = tablex.rows[i].dataset.location;
    if (el.classList.contains("hidden") == false) {
      strloc = tablex.rows[i].cells[0].innerText;
      if (strloc == strprvloc)
        tablex.rows[i].cells[0].innerHTML = "";
      else
        strprvloc = strloc;
    }
  }
}


$(function() {
  var $chk = $("#daysOfWeek input:checkbox"); // cache the selector
  var $tbl = $("#returnsTable");
  var $products = $("#productFiltors input:checkbox")
  var $prod_filters = $('[id^=productsSearchInput_]')

  $chk.prop('checked', true); // check all checkboxes when page loads
  $products.prop('checked', true); // check all checkboxes when page loads

  $chk.click(function() {
    if ($(this).attr("name") == "chk_all") {
      if ($(this).prop('checked') == true) {
        $tbl.find('.draws_and_returns').toggle(true)
      } else {
        $tbl.find('.draws_and_returns').toggle(false)
      };

    } else {
      if ($(".days_of_week").length == $(".days_of_week:checked").length) {
        $(".chk_all").prop('checked', true);
      } else {
        $(".chk_all").prop('checked', false);
      }
      var colToHide = $tbl.find(".draws_and_returns." + $(this).attr("name"));
      if ($(this).prop('checked') == true) {
        $(colToHide).show();
      } else {
        $(colToHide).hide();
      }
    }
  });

  $products.click(function() {
    if ($(this).attr("name") == "chk_all_products") {
      if ($(this).prop('checked') == true) {
        $tbl.find('product_selector_all').toggle(true);
      } else {
        $tbl.find('product_selector_all').toggle(false);
      }

    } else {
      if ($(".product_selectors").length == $(".product_selectors:checked").length) {
        $(".chk_all_products").prop('checked', true);
      } else {
        $(".chk_all_products").prop('checked', false);
      }
      var input, filter, table, tr, td, i, checked;
      products = document.getElementsByName('product_search');

      for (var i = 0; i < products.length; ++i) {
        if (products[i].checked) {
          showrows(products[i].value.toUpperCase())
        } else {
          hiderows(products[i].value.toUpperCase())
        }
      }
    }
    suppresslocationafterfilter();
  });
});

function enableDraws() {
  var elements = document.getElementsByClassName("draw_inputs");
  var el = document.getElementById("drawsInput");

  for (var i = 0; i < elements.length; i++) {
    if (el.checked) {
      elements[i].disabled = false;
    } else {
      elements[i].disabled = true;
    }
  }
  $(".zero_draw_reason_code").prop("disabled", !el.checked)
  freezeFrozen();
};

function enableReturns() {
  var elements = document.getElementsByClassName("return_inputs");
  var el = document.getElementById("returnsInput");

  for (var i = 0; i < elements.length; i++) {
    if (el.checked) {
      elements[i].disabled = false;
    } else {
      elements[i].disabled = true;
    }
  }
  freezeFrozen();
};

function hiderows(prid) {
  $("." + prid).addClass('hidden');
};

function showrows(prid) {
  $("." + prid).removeClass('hidden');
};

function hideDraws() {
  if ($("#drawtable").is(":visible")) {
    $("#drawtable").hide()
  } else {
    $("#drawtable").show();
  }
};

function getIntegerValue(cell) {
  value = cell.val();
  if (value == '') value = '0';
  return parseInt(value);
}

function disableSubmitButton() {
  var submit_button = $(".submit_button");
  var disabled = $("#returnsTable td .error").length > 0;
  submit_button.prop("disabled", disabled);
}

// Draw/Returns values have been changed
function changed_draw_returns(input) {
  var cell = $(input);

  updateTotals(cell);

  errors = validate_draw_returns(cell);
  show_draw_returns_errors(cell, errors);

  set_update_type(cell);

  disableSubmitButton();
};

// Data validations
function validate_draw_returns(cell) {
  var place_holder = cell.closest('[data-js-single-day]');
  var draw_input = place_holder.find('.draw_inputs');
  var return_input = place_holder.find('.return_inputs');
  var zero_draw_reason = place_holder.find('.zero_draw_reason_code');

  var draw_value = getIntegerValue(draw_input);
  var return_value = getIntegerValue(return_input);
  var default_draw = parseInt(draw_input.prop("defaultValue"));
  var return_changed = (return_input.val() != return_input.prop("defaultValue"));
  var draw_changed = (draw_input.val() != draw_input.prop("defaultValue"));

  var draw_day_returns = parseInt(cell.closest("tr").find("[data-draw_day_returns]").data("draw_day_returns"));
  var returns_day_net_draw = parseInt(cell.closest("tr").find("[data-returns_day_net_draw]").data("returns_day_net_draw"));
  var max_draw = parseInt(cell.closest("tr").find("[data-max_draw]").data("max_draw"));

  var errors = [];

  // Draw value should be a number >= 0
  if (draw_changed && draw_input.val() == "") {
    errors.push({ field: draw_input, message: "Draw can't be blank" });
  } else if (isNaN(draw_value)) {
    errors.push({ field: draw_input, message: "Please enter a number" });
  } else if (draw_value < 0) {
    errors.push({ field: draw_input, message: "Cannot enter a negative number" });
  } else if ((draw_value > max_draw) && (default_draw <= max_draw)) {
  // Draw can't exceed max draw
     errors.push({ field: draw_input, message: "Draw exceeds max allowed draw" });
  } else if (!isNaN(draw_day_returns) && draw_changed && draw_value < draw_day_returns) {
     errors.push({ field: draw_input, message: "Draw value cannot be less than returns value of " + draw_day_returns.toString() });
  }

  // Return value should be a number >= 0
  if (isNaN(return_value)) {
    errors.push({ field: return_input, message: "Please enter a number" });
  } else if (return_value < 0) {
  // Returns can't be less than zero
    errors.push({ field: return_input, message: "Cannot enter a negative number" });
  } else if (isNaN(returns_day_net_draw) && return_value > draw_value) {
  // Returns can't be greater than draw on Weekly page
    errors.push({ field: return_input, message: "Returns cannot be greater than draw" });
  } else if (!isNaN(returns_day_net_draw) && return_changed && return_value > returns_day_net_draw) {
  // Returns cannot exceed the draw value for the same distribution date on RDL page
    errors.push({ field: return_input, message: "Return value cannot exceed draw value of " + returns_day_net_draw.toString() });
  }

  // If there's zero Draw we have to have a reason code
  if (draw_changed && draw_value == 0 && zero_draw_reason.val() == "") {
    errors.push({ field: zero_draw_reason, message: "Select a reason for 0 Draw" });
  }

  // Show/Hide zero draw reason code
  if (draw_value == 0) {
    zero_draw_reason.css('visibility', 'visible');
  } else {
    zero_draw_reason.css('visibility', 'hidden');
  }
  return errors;
}

// Show errors in the error_message block
function show_draw_returns_errors(cell, errors) {
  // Clear the previous error messages
  cell.closest('[data-js-single-day]').find('.error_message').text('').css('visibility', 'hidden');
  cell.closest('[data-js-single-day]').find('*').removeClass('error');

  // Display the error messages
  $.each(errors, function() {
    this.field.addClass('error');
    error_message = this.field.closest('td').find('.error_message');
    error_text = error_message.text();
    if (error_text != this.message && this.message != "") {
      if (error_text != "") error_text = error_text + " ";
      error_text = error_text + this.message + ".";
      error_message.text(error_text).css('visibility', 'visible');
    }
  });
}

// Set update type R/D/B/N depending on which fields were modified
function set_update_type(cell) {
  var place_holder = cell.closest('[data-js-single-day]');
  var draw_input = place_holder.find('.draw_inputs');
  var return_input = place_holder.find('.return_inputs');
  var zero_draw_reason = place_holder.find('.zero_draw_reason_code');
  var update_type = place_holder.find('.update_type');

  var return_changed = (return_input.val() != return_input.prop("defaultValue"));
  var draw_changed = (draw_input.val() != draw_input.prop("defaultValue"));

  // Set modified flag
  if (cell.val() != cell.prop("defaultValue")) {
    cell.closest("tr").find(".modified").val("Y");
  }

  // if Zero Draw Reason Code is changed then mark Draw as changed
  var zero_draw_reason_changed = (zero_draw_reason.val().trim() != zero_draw_reason.data('original-value').trim());
  if (zero_draw_reason_changed) draw_changed = true;

  // Set update type
  if (return_changed && draw_changed) {
    update_type_val = "B";
  } else if ( return_changed ) {
    update_type_val = "R";
  } else if ( draw_changed ) {
    update_type_val = "D";
  } else {
    update_type_val = "N";
  }
  update_type.val(update_type_val);
}

// Calculate and update totals table
function updateTotals(cell) {
  var product, day_of_week, action, value, original_value;
  var local_product, row_to_update, day_array, day_we_want;
  var all_elements_to_target, element_to_update, current_value, new_value;

  var rowel = cell.closest('tr');
  var product_array = rowel.attr('class').split(' ');
  var product = product_array[0];
  var day_of_week = cell.closest('td').attr('class');

  var action = (cell.hasClass('return_inputs')) ? 'returns' : 'draw';
  var value = getIntegerValue(cell);

  // Get the original value from the data attribute if it was defined
  // otherwise from the default value
  if ( typeof cell.data('original-value') !== 'undefined' ) {
    var original_value = parseInt(cell.data('original-value'));
  } else {
    var original_value = parseInt(cell.prop("defaultValue"));
  }

  local_product = $('td.total_data.total_' + product)
  row_to_update = $(local_product).closest('tr')
  day_array = day_of_week.split(' ')
  day_we_want = day_array[0]
  all_elements_to_target = row_to_update.find('.' + day_we_want)
  element_to_update = row_to_update.find('.' + day_we_want + '.' + action)
  current_value = parseInt(element_to_update.text())

  if (isNaN(value)) value = 0;
  if (isNaN(original_value)) original_value = 0;
  if (isNaN(current_value)) current_value = 0;

  new_value = (value - original_value) + current_value

  element_to_update.text(new_value.toString())

// Update total sum
  total_element = $("#draw_returns_totals tr.total_sum_row td.total_sum." + day_we_want + "." + action);
  total_value = parseInt(total_element.text());
  if (isNaN(total_value)) total_value = 0;
  total_element.text(value - original_value + total_value);

// Mark changed draw totals
  total_elements = total_element.closest("tr").find("." + day_we_want);
  if (total_elements[0].innerText == total_elements[1].innerText) {
    total_elements.removeClass("unequal");
  } else {
    total_elements.addClass("unequal");
  }

  parseInt(all_elements_to_target[0].innerText) == parseInt(all_elements_to_target[1].innerText) ? all_elements_to_target.removeClass('unequal') : all_elements_to_target.addClass('unequal')

  // Set new original value. We need it for the next update
  cell.data('original-value', cell.val());
};

// Show validation errors generated by Rails validators
function show_rails_validation_errors(model, errors) {
  // Clear previous errors
  $("td .error_message").css("visibility", "hidden").text("");
  $("td :input").removeClass('error');
  $(".base_error_message").remove();

  // Show validation error messages
  $.each(errors, function(id, fields) {
    $.each(fields, function(field, messages) {
      if (field == "base") { // show the record errors in the Location column of the table
        div = $('<div class="base_error_message"></div>');
        div.text(messages.join(". ") + ".");
        place = $('input[data-row-id="' + id + '"]').closest("tr").find("td.location_data");
        place.append(div);
      } else { // show the field errors
        input = $(':input[name="' + model + '[' + id + '][' + field + ']"]');
        input.addClass('error');
        error_message = input.closest("td").find(".error_message");
        error_text = error_message.text() + " " + messages.join(". ") + ".";
        error_message.text(error_text).css("visibility", "visible");
      }
    });
  });

  // Scroll to the first error or to the flash message
  if ($(".error").length) {
    place = $(".error").first();
  } else {
    place = $(".flash_message");
  }
  $(window).scrollTop(place.offset().top);
}
