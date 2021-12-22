#include "inc_ds_ondeath"
#include "inc_ds_records"

void main()
{
    int nMagical = d100();

    object oPC = GetLastUsedBy();
    string sName = GetName(GetPCKEY( oPC));
    if (GetLocalInt(OBJECT_SELF, sName)) { SendMessageToPC( oPC, "Only one book per reset per player" ); return; }
    object oLootBin = GetObjectByTag("CD_TREASURE_books");
    int nIndex;
    string sIndex;
    object oTemplate;

    if (TRUE || nMagical < 99)
    {
            InitialiseLootBin( oLootBin );
            nIndex       = Random( GetLocalInt( oLootBin, LOOTBIN_COUNT ) ) + 1;
            sIndex       = ITEM_PREFIX + IntToString( nIndex );
            oTemplate    = GetLocalObject( oLootBin, sIndex );
            CopyItemVoid( oTemplate, oPC, TRUE);
    }
    else
    {
    }
    SetLocalInt(OBJECT_SELF, sName , TRUE);
}
