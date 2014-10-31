<?php
#
# Loads Markdown from an external URL and converts it into HTML with PHP Markdown.
#
# Usage:
#
#    include_once 'md-include.php';
#    echo GetMarkdown('http://example.com/test.md', 'Page Title');
#

include_once 'markdown.php';

function GetMarkdown($url, $title) {

    // time (in seconds) how long a cached file is valid
    $cachetime = 10 * 60 * 60; 
    
    // name of the cache file: /php/cache/project-name.html
    $cachefile = __DIR__ . '/cache/' . str_replace(' ', '-', strtolower($title)) . '.html';
    
    // load content from cache file if it already exists
    if (file_exists($cachefile) && time() - $cachetime < filemtime($cachefile)) {
        $result = file_get_contents($cachefile);
        $result .= PHP_EOL . '<!-- cached ' . date('Y/m/d H:i:s') . ' -->' . PHP_EOL;
        return $result;
    }
    
    $result = @file_get_contents($url);

    if ($result === false)
    {
        return 'Could not load ' . $url;
    }
    else
    {
        $html = Markdown($result);
        
        // replace image URLs
        $doc = new DOMDocument();
        @$doc->loadHTML($html);
        $images = $doc->getElementsByTagName('img');

        foreach ($images as $image) {
               $img = $image->getAttribute('src');
               $img .= '?x=1';
               $image->setAttribute('src', $img);
        }
        
        $html = $doc->saveHTML();
        
        $cached = fopen($cachefile, 'w');
        fwrite($cached, $html);
        fclose($cached);
        
        return $html;
    }
    
}

?>