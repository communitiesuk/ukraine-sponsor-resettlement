(function() {

    var selfAssesmentContinueButton = document.getElementById('selfAssessmentContinueButton');
    var cookiesRejectButton = document.getElementById('abstract-cookies-accept-cookies-accepted-no-field');

      if(selfAssesmentContinueButton) {
          selfAssesmentContinueButton.addEventListener('click', function() {
              var elements = document.getElementsByName('assessment-buttons');
              var formGroup = document.querySelector('.govuk-form-group');
              var errorMessage = document.querySelector('.govuk-error-message');
              var errorSummaryBox = document.querySelector('.govuk-error-summary');
              var selectedOption;
  
              if(!formGroup) {
                  return false
              }
          
              for (var i=0, len=elements.length; i<len; ++i) {
                  if (elements[i].checked){
                      selectedOption = elements[i].dataset.next;
                      break;
                  }
              }
              if(selectedOption) {
                  window.location.href = selectedOption;
                  formGroup.classList.remove('govuk-form-group--error')
                  errorMessage.style.display = 'none';
                  errorSummaryBox.style.display = 'none'

              
              } else {
                  formGroup.classList.add('govuk-form-group--error')
                  errorMessage.style.display = 'block';
                  errorSummaryBox.style.display = 'block'
              }
            
            })
      }

      if(cookiesRejectButton) {
        cookiesRejectButton.checked = true
      }
  
  } )()