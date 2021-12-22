//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_ds_trap
//description: Trap / Trap-setting routines
//used as: Function Library
//date:    march 10 2008
//author:  Terra/Disco
//-------------------------------------------------------------------------------
// Changelog
//-------------------------------------------------------------------------------
// 2011-07-08   Selmak      Added new functions to support upgradeable traps.

//-------------------------------------------------------------------------------
// settings
//-------------------------------------------------------------------------------
const string TRAP_PVP_MODE      = "tr_pvp_mode";
const string TRAP_HIT_MODE      = "tr_hit_mode";
const string TRAP_CREATOR       = "tr_creator";
const string TRAP_UPGRADE       = "sc_tr_upgrade";
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_died"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//Returns closest trap set by to oPC
object FindTrap( object oPC );

//transfers oPC's PvpMode to trap
void SetTrapMode( object oPC );

//checks if trap should fire
//returns -2 if the trap is illegal and gets destroyed
//returns -1 if the trap shouldn't fire
//returns 0 if the trap is not set by a PC
//returns PvpMode (1-3) otherwise
int GetTrapStatus( object oCreature, object oTrap );

//places the trap's PvpMode (from nTrapStatus) on oCreature for use in death scripts
//this function also notifies the victim that oOwner placed the trap
void TransferPvpMode( object oCreature, object oOwner, int nTrapStatus, int nDamage, string sDamage );

//returns TRUE if oTrap is set by oPC
int GetIsMyTrap( object oPC, object oTrap );

//retrieves a trap
void RetrieveTrap( object oPC, object oTrap );

//finds all traps set by oPC in fRadius meters
//if nRetrieve is set to TRUE all traps are retrieved instead
void FindMyTraps( object oPC, float fRadius=1.0, int nRetrieve=FALSE );

//shows oPC's traps within 30 meters to oTarget
void ShowMyTraps( object oPC, object oTarget, location lTarget );

//Determines the upgrade component for a given TRAP_BASE_TYPE.
//N.B. This is both the tag and the resref for the item.
string GetUpgradeComponent( int nTBT );

//Master Scout function.  Upgrades a single oTrap if the right sComponent is
//available in oPC's inventory.
int UpgradeSingleTrap( object oPC, object oTrap, string sComponent );

//Master Scout function.  Finds all traps belonging to oPC within fRadius of
//oPC and attempts to upgrade them all.
void UpgradeMyTraps( object oPC, float fRadius=1.0 );

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

object FindTrap( object oPC ){

    int i           = 1;
    object oObject  = GetNearestObject( OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER, oPC, i );

    while( GetIsObjectValid( oObject ) ){

        if ( GetIsTrapped( oObject ) && GetTrapCreator( oObject ) == oPC ){

            return oObject;
        }
        else if ( GetDistanceBetween( oPC, oObject ) > 5.0 ){

            return OBJECT_INVALID;
        }

        ++i;

        oObject = GetNearestObject( OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER, oPC, i );
    }

    return OBJECT_INVALID;
}

void SetTrapMode( object oPC ){

    //vars
    object oTrap        = FindTrap( oPC );
    location lPC        = GetLocation( oPC );

    //Lets check so the trap isnt screwed!
    if ( !GetIsObjectValid( oTrap ) ) {

        return;
    }

    //store creator
    SetLocalObject( oTrap, TRAP_CREATOR, oPC );

    //store hit mode
    SetLocalInt( oTrap, TRAP_HIT_MODE, GetLocalInt( oPC, TRAP_HIT_MODE ) );

    //store creator's PvP settings
    SetLocalInt( oTrap, TRAP_PVP_MODE, GetKillerPvpStatus( oPC, OBJECT_INVALID ) );
}

int GetTrapStatus( object oCreature, object oTrap ){

    if ( GetPlotFlag( oCreature ) ){

        //plotted critters can't be killed anyway
        return -1;
    }

    int nPvpMode = GetLocalInt( oTrap, TRAP_PVP_MODE );

    if ( !nPvpMode ){

        //this is a module trap
        return 0;
    }

    object oOwner = GetLocalObject( oTrap, TRAP_CREATOR );

    //for testing
    if ( GetLocalInt( oTrap, "testing" ) == 1  ){

        oOwner = oCreature;

        //store creator
        SetLocalObject( oTrap, TRAP_CREATOR, oOwner );
    }

    //delete trap if owner is not online
    if ( !GetIsObjectValid( oOwner ) ){

        //feedback
        SendMessageToPC( oCreature, "<cþþþ>[Trap removed because its owner is not online.]" );

        if ( GetObjectType( oTrap ) == OBJECT_TYPE_TRIGGER ){

            //simply remove the whole trigger
            DestroyObject( oTrap );
        }
        else{

            SetTrapDisabled( oTrap );
        }

        return -2;
    }

    if ( GetLocalInt( oTrap, TRAP_HIT_MODE ) == 1 && !GetIsReactionTypeHostile( oOwner, oCreature ) ){

        SetTrapOneShot( oTrap, FALSE );
        DelayCommand( 0.5, SetTrapOneShot( oTrap, TRUE ) );

        //mode == 1 means only hostiles will trigger
        return -1;
    }

    return nPvpMode;
}

