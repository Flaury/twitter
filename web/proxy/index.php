<?php 
include_once 'Tweetr.php';

/**
 * Tweetr Proxy Class Startpoint
 * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
 * 
 * see http://code.google.com/p/tweetr/wiki/PHPProxyUsage
 * on how to use the tweetr php proxy and it's options.
 */

$tweetrOptions['baseURL'] = "/proxy";
//$tweetrOptions['userAgent'] = "TweetrProxy/0.93";
//$tweetrOptions['userAgentLink'] = "http://tweetr.googlecode.com/";
//$tweetrOptions['debugMode'] = true;
//$tweetrOptions['ghostName'] = "your_ghost";
//$tweetrOptions['ghostPass'] = "your_ghost";
//$tweetrOptions['userName'] = "your_username";
//$tweetrOptions['userPass'] = "your_password";

$tweetr = new Tweetr($tweetrOptions);
?>