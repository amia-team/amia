/*
  Exit script for the tunnels that lead to the Purple Worm Arena
  - Maverick00053
*/

void main()
{
   object oPLC = OBJECT_SELF;
   object oPC = GetLastUsedBy();
   object oTrigger = GetObjectByTag("wormtunnelrandom");
   object oWP  = GetWaypointByTag("purplewormenarrival");
   int nSetOne = GetLocalInt(oTrigger,"setOne");
   int nSetTwo = GetLocalInt(oTrigger,"setTwo");
   int nTunnel = GetLocalInt(oPLC,"tunnel");

   if((nSetOne==nTunnel) || (nSetTwo==nTunnel))
   {
    DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );
   }
   else
   {
     SpeakString("*You venture through the tunnel for a long time and eventually find a dead end and return*");
   }


}
