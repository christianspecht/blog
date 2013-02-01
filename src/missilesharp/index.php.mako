<%inherit file="_templates/site.mako" />
<%def name="title()">MissileSharp</%def>
<article>

<?php

include_once "../php/md-include.php";
echo GetMarkdown("https://bitbucket.org/christianspecht/missilesharp/raw/tip/readme-full.md");

?>

</article>