void TransferPvpMode( object oCreature, object oOwner, int nTrapStatus, int nDamage, string sDamage ){

    if ( nTrapStatus > 0 ){

        //place PvP mode on victim in case of a lethal 'accident'
        SetLocalInt( oCreature, DIED_DEAD_MODE, nTrapStatus );
        SetLocalObject( oCreature, DIED_PVP_KILLER, oOwner );

        //feedback
        SendMessageToPC( oCreature, "<cþþþ>[This trap was set by "+GetName( oOwner )+".]" );
    }

    if ( GetArea( oCreature ) == GetArea( oOwner ) ){

        SendMessageToPC( oOwner, "<cþþþ>[Your trap deals "+IntToString( nDamage )+" "+sDamage+" damage to "+GetName( oCreature )+".]" );
    }
}

int GetIsMyTrap( object oPC, object oTrap ){

    object oOwner = GetLocalObject( oTrap, TRAP_CREATOR );

    if ( GetIsTrapped( oTrap ) && oPC == oOwner ){

        return 1;
    }

    return 0;
}

void RetrieveTrap( object oPC, object oTrap ){

    //get trap item
    string sTrapResRef = Get2DAString( "traps", "ResRef", GetTrapBaseType( oTrap ) );
    string sCompResRef = GetUpgradeComponent( GetTrapBaseType( oTrap ) );
    if ( GetObjectType( oTrap ) == OBJECT_TYPE_TRIGGER ){

        //Check local int to see if this trap is already marked for destruction.
        if ( GetLocalInt( oTrap, "destroying" ) ) return;
        //simply remove the whole trigger
        DestroyObject( oTrap );
        SetLocalInt( oTrap, "destroying", 1 );
    }
    else{

        SetTrapDisabled( oTrap );

    }

    if ( GetLocalInt( oTrap, TRAP_UPGRADE ) == 1 ){

        if ( GetIsObjectValid( oTrap ) ){

            DeleteLocalInt( oTrap, TRAP_UPGRADE );

        }
        object oComponent = CreateItemOnObject( sCompResRef, oPC, 1 );

    }

    object oNewTrap = CreateItemOnObject( sTrapResRef, oPC, 1 );

    SetIdentified( oNewTrap, TRUE );
}

void FindMyTraps( object oPC, float fRadius=1.0, int nRetrieve=FALSE ){

    int i           = 1;
    object oObject  = GetNearestObject( OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER, oPC, i );
    string sMessage;

    while( GetIsObjectValid( oObject ) ){

        if ( GetDistanceBetween( oPC, oObject ) > fRadius ){

            return;
        }

        if ( GetIsTrapped( oObject ) && GetIsMyTrap( oPC, oObject ) ){

            if ( nRetrieve == FALSE ){

                sMessage  = IntToString( i )+". ";
                sMessage += Get2DAString( "traps", "Label", GetTrapBaseType( oObject ) )+" trap. ";
                sMessage += "Detect DC:"+IntToString( GetTrapDetectDC( oObject) )+", ";
                sMessage += "Disarm DC:"+IntToString( GetTrapDisarmDC( oObject) )+", ";
                sMessage += "Upgraded: ";

                if ( GetLocalInt( oObject, TRAP_UPGRADE ) == 1 ){

                    sMessage += " YES";

                }
                else{

                    sMessage += " NO";

                }
                SendMessageToPC( oPC, sMessage );
            }
            else{

                DelayCommand( 0.0, RetrieveTrap( oPC, oObject ) );
            }
        }

        ++i;

        oObject = GetNearestObject( OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER, oPC, i );
    }
}

