void main()
{
    object pc        = GetLastClosedBy();
    object book      = GetFirstItemInInventory(OBJECT_SELF);
    string book1Tag  = GetLocalString(OBJECT_SELF, "book1");
    string book2Tag  = GetLocalString(OBJECT_SELF, "book2");
    string book3Tag  = GetLocalString(OBJECT_SELF, "book3");
    string book4Tag  = GetLocalString(OBJECT_SELF, "book4");
    object book1     = GetObjectByTag(book1Tag,0);
    object book2     = GetObjectByTag(book2Tag,0);
    object book3     = GetObjectByTag(book3Tag,0);
    object book4     = GetObjectByTag(book4Tag,0);
    string winWP     = GetLocalString(OBJECT_SELF, "jumpWP");
    location winJump = GetLocation(GetWaypointByTag(winWP));

    if ((book == book1) && (GetIsObjectValid(book))){
        book = GetNextItemInInventory(OBJECT_SELF);
    if ((book == book2) && (GetIsObjectValid(book)))	{
        book = GetNextItemInInventory(OBJECT_SELF);
    if ((book == book3) && (GetIsObjectValid(book)))		{
        book = GetNextItemInInventory(OBJECT_SELF);
 			if ((book == book4) && (GetIsObjectValid(book))){

    AssignCommand(pc,ActionJumpToLocation(winJump));
    			}
    		}
    	}
    }
}
