<aside>
  <section>
	<h1 class="post_header_gradient theme_font">Projects</h1>
	<ul>
		<li><a href="${bf.util.site_path_helper(bf.config.blog.path,'bitbucket-backup')}">Bitbucket Backup</a></li>
		<li><a href="${bf.util.site_path_helper(bf.config.blog.path,'missilesharp')}">MissileSharp</a></li>
		<li><a href="${bf.util.site_path_helper(bf.config.blog.path,'recordset-net')}">Recordset.Net</a></li>
		<li><a href="${bf.util.site_path_helper(bf.config.blog.path,'roboshell-backup')}">RoboShell Backup</a></li>
		<li><a href="${bf.util.site_path_helper(bf.config.blog.path,'vba-helpers')}">VBA Helpers</a></li>
	</ul>
  </section>
  <section>
	<h1 class="post_header_gradient theme_font">Links</h1>
	<ul>
		<li>
			<a href="http://stackoverflow.com/users/6884/">
				<img src="http://stackoverflow.com/users/flair/6884.png" width="208" height="58" alt="profile for Christian Specht at Stack Overflow, Q&A for professional and enthusiast programmers" title="profile for Christian Specht at Stack Overflow, Q&A for professional and enthusiast programmers"/>
			</a>
		</li>
		<li>
			<a href="https://bitbucket.org/christianspecht">
				<img src="${bf.util.site_path_helper(bf.config.blog.path,'img/bitbucket.png')}" alt="my Bitbucket page" title="my Bitbucket page"/>
			</a>
		</li>
		<li>
			<a href="https://www.ohloh.net/accounts/131837?ref=Detailed">
				<img alt="Ohloh profile for Christian Specht" title="Ohloh profile for Christian Specht" height="35" src="https://www.ohloh.net/accounts/131837/widgets/account_detailed.gif" width="191" />
			</a>
		</li>
	</ul>
  </section>
  <section>
    <h1 class="post_header_gradient theme_font">Latest Posts</h1>
    <ul>
      % for post in bf.config.blog.iter_posts_published(5):
      <li><a href="${post.path}">${post.title}</a></li>
      % endfor
    </ul>
  </section>
  <section>
    <h1 class="post_header_gradient theme_font">From Twitter "example"</h1>
    <div id="on_twitter">
      <div id="tweets"></div>
      <a href="http://search.twitter.com/search?q=example" style="float: right">See more tweets</a>
    </div>
  </section>
</aside>
