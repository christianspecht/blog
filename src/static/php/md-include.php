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

function DownloadImage($url, $filename) {

    $newfilename = $filename . '-' . basename($url); // doesn't work if the page contains two image files from different URLs, but with the same name!
    $newfile = __DIR__ . '/cache/img/' . $newfilename;
    $newurl = '/php/cache/img/' . $newfilename;
    
    copy($url, $newfile);
    return $newurl;
}

function GetMarkdown($url, $title) {

    // time (in seconds) how long a cached file is valid
    $cachetime = 24 * 60 * 60; 
    
    // name of the cache file: /php/cache/project-name.html
    $filename = str_replace(' ', '-', strtolower($title));
    $cachefile = __DIR__ . '/cache/' . $filename . '.html';
    
    // load content from cache file if it already exists
    if (file_exists($cachefile) && time() - $cachetime < filemtime($cachefile)) {
        $result = file_get_contents($cachefile);
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
               $img = DownloadImage($img, $filename);
               $image->setAttribute('src', $img);
        }
        
        $html = preg_replace('/^<!DOCTYPE.+?>/', '', str_replace( array('<html>', '</html>', '<body>', '</body>'), array('', '', '', ''), $doc->saveHTML()));
        $html = '<!-- cached ' . date('Y/m/d H:i:s') . ' -->' . PHP_EOL . $html;
        
        $cached = fopen($cachefile, 'w');
        fwrite($cached, $html);
        fclose($cached);
        
        return $html;
    }
    
}

?>