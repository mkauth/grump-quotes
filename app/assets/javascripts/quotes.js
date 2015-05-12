$(document).ready(function(){
	$('#show_dropdown').change(function(){
		$('#game_dropdown').empty();
		$('#game_dropdown').append($('<option></option>').attr("value", null).text("Select a game"));
		$('#part_dropdown').empty();
		$('#part_dropdown').append($('<option></option>').attr("value", null).text("Select part"));
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
		$('#part_dropdown').append($('<option></option>').attr("value", null).text("Select part"));
		var game_name = $('#game_dropdown').val();
		if(game_name != null){
			$.get('/quotes/new/parts',{game_name: game_name}, function(data){
				data.forEach(function(episode){
					$('#part_dropdown').append($('<option></option>').attr("value", episode["part"]).text(episode["part"]));
				});
			});
		}
	});
});