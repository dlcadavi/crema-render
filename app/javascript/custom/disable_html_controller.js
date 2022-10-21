import { Controller } from "@hotwired/stimulus"


$(document).ready(function(){
   $('input[id="deshabTipol"]').prop("disabled", false);
   $("select[id=tipologia]").change(function(){
        if($(this).val() =='S')
          {
            // pointer y background son como para dar la idea de readonly (que el usuario las vea pero no las pueda modificar)
            // readonly no funciona en los select pero sí en los inputs. Por es no se puedo usar (por los select)
            // Disable no está bien porque rails no es capaz de leer lo que haya en un campo disable, tiene sentido.
            $('input[id="deshabTipol"]').val('');
            $('select[id="deshabTipol"]').val('1T');
            $('input[id="deshabTipol"]').prop("readonly", true);
            $('select[id="deshabTipol"]').prop("readonly", true);
            $('select[id="deshabTipol"]').css("pointer-events","initial");
            $('select[id="deshabTipol"]').css("background-color","white");
          }
        else
          {
            $('input[id="deshabTipol"]').css("pointer-events","none");
            $('input[id="deshabTipol"]').css("background-color","#E8E8E8");
            $('select[id="deshabTipol"]').css("pointer-events","none");
            $('select[id="deshabTipol"]').css("background-color","#E8E8E8");
            $('input[id="deshabTipol"]').val('NA');
            $('select[id="deshabTipol"]').val('FC');
          }
    });
});
