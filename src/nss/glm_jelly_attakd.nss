//::///////////////////////////////////////////////
//:: glm_jelly_attakd
//:://////////////////////////////////////////////
/*
    OnAttacked script for any jelly or pudding
    type creatures. If the Target is dealt base
    weapon slashing or piercing damage, divide
    into smaller jellies.
*/
//:://////////////////////////////////////////////
//:: Created By: Glim
//:: Created On: 03/20/13
//:://////////////////////////////////////////////

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"
#include "x2_i0_spells"
#include "glm_jellysplit"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter     = OBJECT_SELF;
    object oAttacker    = GetLastAttacker();
    object oWeapon      = GetLastWeaponUsed( oAttacker );
    object oTarget      = GetLocalObject( oCritter, L_CURRENTTARGET );
    int nCount          = GetLocalInt( oCritter, L_INACTIVE );
    int nResult;
    int nReputation     = GetReputation( oAttacker, oCritter );
    int nConfused       = GetHasEffect( EFFECT_TYPE_CONFUSED, oAttacker );
    int nDominated      = GetHasEffect( EFFECT_TYPE_DOMINATED, oAttacker );
    int nHP             = GetCurrentHitPoints( oCritter );
    int nSplit          = 0;

    // if the creature can’t split further or if its HP is being leveled out,
    // do regular script and then abort
    if ( GetLocalInt( oCritter, "SplitLimit" ) == 1 || GetLocalInt( oCritter, "NoLoop" ) == 1 )
    {
        // do regular OnDamage events and then stop
        //set reputation, or set temporary enemy
        if ( GetIsPC( oAttacker ) || GetIsPC( GetMaster( oAttacker ) ) ){

            if ( nReputation >= REPUTATION_TYPE_FRIEND ){
                if ( nDominated ){

                    SetIsTemporaryEnemy( oAttacker, oCritter, TRUE, RoundsToSeconds(10) );

                }
                else{

                    AdjustReputation( oAttacker, oCritter, -100 );

                }
            }
            else if ( !nDominated ){

                AdjustReputation( oAttacker, oCritter, -100 );

            }
        }
        else{

            if ( nConfused && ( nReputation >= REPUTATION_TYPE_FRIEND ) ){

                SetIsTemporaryEnemy( oAttacker, oCritter, TRUE, RoundsToSeconds(10) );

            }
            else{

                AdjustReputation( oAttacker, oCritter, -100 );

            }
        }

        if ( nCount > 0 ){

            SetLocalObject( oCritter, L_CURRENTTARGET, oAttacker );

            nResult = PerformAction( OBJECT_SELF, "ds_ai2_attacked" );

            if ( nResult == -1 && GetIsObjectValid( oAttacker ) ){

                ActionMoveToObject( oAttacker, TRUE, 10.0 );
            }

            SpeakString( M_ATTACKED, TALKVOLUME_SILENT_TALK );
        }
        else if ( oTarget != oAttacker ){

            if ( GetObjectSeen( oAttacker, oCritter ) && d100() < 25 ){

                SetLocalObject( oCritter, L_CURRENTTARGET, oAttacker );
            }
        }

        return;
    }

    // check creature weapon type
    if( GetBaseItemType( oWeapon ) == BASE_ITEM_CBLUDGWEAPON && GetLocalInt( oCritter, "SplitBlunt" ) == 1 )
    {
        nSplit = 1;
    }
    if( GetBaseItemType( oWeapon ) == BASE_ITEM_CPIERCWEAPON && GetLocalInt( oCritter, "SplitPierce" ) == 1 )
    {
        nSplit = 1;
    }
    if( GetBaseItemType( oWeapon ) == BASE_ITEM_CSLASHWEAPON && GetLocalInt( oCritter, "SplitSlash" ) == 1 )
    {
        nSplit = 1;
    }
    if( GetBaseItemType( oWeapon ) == BASE_ITEM_CSLSHPRCWEAP )
    {
        if( GetLocalInt( oCritter, "SplitSlash" ) == 1 || GetLocalInt( oCritter, "SplitPierce" ) == 1 )
        {
            nSplit = 1;
        }
    }
    // check basic weapon type
    if( GetSlashingWeapon( oWeapon ) == TRUE && GetLocalInt( oCritter, "SplitSlash" ) == 1 )
    {
        nSplit = 1;
    }
    if( GetPiercingWeapon( oWeapon ) == TRUE && GetLocalInt( oCritter, "SplitPierce" ) == 1 )
    {
        nSplit = 1;
    }
    if( GetBludgeoningWeapon( oWeapon ) == TRUE && GetLocalInt( oCritter, "SplitBlunt" ) == 1 )
    {
        nSplit = 1;
    }
    //if any of the above categories are found to be true, then split the critter
    if( nSplit == 1 )
    {
        DelayCommand( 1.0, AssignCommand( oAttacker, ClearAllActions( TRUE ) ) );
        SplitCreature( oCritter, nHP );
    }

    //continue with standard script
    //set reputation, or set temporary enemy
    if ( GetIsPC( oAttacker ) || GetIsPC( GetMaster( oAttacker ) ) ){

        if ( nReputation >= REPUTATION_TYPE_FRIEND ){
            if ( nDominated ){

                SetIsTemporaryEnemy( oAttacker, oCritter, TRUE, RoundsToSeconds(10) );

            }
            else{

                AdjustReputation( oAttacker, oCritter, -100 );

            }
        }
        else if ( !nDominated ){

            AdjustReputation( oAttacker, oCritter, -100 );

        }
    }
    else{

        if ( nConfused && ( nReputation >= REPUTATION_TYPE_FRIEND ) ){

            SetIsTemporaryEnemy( oAttacker, oCritter, TRUE, RoundsToSeconds(10) );

        }
        else{

            AdjustReputation( oAttacker, oCritter, -100 );

        }
    }

    if ( nCount > 0 ){

        SetLocalObject( oCritter, L_CURRENTTARGET, oAttacker );

        nResult = PerformAction( OBJECT_SELF, "ds_ai2_attacked" );

        if ( nResult == -1 && GetIsObjectValid( oAttacker ) ){

            ActionMoveToObject( oAttacker, TRUE, 10.0 );
        }

        SpeakString( M_ATTACKED, TALKVOLUME_SILENT_TALK );
    }
    else if ( oTarget != oAttacker ){

        if ( GetObjectSeen( oAttacker, oCritter ) && d100() < 25 ){

            SetLocalObject( oCritter, L_CURRENTTARGET, oAttacker );
        }
    }
}
