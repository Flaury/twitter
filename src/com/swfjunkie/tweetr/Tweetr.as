package com.swfjunkie.tweetr
{
    import com.swfjunkie.tweetr.data.DataParser;
    import com.swfjunkie.tweetr.events.TweetEvent;
    import com.swfjunkie.tweetr.utils.Base64Encoder;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    
    import mx.events.IndexChangedEvent;
    
    /**
	 * Dispatched when the Tweetr has Completed a Request.
	 * @eventType com.swfjunkie.Tweetr.events.TweetEvent.COMPLETE
	 */ 
    [Event(name="complete", type="com.swfjunkie.Tweetr.events.TweetEvent")]
    /**
     * Dispatched when something goes wrong while trying to request something from twitter
     * @eventType com.swfjunkie.Tweetr.events.TweetEvent.FAILED
     */ 
    [Event(name="failed", type="com.swfjunkie.Tweetr.events.TweetEvent")]
    /**
     * Merely for Informational purposes. Dispatches the http status to the listener
     * @eventType com.swfjunkie.Tweetr.events.TweetEvent.STATUS
     */ 
    [Event(name="status", type="com.swfjunkie.Tweetr.events.TweetEvent")]
    
    /**
     * Tweetr contains all twitter api calls that you need to create your own twitter client
     * or application that uses twitter.
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
     
    public class Tweetr extends EventDispatcher
    {
        //--------------------------------------------------------------------------
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------
        private static const URL_FRIENDS_TIMELINE:String =          "/statuses/friends_timeline.xml";
        private static const URL_USER_TIMELINE:String =             "/statuses/user_timeline";
        private static const URL_PUBLIC_TIMELINE:String =           "/statuses/public_timeline.xml";
        private static const URL_SINGLE_TWEET:String =              "/statuses/show/";
        private static const URL_SEND_UPDATE:String =               "/statuses/update.xml";
        private static const URL_DESTROY_TWEET:String =             "/statuses/destroy/";
        private static const URL_REPLIES:String =                   "/statuses/replies.xml";
        private static const URL_FRIENDS:String =                   "/statuses/friends";
        private static const URL_FOLLOWERS:String =                 "/statuses/followers";
        private static const URL_USER_DETAILS:String =              "/users/show/";
        private static const URL_RECEIVED_DIRECT_MESSAGES:String =  "/direct_messages.xml";
        private static const URL_SENT_DIRECT_MESSAGES:String =      "/direct_messages/sent.xml";
        private static const URL_SEND_NEW_DIRECT_MESSAGE:String =   "/direct_messages/new.xml";
        private static const URL_DESTROY_DIRECT_MESSAGE:String =    "/direct_messages/destroy";
        private static const URL_CREATE_FRIENDSHIP:String =         "/friendships/create/";
        private static const URL_DESTROY_FRIENDSHIP:String =        "/friendships/destroy/";
        private static const URL_FRIENDSHIP_EXISTS:String =         "/friendships/exists.xml";
        private static const URL_RATELIMIT_STATUS:String =          "/account/rate_limit_status.xml";
        private static const URL_UPDATE_PROFILE:String =            "/account/update_profile.xml";
        private static const URL_RETRIEVE_FAVORITES:String =        "/favorites/";
        private static const URL_CREATE_FAVORITE:String =           "/favorites/create/";
        private static const URL_DESTROY_FAVORITE:String =          "/favorites/destroy/";
        private static const URL_FOLLOW_USER:String =               "/notifications/follow/";
		private static const URL_UNFOLLOW_USER:String =             "/notifications/leave/";
		private static const URL_BLOCK_USER:String =                "/blocks/create/";
		private static const URL_UNBLOCK_USER:String =              "/blocks/destroy/";
		private static const URL_TWITTER_SEARCH:String =            "http://search.twitter.com/search.atom";
		private static const URL_TWITTER_TRENDS:String =            "http://search.twitter.com/trends.json";
		private static const DATA_FORMAT:String = "xml";
        
        /** Version String of the Tweetr Library */
        public static const version:String = "0.9";		
		
		/** Return type defining what type of return Object you can expect, in this case: <code>StatusData</code> */
		public static const RETURN_TYPE_STATUS:String = "status";
		/** Return type defining what type of return Object you can expect, in this case: <code>UserData</code> */
		public static const RETURN_TYPE_BASIC_USER_INFO:String = "users";    
		/** Return type defining what type of return Object you can expect, in this case: <code>ExtendedUserData</code> */
		public static const RETURN_TYPE_EXTENDED_USER_INFO:String = "extended_user_info";
		/** Return type defining what type of return Object you can expect, in this case: <code>DirectMessageData</code> */
		public static const RETURN_TYPE_DIRECT_MESSAGE:String = "direct_message";
		/** Return type defining what type of return Object you can expect, in this case a Boolean value */
		public static const RETURN_TYPE_BOOLEAN:String = "bool";
		/** Return type defining what type of return Object you can expect, in this case: <code>HashData</code> */
		public static const RETURN_TYPE_HASH:String = "hash";
		/** Return type defining what type of return Object you can expect, in this case: <code>SearchResultData</code> */
		public static const RETURN_TYPE_SEARCH_RESULTS:String = "search";
		/** Return type defining what type of return Object you can expect, in this case: <code>TrendData/code> */
		public static const RETURN_TYPE_TRENDS_RESULTS:String = "trends";
        //--------------------------------------------------------------------------
        //
        //  Initialization
        //
        //--------------------------------------------------------------------------
        /**
         * Creates a new Tweetr Instance
         * @param username   Username is optional at this point but is required for most twitter api calls
         * @param password   Password is optional at this point but is required for most twitter api calls
         */ 
        public function Tweetr(username:String = null, password:String = null)
        {
            _username = username;
            _password = password;
            init();
        }
        /**
         * @private
         * Initializes the instance.
         */
        private function init():void
        {
            urlRequest = new URLRequest();
            urlLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE,handleTweetsLoaded);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleTweetsLoadingFailed);
            urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
        }
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        private var urlLoader:URLLoader;
    	private var urlRequest:URLRequest;
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        /** @private */
        private var request:String;
        
        /**
         * Get/Set if Browser interal Authorization Scheme should be used. 
         * Only needs to be set to false if you use this library with AIR.
         */ 
        public var browserAuth:Boolean = true;
        
        /**
         * @private 
         * Returns the full request url
         */ 
        private function get url():URLRequest
        {
            if (!_username && !_password)
            {
                urlRequest.url = "http://"+serviceHost+request;
            }
            else if (!browserAuth)
            {
                var base64:Base64Encoder = new Base64Encoder();
                base64.encode(_username+":"+_password);
                urlRequest.requestHeaders = [new URLRequestHeader("Authorization", "Basic "+base64.toString())];
                urlRequest.url = "http://"+serviceHost+request;
            }
            else
            {
                urlRequest.url = "http://"+_username+":"+_password+"@"+serviceHost+request;
            }
            return urlRequest;
        }
        
        /** @private */
        private var _username:String;
        /** Set the username  */ 
        public function set username(value:String):void
        {
            _username = value;
        }
        
        /** @private */
        private var _password:String;
        /** Set the users password */ 
        public function set password(value:String):void
        {
            _password = value;
        }
        
        /** @private */
        private var _returnType:String;
        /** Return type of the current response */ 
        public function get returnType():String
        {
            return _returnType;
        }
        
        /**
         * Service Host URL you want to use without "http://".
         * This has to be changed if you are going to use tweetr
         * from a web app. Since the crossdomain policy of twitter.com
         * is very restrictive. use Tweetr's own PHPProxy Class for this. 
         */ 
        public var serviceHost:String = "twitter.com";
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
        
        
        //----------------------------------
		//  Status Methods
		//----------------------------------
        
        /**
         * Returns the 20 most recent statuses from non-protected users who have set a custom user icon.  
         * Does not require authentication.  Note that the public timeline is cached for 60 seconds so 
         * requesting it more often than that is a waste of resources.
         */
        public function getPublicTimeLine():void
        {
            setGETRequest();
            _returnType = RETURN_TYPE_STATUS;
            request = URL_PUBLIC_TIMELINE; 
            urlLoader.load(url);
        }
        
        /**
         * Returns the 20 most recent statuses posted by the authenticating user and that user's friends. 
         * This is the equivalent of /home on the Web.
         * @param since_id        Optional.  Returns only statuses with an ID greater than (that is, more recent than) the specified ID.
         * @param since_date      Optional. Narrows the returned results to just those statuses created after the specified HTTP-formatted date, up to 24 hours old.
         * @param count           Optional. Specifies the number of statuses to retrieve. May not be greater than 200.
         * @param page            Optional. Provides paging. Ex. http://twitter.com/statuses/user_timeline.xml?page=3
         */ 
        public function getFriendsTimeLine(since_id:String = null, since_date:String = null, count:int = 0, page:int = 0):void
        {
            var arguments:Array = [];
            checkCredentials();
            setGETRequest();
            _returnType = RETURN_TYPE_STATUS;
            
            if (since_id)
                arguments.push("since_id="+since_id);
            if (since_date)
                arguments.push("since="+since_date);
            if (count > 0)
            {
                if (count > 200)
                    count = 200;
                arguments.push("count="+count);
            }
            if (page > 0)
                arguments.push("page="+page);
            
            request = URL_FRIENDS_TIMELINE + ( (arguments.length != 0) ? returnArgumentsString(arguments) : "" );
            urlLoader.load(url);
        }
        
        /**
         * Returns the 20 most recent statuses posted from the authenticating user. It's also possible to request 
         * another user's timeline via the id parameter. This is the equivalent of the Web /archive page for your 
         * own user, or the profile page for a third party.
         * @param id              Optional. Specifies the ID or screen name of the user for whom to return the friends_timeline.
         * @param since_id        Optional. Returns only statuses with an ID greater than (that is, more recent than) the specified ID.
         * @param since_date      Optional. Narrows the returned results to just those statuses created after the specified HTTP-formatted date, up to 24 hours old.
         * @param count           Optional. Specifies the number of statuses to retrieve. May not be greater than 200.
         * @param page            Optional. Provides paging. Ex. http://twitter.com/statuses/user_timeline.xml?page=3
         */ 
        public function getUserTimeLine(id:String = null, since_id:String = null, since_date:String = null, count:int = 0, page:int = 0):void
        {
            var arguments:Array = [];
            
            if(!id)
                checkCredentials();
            
            setGETRequest();
            _returnType = RETURN_TYPE_STATUS;
            
            if (since_id)
                arguments.push("since_id="+since_id);
            if (since_date)
                arguments.push("since="+since_date);
            if (count > 0)
            {
                if (count > 200)
                    count = 200;
                arguments.push("count="+count);
            }
            if (page > 0)
                arguments.push("page="+page);
            
            request = URL_USER_TIMELINE + ( (id) ? "/"+id+"."+DATA_FORMAT : "."+DATA_FORMAT  ) + ( (arguments.length != 0) ? returnArgumentsString(arguments) : "" );
            urlLoader.load(url);
        }
        
        /**
         * Returns a single status, specified by the id parameter below.  The status's author will be returned inline.
         * @param id   Tweet ID
         */ 
        public function getSingleTweet(id:int):void
        {
            setGETRequest();
            _returnType = RETURN_TYPE_STATUS;
            request = URL_SINGLE_TWEET + String(id) + "."+DATA_FORMAT;
            urlLoader.load(url);
        }
        
        /**
         * Updates the authenticating user's status. 
         * A status update with text identical to the authenticating user's 
         * current status will be ignored.
         * @param status      Required. The text of your status update. Should not be more than 140 characters.
         * @param inReplyTo   Optional. The ID of an existing status that the status to be posted is in reply to. Invalid/missing status IDs will be ignored.
         */ 
        public function sendTweet(status:String, inReplyTo:int = 0):void
        {
            var vars:URLVariables = new URLVariables();
            checkCredentials();
            _returnType = RETURN_TYPE_STATUS;
            
            vars.status = status.substr(0,140);
            if (inReplyTo != 0)
                vars.in_reply_to_status_id = inReplyTo;
            
            setPOSTRequest(vars);
            request = URL_SEND_UPDATE;
            urlLoader.load(url);
        }
        
        /**
         * Returns the 20 most recent @replies (status updates prefixed with @username) for the authenticating user.
         * @param since_id        Optional. Returns only statuses with an ID greater than (that is, more recent than) the specified ID.
         * @param since_date      Optional. Narrows the returned results to just those statuses created after the specified HTTP-formatted date, up to 24 hours old.
         * @param page            Optional. Provides paging. Ex. http://twitter.com/statuses/user_timeline.xml?page=3
         */ 
        public function getReplies(since_id:String = null, since_date:String = null, page:int = 0):void
        {
            var arguments:Array = [];
            checkCredentials();
            setGETRequest();
            _returnType = RETURN_TYPE_STATUS;
            
            if (since_id)
                arguments.push("since_id="+since_id);
            if (since_date)
                arguments.push("since="+since_date);
            if (page > 0)
                arguments.push("page="+page);
                
            request = URL_REPLIES + ( (arguments.length != 0) ? returnArgumentsString(arguments) : "" );
            urlLoader.load(url);
                
        }
        
        /**
         * Destroys the status specified by the required ID parameter.
         * The authenticating user must be the author of the specified status.
         * @param id   Required. The ID of the status to destroy
         */ 
        public function destroyTweet(id:int):void
        {   
            var vars:URLVariables = new URLVariables();
            checkCredentials();
            _returnType = RETURN_TYPE_STATUS;
            
            vars.id = id;
            vars.format = DATA_FORMAT;
            
            setPOSTRequest(vars);
            request = URL_DESTROY_TWEET + id + "."+DATA_FORMAT;
            urlLoader.load(url);
        }
        
        
        //----------------------------------
		//  User Methods
		//----------------------------------
        
        /**
         * Returns up to 100 of the authenticating user's friends who have 
         * most recently updated, each with current status inline. 
         * It's also possible to request another user's recent friends list via the id parameter.
         * @param id      Optional. The ID or screen name of the user for whom to request a list of friends.
         * @param page    Optional. Retrieves the next 100 friends.
         */ 
        public function getFriends(id:String = null, page:int = 0):void
        {
            var arguments:Array = [];
            
            if (!id)
                checkCredentials();
            
            setGETRequest();
            _returnType = RETURN_TYPE_BASIC_USER_INFO;
            
             if (page > 0)
                arguments.push("page="+page);
            
            request = URL_FRIENDS + ( (id) ? "/"+id+"."+DATA_FORMAT : "."+DATA_FORMAT  ) + ( (arguments.length != 0) ? returnArgumentsString(arguments) : "" );
            urlLoader.load(url);
        }
        
        /**
         * Returns the authenticating user's followers, each with current status inline.  
         * They are ordered by the order in which they joined Twitter (this is going to be changed).
         * @param id      Optional. The ID or screen name of the user for whom to request a list of followers.
         * @param page    Optional. Retrieves the next 100 followers.
         */ 
        public function getFollowers(id:String = null, page:int = 0):void
        {
            var arguments:Array = [];
            checkCredentials();
            setGETRequest();
            _returnType = RETURN_TYPE_BASIC_USER_INFO;
            
             if (page > 0)
                arguments.push("page="+page);
            
            request = URL_FOLLOWERS + ( (id) ? "/"+id+"."+DATA_FORMAT : "."+DATA_FORMAT  ) + ( (arguments.length != 0) ? returnArgumentsString(arguments) : "" );
            urlLoader.load(url);
        }
        
        /**
         * Returns extended information of a given user, specified by ID or screen name.  
         * This information includes design settings, so third party developers can theme 
         * their widgets according to a given user's preferences. You must be properly 
         * authenticated to request the page of a protected user.
         * @param id       The ID or screen name of a user.
         * @param email    May be used in place of "id" parameter above.  The email address of a user.
         */ 
        public function getUserDetails(id:String=null, email:String=null):void
        {
            var arguments:Array = [];
            setGETRequest();
            _returnType = RETURN_TYPE_EXTENDED_USER_INFO;
            
             if (!id && !email)
                throw new Error("You have to supply either an ID or an Email!");
            
            if (id)
            {
                request = URL_USER_DETAILS + "/"+id+"."+DATA_FORMAT;
            }
            else
            {
                arguments.push("email="+email);
                request = URL_USER_DETAILS + "/show."+DATA_FORMAT + returnArgumentsString(arguments);
            }
            urlLoader.load(url);
        }
        
        
        //----------------------------------
		//  Direct Message Methods
		//----------------------------------
        
        /**
         * Returns a list of the 20 most recent direct messages sent to the authenticating user.
         * The XML includes detailed information about the sending and recipient users.
         * @param since_id      Optional. Returns only direct messages with an ID greater than (that is, more recent than) the specified ID. 
         * @param since_date    Optional. Narrows the resulting list of direct messages to just those sent after the specified HTTP-formatted date, up to 24 hours old.
         * @param page          Optional. Retrieves the 20 next most recent direct messages.
         */ 
        public function getReceivedDirectMessages(since_id:String = null, since_date:String = null, page:int = 0):void
        {
            var arguments:Array = [];
            checkCredentials();
            setGETRequest();
            _returnType = RETURN_TYPE_DIRECT_MESSAGE;
            
            if (since_id)
                arguments.push("since_id="+since_id);
            if (since_date)
                arguments.push("since="+since_date);
            if (page > 0)
                arguments.push("page="+page);
            
            request = URL_RECEIVED_DIRECT_MESSAGES + ( (arguments.length != 0) ? returnArgumentsString(arguments) : "" );
            urlLoader.load(url);
        }
        
        /**
         * Returns a list of the 20 most recent direct messages sent by the authenticating user.
         * The XML includes detailed information about the sending and recipient users.
         * @param since_id      Optional. Returns only direct messages with an ID greater than (that is, more recent than) the specified ID. 
         * @param since_date    Optional. Narrows the resulting list of direct messages to just those sent after the specified HTTP-formatted date, up to 24 hours old.
         * @param page          Optional. Retrieves the 20 next most recent direct messages.
         */ 
        public function getSentDirectMessages(since_id:String = null, since_date:String = null, page:int = 0):void
        {
            var arguments:Array = [];
            checkCredentials();
            setGETRequest();
            _returnType = RETURN_TYPE_DIRECT_MESSAGE;
            
            if (since_id)
                arguments.push("since_id="+since_id);
            if (since_date)
                arguments.push("since="+since_date);
            if (page > 0)
                arguments.push("page="+page);
            
            request = URL_SENT_DIRECT_MESSAGES + ( (arguments.length != 0) ? returnArgumentsString(arguments) : "" );
            urlLoader.load(url);
        }
        
        
        /**
         * Sends a new direct message to the specified user from the authenticating user.
         * @param text   Required. The text of your direct message, keep it under 140 characters or else it will be cut! 
         * @param user   Required. The ID or screen name of the recipient user.
         */
        public function sendDirectMessage(text:String, user:String):void
        {
            var vars:URLVariables = new URLVariables();
            checkCredentials();
            _returnType = RETURN_TYPE_DIRECT_MESSAGE;
            vars.user = user;
            vars.text = text.substr(0,140);

            setPOSTRequest(vars);
            request = URL_SEND_NEW_DIRECT_MESSAGE;
            urlLoader.load(url);
        } 
        
        
        /**
         * Destroys the direct message specified in the required ID parameter.  
         * The authenticating user must be the recipient of the specified direct message.
         * @param id   Required. The ID of the direct message to destroy
         */ 
        public function destroyDirectMessage(id:int):void
        {
            var vars:URLVariables = new URLVariables();
            checkCredentials();
            _returnType = RETURN_TYPE_DIRECT_MESSAGE;
            
            vars.id = id;
            vars.format = DATA_FORMAT;
            
            setPOSTRequest(vars);
            request = URL_DESTROY_DIRECT_MESSAGE;
            urlLoader.load(url);
        }
        
        
        //----------------------------------
		//  Friendship Methods
		//----------------------------------
        
        /**
         * Befriends the user specified in the ID parameter as the authenticating user.
         * Returns the befriended user in the requested format when successful.  
         * Returns a string describing the failure condition when unsuccessful.
         * @param id         The ID or screen name of the user to befriend
         * @param follow     Enable notifications for the target user in addition to becoming friends. Default is true.
         */ 
        public function createFriendship(id:String, follow:Boolean = true):void
        {
            var vars:URLVariables = new URLVariables();
            checkCredentials();
            _returnType = RETURN_TYPE_BASIC_USER_INFO;
            
            vars.id = id;
            vars.follow = follow;
            vars.format = DATA_FORMAT;
            
            setPOSTRequest(vars);
            request = URL_CREATE_FRIENDSHIP;
            urlLoader.load(url);
        }
        
        /**
         * Discontinues friendship with the user specified in the ID parameter as the authenticating user.  
         * Returns the un-friended user in the requested format when successful.  
         * Returns a string describing the failure condition when unsuccessful.  
         * @param id    The ID or screen name of the user with whom to discontinue friendship.
         */ 
        public function destroyFriendship(id:String):void
        {
            var vars:URLVariables = new URLVariables();
            checkCredentials();
            _returnType = RETURN_TYPE_BASIC_USER_INFO;
            
            vars.id = id;
            vars.format = DATA_FORMAT;
            
            setPOSTRequest(vars);
            request = URL_DESTROY_FRIENDSHIP;
            urlLoader.load(url);
        }
        
        /**
         * Tests if a friendship exists between two users.
         * @param userA      Required.  The ID or screen_name of the first user to test friendship for.
         * @param userB      Required.  The ID or screen_name of the second user to test friendship for.
         */ 
        public function hasFriendship(userA:String, userB:String):void
        {
            _returnType = RETURN_TYPE_BOOLEAN;
            setGETRequest();
            request = URL_FRIENDSHIP_EXISTS + "?user_a="+userA+"&user_b="+userB;
            urlLoader.load(url);
        }
        
        
        //----------------------------------
		//  Account Methods
		//----------------------------------
		
		/* API Methods that are not implemented:
		    - verify_credentials
		    - end_session
		    - update_location (deprecated)
		    - update_delivery_device
		    - update_profile_colors
		    - update_profile_image
		    - update_profile_background_image
		*/
		
		/**
		 * Returns the remaining number of API requests available to the requesting user 
		 * before the API limit is reached for the current hour. 
		 * Calls to rate_limit_status do not count against the rate limit.  
		 */ 
		public function getRateLimitStatus():void
		{
		    _returnType = RETURN_TYPE_HASH;
		    setGETRequest()
		    request = URL_RATELIMIT_STATUS;
		    urlLoader.load(url);
		}
		
		/**
		 * Sets values that users are able to set under the "Account" tab of their settings page. 
		 * Only the parameters specified will be updated
		 * @param name            Optional. Maximum of 40 characters.
		 * @param email           Optional. Maximum of 40 characters. Must be a valid email address.
		 * @param url             Optional. Maximum of 100 characters. Will be prepended with "http://" if not present.
		 * @param location        Optional. Maximum of 30 characters. The contents are not normalized or geocoded in any way.
		 * @param description     Optional. Maximum of 160 characters.
		 */ 
		public function updateProfile(name:String = null, email:String = null, url:String = null, location:String = null, description:String = null):void
		{
		    var vars:URLVariables = new URLVariables();
		    checkCredentials();
		    _returnType = RETURN_TYPE_EXTENDED_USER_INFO;
		    
		    if (name)
		        vars.name = name.substr(0,40);
		    if (email)
		        vars.email = email.substr(0,40);
		    if (url)
		        vars.url = url.substr(0,100);
		    if (location)
		        vars.location = location.substr(0,30);
		    if (description)
		        vars.description = description.substr(0,160);

		    setPOSTRequest(vars);
		    request = URL_UPDATE_PROFILE;
		    urlLoader.load(this.url);
		}
		
		
		//----------------------------------
		//  Favorite Methods
		//----------------------------------
		
		/**
		 * Returns the 20 most recent favorite statuses for the authenticating user or user specified by the ID parameter in the requested format. 
		 * @param id      Optional.  The ID or screen name of the user for whom to request a list of favorite statuses
		 * @param page    Optional. Retrieves the 20 next most recent favorite statuses.
		 */
		public function getFavorites(id:String, page:int = 0):void
		{
		    var arguments:Array = [];
		   
		    if (!id)
		        checkCredentials();
            
            setGETRequest();
            _returnType = RETURN_TYPE_STATUS;
            
            if (page > 0)
                arguments.push("page="+page);
            
            request = URL_RETRIEVE_FAVORITES + ( (id) ? "/"+id+"."+DATA_FORMAT : "."+DATA_FORMAT  ) + ( (arguments.length != 0) ? returnArgumentsString(arguments) : "" );
            urlLoader.load(url);   
		}
		
		/**
		 * Favorites the status specified in the ID parameter as the authenticating user.  
		 * Returns the favorite status when successful.
		 * @param id    Required.  The ID of the status to favorite.
		 */
		public function createFavorite(id:int):void
		{
		    var vars:URLVariables = new URLVariables();
		    checkCredentials();
		    _returnType = RETURN_TYPE_STATUS;
		    
		    vars.id = id;
		    vars.format = DATA_FORMAT;
		    
		    setPOSTRequest(vars);
		    request = URL_CREATE_FAVORITE;
		    urlLoader.load(url);   
		}
		
		/**
		 * Un-favorites the status specified in the ID parameter as the authenticating user.  
		 * Returns the un-favorited status when successful.  
		 * @param id   Required.  The ID of the status to un-favorite.
		 */ 
		public function destroyFavorite(id:int):void
		{
		    var vars:URLVariables = new URLVariables();
		    checkCredentials();
		    _returnType = RETURN_TYPE_STATUS;
		    
		    vars.id = id;
		    vars.format = DATA_FORMAT;
		    
		    setPOSTRequest(vars);
		    request = URL_DESTROY_FAVORITE;
		    urlLoader.load(url);   
		}
		
		
        //----------------------------------
		//  Notification Methods
		//----------------------------------
		
		/**
		 * Enables notifications for updates from the specified user to the authenticating user.  Returns the specified user when successful.
		 * NOTE: The Notification Methods require the authenticated user to already be friends with the specified user otherwise 
		 * a failed event will be fired.
		 * @param id    Required.  The ID or screen name of the user to follow.
		 */ 
		public function followUser(id:String):void
		{
		    var vars:URLVariables = new URLVariables();
		    checkCredentials();
		    _returnType = RETURN_TYPE_BASIC_USER_INFO;
		    
		    vars.id = id;
		    vars.format = DATA_FORMAT;
		    
		    setPOSTRequest(vars);
		    request = URL_FOLLOW_USER;
		    urlLoader.load(url);
		}
		
		/**
		 * Disables notifications for updates from the specified user to the authenticating user.  Returns the specified user when successful.
		 * NOTE: The Notification Methods require the authenticated user to already be friends with the specified user otherwise 
		 * a failed event will be fired.
		 * @param id    Required.  The ID or screen name of the user to leave
		 */ 
		public function unfollowUser(id:String):void
		{
		    var vars:URLVariables = new URLVariables();
		    checkCredentials();
		    _returnType = RETURN_TYPE_BASIC_USER_INFO;
		    
		    vars.id = id;
		    vars.format = DATA_FORMAT;
		    
		    setPOSTRequest(vars);
		    request = URL_UNFOLLOW_USER;
		    urlLoader.load(url);
		}
		
		
		//----------------------------------
		//  Block Methods
		//----------------------------------
		
		/**
		 * Blocks the user specified in the ID parameter as the authenticating user.  
		 * Returns the blocked user in the requested format when successful.
		 * @param id   Required.  The ID or screen_name of the user to block.
		 */ 
		public function blockUser(id:String):void
		{
		    var vars:URLVariables = new URLVariables();
		    checkCredentials();
		    _returnType = RETURN_TYPE_BASIC_USER_INFO;
		    
		    vars.id = id;
		    vars.format = DATA_FORMAT;
		    
		    setPOSTRequest(vars);
		    request = URL_BLOCK_USER;
		    urlLoader.load(url);
		}
		
		/**
		 * Un-blocks the user specified in the ID parameter as the authenticating user. 
		 * Returns the un-blocked user in the requested format when successful.
		 * @param id   Required.  The ID or screen_name of the user to un-block.
		 */
		public function unblockUser(id:String):void
		{
		    var vars:URLVariables = new URLVariables();
		    checkCredentials();
		    _returnType = RETURN_TYPE_BASIC_USER_INFO;
		    
		    vars.id = id;
		    vars.format = DATA_FORMAT;
		    
		    setPOSTRequest(vars);
		    request = URL_UNBLOCK_USER;
		    urlLoader.load(url);
		}
		
		//----------------------------------
		//  Twitter Search Methods
		//----------------------------------
		
		/**
		 * Returns tweets that match a specified query.  You can use a variety of search operators in your query. For a list
		 * of available operators check out <link>http://search.twitter.com/operators</link>
		 * @param searchString      Your query string
		 * @param lang              Optional. Restricts tweets to the given language given by an ISO 639-1 code. (en,de,it,fr .. )
		 * @param numTweets         Optional. The number of tweets to return per page, up to a max of 100.
		 * @param page              Optional. The page number (starting at 1) to return, up to a max of roughly 1500 results ((based on numTweets * page).
		 * @param since_id          Optional. Returns tweets with status ids greater than the given id.
		 * @param geocode           Optional. Returns tweets by users located within a given radius of the given Latitude/longitude. Ex. geocode=40.757929,-73.985506,25km
		 */ 
		public function search(searchString:String, lang:String = null, numTweets:int = 15, page:int = 1, since_id:int = 0, geocode:String = null):void
		{
		    var arguments:Array = [];
		    _returnType = RETURN_TYPE_SEARCH_RESULTS;
		    setGETRequest();
            
            arguments.push("q="+searchString);
		    if (lang)
		        arguments.push("lang="+lang);
		    if (numTweets != 15)
		        arguments.push("rpp="+numTweets);
		    if (page != 1)
		        arguments.push("page="+page);
		    if (since_id != 0)
		        arguments.push("since_id="+since_id);
		    if (geocode)
		        arguments.push("geocode="+geocode);
		    
		    urlLoader.load(new URLRequest(URL_TWITTER_SEARCH+returnArgumentsString(arguments)));
		}
		
		/**
		 * Returns the top ten queries that are currently trending on Twitter.
		 */
		public function trends():void
		{
		    _returnType = RETURN_TYPE_TRENDS_RESULTS;
		    setGETRequest();
		    urlLoader.load(new URLRequest(URL_TWITTER_TRENDS));
		}
		
		
        /**
         * Completely destroys the instance and frees all objects for the garbage
         * collector by setting their references to null.
         */
        public function destroy():void
        {
            urlLoader.removeEventListener(Event.COMPLETE,handleTweetsLoaded);
            urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, handleTweetsLoadingFailed);
            urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
            urlLoader = null;
    	    urlRequest = null;
    	    request = null;
    	    _username = null;
    	    _password = null;
    	    _returnType = null;
        }
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        /**
         * @private
         * Parse the XML to their appropriate data object and return an Array filled with them
         */ 
        private function responseParser(data:Object):Array
        {
            var returnArray:Array = [];

            if (_returnType != RETURN_TYPE_TRENDS_RESULTS)
            {
                var xml:XML = new XML(data);
                var isArray:Boolean = (xml.@type.toString() == "array") ? true : false;
            }
            
            switch (_returnType)
            {
                case RETURN_TYPE_STATUS:
                {
                    returnArray = DataParser.parseStatuses(xml,isArray);
                    break;
                }
                case RETURN_TYPE_DIRECT_MESSAGE:
                {
                    returnArray = DataParser.parseDirectMessages(xml,isArray);
                    break;
                }
                case RETURN_TYPE_BASIC_USER_INFO:
                {
                    returnArray = DataParser.parseUserInfos(xml,isArray);
                    break;   
                }
                case RETURN_TYPE_EXTENDED_USER_INFO:
                {
                    returnArray = DataParser.parseUserInfos(xml,isArray,true);
                    break;
                }
                case RETURN_TYPE_HASH:
                {
                    returnArray = DataParser.parseHash(xml);
                    break;
                }
                case RETURN_TYPE_BOOLEAN:
                {
                    returnArray = DataParser.parseBoolean(xml);
                    break;   
                }
                case RETURN_TYPE_SEARCH_RESULTS:
                {
                    returnArray = DataParser.parseSearchResults(xml);
                    break;
                }
                case RETURN_TYPE_TRENDS_RESULTS:
                {
                    returnArray = DataParser.parseTrendsResults(String(data));
                    break;
                }
                default:
                {
                    throw new Error("Unhandled Returntype occured!");
                    break;
                }
            }
            return returnArray;
        }
        
        /**
         * @private
         * Simply builds an argument string from the supplied arguments array
         */  
        private function returnArgumentsString(arguments:Array):String
        {
            var str:String;
            var n:int = arguments.length;
            for (var i:int = 0; i < n; i++)
            {
                if (i == 0)
                    str = "?"
                    
                str += arguments[i];
                
                if (i != (n-1))
                    str += "&";
            }
            return str;
        }
        
        /**
         * @private 
         */ 
        private function setGETRequest():void
        {
            urlRequest.method = URLRequestMethod.GET;
            urlRequest.data = null;
        }
        
        /**
         * @private
         */ 
        private function setPOSTRequest(vars:URLVariables=null):void
        {
            urlRequest.method = URLRequestMethod.POST;
            urlRequest.data = vars;
        }
        
        /**
         * @private
         */ 
        private function checkCredentials():void
        {
            if(!_username && !_password)
                throw new Error("Username and Password required but missing!");
        }
        //--------------------------------------------------------------------------
        //
        //  Broadcasting
        //
        //--------------------------------------------------------------------------
        /**
         * @private
         * Broadcast all TweetEvents from here
         */ 
        private function broadcastTweetEvent(type:String, tweets:Array=null, info:String = null):void
        {
            dispatchEvent(new TweetEvent(type,false,false,tweets,info));
        }
        //--------------------------------------------------------------------------
        //
        //  Eventhandling
        //
        //--------------------------------------------------------------------------
        /**
         * @private
         * Handles the Event.Complete after receiving the tweet xml
         */ 
        private function handleTweetsLoaded(event:Event):void
        {
            var returnArray:Array = responseParser(urlLoader.data);
            
            broadcastTweetEvent(TweetEvent.COMPLETE,returnArray);
        }
        
        /**
         * @private
         * Handles any IOError that might occur and dispatches it to the listener
         */ 
        private function handleTweetsLoadingFailed(event:IOErrorEvent):void
        {
            broadcastTweetEvent(TweetEvent.FAILED,null,event.text);
        }
        
        /**
         * @private
         * Handles any Security related Errors and dispatches it to the listener
         */ 
        private function handleSecurityError(event:SecurityErrorEvent):void
        {
            broadcastTweetEvent(TweetEvent.FAILED,null,event.text);
        }

        /**
         * @private
         * Merely for Informational purposes. Dispatches the status to the listener
         */ 
        private function handleHTTPStatus(event:HTTPStatusEvent):void
        {
            broadcastTweetEvent(TweetEvent.STATUS,null,String(event.status));
        }
    }
}