void ShowMyTraps( object oPC, object oTarget, location lTarget ){

    object oObject  = GetFirstObjectInShape( SHAPE_SPHERE, 30.0, lTarget, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER );

    while ( GetIsObjectValid( oObject ) ){

        if ( GetIsMyTrap( oPC, oObject ) ){

            SetTrapDetectedBy( oObject, oTarget, TRUE );

            SendMessageToPC( oPC, GetName( oTarget )+" now sees "+Get2DAString( "traps", "Label", GetTrapBaseType( oObject ) )+" trap." );
        }

        oObject  = GetNextObjectInShape( SHAPE_SPHERE, 30.0, lTarget, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER );
    }
}

string GetUpgradeComponent( int nTBT ){

    string sTag;

    if      (   nTBT >=  4 && nTBT <=  7 )                      sTag = "itm_sc_hatomis";  //Holy traps
    else if (   nTBT >=  8 && nTBT <= 11 )                      sTag = "itm_sc_trazors";  //Tangle traps
    else if (   nTBT >= 12 && nTBT <= 15 )                      sTag = "itm_sc_aconcent"; //Acid Splash traps
    else if (   nTBT >= 40 && nTBT <= 43 )                      sTag = "itm_sc_aconcent"; //Blob of Acid traps
    else if ( ( nTBT >= 16 && nTBT <= 19 ) || ( nTBT == 45 ) )  sTag = "itm_sc_fivalve";  //Fire traps
    else if ( ( nTBT >= 20 && nTBT <= 23 ) || ( nTBT == 44 ) )  sTag = "itm_sc_ecoil";    //Electrical traps
    else if (   nTBT >= 24 && nTBT <= 27 )                      sTag = "itm_sc_gxcan";    //Gas traps
    else if ( ( nTBT >= 28 && nTBT <= 31 ) || ( nTBT == 46 ) )  sTag = "itm_sc_cxchangr"; //Frost traps
    else if (   nTBT >= 32 && nTBT <= 35 )                      sTag = "itm_sc_ninducer"; //Negative traps
    else if ( ( nTBT >= 36 && nTBT <= 39 ) || ( nTBT == 47 ) )  sTag = "itm_sc_sintensi"; //Sonic traps

    return sTag;
}

int UpgradeSingleTrap( object oPC, object oTrap, string sComponent ){

    //Check for existing trap upgrade
    int nUpgraded = GetLocalInt( oTrap, TRAP_UPGRADE );

    //Trap is already upgraded, we can't improve any further.
    if ( nUpgraded == 1 ) return FALSE;

    object oItem;

    oItem = GetItemPossessedBy( oPC, sComponent );
    int nStack;

    //Check local int to see if this component is marked for destruction.
    if ( GetLocalInt( oItem, "destroying" ) ){

        FloatingTextStringOnCreature( "Depleted a stack of trap upgrade components.", oPC, TRUE );
        return FALSE;
    }

    if ( GetIsObjectValid( oItem ) ){
        nStack = GetItemStackSize( oItem );
        if ( nStack > 1 ){
            //If the item is stackable, we remove one from the stack
            SetItemStackSize( oItem, nStack - 1 );

        }
        else{
            //If there is just one of the item in the stack, or it is not
            //stackable, we remove that item.
            DestroyObject( oItem );
            SetLocalInt( oItem, "destroying", 1 );

        }

        //Set this trap as upgraded.
        SetLocalInt( oTrap, TRAP_UPGRADE, 1 );
        return TRUE;
    }
    else{
        //If the upgrade item does not exist, no upgrade occurs.
        return FALSE;

    }

}

void UpgradeMyTraps( object oPC, float fRadius ){

    location lOrigin = GetLocation( oPC );
    object oObject  = GetFirstObjectInShape( SHAPE_SPHERE, fRadius, lOrigin, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER );
    string sMessage;
    int nTrapBaseType;
    int nResult;
    string sComponent;

    while ( GetIsObjectValid( oObject ) ){

        if ( GetIsMyTrap( oPC, oObject ) ){
            nTrapBaseType   = GetTrapBaseType( oObject );
            sComponent      = GetUpgradeComponent( nTrapBaseType );
            nResult = UpgradeSingleTrap( oPC, oObject, sComponent );
            sMessage = Get2DAString( "traps", "Label", GetTrapBaseType( oObject ) )+" trap";
            if ( nResult == TRUE ){

                sMessage += " has been upgraded!";

            }
            else{

                sMessage += " has not been upgraded.";

            }
            SendMessageToPC( oPC, sMessage );
        }

        oObject  = GetNextObjectInShape( SHAPE_SPHERE, fRadius, lOrigin, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER );
    }



}

