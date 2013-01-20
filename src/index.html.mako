<%inherit file="_templates/site.mako" />
          <div class="hero-unit">
<%self:filter chain="markdown">

TODO: intro text

</%self:filter>

          </div>

<%
import locale
locale.setlocale(locale.LC_ALL, 'english')
%>

          <div class="row-fluid">
% for post in bf.config.blog.posts[0:3]:
            <div class="span4">
              <h4><a href="${post.path}">${post.title}</a></h4>
              <p>${post.excerpt} ...</p>
              <p>${post.date.strftime("%b %d %Y")} | ${post.categories}</p>
            </div><!--/span-->
% endfor
          </div><!--/row-->
          <div class="row-fluid">
% for post in bf.config.blog.posts[3:6]:
            <div class="span4">
              <h4><a href="${post.path}">${post.title}</a></h4>
              <p>${post.excerpt} ...</p>
              <p>${post.date.strftime("%b %d %Y")} | ${post.categories}</p>
            </div><!--/span-->
% endfor
          </div><!--/row-->