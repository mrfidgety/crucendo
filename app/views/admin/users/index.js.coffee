$('#users-container').append('<%= j render @users %>')
<% if @users.next_page %>
$('.pagination').replaceWith('<%= j will_paginate @users %>')
<% else %>
$(window).off('scroll')
$('.pagination').remove()
<% end %>