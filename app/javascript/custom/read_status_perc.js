import { Controller } from "@hotwired/stimulus"

$('#my_button').on('click', function(){
    var porc = $('#porcentaje').val();
    var resultado = $('#resultado');
    resultado.val(porc);
});
