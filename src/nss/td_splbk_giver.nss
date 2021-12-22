#include "inc_ds_actions"

const string SPELLBOOK_REF = "spellbook";
const int DEFAULT_PRICE = 10000;

int HasASpellbook(object oPC){

    object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem)){

        if(GetResRef(oItem)==SPELLBOOK_REF){
            return TRUE;
        }

        oItem = GetNextItemInInventory(oPC);
    }

    return FALSE;
}

void main()
{
    object oPC = GetLastSpeaker();

    int nPrice = GetLocalInt(OBJECT_SELF, "price" );
    SetLocalString(OBJECT_SELF, "itm_resref",SPELLBOOK_REF );

    if(nPrice <= 0){
        nPrice = DEFAULT_PRICE;
        SetLocalInt(OBJECT_SELF, "price",nPrice );
    }

    clean_vars( oPC, 4, "td_splbk_g_act" );

    SetLocalObject(oPC,"ds_target",OBJECT_SELF);
    SetCustomToken(9874,IntToString(nPrice));
    SetLocalInt( oPC, "ds_check_1", GetGold(oPC) >= nPrice );
    SetLocalInt( oPC, "ds_check_2", GetGold(oPC) < nPrice );
    AssignCommand( OBJECT_SELF, ActionStartConversation( oPC, "td_splbk_g", TRUE, FALSE ) );
}
