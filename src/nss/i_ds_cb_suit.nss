//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:   ds_cb_
//group:    chickenball
//used as:  OnConversation
//date:     2009-07-10
//author:   Disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_cb"
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;
    object oPC;
    object oItem;
    object oArea;
    string sResRef;
    effect eGlow;

    switch (nEvent){

        case X2_ITEM_EVENT_EQUIP:

            // item activate variables
            oPC       = GetPCItemLastEquippedBy();
            oItem     = GetPCItemLastEquipped();
            sResRef   = GetResRef( oItem );

            if ( sResRef == CB_REFSUIT ){

                oArea = GetArea( oPC );

                if ( GetArea( GetLocalObject( oArea, CB_REFEREE ) ) != oArea  ){

                    DelayCommand( 1.0, SetLocalInt( oPC, CB_TEAM, CB_TEAM_REFEREE ) );
                    DelayCommand( 1.0, SetLocalInt( oPC, CB_REFEREE, 1 ) );
                    DelayCommand( 1.0, SetLocalInt( oPC, CB_PLAYER, 1 ) );
                    DelayCommand( 1.0, SetLocalObject( oArea, CB_REFEREE, oPC ) );
                    SendMessageToPC( oPC, "Tagged as referee..." );
                }
                else{

                    SpeakString( "There is another referee here... somewhere in this area?" );
                }
            }
            else if ( sResRef == CB_REDSUIT ){

                if ( GetXP( oPC ) >= 3000 ){

                    DestroyObject( oItem );

                    SendMessageToPC( oPC, "You have too much XP to play this game!" );
                    return;
                }

                DelayCommand( 1.0, SetLocalInt( oPC, CB_TEAM, CB_TEAM_RED ) );
                DelayCommand( 1.0, SetLocalInt( oPC, CB_REFEREE, 0 ) );
                DelayCommand( 1.0, SetLocalInt( oPC, CB_PLAYER, 1 ) );

                eGlow = EffectVisualEffect( VFX_DUR_AURA_RED );

                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eGlow, oPC );

                SendMessageToPC( oPC, "Tagged as team red..." );
            }
            else if ( sResRef == CB_YELLOWSUIT ){

                if ( GetXP( oPC ) > 3000 ){

                    DestroyObject( oItem );

                    SendMessageToPC( oPC, "You have too much XP to play this game!" );
                    return;
                }

                DelayCommand( 1.0, SetLocalInt( oPC, CB_TEAM, CB_TEAM_YELLOW ) );
                DelayCommand( 1.0, SetLocalInt( oPC, CB_REFEREE, 0 ) );
                DelayCommand( 1.0, SetLocalInt( oPC, CB_PLAYER, 1 ) );

                eGlow = EffectVisualEffect( VFX_DUR_AURA_RED );

                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eGlow, oPC );

                SendMessageToPC( oPC, "Tagged as team yellow..." );
            }

       break;

       case X2_ITEM_EVENT_UNEQUIP:

            // item activate variables
            oPC       = GetPCItemLastUnequippedBy();
            oItem     = GetPCItemLastUnequipped();
            sResRef   = GetResRef( oItem );

            DeleteLocalInt( oPC, CB_PLAYER );
            DeleteLocalInt( oPC, CB_REFEREE );
            DeleteLocalInt( oPC, CB_TEAM );

            cb_SetBallPossession( oPC, FALSE );


            if ( sResRef == CB_REFSUIT ){

                oArea = GetArea( oPC );
                DeleteLocalObject( oArea, CB_REFEREE );
                SendMessageToPC( oPC, "You are no longer tagged as a referee." );
            }


       break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------






