//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: amx_rental_house
//group: rentable housing
//used as: OnFailToOpen door event
//date: 2022-08-20
//author: The1Kobra
#include "inc_ds_rental"
#include "amx_rental_sys"

void main() {

    string RENTAL_UNIT_ID = "RENTAL_UNIT_ID";
    object oPC = GetClickingObject();
    object oSign = OBJECT_SELF;
    string sKey = GetLocalString(oSign, RENTAL_UNIT_ID);
    string sPCKEY = GetName( GetPCKEY( oPC ) );

    // Get Owner Key ID
    string sPropertyOwner = GetPropertyOwner(RENTAL_UNIT_ID);
    string sKeyTag = GetPropertyKeyTag(RENTAL_UNIT_ID);




}
