//Quest convo script check to determine what inventory slot type to reward.

void main()
{
    int nSlot = INVENTORY_SLOT_RIGHTRING;
    object oPC = GetPCSpeaker( );

    SetLocalInt( oPC, "q_rewardslot", nSlot );
}
