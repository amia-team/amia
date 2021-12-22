#include "inc_ds_j_lib"

void main()
{

    object oPC   = GetLocalObject( OBJECT_SELF, DS_J_USER );
    object oNPC  = GetEnteringObject();
    string sEssence;
    int nResource;
    int nEssence = GetLocalInt( oNPC, "ds_j_essence" );

    if ( GetIsReactionTypeHostile( oPC, oNPC ) && nEssence != 0 ){

        //check if the find is succesful and deal with XP
        int nResult     = ds_j_StandardRoll( oPC, 70 );
        int nRank       = ds_j_GiveStandardXP( oPC, 70, nResult );

        FreezePC( oNPC, 1.0 );

        if ( nEssence == 1 ){ sEssence = "Air Essence";   nResource=211; }
        if ( nEssence == 2 ){ sEssence = "Earth Essence"; nResource=212; }
        if ( nEssence == 3 ){ sEssence = "Fire Essence";  nResource=213; }
        if ( nEssence == 4 ){ sEssence = "Water Essence"; nResource=214; }

        ds_j_CreateItemOnPC( oPC, "ds_j_thin_a", nResource, sEssence, "", 12 );
    }
}
