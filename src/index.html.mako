<%inherit file="_templates/site.mako" />
          <div class="hero-unit">
            <div class="row">
                <div class="span3">
                    <img src="http://www.gravatar.com/avatar/6f807629c5f3765f28c61b1271552dc9?s=180" class="img-rounded" />
                </div>
                <div class="span9">
<%self:filter chain="markdown">

TODO: intro text

</%self:filter>
                </div>
            </div>
          </div>

<%
import locale
locale.setlocale(locale.LC_ALL, 'english')
%>

          <div class="row-fluid">
% for post in bf.config.blog.posts[0:3]:
<% 
   category_links = []
   for category in post.categories:
           category_links.append("<a href='%s'>%s</a>" % (category.path, category.name))
%>
            <div class="span4">
              <h4><a href="${post.path}">${post.title}</a></h4>
              <p>${post.excerpt} ...</p>
              <p><small>${post.date.strftime("%b %d %Y")} | ${", ".join(category_links)}</small></p>
            </div><!--/span-->
% endfor
          </div><!--/row-->
          <div class="row-fluid hidden-phone spacer50"></div>
          <div class="row-fluid">
% for post in bf.config.blog.posts[3:6]:
<% 
   category_links = []
   for category in post.categories:
           category_links.append("<a href='%s'>%s</a>" % (category.path, category.name))
%>
            <div class="span4">
              <h4><a href="${post.path}">${post.title}</a></h4>
              <p>${post.excerpt} ...</p>
              <p><small>${post.date.strftime("%b %d %Y")} | ${", ".join(category_links)}</small></p>
            </div><!--/span-->
% endfor
          </div><!--/row-->