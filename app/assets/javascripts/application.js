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
//= require foundation
//= require Chart.min
//= require cocoon
//= require_tree .




$( document ).ready(function() {
	
	// show_user_bar();
	if ($('.responsive').length > 0){
		table_responsive();	
	}
	
	// Filter by User
	$('select#users').on('change', function() {
	  if (this.value != ''){
	  	window.location.href = "/quotations?user=" + this.value;
	  }else{
	  	window.location.href = "/quotations?user=all";
	  }

	});

	if ($('#total').length > 0){
		calculate_total();	
	}
	window.setInterval(function(){
		if ($('#total').length > 0){
			calculate_total();	
		}
	}, 500);

	$(document).delegate('.q-item-select', 'change', function(event) {
		event.stopPropagation();
		id = this.value;
		parent = $(this).parent();
		get_exam_values(id, parent);
	});
  
	
});

//Get values of exams
function show_user_bar(){
	$('#user-info').css('left', $('#main_content').offset().left - $('#user-info').width() - 10)
  $('#user-info').css('top', $('#main_content').offset().top)
}

function get_exam_values(id, parent){
	if (id != ''){
		url = "/exams/"+ id + "/get_values"
		$.ajax({
		  method: "GET",
		  url: url
		})
	  .done(function( msg ) {
	  	msg = JSON.parse(msg)
	  	parent.find('.city').val(msg[0]);
			parent.find('.province').val(msg[1]);
			parent.find('.mobile').val(msg[2]);
	  });
	}	
	else{
		parent.find('.city').val(0);
		parent.find('.province').val(0);
		parent.find('.mobile').val(0);
	}
}

function calculate_total(){

	// City Value
	city = 0;
	$(".city").each(function( index ) {
		parent = $( this ).parents(".q-item");
		if (parent.is(":visible")){
			city = city + parseFloat($( this ).val());
		}
	});
	$('#quotation_city_total').val(city.toFixed(2))


	// Province Value
	province = 0;
	$(".province").each(function( index ) {
		parent = $( this ).parents(".q-item");
		if (parent.is(":visible")){
			province = province + parseFloat($( this ).val());	
		}
	});
	$('#quotation_province_total').val(province.toFixed(2));


	// Mobile Value
	mobile = 0;
	$(".mobile").each(function( index ) {
		parent = $( this ).parents(".q-item");
		if (parent.is(":visible")){
			mobile = mobile + parseFloat($( this ).val());
		}
	});
	$('#quotation_m_units_total').val(mobile.toFixed(2));

	// Total Users
	total_users = 0;
	total_users = $('#quotation_total_users').val();


	quotation_city_total = 0;
	quotation_province_total = 0;
	quotation_m_units_total = 0;

	quotation_city_total = parseFloat($('#quotation_city_total').val());
	if ($('#quotation_provinces').is(':checked')){
		quotation_province_total = parseFloat($('#quotation_province_total').val());	
	}
	if ($('#quotation_mobile_units').is(':checked')){
		quotation_m_units_total = parseFloat($('#quotation_m_units_total').val());
	}	

	total = (quotation_city_total + quotation_province_total + quotation_m_units_total) * total_users;

	$('#total').val(total.toFixed(2));
}
// $(window).scroll(function (){ 
// 	$('#user-info').css('left', $('#main_content').offset().left - $('#user-info').width() - 10)
// 	if ($('#main_content').offset().top > $(window).scrollTop()){
// 		$('#user-info').css('top', $('#main_content').offset().top - $(window).scrollTop())
// 	}
// 	else{
// 		$('#user-info').css('top', 5)
// 	}
// });

// $( window ).resize(function() {
// 	left = $('#main_content').offset().left - $('#user-info').width() - 10
// 	if (left > 8){
// 		$('#user-info').show()
// 		$('#user-info').css('left', left)	
// 	}
// 	else{
// 		$('#user-info').hide()	
// 	}
	

// });

function table_responsive(){
	var headertext = [],
	headers = document.querySelectorAll(".responsive th"),
	tablerows = document.querySelectorAll(".responsive th"),
	tablebody = document.querySelector('.responsive tbody');
	console.log();

	for(var i = 0; i < headers.length; i++) {
	  var current = headers[i];
	  headertext.push(current.textContent.replace(/\r?\n|\r/,""));
	} 
	for (var i = 0, row; row = tablebody.rows[i]; i++) {
	  for (var j = 0, col; col = row.cells[j]; j++) {
	    col.setAttribute("data-th", headertext[j]);
	  } 
	}
}

$(document).delegate('#change_yes', 'click', function(event) {
	$('#authorization_num').removeAttr("disabled")
	$('#exam_city_value').removeAttr("disabled")
	$('#exam_province_value').removeAttr("disabled")
	$('#exam_m_units_value').removeAttr("disabled")

});

$(document).delegate('#change_no', 'click', function(event) {
	$('#authorization_num').attr("disabled", "disabled")
	$('#exam_city_value').attr("disabled", "disabled")
	$('#exam_province_value').attr("disabled", "disabled")
	$('#exam_m_units_value').attr("disabled", "disabled")
	
});




$(function(){ $(document).foundation(); });





