function hideLoadingGFX(targetElement) {
  $(targetElement).unblock();
}

function showLoadingGFX(targetElement) {
  $(targetElement).block({
    blockMsgClass: 'spinner-overlay',
    css: {
      backgroundColor: '#000',
      border: '0px',
      borderRadius: '50%',
    	boxShadow: '0 0 120px 25px #FFF',
      height: '50px',
      opacity: 0.75,
      width: '50px'
    },
    message: ' '
  });
}

function processForm() {
  // debugger;
  var input_text = $(document).find('#markov_chainer_input_text').val();
  var order = $(document).find('#markov_chainer_order').val();
  var n_paragraphs = $(document).find('#markov_chainer_n_paragraphs').val();
  var n_sentences = $(document).find('#markov_chainer_n_sentences').val();

  var data = JSON.stringify({
    input_text: input_text,
    order: order,
    n_sentences: n_sentences,
    n_paragraphs: n_paragraphs
  });

  return data;
}

function submitForm(event) {
  event.preventDefault();

  showLoadingGFX('.form');

  var action = $(this).attr('action');
  var method = $(this).attr('method');
  var processedForm = processForm();

  $.when(
    $.ajax({
      type: method,
      url: action,
      data: processedForm,
      contentType: 'application/json',
      dataType: 'json'
    }).done(function(data) {
      $('.markified-text').html("<p>" + data + "</p>");
    }).fail(function(error) {
      console.log(error);
    })
  ).then(function() {
    hideLoadingGFX('.form');
    $(':submit').attr('disabled', false);
  });
}

$(document).ready(function() {
  $('#new_markov_chainer').bind('submit', submitForm);
});
