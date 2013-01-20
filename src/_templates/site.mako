<%inherit file="base.mako" />
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>${bf.config.blog.name}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="${bf.config.blog.description}">
%if bf.config.site.author:
    <meta name="author" content="${bf.config.site.author}">
%endif
    <link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed')}" />
    <link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed/atom')}" />

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
          <a class="brand" href="${bf.util.site_path_helper()}">${bf.config.blog.name}</a>
          <div class="nav-collapse collapse">
            <ul class="nav">
              <li><a href="${bf.util.site_path_helper()}">Home</a></li>
              <li><a href="${bf.util.site_path_helper(bf.config.blog.path,'archive')}">Archive</a></li>
              <li><a href="#">Projects</a></li>
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
              <li><a href="https://www.ohloh.net/accounts/131837?ref=Detailed" rel="toolip" title="Ohloh profile for Christian Specht"><img alt="Ohloh profile for Christian Specht" title="Ohloh profile for Christian Specht" height="35" src="https://www.ohloh.net/accounts/131837/widgets/account_detailed.gif" width="191" /></a></li>
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
