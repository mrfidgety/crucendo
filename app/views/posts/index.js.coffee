$('#posts-container').append('<%= j render @posts %>')
<% if @posts.next_page %>
$('.pagination').replaceWith('<%= j will_paginate @posts %>')
<% else %>
$(window).off('scroll')
$('.pagination').remove()
<% end %>