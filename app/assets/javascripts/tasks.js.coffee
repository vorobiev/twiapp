# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$('#show_all').live 'click' , (event) ->
    window.location.href = $('form').attr('action')
    
$('#csv_export').live 'click' , (event) ->
    url = $('form').attr('action')
    url += '.xls'
    $('form').attr('action',url)
    $('form').submit()
    
