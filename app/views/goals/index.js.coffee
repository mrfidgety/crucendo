$('#active-goals').append('<%= j render @goals %>')
<% if @goals.next_page %>
$('.pagination').replaceWith('<%= j will_paginate @goals %>')
<% else %>
$(window).off('scroll')
$('.pagination').remove()
<% end %>