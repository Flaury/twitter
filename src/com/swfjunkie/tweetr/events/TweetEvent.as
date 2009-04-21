package com.swfjunkie.tweetr.events
{
	import flash.events.Event;
	
    /**
     * Tweeter Event Class
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class TweetEvent extends Event
    {
        //--------------------------------------------------------------------------
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------
        /**
		 * <p>The event returns the following properties:</p>
		 * <table class=innertable>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td>responseArray</td><td>Array filled with Data Objects containing the results of your request</td></tr>
		 * </table>
		 *
		 * @eventType complete
		 */
        public static const COMPLETE:String = "complete";
        /**
		 * <p>The event returns the following properties:</p>
		 * <table class=innertable>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td>info</td><td>Contains the Error Message returned</td></tr>
		 * </table>
		 *
		 * @eventType failed
		 */
        public static const FAILED:String = "failed";
        /**
		 * <p>The event returns the following properties:</p>
		 * <table class=innertable>
		 * <tr><th>Property</th><th>Value</th></tr>
		 * <tr><td>info</td><td>Contains the HTTP Status</td></tr>
		 * </table>
		 *
		 * @eventType status
		 */
        public static const STATUS:String = "status";
        //--------------------------------------------------------------------------
        //
        //  Initialization
        //
        //--------------------------------------------------------------------------
        /**
         * Creates a TweetEvent object to pass as a parameter to event listeners.
         * @param type               The type of the event, accessible as <code>TweetEvent.type</code>.
         * @param bubbles            Determines whether the Event object participates in the bubbling stage of the event flow. The default value is <code>false</code>.
         * @param cancelable         Determines whether the Event object can be canceled. The default values is <code>false</code>. 
         * @param responseArray      An Array filled with Data Object returned after a succesful twitter request.
         * @param info               A Text Message containing information when a request fails or the status of your http request.
         */ 
        public function TweetEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, responseArray:Array = null, info:String = null) 
        {
			super(type, bubbles, cancelable);
			this.responseArray = responseArray;
			this.info = info;
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        /** An Array filled with Data Object returned after a succesful twitter request */
        public var responseArray:Array;
        /** A Text Message containing information when a request fails or the status of your http request */
        public var info:String;
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        /** @private */
        override public function toString():String
        {
        	return "[Event type=\""+type+"\"]";
        }
    }
}