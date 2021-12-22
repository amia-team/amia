// Casts Haste on self for 1 round per WM level, or others for 2 rounds per WM level.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/10/2011 PaladinOfSune    Initial Release

#include "x2_inc_switches"
#include "x2_inc_itemprop"

void ActivateItem()
{
    object oPC          = GetItemActivator();
    object oTarget      = GetItemActivatedTarget();
    location lTarget    = GetItemActivatedTargetLocation();
    int nLevel          = GetLevelByClass( CLASS_TYPE_WEAPON_MASTER, oPC );
    float fDur          = RoundsToSeconds( nLevel );

    // The old method only checked for one feat use left... this ensures the PC has three.
    int x;
    for ( x = 0; x < 3; x++ ) {
        if( !GetHasFeat( FEAT_KI_DAMAGE, oPC ) ) {
            FloatingTextStringOnCreature( "You do not have enough uses of Ki Damage to use this ability.", oPC, FALSE );
            return;
        }
        DecrementRemainingFeatUses( oPC, FEAT_KI_DAMAGE );
    }

    // Visual effects and Haste.
    effect eHaste   = EffectHaste();
    effect eVis     = EffectVisualEffect( VFX_IMP_HASTE );
    effect eVis2    = EffectVisualEffect( VFX_FNF_LOS_NORMAL_30 );

    // Undispellable.
    ExtraordinaryEffect( eHaste );

    if( oPC == oTarget )
    {
        // Apply it.
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHaste, oPC, fDur );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
    }
    else
    {
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis2, lTarget );
        oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget );
        while( GetIsObjectValid( oTarget ) )
        {
            //Make faction check on the target
            if( GetIsFriend( oTarget ) && oTarget != oPC )
            {
                DelayCommand( 0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHaste, oTarget, fDur * 2 ) );
                DelayCommand( 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget ) );
            }
            //Select the next target within the spell shape.
            oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget );
        }
    }
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
