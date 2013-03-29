<%inherit file="_templates/site.mako" />
          <div class="hero-unit">
<%self:filter chain="markdown">

My name is Christian Specht, and this is my personal site.  
I'm a software developer and I use this site to feature [my projects](${bf.util.site_path_helper(bf.config.blog.path,'projects')}) and (occasionally) [some blogging](${bf.util.site_path_helper(bf.config.blog.path,'archive')}).

</%self:filter>
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