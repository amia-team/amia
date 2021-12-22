//::///////////////////////////////////////////////
//:: FileName tshar_sinkeybuy
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 6/12/2006 1:58:22 PM
//:://////////////////////////////////////////////
void main()
{
    // Variables.
    object oPC      = GetPCSpeaker( );
    int nGold       = GetGold( oPC );

    // Give the speaker the items
    if( nGold >= 5000 ){
        CreateItemOnObject("tshar_sinkey", GetPCSpeaker(), 1);
        // Remove some gold from the player
        TakeGoldFromCreature(5000, oPC, TRUE);
    }

    return;

}
