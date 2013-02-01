<%inherit file="bf_base_template" />
<%def name="title()">Archive</%def> 
<h1>${self.title()}</h1>
<p>&nbsp;</p>
% for posts in month_posts:
<h3>${posts[0].date.strftime("%B %Y")}</h3>
<ul>
  % for post in posts:
  <li><a href="${post.permapath()}">${post.title}</a></li>
  % endfor
</ul>
% endfor
