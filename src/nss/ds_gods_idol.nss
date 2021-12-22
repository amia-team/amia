//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_gods_idol
//group:   deity system
//used as: OnUse and action script
//date:    may 25 2007
//author:  disco


//-----------------------------------------------------------------------------
// changes
//-----------------------------------------------------------------------------
//2007-06-22    disco   added timer
//2007-06-24    disco   added Druid, Paladin, etc support
//2008-08-04    disco   some fixes
//2008-08-05    disco   added DB support
//2008-08-05    disco   added pre-split domain fixes
//2009-11-28    disco   death domain fix
//2011-09-04    Selmak  Druids can remove fallen state by worshipping an idol
//                      for a valid druid deity, rangers and divine champions
//                      can remove fallen state by worshipping an idol for a
//                      valid deity
//2011-09-21    Selmak  Recompiled because of fixes in inc_ds_gods include
//2011-10-03    Selmak  Re-routes to deity room idol if old idol is worshipped
//2011-10-10    Selmak  Recompile: FindIdol uses updated NameToTag which
//                      capitalises the name supplied.  Also fixed a local
//                      variable "name" which was wrongly capitalised.  My bad.
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "inc_ds_records"
#include "inc_ds_gods"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    if ( GetIsPC( OBJECT_SELF ) ){

        //the script has been called by the idol convo or the rest menu

        object oPC      = OBJECT_SELF;
        int nNode       = GetLocalInt( oPC, "ds_node" );
        object oDummy   = GetLocalObject( oPC, "ds_idol" );

        if ( nNode == 5 ){

            //clean ds_idol
            DeleteLocalObject( oPC,"ds_idol" );
            return;

        }
        else if ( oDummy == OBJECT_INVALID ){

            //script has been called from the rest menu

            //SendMessageToPC( oPC, "[test: praying activated]" );
            Pray( oPC );
            return;
        }



        //Just in case we're dealing with an old idol, we go find the idol in
        //the deity room, based on the name variable for whichever idol has been
        //worshipped
        object oIdol    = FindIdol( oPC, GetLocalString( oDummy, "name" ));
        int nDruidDeity, nFallen;

        //SendMessageToPC( oPC, "[test: node = "+IntToString(nNode)+"]" );
        //SendMessageToPC( oPC, "[test: idol = "+GetName(oIdol)+"]" );


        if ( nNode == 1 && oIdol != OBJECT_INVALID ){

            //script has been called from the idol convo

            AssignCommand( oPC, PlayAnimation( ANIMATION_LOOPING_WORSHIP, 1.0, 30.0 ) );

            return;
        }
        else if ( nNode == 3 && oIdol != OBJECT_INVALID ){

            if ( GetHitDice( oPC ) > 10 && GetDeity( oPC ) != "" ){

                //feedback
                SendMessageToPC( oPC, "You can only swap deities under DM supervision after level 10!" );
            }
            else if ( MatchAlignment( oPC, oIdol ) == 1 ){

                //set the new god
                SetDeity( oPC, GetLocalString( oIdol, "name" ) );

                //save
                DelayCommand( 0.5, ExportSingleCharacter( oPC ) );

                //druids become unfallen if new deity supports druids
                if ( GetLevelByClass( CLASS_TYPE_DRUID, oPC ) ){
                    nDruidDeity = IsValidDruidGod( oIdol );
                    nFallen = GetLocalInt( oPC, "Fallen" );

                    if ( nDruidDeity && nFallen &&
                         !GetIsObjectValid( GetItemPossessedBy( oPC, "dg_fall" ) ) ){

                        //This removes the fallen state from the druid
                        DeleteLocalInt( oPC, "Fallen" );
                        SendMessageToPC( oPC, "You are no longer a fallen druid." );
                    }
                }
                else if ( GetLevelByClass( CLASS_TYPE_RANGER, oPC ) ||
                          GetLevelByClass( CLASS_TYPE_DIVINECHAMPION, oPC )){
                          nFallen = GetLocalInt( oPC, "Fallen" );

                          if ( nFallen &&
                               !GetIsObjectValid( GetItemPossessedBy( oPC, "dg_fall" ) ) ){

                        //This removes the fallen state from the ranger or divine champion
                        DeleteLocalInt( oPC, "Fallen" );
                        SendMessageToPC( oPC, "You are no longer fallen." );
                    }
                }


                //feedback
                DelayCommand( 1.0, SendMessageToPC( oPC, "Your deity is "+GetDeity( oPC )+" from now on!" ) );

                DelayCommand( 1.0, CastAlignmentEffect( oPC, oIdol, -1 ) );

                DelayCommand( 6.0, AssignCommand( oPC, PlayAnimation( ANIMATION_LOOPING_PAUSE ) ) );

                //cleanup
                DeleteLocalInt( oPC, "ds_check_1" );
                DeleteLocalInt( oPC, "ds_check_2" );
                DeleteLocalInt( oPC, "ds_node" );
                DeleteLocalString( oPC,"ds_action" );
                DeleteLocalObject( oPC,"ds_idol" );

                RecordPC( oPC );
            }
            else{

                SendMessageToPC( oPC, "You do not have the right alignment for this god!" );
            }
        }
        else if ( nNode == 4 && oIdol != OBJECT_INVALID ){

            //set the new god
            DeityInfo( oPC, oIdol );
        }

        return;
    }

    //the part below gets executed on OnUse
    object oPC      = GetLastUsedBy();
    object oIdol    = OBJECT_SELF;

    int nAlignment  = MatchAlignment( oPC, oIdol );

    if( GetLevelByClass( CLASS_TYPE_CLERIC , oPC ) > 0 && nAlignment == 1 ){

        //set convo check
        SetLocalInt( oPC, "ds_check_1", 1 );

    }
    else if ( nAlignment == 1  ){

        //set convo check
        SetLocalInt( oPC, "ds_check_2", 1 );
    }

    //set custom token
    SetCustomToken( 4150, GetLocalString( oIdol, "name" ) );

    //set action script
    SetLocalString( oPC, "ds_action", "ds_gods_idol" );

    //set Idol object on PC
    SetLocalObject( oPC, "ds_idol", oIdol );

    AssignCommand( oPC, ActionStartConversation( oPC, "ds_idol", TRUE, FALSE ) );
}


