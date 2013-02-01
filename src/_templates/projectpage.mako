<%inherit file="site.mako" />
<%def name="title()">
%if hasattr(next, 'title'):
${next.title()}
%else:
no title
%endif
</%def>
<h1>${self.title()}</h1>
<p>&nbsp;</p>
%if hasattr(next, 'markdownurl'):
<?php
include_once "../php/md-include.php";
echo GetMarkdown("${next.markdownurl()}");
?>
%else:
<p>no markdown URL specified!</p>
%endif