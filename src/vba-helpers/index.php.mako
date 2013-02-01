<%inherit file="_templates/site.mako" />
<%def name="title()">VBA Helpers</%def>
<article>

<?php

include_once "../php/md-include.php";
echo GetMarkdown("https://bitbucket.org/christianspecht/vba-helpers/raw/tip/readme-full.md");

?>

</article>
