/*  Bardic College - OnUsed script.

    --------
    Verbatim
    --------
    Allows for porting and other events when the player clicks on an object.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    101206  Aleph       Initial release.
    012307  Aleph       Twilight Stage revision.
    ----------------------------------------------------------------------------

*/


void main()
{
object oPC  = GetLastUsedBy();
object oWP1 = GetWaypointByTag("bc_portpoint_cordor");
object oWP2 = GetWaypointByTag("bc_portpoint_mystra");
location lLocation1 = GetLocation(oWP1);
location lLocation2 = GetLocation(oWP2);

////////////////////////////////////////////////////
///  Click on painting in couryard, port to theater.
////////////////////////////////////////////////////

if(GetTag(OBJECT_SELF) == "bc_cordorpaint")
{
   object oItem = GetFirstItemInInventory(oPC);

   while (GetIsObjectValid(oItem) == TRUE)
   {
      if(GetName(oItem) == "Mystic Quill")
      {
        AssignCommand( oPC, JumpToLocation( lLocation1 ) );
        break;
      }
      oItem = GetNextItemInInventory(oPC);
   }
}

////////////////////////////////////////////////////
///  Click on painting in couryard, port to theater.
////////////////////////////////////////////////////

if(GetTag(OBJECT_SELF) == "bc_mystranpaint")
{
   object oItem = GetFirstItemInInventory(oPC);
   while (GetIsObjectValid(oItem) == TRUE)
   {
      if(GetName(oItem) == "Mystic Quill")
      {
        AssignCommand(oPC,JumpToLocation(lLocation2));
        break;
      }
      oItem = GetNextItemInInventory(oPC);
   }
}


////////////////////////////////////////////////////
///  Click on mirror, port to Twilight Stage.
////////////////////////////////////////////////////

if(GetTag(OBJECT_SELF) == "bc_twilight_mirrorleft")
{
    AssignCommand(oPC,JumpToObject(GetObjectByTag("bc_twilight_wp_exitstageleft")));
}

if(GetTag(OBJECT_SELF) == "bc_twilight_mirrorright")
{
    AssignCommand(oPC,JumpToObject(GetObjectByTag("bc_twilight_wp_exitstageright")));
}

if(GetTag(OBJECT_SELF) == "bc_twilight_exitstageleft")
{
    AssignCommand(oPC,JumpToObject(GetObjectByTag("bc_twilight_wp_entstageleft")));
}

if(GetTag(OBJECT_SELF) == "bc_twilight_exitstageright")
{
    AssignCommand(oPC,JumpToObject(GetObjectByTag("bc_twilight_wp_entstageright")));
}


////////////////////////////////////////////////////
///  Click on wheel, get a fortune.
////////////////////////////////////////////////////

if(GetTag(OBJECT_SELF) == "bc_twilight_wheel")
{

int iWheel = d4();

switch(iWheel)

{

case 1:


AssignCommand(OBJECT_SELF, SpeakString ("You spin the wheel and it lands on...  Cups!  Now is the time to act on matters of love, artistic endeavors, or water."));

break;

case 2:

AssignCommand(OBJECT_SELF, SpeakString ("You spin the wheel and it lands on...  Swords!  Now is the time to act on matters of progess, intellectual pursuits, or air."));

break;

case 3:

AssignCommand(OBJECT_SELF, SpeakString ("You spin the wheel and it lands on...  Wands!  Now is the time to act on matters of desire, creativity, or fire."));

break;

case 4:

AssignCommand(OBJECT_SELF, SpeakString ("You spin the wheel and it lands on...  Coins!  Now is the time to act on matters of commerce, professional advancement, or earth."));

break;

}

}

}
