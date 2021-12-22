// nw_s0_darknessb - Darkness (On Exit)
// Copyright (c) 2001 Bioware Corp.
//
// Creates a globe of darkness around those in the area of effect.
//
// Rundown:
// Step 1 - Checks to see if overlapping Darkness AoEs are in play.
//              - If so, leaves Darkness in place, reduces tracking number and stops.
// Step 2 - Remove all Darkness effects (invisibility and blindness).
// Step 3 - Reset overlap tracking to zero.
//
// Revision History
// Date       Name                Description
// ---------- ------------------  --------------------------------------------
// 02/28/2002 Preston Watamaniuk  Initial Release
// 08/16/2003 jpavelch            Added handling for subraces.
// 12/10/2005 kfw                 disabled SEI, True Race compatibility added
// 2008/07/05 disco               new blindness/underwater system
// 2008/07/05 disco               new racial trait system
// 2013/04/09 Glim                Fixes for overlapping Darkness spells and Ultravision

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "amia_include"



void main()
{

    object oTarget      = GetExitingObject();
    string szRace       = GetStringLowerCase(GetSubRace(oTarget));
    object oArea        = GetArea(oTarget);
    object oCreator     = GetAreaOfEffectCreator();
    int nTracking       = GetLocalInt( oTarget, "Darkness" );

    int bValid = FALSE;

    //if a second Darkness spell is in effect, do not remove OnExit
    if( nTracking >= 2 )
    {
        //Reduce the tracking variable for next time
        nTracking = nTracking - 1;
        SetLocalInt( oTarget, "Darkness", nTracking );
        return;
    }

    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);

    while (GetIsEffectValid(eAOE))
    {
        //Removes the Darkness (blindness) portion of the effect
        if( GetEffectType( eAOE ) == EFFECT_TYPE_DARKNESS )
        {
            RemoveEffect(oTarget, eAOE);
        }
        //Removes the Darkness (invisibility) portion of the effect
        else if( GetEffectType( eAOE ) == EFFECT_TYPE_INVISIBILITY && GetEffectDurationType( eAOE ) == DURATION_TYPE_PERMANENT )
        {
            RemoveEffect(oTarget, eAOE);
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }

    /*  True Races vulnerability handling    */
    ApplyAreaAndRaceEffects( oTarget, 0, 2 );

    //Reduce the tracking variable for next time
    SetLocalInt( oTarget, "Darkness", 0 );
}
