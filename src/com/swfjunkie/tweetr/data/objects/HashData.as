package com.swfjunkie.tweetr.data.objects
{	
    /**
     * Hash Data Object
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class HashData
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
        public function HashData(remainingHits:int, hourlyLimit:int, resetTimeInSeconds:int) 
        {
            this.remainingHits = remainingHits;
            this.hourlyLimit = hourlyLimit;
            this.resetTimeInSeconds = resetTimeInSeconds;
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        public var resetTimeInSeconds:int;
        public var remainingHits:int;
        public var hourlyLimit:int;
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}