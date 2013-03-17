<%inherit file="_templates/site.mako" />
          <div class="hero-unit">
            <div class="media">
                <div class="pull-left">
                    <img src="http://www.gravatar.com/avatar/6f807629c5f3765f28c61b1271552dc9?s=140" class="img-rounded media-object" />
                </div>
                <div class="media-body">
<% import datetime %>
<%self:filter chain="markdown">

My name is Christian Specht, and this is my personal site.  
I'm a software developer from Kerpen, Germany (near Cologne) and I've been doing this for about ${datetime.datetime.now().year - 2003} years now. Check out [my projects](${bf.util.site_path_helper(bf.config.blog.path,'projects')})!

</%self:filter>
                </div>
            </div>
          </div>

          <h3>Recent Posts:</h3>

          <div class="row">
% for post in bf.config.blog.posts[0:3]:
<% 
   category_links = []
   for category in post.categories:
           category_links.append("<a href='%s'>%s</a>" % (category.path, category.name))
%>
            <div class="span3">
              <h4><a href="${post.path}">${post.title}</a></h4>
              <p>${post.excerpt} ...</p>
              <p><small>${post.date.strftime("%b %d %Y")} | ${", ".join(category_links)}</small></p>
            </div><!--/span-->
            <div class="row visible-phone spacer25"></div>
% endfor
          </div><!--/row-->
          <div class="row hidden-phone spacer50"></div>
          <div class="row">
% for post in bf.config.blog.posts[3:6]:
<% 
   category_links = []
   for category in post.categories:
           category_links.append("<a href='%s'>%s</a>" % (category.path, category.name))
%>
            <div class="span3">
              <h4><a href="${post.path}">${post.title}</a></h4>
              <p>${post.excerpt} ...</p>
              <p><small>${post.date.strftime("%b %d %Y")} | ${", ".join(category_links)}</small></p>
            </div><!--/span-->
            <div class="row visible-phone spacer25"></div>
% endfor
          </div><!--/row-->