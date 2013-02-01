<%inherit file="_templates/site.mako" />
<%def name="title()">Recordset.Net</%def>
<article>

<?php

include_once "../php/md-include.php";
echo GetMarkdown("https://bitbucket.org/christianspecht/recordset.net/raw/tip/readme-full.md");

?>

</article>
