<%inherit file="_templates/site.mako" />
<article class="page_box">
<%self:filter chain="markdown">

TODO: intro text

</%self:filter>

</article>

<ul>
% for post in bf.config.blog.posts[:6]:
  <li>
	<h2><a href="${post.path}">${post.title}</a></h2>
	<p>${post.excerpt} ...</p>
	<p>${post.date} | ${post.categories}</p>
  </li>
% endfor
</ul>
