//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_tools
//group: general PC widgets
//used as: activation script
//date:    march 24 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_died"
#include "inc_ds_traps"

int CanBeRessurected( object oTarget, object oCaster );

int CanBeRessurected( object oTarget, object oCaster ){

    if( GetIsBlocked( oTarget, "ressurection_block" ) <= 0 || GetIsDM( oCaster ) || !GetIsPC( oCaster ) || oCaster == GetLocalObject( oTarget, "my_ressurector" ) || GetLocalInt( GetArea( oTarget ), "FreeRest" ) || GetLocalInt( GetArea( oTarget ), "ds_freezone" ) ){

        effect eEffect = GetFirstEffect( oTarget );
        while( GetIsEffectValid( eEffect ) ){

            if( GetEffectSubType( eEffect ) == SUBTYPE_SUPERNATURAL && GetEffectType( eEffect ) == EFFECT_TYPE_VISUALEFFECT && GetEffectSpellId( eEffect ) == -1 )
                RemoveEffect( oTarget, eEffect );

            DeleteLocalInt( oTarget, "ressurection_block" );
            DeleteLocalObject( oTarget, "my_ressurector" );
            eEffect = GetNextEffect( oTarget );
        }

        return TRUE;
    }
    return FALSE;
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();


            if ( sItemName == "PvP Tool" ){

                if ( GetIsDead( oTarget ) ){

                    if ( GetIsBlocked( oTarget, "pvp_raise" ) > 0 ){

                        SendMessageToPC( oPC, "You can do a free raise on a PC once every 5 minutes!" );
                    }
                    else{

                        int PvpMode = GetLocalInt( oTarget, DIED_DEAD_MODE );

                        if ( PvpMode > 0 ){

                            if( CanBeRessurected( oTarget, oPC ) ){

                                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectResurrection( ), oTarget );

                                RemoveDeadStatus( oTarget );

                                SetBlockTime( oTarget, 5, 0, "pvp_raise" );
                            }
                            else{

                                SendMessageToPC( oPC, "Cannot ressurect this person yet!" );
                            }
                        }
                        else{

                            SendMessageToPC( oPC, "This corpse is not recognised as being PvP-ed." );
                        }
                    }
                }
                else if ( oTarget == oPC ){

                    SetLocalString( oPC, "ds_action", "ds_pvp_settings" );
                    AssignCommand( oPC, ActionStartConversation( oPC, "ds_pvp_dialog", TRUE, FALSE ) );
                }
                else if ( GetIsPC( oTarget ) ){

                    object oArea = GetArea( oPC );

                    if( GetLocalInt( oArea, "NoCasting" ) ){

                        // Filter: Bug out in 'NoCasting' Zones.
                        FloatingTextStringOnCreature( "<cþ  >You may not use the Dislike Wand in a No-PvP or No-Casting Zone!</c>", oPC, FALSE );
                    }
                    else if ( GetName( GetFactionLeader( oPC ) ) == GetName( GetFactionLeader( oTarget ) ) ){

                        // only PCs not in your own party are permitted to be disliked
                        FloatingTextStringOnCreature( "<cþ  >You may only like or dislike PCs that aren't in your own party!</c>", oPC, FALSE);
                    }
                    else {

                        if ( GetIsEnemy( oTarget, oPC ) == TRUE ){

                            // if disliked, set them to like
                            SetPCLike( oPC, oTarget );
                        }
                        // if liked, set them to dislike
                        else{

                            SetPCDislike( oPC, oTarget );
                        }
                    }
                }
                // GetAssociateType returns ASSOCIATE_TYPE_NONE if the target is not anyone's associate, so this can be used to determine if the target is an associate
                else if ( GetAssociateType(oTarget) != ASSOCIATE_TYPE_NONE ) {
                    // Get the PC master of the target
                    object oMaster = GetMaster(oTarget);
                    object oArea = GetArea( oPC );

                    if( GetLocalInt( oArea, "NoCasting" ) ){

                        // Filter: Bug out in 'NoCasting' Zones.
                        FloatingTextStringOnCreature( "<cþ  >You may not use the Dislike Wand in a No-PvP or No-Casting Zone!</c>", oPC, FALSE );
                    }
                    else if ( GetName( GetFactionLeader( oPC ) ) == GetName( GetFactionLeader( oTarget ) ) ){

                        // only PCs not in your own party are permitted to be disliked
                        FloatingTextStringOnCreature( "<cþ  >You may only like or dislike PCs that aren't in your own party!</c>", oPC, FALSE);
                    }
                    else {

                        if ( GetIsEnemy( oMaster, oPC ) == TRUE ){

                            // if disliked, set them to like
                            SetPCLike( oPC, oMaster );
                        }
                        // if liked, set them to dislike
                        else{

                            SetPCDislike( oPC, oMaster );
                        }
                    }
                }
            }
            else if ( sItemName == "Trap Tool" ){

                int nType = GetObjectType( oTarget );

                if ( oPC == oTarget ){

                    SetLocalString( oPC, "ds_action", "ds_trap_dialog" );

                    AssignCommand( oPC, ActionStartConversation( oPC, "ds_trap_dialog", TRUE, FALSE ) );
                }
                else if ( nType == OBJECT_TYPE_DOOR || nType == OBJECT_TYPE_TRIGGER || nType == OBJECT_TYPE_PLACEABLE ){

                    if ( GetIsMyTrap( oPC, oTarget ) ){

                        RetrieveTrap( oPC, oTarget );
                    }
                }
                else if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

                    ShowMyTraps( oPC, oTarget, GetLocation( oTarget ) );
                }
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}






