package 
{
    import com.adobe.viewsource.ViewSource;
    import com.swfjunkie.tweetr.Tweetr;
    import com.swfjunkie.tweetr.data.objects.StatusData;
    import com.swfjunkie.tweetr.events.TweetEvent;
    import com.swfjunkie.tweetr.utils.TweetUtil;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.filters.DropShadowFilter;
    import flash.text.StyleSheet;
    import flash.text.TextField;
    
    [SWF(frameRate="24", backgroundColor="0x666666")]
    
    /**
     * A simple pure AS3 Example
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
    public class Example extends Sprite 
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
        
        public function Example()
        {
            ViewSource.addMenuItem(this, "srcview/index.html");
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            init();
        }
        /**
         * @private
         * Initializes the instance.
         */
        private function init():void
        {
            tweetr = new Tweetr();
            tweetr.serviceHost = "labs.swfjunkie.com/tweetr/proxy";
            
            tweetr.addEventListener(TweetEvent.COMPLETE, handleTweetsLoaded);
            tweetr.addEventListener(TweetEvent.FAILED, handleTweetsFail);
                
            tweetr.getPublicTimeLine();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        private var tweetr:Tweetr;
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
        /**
         * @private
         * Show a Tweet
         */ 
        private function showTweet(tweet:StatusData):void
        {
            var bg:Sprite = new Sprite();
            bg.graphics.lineStyle(1, 0x888888,1,true);
            bg.graphics.beginFill(0,.4);
            bg.graphics.drawRoundRect(0, 0, 350, 200, 15, 15);
            bg.graphics.endFill();
            bg.filters = [new DropShadowFilter(7, 45, 0, .6, 4, 4, 1, 1)]; 
            
            var styles:StyleSheet = new StyleSheet();
            styles.setStyle(".tweet", {color: "#FFFFFF", fontFamily: "Georgia", fontSize: "12"});
            styles.setStyle(".age", {fontStyle: "italic", fontSize: "10"});
            
            var textField:TextField = new TextField();
            textField.styleSheet = styles;
            textField.width = 310;
            textField.wordWrap = true;
            textField.multiline = true;
            textField.htmlText = "<img src=\""+tweet.user.profileImageUrl+"\" height=\"50\" width=\"50\">" + 
                                 "<p class=\"tweet\"><b>" + 
                                 "<a target=\"_blank\" href=\"http://twitter.com/"+tweet.user.screenName+"\">@"+tweet.user.screenName+"</a></b> " + 
                                 ""+tweet.text + "" + 
                                 "<br><span class=\"age\">"+TweetUtil.returnTweetAge(tweet.createdAt)+"</span></p>";
            
            bg.height = (textField.height < 100) ? 120 : textField.height + 20;
            bg.x = stage.stageWidth/2 - bg.width/2;
            bg.y = stage.stageHeight/2 - bg.height/2;
            textField.x = bg.x + 20;
            textField.y = bg.y + 20;
            
            addChild(bg);
            addChild(textField);
        }
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
        private function handleTweetsLoaded(event:TweetEvent):void
        {
            var tweet:StatusData = event.responseArray[0] as StatusData;
            showTweet(tweet);
        }
        
        private function handleTweetsFail(event:TweetEvent):void
        {
            // handle error here   
        }
    }
}