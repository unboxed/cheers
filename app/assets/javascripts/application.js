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
//= require_tree .

var ids = [];

$(document).ready(function() {
  $(".cheer-button").click(function() {
    $(this).addClass("btn-success");
    $(this).removeClass("btn-default");
    ids.push(this.id);
    $('#b' + this.id).text(countOccurrences(this.id).toString());
    updateCommand();
    updateButtons();
  });

  $(".clear-cheers").click(function() {
    clearCheers();
  });

  $('#commandBox').click(function() {
    this.setSelectionRange(0, this.value.length);
  });
});

function updateCommand() {
  var command = "/vote ";
  for (var i in ids) {
    command = command + "#" + ids[i] + " ";
  }
  command = command.trim();
  $('#commandBox').val(command);
  $('#mobileCommandBox').text(command);
}

function updateButtons() {
  if (ids.length === 3) {
    $('button.btn-default[type=submit]').animate({opacity:0})
                                        .prop('disabled', true);
    $('button.btn-success[type=submit]').prop('disabled', true);
    $('#slackCommandModal').modal('show')
    $("#hand").fadeIn();
    $("#slack-help-text").fadeIn();
    $('#commandBox').focus().select();
  } else {
    $('button[type=button]').prop('disabled', false);
  }
}

function countOccurrences(num) {
  var occurences = 0;
  for(var i = 0; i < ids.length; i++) {
    if(ids[i] === num) {
      occurences++;
    }
  }
  return occurences;
}

function clearCheers() {
  ids = [];
  updateCommand();
  updateButtons();
  $('button.btn-success[type=submit]').addClass("btn-default");
  $('button[type=submit]').removeClass("btn-success")
                          .animate({opacity:1})
                          .prop('disabled', false);
  $('button[type=button]').prop('disabled', true);
  $('#commandBox').val("");
  $("#hand").fadeOut();
  $("#slack-help-text").fadeOut();
  $(".cheer-button-counter").text("");
}
