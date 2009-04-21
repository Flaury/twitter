<?php
/**
 * Tweetr Proxy Class
 * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
 */
class Tweetr
{	
	//--------------------------------------------------------------------------
    //
    //  Class variables
	//
	//--------------------------------------------------------------------------
	const USER_AGENT = 'TweetrProxy/0.93';
	const USER_AGENT_LINK = 'http://tweetr.googlecode.com/';
	const BASEURL = "/proxy";
	const DEBUGMODE = false;
	const GHOST_DEFAULT = "ghost";
	//--------------------------------------------------------------------------
	//
	//  Initialization
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a Tweetr Proxy Instance
	 * @param (array) $options	Associative Array containing optional values see http://code.google.com/p/tweetr/wiki/PHPProxyUsage
	 */
	public function Tweetr($options = null)
	{
		// set the options
		$this->baseURL = (isset($options['baseURL'])) ? $options['baseURL'] : self::BASEURL;
		$this->userAgent = (isset($options['userAgent'])) ? $options['userAgent'] : self::USER_AGENT;
		$this->userAgentLink = (isset($options['userAgentLink'])) ? $options['userAgentLink'] : self::USER_AGENT_LINK;
		$this->debug = (isset($options['debugMode'])) ? $options['debugMode'] : self::DEBUGMODE;
		
		$this->ghostName = (isset($options['ghostName'])) ? $options['ghostName'] : self::GHOST_DEFAULT;
		$this->ghostPass = (isset($options['ghostPass'])) ? $options['ghostPass'] : self::GHOST_DEFAULT;
		$this->userName = (isset($options['userName'])) ? $options['userName'] : null;
		$this->userPass = (isset($options['userPass'])) ? $options['userPass'] : null;

		
		// set the current url and parse it
		$this->url = parse_url($_SERVER[REQUEST_URI]);
		$this->parseRequest();
	}

	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	private $url;
	private $debug;
	private $baseURL;
	private $userAgent;
	private $userAgentLink;
	private $userName;
	private $userPass;
	private $ghostName;
	private $ghostPass;
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	/**
	 * Pre-Parses the received request to see if we need authentication or not
	 */
	private function parseRequest()
	{
		if($_SERVER[REQUEST_METHOD] == "POST")
		{
			$this->requestCredentials();
		}
		else
		{
			if($this->url['path'] == $this->baseURL."/")
			{
				echo '<html><head><title>'.$this->userAgent.'</title></head><body><a href="'.$this->userAgentLink.'" title="Go to Website">'.$this->userAgent.'</a></body></html>';
			    exit;
			}
			else if( strpos($this->url['path'], "statuses/friends_timeline") != false ||
				strpos($this->url['path'], "statuses/user_timeline.") != false ||
				strpos($this->url['path'], "statuses/replies.") != false ||
				strpos($this->url['path'], "statuses/friends.") != false ||
				strpos($this->url['path'], "statuses/followers") != false ||
				strpos($this->url['path'], "direct_messages") != false ||
				strpos($this->url['path'], "favorites.") != false )
			{
				$this->requestCredentials();
			}
			else
			{
				$this->twitterRequest();
			}
		}
	}
	
	
	/**
	 * Makes a request to twitter with the data provided and returns the result to the screen
	 */
	private function twitterRequest($authentication = false)
	{	
		$twitterURL = "http://twitter.com".str_replace($this->baseURL,"",$this->url['path']);
		
		$opt[CURLOPT_URL] = $twitterURL;
		$opt[CURLOPT_USERAGENT] = $this->userAgent;
		$opt[CURLOPT_FOLLOWLOCATION] = true;
		$opt[CURLOPT_RETURNTRANSFER] = true;
		$opt[CURLOPT_TIMEOUT] = 60;

		if($authentication)
		{	
			$opt[CURLOPT_HTTPAUTH] = CURLAUTH_BASIC;
			
			if(	isset($this->ghostName) && isset($this->ghostPass) && 
				isset($this->userName) && isset($this->userPass) &&
				$this->ghostName == $_SERVER['PHP_AUTH_USER'] && $this->ghostPass == $_SERVER['PHP_AUTH_PW'])
			{
				$opt[CURLOPT_USERPWD] = $this->userName .':'. $this->userPass;
			}
			else
			{
				$opt[CURLOPT_USERPWD] = $_SERVER['PHP_AUTH_USER'] .':'. $_SERVER['PHP_AUTH_PW'];
			}
			
		}

		if($_SERVER[REQUEST_METHOD] == POST)
		{
			// parse post parameters
			$vars = "";
			foreach($_POST as $key => $value) $vars .= '&'. $key .'='. urlencode($value);

			$opt[CURLOPT_POST] = true;
			$opt[CURLOPT_POSTFIELDS] = trim($vars, '&');
			$opt[CURLOPT_HTTPHEADER] = array('Expect:');
		}
		
		//do the request
		$curl = curl_init();
		curl_setopt_array($curl, $opt);

		$response = curl_exec($curl);
		
		if($this->debug)
		{
			$headers = curl_getinfo($curl);
			$errorNumber = curl_errno($curl);
			$errorMessage = curl_error($curl);	
		}
		curl_close($curl);
		
		if($this->debug)
		{
			$this->log($headers);
			$this->log($errorNumber);
			$this->log($errorMessage);
		}
		
		header ("content-type: text/xml");
		echo $response;
	}
	
	
	/**
	 * Requests Basic Authentication
	 */
	private function requestCredentials()
	{
		if (!isset($_SERVER['PHP_AUTH_USER']) && !isset($_SERVER['PHP_AUTH_PW']))
		{
		   header('WWW-Authenticate: Basic realm="Tweetr Realm"');
		   header('HTTP/1.0 401 Unauthorized');
		   echo 'Credentials missing';
		   exit;
		} 
		else
		{
			$this->twitterRequest(true);
		}
	}
	
	/**
	 * Log Method that you can overwrite with your own logging stuff.
	 * FirePHP is my personal recommendation though ;)
	 * @param $obj	Whatever you are trying to log
	 */
	private function log($obj)
	{
		//require_once('fire/fb.php');
		//FB::log($obj);
	}
}
?>