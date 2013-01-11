<?php
#
# Loads Markdown from an external URL and converts it into HTML with PHP Markdown.
#
# Usage:
#
#    include_once "md-include.php";
#    echo GetMarkdown("http://example.com/test.md");
#

include_once "markdown.php";

function GetMarkdown($url) {

	$result = @file_get_contents($url);

	if ($result === false)
	{
		return "Could not load $url";
	}
	else
	{
		return Markdown($result);
	}
	
}

?>