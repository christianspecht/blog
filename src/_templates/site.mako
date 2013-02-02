<%inherit file="base.mako" />
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
%if hasattr(next, 'title'):
    <title>${next.title()} - ${bf.config.blog.name}</title>
%else:
    <title>${bf.config.blog.name}</title>
%endif
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="${bf.config.blog.description}">
%if bf.config.site.author:
    <meta name="author" content="${bf.config.site.author}">
%endif
    <link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="http://feeds.feedburner.com/ChristianSpecht" />
    <link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="http://feeds.feedburner.com/ChristianSpecht" />

    <!-- Le styles -->
    <link href="${bf.util.site_path_helper('css/bootstrap.min.css')}" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
      .sidebar-nav {
        padding: 9px 0;
      }
      .spacer25 {
        height: 25px; width: 100%; font-size: 0; margin: 0; padding: 0; border: 0; display: block;
      }
      .spacer50 {
        height: 50px; width: 100%; font-size: 0; margin: 0; padding: 0; border: 0; display: block;
      }
    </style>
    <link href="${bf.util.site_path_helper('css/bootstrap-responsive.min.css')}" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="http://www.gravatar.com/avatar/6f807629c5f3765f28c61b1271552dc9?s=144">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="http://www.gravatar.com/avatar/6f807629c5f3765f28c61b1271552dc9?s=114">
      <link rel="apple-touch-icon-precomposed" sizes="72x72" href="http://www.gravatar.com/avatar/6f807629c5f3765f28c61b1271552dc9?s=72">
                    <link rel="apple-touch-icon-precomposed" href="http://www.gravatar.com/avatar/6f807629c5f3765f28c61b1271552dc9?s=57">
                                   <link rel="shortcut icon" href="http://www.gravatar.com/avatar/6f807629c5f3765f28c61b1271552dc9?s=32">
  </head>

  <body>

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="${bf.util.site_path_helper()}">${bf.config.blog.name}</a>
          <div class="nav-collapse collapse">
            <ul class="nav">
              <li><a href="${bf.util.site_path_helper()}"><i class="icon-home icon-white"></i> Home</a></li>
              <li><a href="${bf.util.site_path_helper(bf.config.blog.path,'archive')}"><i class="icon-calendar icon-white"></i> Archive</a></li>
              <!--<li><a href="#"><i class="icon-wrench icon-white"></i> Projects</a></li>-->
              <li><a href="http://feeds.feedburner.com/ChristianSpecht"><img src="${bf.util.site_path_helper('img/feed.png')}"> RSS Feed</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container-fluid">
      <div class="row-fluid">
        <div class="span9">
          ${next.body()}
        </div><!--/span-->
        <div class="span3">
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Projects</li>
              <li><a href="${bf.util.site_path_helper('bitbucket-backup')}" rel="tooltip" title="A backup tool which clones all your Bitbucket repositories to your local machine">Bitbucket Backup</a></li>
              <li><a href="${bf.util.site_path_helper('missilesharp')}" rel="tooltip" title=".NET library to control an USB Missile Launcher">MissileSharp</a></li>
              <li><a href="${bf.util.site_path_helper('recordset-net')}" rel="tooltip" title="Converts .NET POCOs to ADODB.Recordsets">Recordset.Net</a></li>
              <li><a href="${bf.util.site_path_helper('roboshell-backup')}" rel="tooltip" title="A simple personal backup tool, using RoboCopy and written in Windows Powershell">RoboShell Backup</a></li>
              <li><a href="${bf.util.site_path_helper('vba-helpers')}" rel="tooltip" title="A collection of useful VBA functions">VBA Helpers</a></li>
            </ul>
          </div><!--/.well -->
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Links</li>
              <li><a href="http://stackoverflow.com/users/6884/" rel="tooltip" title="profile for Christian Specht at Stack Overflow, Q&A for professional and enthusiast programmers"><img src="http://stackoverflow.com/users/flair/6884.png" width="208" height="58" alt="profile for Christian Specht at Stack Overflow, Q&A for professional and enthusiast programmers" title="profile for Christian Specht at Stack Overflow, Q&A for professional and enthusiast programmers"/></a></li>
              <li><a href="https://bitbucket.org/christianspecht" rel="tooltip" title="my Bitbucket profile"><img src="${bf.util.site_path_helper('img/bitbucket.png')}" alt="my Bitbucket profile" title="my Bitbucket profile"/></a></li>
              <li><a href="https://www.ohloh.net/accounts/131837?ref=Detailed" rel="tooltip" title="Ohloh profile for Christian Specht"><img alt="Ohloh profile for Christian Specht" title="Ohloh profile for Christian Specht" height="35" src="https://www.ohloh.net/accounts/131837/widgets/account_detailed.gif" width="191" /></a></li>
            </ul>
          </div><!--/.well -->
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Recent Posts</li>
              % for post in bf.config.blog.iter_posts_published(5):
              <li><a href="${post.path}">${post.title}</a></li>
              % endfor
            </ul>
          </div><!--/.well -->
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Archives</li>
                % for link, name, num_posts in bf.config.blog.archive_links:
                <%
                    if name.startswith('Januar'):
                        month=name.replace('Januar','January')
                    elif name.startswith('Februar'):
                        month=name.replace('Februar','February')
                    # omit March because the German name makes Blogofile/Mako crash, because it contains an umlaut
                    # (there will never be posts in March anyway, because they make Blogofile/Mako crash, too)
                    elif name.startswith('Mai'):
                        month=name.replace('Mai','May')
                    elif name.startswith('Juni'):
                        month=name.replace('Juni','June')
                    elif name.startswith('Juli'):
                        month=name.replace('Juli','July')
                    elif name.startswith('Oktober'):
                        month=name.replace('Oktober','October')
                    elif name.startswith('Dezember'):
                        month=name.replace('Dezember','December')
                    else:
                        month=name
                %>
                <li><a href="${bf.util.site_path_helper(bf.config.blog.path,link)}/1">${month}&nbsp;(${num_posts})</a></li>
                % endfor
            </ul>
          </div><!--/.well -->
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Categories</li>
                % for category, num_posts in bf.config.blog.all_categories:
                <li><a href="${category.path}">${category}&nbsp;(${num_posts})</a></li>
                % endfor
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
      </div><!--/row-->

      <hr>

      <footer>
        <div class="row">
            <div class="span8">
                <p>
                    <% import datetime %>
                    Copyright 2012-${datetime.datetime.now().year}
                    ${bf.config.site.author}
                    <br/>
                    <a href="${bf.util.site_path_helper(bf.config.blog.path,'imprint')}">Imprint / Impressum und Datenschutzhinweis</a>
                </p>
            </div>
            <div class="span4">
                <p>
                    Powered by <a href="http://www.blogofile.com">Blogofile</a>. Built with <a href="http://twitter.github.com/bootstrap/">Bootstrap</a>.<br/>
                    <a href="http://bootswatch.com/cosmo/">Cosmo</a> theme by <a href="http://bootswatch.com">bootswatch.com</a>.
                </p>
            </div>
        </div>
      </footer>

    </div><!--/.fluid-container-->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="${bf.util.site_path_helper('js/jquery.js')}"></script>
    <script src="${bf.util.site_path_helper('js/bootstrap.min.js')}"></script>
    <script type="text/javascript">

      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-28992440-1']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();

    </script>
  </body>
</html>
