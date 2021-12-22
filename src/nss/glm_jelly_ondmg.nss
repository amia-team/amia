//::///////////////////////////////////////////////
//:: glm_jelly_ondmg
//:://////////////////////////////////////////////
/*
    OnDamaged script for any jelly or pudding
    type creatures. If the Target is dealt slashing,
    piercing or electrical damage, divide into
    smaller jellies.
*/
//:://////////////////////////////////////////////
//:: Created By: Glim
//:: Created On: 03/20/13
//:://////////////////////////////////////////////


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"
#include "glm_jellysplit"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter     = OBJECT_SELF;
    object oDamager     = GetLastDamager();
    object oWeapon      = GetLastWeaponUsed( oDamager );
    object oTarget      = GetLocalObject( oCritter, L_CURRENTTARGET );
    string sArchetype   = GetLocalString( oCritter, L_ARCHETYPE );
    int nReaction       = GetReaction( oCritter, oDamager );
    int nHP             = GetCurrentHitPoints( oCritter );
    int nSplit          = 0;

    // instead of putting in a custom OnSpawn, check when first damaged to see if
    // custscene ghost effect has already been applied or not
    if( GetLocalInt( oCritter, "CSGhost" ) != 1 )
    {
        effect eGhost = EffectCutsceneGhost();
               eGhost = SupernaturalEffect( eGhost );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eGhost, oCritter );
        SetLocalInt( oCritter, "CSGhost", 1 );
    }

    // if the creature can’t split further or if its HP is being leveled out,
    // do regular script and then abort
    if ( GetLocalInt( oCritter, "SplitLimit" ) == 1 || GetLocalInt( oCritter, "NoLoop" ) == 1 )
    {
        // do regular OnDamage events and then stop
        if ( nReaction == 2 ){

            if ( GetDistanceBetween( oCritter, oDamager ) < 5.0 ){

                ClearAllActions();
                ActionMoveAwayFromObject( oDamager, TRUE, 10.0 );
                SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
            }
        }
        else if ( nReaction == 1 ){

            if ( oTarget != oDamager ){

                if ( GetObjectSeen( oDamager, oCritter ) && ( d100() - 20 ) < 25 ){

                    SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
                }
            }
        }

        return;
    }

    // check elemental damage types
    if( GetDamageDealtByType( DAMAGE_TYPE_ACID ) != -1 && GetLocalInt( oCritter, "SplitAcid" ) == 1 )
    {
        nSplit = 1;
    }
    if( GetDamageDealtByType( DAMAGE_TYPE_COLD ) != -1 && GetLocalInt( oCritter, "SplitCold" ) == 1 )
    {
        nSplit = 1;
    }
    if( GetDamageDealtByType( DAMAGE_TYPE_ELECTRICAL ) != -1 && GetLocalInt( oCritter, "SplitElectric" ) == 1 )
    {
        nSplit = 1;
    }
    if( GetDamageDealtByType( DAMAGE_TYPE_FIRE ) != -1 && GetLocalInt( oCritter, "SplitFire" ) == 1 )
    {
        nSplit = 1;
    }
    // check physical damage types
    if( GetDamageDealtByType( DAMAGE_TYPE_PIERCING ) != -1 && GetLocalInt( oCritter, "SplitPierce" ) == 1 )
    {
        nSplit = 1;
    }
    if( GetDamageDealtByType( DAMAGE_TYPE_SLASHING ) != -1 && GetLocalInt( oCritter, "SplitSlash" ) == 1 )
    {
        nSplit = 1;
    }
    if( GetDamageDealtByType( DAMAGE_TYPE_BLUDGEONING ) != -1 && GetLocalInt( oCritter, "SplitBlunt" ) == 1 )
    {
        nSplit = 1;
    }

    //if any of the above categories are found to be true, then split the critter
    if( nSplit == 1 )
    {
        AssignCommand( oDamager, ClearAllActions( TRUE ) );
        SplitCreature( oCritter, nHP );
        SpeakString( "**whatever you tried to hurt the creature with only seemed to make it split into pieces instead!**" );
    }

    //continue with standard script
    if ( nReaction == 2 ){

        if ( GetDistanceBetween( oCritter, oDamager ) < 5.0 ){

            ClearAllActions();
            ActionMoveAwayFromObject( oDamager, TRUE, 10.0 );
            SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
        }
    }
    else if ( nReaction == 1 ){

        if ( oTarget != oDamager ){

            if ( GetObjectSeen( oDamager, oCritter ) && ( d100() - 20 ) < 25 ){

                SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
            }
        }
    }
}
