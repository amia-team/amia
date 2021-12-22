/*  i_bx_dc_items_1

--------
Verbatim
--------
Pools custom item request scripts

---------
Changelog
---------

Date      Name      Reason
------------------------------------------------------------------
10/14/2007 killA    Added Ger's Hymn
10/16/2007 killA    Added Tormaks Speed of Thought
10/23/2007 killA    Added Garou's Song
02/08/2011 PoS      Rewrote Speed of Thought, lots of errors.
------------------------------------------------------------------

-----------------------
Item Name Reference Log
-----------------------

Player          Name            Function
------------------------------------------------------------------
Gers    Hymn of Enforced Rest   Hymn of Enforced Rest(oPC, oTarget)
Tormak  Speed of Thought        Speed of Thought(oPC,  oTarget )
Garou   Dra'kil Song            Drakil Song(oPC)
------------------------------------------------------------------


*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x0_i0_spells"
#include "amia_include"
#include "inc_ds_info"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void HymnofEnforcedRest( object oPC, object oTarget );
void SpeedOfThought( object oPC );
void DrakilSong( object oPC, object oTarget, location lTarget );
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch ( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();

            if( sItemName == "Hymn of Enforced Rest"){

                     HymnofEnforcedRest( oPC, oTarget );
            }
            if( sItemName == "Speed of Thought"){

                     SpeedOfThought( oPC );
            }
            if( sItemName == "Drakil Song"){

                     DrakilSong( oPC, oTarget, lTarget );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
//-------------------------------------------------------------------------------
// Functions - See Subheading for individual scripts
//-------------------------------------------------------------------------------

// ---------------------
// Gers's Hymn of Enforced Rest
// ---------------------

void HymnofEnforcedRest( object oPC, object oTarget )
{

     // Determines if it's a weapon or PC being targeted.

    object oMyWeapon;

    if ((GetIsPC(oTarget) || GetIsDM(oTarget))) {
     oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    }

    else{

    if ( IPGetIsMeleeWeapon(oTarget))
     oMyWeapon  = oTarget;
    }

   // If PC has no Bard Songs left the script ends.

    if ( !GetIsObjectValid(oTarget)) {
       SendMessageToPC( oPC, "You need to target something!" );
       return;
    }

     if ( GetItemPossessor(oMyWeapon) != oPC ) {
       SendMessageToPC( oPC, "You may only target your own items!" );
       return;
    }

    if ( !GetHasFeat(FEAT_BARD_SONGS, oPC) ) {
       SendMessageToPCByStrRef( oPC, 40063 );
       return;
    }

   // Variables for the item Properties and Duration.

   itemproperty ipDamage =

       ItemPropertyDamageBonus(
           IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_2d4);
           float fDuration = 300.0f;

  // Adding the damage and Duration

   IPSafeAddItemProperty(
       oMyWeapon,
       ipDamage,
       fDuration,
       X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,
       FALSE,
       FALSE);

   // VFX

       ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
       EffectVisualEffect(VFX_DUR_AURA_PULSE_CYAN_GREEN),
       oPC,
       300.0f);


   // Decrement the remaining uses of bard song.

   DecrementRemainingFeatUses(
      oPC,
      FEAT_BARD_SONGS);
     }

// ---------------------
// Tormak's Speed of thought
// ---------------------

void SpeedOfThought( object oPC )
{
    int nLevel  = GetLevelByClass( CLASS_TYPE_WEAPON_MASTER, oPC );
    float fDur  = RoundsToSeconds( nLevel );

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
    effect eDur1    = EffectVisualEffect( VFX_DUR_GHOST_SMOKE_2 );
    effect eDur2    = EffectVisualEffect( VFX_DUR_AURA_PULSE_GREY_WHITE );
    effect eVis     = EffectVisualEffect( VFX_IMP_HEALING_L );

    // Link it all together.
    effect eLink    = EffectLinkEffects( eHaste, eDur1 );
           eLink    = EffectLinkEffects( eDur2, eLink );

    // Undispellable.
    ExtraordinaryEffect( eLink );

    // Apply it.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, fDur );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
}

// --------------------------
// Dra'kils Song
// --------------------------

void DrakilSong( object oPC, object oTarget, location lTarget ){

    //info function
    ListEffects( oPC, oPC );

    if ( GetIsBlocked( oPC, "drsong" ) > 0 ){

        return;
    }
    else{

        SetBlockTime( oPC, 2, 30, "drsong" );
    }

    //Can't sing if Silenced.
    if  ( GetHasEffect( EFFECT_TYPE_SILENCE, oPC ) ){

        FloatingTextStrRefOnCreature( 85764, oPC ); return;
    }

    //Can't sing if lacking in Bardsongs.
    if ( !GetHasFeat(FEAT_BARD_SONGS, oPC ) ){

        SendMessageToPCByStrRef( oPC, 40063 );
        return;
    }

    //Visual effects.
    effect eEyes    = EffectVisualEffect( VFX_EYES_RED_FLAME_ELF_MALE );
    effect eCurse   = EffectVisualEffect( VFX_FNF_LOS_EVIL_30 );
    effect eNotes   = EffectVisualEffect( VFX_DUR_BARD_SONG );
    effect eImpact  = EffectVisualEffect( VFX_IMP_HEAD_SONIC );

    //Mechanical effects.
    effect eAC      = EffectACIncrease( 3, AC_DODGE_BONUS );

    //Link effects.
    effect eBard    = EffectLinkEffects( eNotes, eEyes );
    eBard           = EffectLinkEffects( eBard, eAC );

    //Set effect type to Ex
    eAC             = ExtraordinaryEffect( eAC );
    eBard           = ExtraordinaryEffect( eBard );

    //Decrement remaining Bardsongs before playing.
    DecrementRemainingFeatUses( oPC, FEAT_BARD_SONGS );

    //Flash Curse Song effect and play sounds.
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eCurse, GetLocation( oPC ) );
    AssignCommand( oPC, PlaySound( "as_cv_flute2" ) );

    //Get the first target in the radius around the caster.
    oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );

    while( GetIsObjectValid( oTarget ) ){

        if( GetIsFriend( oTarget, oPC ) ){

            SendMessageToPC( oPC, GetName( oTarget ) + " is friendly to you." );

            if ( !GetHasSpellEffect( EFFECT_TYPE_SILENCE, oTarget ) && !GetHasSpellEffect( EFFECT_TYPE_DEAF, oTarget ) ){

                //shoudl block
            }

            if ( oTarget == oPC ){

                SendMessageToPC( oPC, GetName( oTarget ) + " receives effect eBard." );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBard, oPC, 150.0 );
            }
            else{

                SendMessageToPC( oPC, GetName( oTarget ) + " receives effects eAC & eImpact." );

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eAC, oTarget, 150.0 );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
            }
        }

        //Get the next target in the specified area around the caster.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
    }
}


