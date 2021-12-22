/* Quest script for the Phane quest convo on Belorfin to simultaneously reward
    the character with 5/- Divine Damage resist to the item of their choice,
    remove quest item from their inventory, and move to the next stage of the
    quest (which is completed now).
*/


/*  ds_action_#

    --------
    Verbatim
    --------
    Performs a generic convo action based on the convo tag

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    22-07-06  Disco       Start of header
    ------------------------------------------------------------------


*/
#include "x2_inc_itemprop"

void main(){

    //Convo node number (same as script number)
    int nNode = 2;

    //Get PC
    object oPC       = GetPCSpeaker();

    //get action script name
    string sScript   = GetLocalString( oPC, "ds_action" );

    //change number to the number of the script
    SetLocalInt( oPC, "ds_node", nNode );

    //run action script
    ExecuteScript( sScript, oPC );

    //Add property to chosen item slot
    int nSlot = GetLocalInt( oPC, "q_rewardslot" );
    object oItem = GetItemInSlot( nSlot, oPC );
    itemproperty ipResist = ItemPropertyDamageResistance( IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGERESIST_5 );

    IPSafeAddItemProperty( oItem, ipResist, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
}
