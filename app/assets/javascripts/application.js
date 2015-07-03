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
  $(".cheer-button").click(function() {
    $(this).addClass("btn-success");
    ids.push(this.id);
    updateCommand();
    updateButtons();
  });

  $('#slackCommandModal').on('hidden.bs.modal', function (e) {
    clearCheers();
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

function updateButtons() {
  if (ids.length === 3) {
    $('button[type=submit]').prop('disabled', true);
    $(".clear-cheers").css("display", "block");
    $('#slackCommandModal').modal('show')
  } else {
    $('button[type=submit]').prop('disabled', false);
  }
}

function clearCheers() {
  ids = [];
  updateCommand();
  updateButtons();
  $(".clear-cheers").css("display", "none");
  $('button[type=submit]').removeClass("btn-success");
}

