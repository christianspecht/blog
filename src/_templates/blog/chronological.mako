<%inherit file="bf_base_template" />
% for post in posts:
  <%include file="post.mako" args="post=post" />
% if bf.config.blog.disqus.enabled:
  <div class="after_post"><a href="${post.permalink}#disqus_thread">Read and Post Comments</a></div>
% endif
  <hr class="interblog" />
% endfor
% if prev_link or next_link:
  <ul class="pager">
% endif
% if prev_link:
    <li><a href="${prev_link}">&larr; Older</a></li>
% endif
% if next_link:
    <li><a href="${next_link}">Newer &rarr;</a></li>
% endif
% if prev_link or next_link:
  </ul>
% endif



