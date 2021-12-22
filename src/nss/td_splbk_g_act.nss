void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetLocalObject(oPC,"ds_target");
    int nNode = GetLocalInt( oPC, "ds_node" );

    if(nNode == 1){

        int nPrice = GetLocalInt(oTarget,"price");
        if(nPrice > GetGold(oPC)){
            SendMessageToPC(oPC,"Not enough gold!");
        }
        else{
            object oItem = CreateItemOnObject(GetLocalString(oTarget,"itm_resref"),oPC);
            if(GetIsObjectValid(oItem)){
                TakeGoldFromCreature(nPrice,oPC,TRUE);
            }
        }
    }
}
