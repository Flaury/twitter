package com.swfjunkie.tweetr.data
{
    import com.swfjunkie.tweetr.data.objects.DirectMessageData;
    import com.swfjunkie.tweetr.data.objects.ExtendedUserData;
    import com.swfjunkie.tweetr.data.objects.HashData;
    import com.swfjunkie.tweetr.data.objects.SearchResultData;
    import com.swfjunkie.tweetr.data.objects.StatusData;
    import com.swfjunkie.tweetr.data.objects.TrendData;
    import com.swfjunkie.tweetr.data.objects.UserData;
    import com.swfjunkie.tweetr.utils.TweetUtil;
    
    /**
     * Static Class doing nothing more than Parsing to Data Objects
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
     
    public class DataParser 
    {
        //--------------------------------------------------------------------------
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------
        //--------------------------------------------------------------------------
        //
        //  Initialization
        //
        //--------------------------------------------------------------------------
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        //--------------------------------------------------------------------------
        //
        //  Additional getters and setters
        //
        //--------------------------------------------------------------------------
        //--------------------------------------------------------------------------
        //
        // Overridden API
        //
        //--------------------------------------------------------------------------
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
        /**
         * Parses a Status XML to StatusData Objects
         * @param xml        The XML Response from Twitter
         * @param isArray    Boolean indicating if we have received an array of elements in the XML
         * @return An Array filled with StatusData's
         */ 
        public static function parseStatuses(xml:XML, isArray:Boolean = false):Array
        {
            var statusData:StatusData;
            var userData:UserData;
            var array:Array = [];
            var list:XMLList = (isArray) ? xml.status : null;
            var n:int = (isArray) ? list.length() : 1;
            
            for (var i:int = 0; i < n; i++)
            {
                var node:XML = (isArray) ? list[i] as XML : xml;
            
                statusData = new StatusData(node.created_at,
                                            node.id,
                                            TweetUtil.tidyTweet(node.text),
                                            node.source,
                                            TweetUtil.stringToBool(node.truncated),
                                            node.in_reply_to_status_id,
                                            node.in_reply_to_user_id,
                                            TweetUtil.stringToBool(node.favorited),
                                            node.in_reply_to_screen_name);
            
                userData = new UserData(node.user.id,
                                        node.user.name,
                                        node.user.screen_name,
                                        node.user.location,
                                        node.user.description,
                                        node.user.profile_image_url,
                                        node.user.url,
                                        TweetUtil.stringToBool(node.user.protected),
                                        node.user.followers_count); 
                                                                         
                statusData.user = userData;
                array.push(statusData);
            }
            return array;
        }
        /**
         * Parses a Direct Message XML to DirectMessageData Objects
         * @param xml        The XML Response from Twitter
         * @param isArray    Boolean indicating if we have received an array of elements in the XML
         * @return An Array filled with DirectMessageData's
         */ 
        public static function parseDirectMessages(xml:XML, isArray:Boolean = false):Array
        {
            var senderData:UserData;
            var recipientData:UserData;
            var directData:DirectMessageData;
            var array:Array = [];
            var list:XMLList = (isArray) ? xml.direct_message : null;
            var n:int = (isArray) ? list.length() : 1;
            
            for (var i:int = 0; i < n; i++)
            {
                var node:XML = (isArray) ? list[i] as XML : xml;
            
                directData = new DirectMessageData(
                                                    node.id,
                                                    node.sender_id,
                                                    node.text,
                                                    node.recipient_id,
                                                    node.created_at,
                                                    node.sender_screen_name,
                                                    node.recipient_screen_name
                                                  );
                senderData = new UserData(
                                            node.sender.id,
                                            node.sender.name,
                                            node.sender.screen_name,
                                            node.sender.location,
                                            node.sender.description,
                                            node.sender.profile_image_url,
                                            node.sender.url,
                                            TweetUtil.stringToBool(node.sender.protected),
                                            node.sender.followers_count
                                          );
                                          
                recipientData = new UserData(
                                            node.recipient.id,
                                            node.recipient.name,
                                            node.recipient.screen_name,
                                            node.recipient.location,
                                            node.recipient.description,
                                            node.recipient.profile_image_url,
                                            node.recipient.url,
                                            TweetUtil.stringToBool(node.recipient.protected),
                                            node.recipient.followers_count
                                            );         
                                                            
                directData.sender = senderData;
                directData.recipient = recipientData;
                array.push(directData);
            }
            return array;   
        }
        
         /**
         * Parses a User XML to either UserData or ExtendedUserData Objects
         * @param xml        The XML Response from Twitter
         * @param isArray    Boolean indicating if we have received an array of elements in the XML
         * @param extended   Should extended User Element be retrieved
         * @return An Array filled with either UserData or ExtendedUserData Objects
         */ 
        public static function parseUserInfos(xml:XML, isArray:Boolean = false, extended:Boolean = false):Array
        {
            var statusData:StatusData;
            var userData:UserData;
            var extendedData:ExtendedUserData;
            var array:Array = [];
            var list:XMLList = (isArray) ? xml.user : null;
            var n:int = (isArray) ? list.length() : 1;
            
            for (var i:int = 0; i < n; i++)
            {
                var node:XML = (isArray) ? list[i] as XML : xml;
            
                statusData = new StatusData(node.status.created_at,
                                            node.status.id,
                                            TweetUtil.tidyTweet(node.status.text),
                                            node.status.source,
                                            TweetUtil.stringToBool(node.status.truncated),
                                            node.status.in_reply_to_status_id,
                                            node.status.in_reply_to_user_id,
                                            TweetUtil.stringToBool(node.status.favorited),
                                            node.status.in_reply_to_screen_name);
            
                userData = new UserData(node.id,
                                        node.name,
                                        node.screen_name,
                                        node.location,
                                        node.description,
                                        node.profile_image_url,
                                        node.url,
                                        TweetUtil.stringToBool(node.protected),
                                        node.followers_count);
                                                                          
                userData.lastStatus= statusData;
                
                if (extended)
                {
                    extendedData = new ExtendedUserData(
                                                        parseInt("0x"+node.profile_background_color),
                                                        parseInt("0x"+node.profile_text_color),
                                                        parseInt("0x"+node.profile_link_color),
                                                        parseInt("0x"+node.profile_sidebar_fill_color),
                                                        parseInt("0x"+node.profile_sidebar_border_color),
                                                        node.friends_count,
                                                        node.created_at,
                                                        node.favourites_count,
                                                        node.utc_offset,
                                                        node.time_zone,
                                                        node.profile_background_image_url,
                                                        TweetUtil.stringToBool(node.profile_background_tile),
                                                        TweetUtil.stringToBool(node.following),
                                                        TweetUtil.stringToBool(node.notificactions),
                                                        node.statuses_count
                                                        )
                    userData.extended = extendedData;
                }
                array.push(userData);
            }
            return array;   
        }
        
        /**
         * Parses a Hash XML to HashData Objects
         * @param xml  The XML Response from Twitter
         * @return An Array filled with HashData Objects
         */ 
        public static function parseHash(xml:XML):Array
        {
            var array:Array = [];
            var hashData:HashData = new HashData(xml['remaining-hits'], xml['hourly-limit'], xml['reset-time-in-seconds']);
            array.push(hashData);
            return array;   
        }
        
        
        /**
         * Parses out Boolean value from a <code>hasFriendship</code> Request
         * @param xml  The XML Response from Twitter
         * @return A Boolean value
         */ 
        public static function parseBoolean(xml:XML):Array
        {
            var array:Array = [];
            array.push(TweetUtil.stringToBool(xml.toString()));
            return array;   
        }
        
        /**
         * Parses a Searchresult XML to SearchResult Objects
         * @param xml  The XML Response from Twitter
         * @return An Array filled with SearchResult Objects
         */
        public static function parseSearchResults(xml:XML):Array
        {
            var ns:Namespace = new Namespace("http://www.w3.org/2005/Atom");
            var searchData:SearchResultData;
            var array:Array = [];
            var entry:XML;
            
            for each (entry in xml.ns::entry)
            {
                searchData = new SearchResultData();
                var str:String = entry.ns::id;
                var index:int = str.lastIndexOf(':');
                
                searchData.id = parseInt(str.substring(index+1, str.length-1));
                searchData.text = entry.ns::title;        
                searchData.createdAt = entry.ns::updated;
                searchData.userProfileImage = entry.ns::link[1].@href;
                searchData.link = entry.ns::link[0].@href;
                searchData.userLink = entry.ns::author.ns::uri;
                searchData.user = entry.ns::author.ns::name;
                
                array.push(searchData);
            }
            return array;
        }
        
        
        /**
         * Parses a Trend JSON to TrendData Objects
         * @param xml  The XML Response from Twitter
         * @return An Array filled with TrendData Objects
         */
        public static function parseTrendsResults(data:String):Array
        {
            var array:Array = [];
            var trendData:TrendData;
            var startIndex:int = String(data).indexOf("[");
            var endIndex:int = String(data).indexOf("]");
            var nameArr:Array = [];
            var urlArr:Array = [];
            var str:String = String(data).substring(startIndex+2,endIndex-1);
            var strArr:Array = str.split("},{");
            var i:int = 0;
            var n:int = strArr.length;
            
            for (i = 0; i < n; i++)
            {
                var tmp:Array = String(strArr[i]).split(",");
                var name:String = tmp[0].split('"')[3];
                var url:String = tmp[1].split('"')[3];
                
                nameArr.push(name);
                urlArr.push(TweetUtil.replace(url,"\\/","/"));
            }
            
            n = nameArr.length;
            for (i = 0; i < n; i++)
            {
                trendData = new TrendData(nameArr[i], urlArr[i]);
                array.push(trendData);
            }
            return array;
        }
        //--------------------------------------------------------------------------
        //
        //  Overridden methods: _SuperClassName_
        //
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        //
        //  Broadcasting
        //
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        //
        //  Eventhandling
        //
        //--------------------------------------------------------------------------
    }
}