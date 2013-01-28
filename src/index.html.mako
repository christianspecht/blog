<%inherit file="_templates/site.mako" />
          <div class="hero-unit">
            <div class="row">
                <div class="span3">
                    <img src="http://www.gravatar.com/avatar/6f807629c5f3765f28c61b1271552dc9?s=140" class="img-rounded" />
                </div>
                <div class="span9">
<%self:filter chain="markdown">

My name is Christian Specht, and this is my personal site.  
I'm a software developer from Kerpen, Germany (near Cologne) with about 10 years experience. Check out my open source projects!

</%self:filter>
                </div>
            </div>
          </div>

          <h3>Recent Posts:</h3>
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
            <div class="row-fluid visible-phone spacer25"></div>
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
            <div class="row-fluid visible-phone spacer25"></div>
% endfor
          </div><!--/row-->