//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  chaos_zone_exit
//group:   N/A
//used as: OnExit Aura script for Chaos Growth PLCs
//date:    Oct 15 2012
//author:  Glim

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oTarget = GetExitingObject();

    while( GetLocalInt( oTarget, "ChaosZone" ) == TRUE )
    {
        DeleteLocalInt( oTarget, "ChaosZone" );
    }
}
