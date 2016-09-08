function processForm() {
  // debugger;
  var input_text = $(document).find('#markov_chainer_input_text').val();
  var order = $(document).find('#markov_chainer_order').val();
  var n_sentences = $(document).find('#markov_chainer_n_sentences').val();

  var data = JSON.stringify({
    input_text: input_text,
    order: order,
    n_sentences: n_sentences
  });

  return data;
};

function submitForm(event) {
  event.preventDefault();

  var action = $(this).attr('action');
  var method = $(this).attr('method');

  var processedForm = processForm();

  console.log(processedForm)

  $.ajax({
    type: method,
    url: action,
    data: processedForm,
    contentType: 'application/json',
    dataType: 'json'
  }).done(function(data) {
    console.log(data);
    $('.markified-text').html("<p>" + data + "</p>");
    enableSubmit()
  }).fail(function(error) {
    console.log(error)
    enableSubmit()
  });

  function enableSubmit() {
    $(':submit').attr('disabled', false)
  };
};

$(document).ready(function() {
  $('#new_markov_chainer').bind('submit', submitForm);
});
