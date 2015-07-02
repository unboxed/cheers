// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var ids = [];

$(document).ready(function() {
  $('input[type="checkbox"]').click(function() {
    if($(this).is(":checked")) {
        if ($.inArray(this.id, ids) === -1) {
          ids.push(this.id);
        }
    }
    else if($(this).is(":not(:checked)")) {
        var loc = $.inArray(this.id, ids);
        ids.splice(loc, 1);
    }
    updateCheckboxes();
    updateCommand();
  });

  $('#commandBox').click(function() {
    this.setSelectionRange(0, this.value.length);
  });
});

function updateCommand() {
  var command = "/cheer ";
  for (var i in ids) {
    command = command + "#" + ids[i] + " ";
  }
  $('#commandBox').val(command);
}

function updateCheckboxes() {
  if (ids.length === 3) {
    $('input[type=checkbox]').not(':checked').attr("disabled", true);
  } else {
    $('input[type=checkbox]').not(':checked').attr("disabled", false);
  }
}

