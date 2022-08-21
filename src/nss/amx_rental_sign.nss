//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: amx_rental_sign
//group: rentable housing
//used as: OnUsed shingle event
//date: 2022-08-20
//author: The1Kobra
#include "inc_ds_rental"
#include "amx_rental_sys"

void main() {
    string RENTAL_UNIT_ID = "RENTAL_UNIT_ID";
    string RENTAL_UNIT_COST = "RENTAL_UNIT_PRICE";
    object oPC = GetClickingObject();
    object oSign = OBJECT_SELF;
    string sRental = GetLocalString(oSign, RENTAL_UNIT_ID);
    string sPCKEY = GetName( GetPCKEY( oPC ) );
    int iCost = GetLocalInt(oSign,RENTAL_UNIT_COST);

    // Get Property Owner
    string sPropertyOwner = GetPropertyOwner(RENTAL_UNIT_ID);

    // Call Conversation IF Property not owned.
    if (sPropertyOwner == "") {

    // Call Conversation IF Property is owned and is being used by Onwer.
    } else if (sPropertyOwner == sPCKEY) {

    // Else end
    } else {

    }
}
