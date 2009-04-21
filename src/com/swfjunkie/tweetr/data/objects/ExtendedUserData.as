package com.swfjunkie.tweetr.data.objects
{	
    /**
     * Extended User Data Object
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class ExtendedUserData
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
        public function ExtendedUserData(
                                            profileBackgroundColor:int = 0,
                                            profileTextColor:int = 0,
                                            profileLinkColor:int = 0,
                                            profileSidebarFillColor:int = 0,
                                            profileSidebarBorderColor:int = 0,
                                            friendsCount:int = 0,
                                            createdAt:String = null,
                                            favouritesCount:int = 0,
                                            utcOffset:int = 0,
                                            timeZone:String = null,
                                            profileBackgroundImageUrl:String = null,
                                            profileBackgroundTile:Boolean = false,
                                            following:Boolean = false,
                                            notifications:Boolean = false,
                                            statusesCount:int = 0
                                        ) 
        {
            this.profileBackgroundColor = profileBackgroundColor;
            this.profileTextColor = profileTextColor;
            this.profileLinkColor = profileLinkColor;
            this.profileSidebarFillColor = profileSidebarFillColor;
            this.profileSidebarBorderColor = profileSidebarBorderColor;
            this.friendsCount = friendsCount;
            this.createdAt = createdAt;
            this.favouritesCount = favouritesCount;
            this.utcOffset = utcOffset;
            this.timeZone = timeZone;
            this.profileBackgroundImageUrl = profileBackgroundImageUrl;
            this.profileBackgroundTile = profileBackgroundTile;
            this.following = following;
            this.notifications = notifications;
            this.statusesCount = statusesCount;
            
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        public var profileBackgroundColor:int;
        public var profileTextColor:int;
        public var profileLinkColor:int;
        public var profileSidebarFillColor:int;
        public var profileSidebarBorderColor:int;
        public var friendsCount:int;
        public var createdAt:String;
        public var favouritesCount:int;
        public var utcOffset:int;
        public var timeZone:String;
        public var profileBackgroundImageUrl:String;
        public var profileBackgroundTile:Boolean;
        public var following:Boolean;
        public var notifications:Boolean;
        public var statusesCount:int;
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}