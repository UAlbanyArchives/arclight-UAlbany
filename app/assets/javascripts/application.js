// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//

//= require tether
// Required by Blacklight
//= require jquery
//= require blacklight/blacklight
//= require bootstrap/scrollspy

//= require bootstrap/tab
//= require headerAffix
//= require displayHyraxDaos

//= require_tree .


// For blacklight_range_limit built-in JS, if you don't want it you don't need
// this:
//= require 'blacklight_range_limit'

$(document).ready(function () {
    $('#al-date-range-histogram-content').on('hide.bs.collapse', function () {
	  $('#date-range-icon').children('i').removeClass("fa-arrow-up").addClass("fa-arrow-down")
	})
	$('#al-date-range-histogram-content').on('show.bs.collapse', function () {
	  $('#date-range-icon').children('i').removeClass("fa-arrow-down").addClass("fa-arrow-up")
	})
});
