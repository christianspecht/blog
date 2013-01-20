<%inherit file="base.mako" />
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Bootstrap, from Twitter</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

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
          <a class="brand" href="#">Project name</a>
          <div class="nav-collapse collapse">
            <p class="navbar-text pull-right">
              Logged in as <a href="#" class="navbar-link">Username</a>
            </p>
            <ul class="nav">
              <li class="active"><a href="#">Home</a></li>
              <li><a href="#about">About</a></li>
              <li><a href="#contact">Contact</a></li>
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
              <li><a href="#" rel="tooltip" title="first tooltip">Link</a></li>
              <li><a href="#" rel="tooltip" title="second tooltip">Link</a></li>
              <li><a href="#" rel="tooltip" title="third tooltip">Link</a></li>
            </ul>
          </div><!--/.well -->
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Links</li>
              <li><a href="#">Link</a></li>
              <li><a href="#">Link</a></li>
              <li><a href="#">Link</a></li>
            </ul>
          </div><!--/.well -->
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Recent Posts</li>
              <li><a href="#">Link</a></li>
              <li><a href="#">Link</a></li>
              <li><a href="#">Link</a></li>
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
                </p>
                <p>
                    <a href="${bf.util.site_path_helper(bf.config.blog.path,'imprint')}">Imprint / Impressum und Datenschutzhinweis</a>
                </p>
            </div>
            <div class="span4">
                <p>
                    Powered by <a href="http://www.blogofile.com">Blogofile</a>
                </p>
                <p>
                    <a href="${bf.util.site_path_helper(bf.config.blog.path,'feed','index.xml')}">RSS</a>
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

  </body>
</html>
