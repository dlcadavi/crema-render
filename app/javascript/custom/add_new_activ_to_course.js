import { Controller } from "@hotwired/stimulus"


$(document).ready(function(){
  
  $('#addNewTag').on('click', function(){
    $("#skillSet").append($("#new_skills_form").html());
  });
});
