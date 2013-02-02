<%inherit file="_templates/site.mako" />
<%def name="title()">Projects</%def>

<h1>${self.title()}</h1>

<div class="row-fluid spacer25"></div>
<p><%self:filter chain="markdown">
TODO: intro text
</%self:filter></p>
<div class="row-fluid spacer25"></div>

<div class="container-fluid">
    <div class="row-fluid">
    
        <div class="span6">
          <h2><img src="https://bitbucket.org/christianspecht/roboshell-backup/raw/tip/img/head35x35.png" /> <a href="${bf.util.site_path_helper('roboshell-backup')}">RoboShell Backup</a></h2>
          <%self:filter chain="markdown">
**What I needed:**  
xxxxx

**What I learned:**

- xxxxx
          </%self:filter>
        </div><!--/span-->
        
        <div class="row-fluid visible-phone spacer25"></div>
        
        <div class="span6">
            <h2><img src="https://bitbucket.org/christianspecht/bitbucket-backup/raw/tip/img/logo35x35.png" /> <a href="${bf.util.site_path_helper('bitbucket-backup')}">Bitbucket Backup</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
xxxxx

**What I learned:**

- xxxxx
            </%self:filter>
        </div><!--/span-->
        
    </div><!--/row-->
    
    <div class="row-fluid spacer25"></div>
    
    <div class="row-fluid">
    
        <div class="span6">
            <h2><img src="https://bitbucket.org/christianspecht/recordset.net/raw/tip/img/logo35x35.png" /> <a href="${bf.util.site_path_helper('recordset-net')}">Recordset.Net</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
xxxxx

**What I learned:**

- xxxxx
            </%self:filter>
        </div><!--/span-->
        
        <div class="row-fluid visible-phone spacer25"></div>
        
        <div class="span6">
            <h2><img src="https://bitbucket.org/christianspecht/missilesharp/raw/tip/img/logo35x35.png" /> <a href="${bf.util.site_path_helper('missilesharp')}">MissileSharp</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
xxxxx

**What I learned:**

- xxxxx
            </%self:filter>
        </div><!--/span-->
        
    </div><!--/row-->
    
    <div class="row-fluid spacer25"></div>
    
     <div class="row-fluid">
     
        <div class="span6">
            <h2><img src="https://bitbucket.org/christianspecht/vba-helpers/raw/tip/img/logo35x35.png" /> <a href="${bf.util.site_path_helper('vba-helpers')}">VBA Helpers</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
xxxxx

**What I learned:**

- xxxxx
            </%self:filter>
        </div><!--/span-->
        
        <div class="row-fluid visible-phone spacer25"></div>
        
        <div class="span6">
            <h2><img src="http://www.gravatar.com/avatar/6f807629c5f3765f28c61b1271552dc9?s=35" class="img-rounded" /> <a href="${bf.util.site_path_helper()}">This site</a></h2>
            <%self:filter chain="markdown">
**What I needed:**  
xxxxx

**What I learned:**

- xxxxx
            </%self:filter>
        </div><!--/span-->
        
    </div><!--/row-->
</div><!--/container-fluid-->
