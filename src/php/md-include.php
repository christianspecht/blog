<?php
#
# Loads Markdown from an external URL and converts it into HTML with PHP Markdown.
#
# Usage:
#
#    include_once "md-include.php";
#    echo GetMarkdown("http://example.com/test.md", "Page Title");
#

include_once "markdown.php";

function GetMarkdown($url, $title) {

    // time (in minutes) how long a cached file is valid
    $cachetime = 5; // 10 * 60; 
    
    // name of the cache file: /php/cache/Project-Name.html
    $cachefile = __DIR__ . "/cache/" . str_replace(" ", "-", $title) . ".html";
    echo "<!-- $cachefile -->";
    
    // TODO: load content from cache file if it already exists
    
    
    $result = @file_get_contents($url);

    if ($result === false)
    {
        return "Could not load $url";
    }
    else
    {
        $md = Markdown($result);
        $md = "\r\n<!-- cached " . date('Y/m/d H:i:s') . " -->\r\n" . $md;
        
        $cached = fopen($cachefile, 'w');
        fwrite($cached, $md);
        fclose($cached);
        
        return $md;
    }
    
}

?>