// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  $("#volunteers_search input").keyup(function() {
    $.get($("#volunteers_search").attr("action"), $("#volunteers_search").serialize(), null, "script");
    return false;
  });

  $("#active_volunteers_search input").keyup(function() {
    $("#active_avail_search").val($("#avail_search").val())
    act = $("#active_volunteers_search").serialize()

    $.get($("#active_volunteers_search").attr("action"), act, null, "script");
    return false;
  });

  $("#avail_volunteers_search input").keyup(function() {
    $("#avail_active_search").val($("#active_search").val())
    av = $("#avail_volunteers_search").serialize()

    $.get($("#avail_volunteers_search").attr("action"), av, null, "script");
    return false;
  });
});
