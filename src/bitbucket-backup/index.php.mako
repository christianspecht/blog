<%inherit file="_templates/site.mako" />
<%def name="title()">Bitbucket Backup</%def>
<article>

<?php

include_once "../php/md-include.php";
echo GetMarkdown("https://bitbucket.org/christianspecht/bitbucket-backup/raw/tip/readme-full.md");

?>

</article>
