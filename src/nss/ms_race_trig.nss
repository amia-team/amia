//  author msheeler
//  spawns a plc if the right subrace enters the trigger
//  created 7/13/2014

//------------------------------------------------------------------------------
//  Includes
//------------------------------------------------------------------------------

#include "cs_inc_xp"
#include "inc_ds_records"
#include "amia_include"

//------------------------------------------------------------------------------
// prototypes
//------------------------------------------------------------------------------

int IsBanned( object oPC, object oTrigger );

//------------------------------------------------------------------------------
//  main
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//  block timer
//------------------------------------------------------------------------------

void main(){

    if ( GetIsBlocked() > 0 ){
        return;
    }

    else SetBlockTime(OBJECT_SELF, 0, 25);

    object oPC          = GetEnteringObject ();
    object oPLC         = OBJECT_SELF;
    object oTrigger     = OBJECT_SELF;
    int nSubrace        = GetRaceInteger ( GetRacialType (oPC), GetSubRace (oPC) );
    string sResref      = GetLocalString ( oTrigger, "resref" );
    string sTarget      = GetLocalString ( oTrigger, "target" );
    string sSpawnpoint  = GetLocalString ( oTrigger, "spawnpoint" );

    if  ( IsBanned( oPC, oTrigger ) ){
        return;
    }

    else{
        oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResref, GetLocation( GetWaypointByTag( sSpawnpoint ) ), FALSE, sTarget );
        DestroyObject ( oPLC, 20.0 );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


int IsBanned( object oPC, object oTrigger ){

    if ( GetIsPolymorphed( oPC ) || GetIsPossessedFamiliar( oPC ) ){
        return TRUE;
    }

    object oTrigger     = OBJECT_SELF;
    object oPC          = GetEnteringObject ();
    object oItem        = GetItemPossessedBy( oPC, GetLocalString( oTrigger, "ItemName" ) );
    int nSubrace        = GetRaceInteger ( GetRacialType (oPC), GetSubRace (oPC) );
    int nRaceSlot       = GetLocalInt ( oTrigger, "Race_" + IntToString (nSubrace) );
    int nBindpoint      = GetLocalInt ( oTrigger, "ds_bindpoint" );
    string sType        = GetLocalString ( oTrigger, "type" );
    string sInsignia    = GetLocalString ( GetInsigniaB( oPC ), "HouseName" );

    if( GetLocalString( oTrigger, "ItemName" ) != "" )
    {
        if( GetIsObjectValid( oItem ) ) {
            return FALSE;
        }
    }

    if ( nBindpoint && HasBindPoint( oPC, nBindpoint ) ){
        return FALSE;
    }

    if ( GetLocalInt( oTrigger, sInsignia ) == 1 ){
        return FALSE;
    }

    if ( GetLocalInt( oPC, GetTag( oTrigger ) ) == 1 ){
        return FALSE;
    }

    if (  nRaceSlot == 1 && sType == "ban" ){
        //not allowed to enter
        return TRUE;
    }

    if (  nRaceSlot == 0 && sType == "allow"  ){
        //not allowed to enter
        return TRUE;
    }

    return FALSE;
}

