// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


var ready = function (){
	$('#show_dropdown').change(function(){
		$('#game_dropdown').empty();
		$('#game_dropdown').append($('<option></option>').attr("value", "").text("Select a game"));
		$('#part_dropdown').empty();
		$('#part_dropdown').append($('<option></option>').attr("value", "").text("Select part"));
		var show_name = $('#show_dropdown').val();
		if(show_name != null){
			$.get('/quotes/new/games',{show_name: show_name}, function(data){
				data.forEach(function(episode){
					$('#game_dropdown').append($('<option></option>').attr("value", episode["game"]).text(episode["game"]));
				});
			});
		}
	});
	$('#game_dropdown').change(function(){
		$('#part_dropdown').empty();
		$('#part_dropdown').append($('<option></option>').attr("value", "").text("Select part"));
		var game_name = $('#game_dropdown').val();
		if(game_name != null){
			$.get('/quotes/new/parts',{game_name: game_name}, function(data){
				data.forEach(function(episode){
					if(episode["part"] != null){
						$('#part_dropdown').append($('<option></option>').attr("value", episode["part"]).text(episode["part"]));
					}
				});
			});
		}
	});
	$("#new_quote").submit(function(){
		if($("#show_dropdown").val() == ""){
			alert("Select a show");
			return false;
		}
		if($("#game_dropdown").val() == ""){
			alert("Select a game");
			return false;
		}
		if($("#part_dropdown option").size() > 1 && $("#part_dropdown").val() == ""){
			alert("Select a part");
			return false;
		}
		if($("#quote_content").val() == ""){
			alert("Enter a quote");
			return false;
		}
		if($("#quote_time").val() == ""){
			alert("Enter a time");
			return false;
		}
		var patt = /^(\d+h\d+m\d+s|\d+m\d+s|\d+s)$/
		if(!patt.test($("#quote_time").val())){
			alert("Enter time in the form XhXmXs");
			return false;
		}
	});
};
$(document).ready(ready);
$(document).on('page:load', ready);


