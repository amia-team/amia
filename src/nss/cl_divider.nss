// OnClose event of the loot divider.  Finds gold value of each item in
// inventory and distributes a fair share to each party member.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/01/2004 jpavelch         Initial Release.
//


void DistributeGoldForItem( object oItem )
{
    object oOwner = GetLocalObject( oItem, "AR_LastOwner" );
    if ( !GetIsPC(oOwner) ) return;

    object oSelf = OBJECT_SELF;

    if ( !GetIdentified(oItem) || GetStolenFlag(oItem) ) {
        SendMessageToPC( oOwner, "Unidentified and stolen items cannot be divided." );
        CopyItem( oItem, oOwner );
        return;
    }

    int nTotalGold = FloatToInt( IntToFloat(GetGoldPieceValue(oItem)) * 0.4 );

    // First loop to count party members to determine share of gold.
    int nPartyCount = 0;
    object oMember = GetFirstFactionMember( oOwner );
    while ( GetIsPC(oMember) ) {
        ++nPartyCount;
        oMember = GetNextFactionMember( oOwner );
    }

    if ( nPartyCount <= 0 ) return;

    int nShare = nTotalGold / nPartyCount;
    oMember = GetFirstFactionMember( oOwner );
    while ( GetIsPC(oMember) ) {
        GiveGoldToCreature( oMember, nShare );
        oMember = GetNextFactionMember( oOwner );
    }
}


void main( )
{
    object oPC = GetLastClosedBy( );
    if ( !GetIsPC(oPC) ) return;

    object oSelf = OBJECT_SELF;

    object oItem = GetFirstItemInInventory( oSelf );
    while ( GetIsObjectValid(oItem) ) {
        DistributeGoldForItem( oItem );
        oItem = GetNextItemInInventory( oSelf );
    }

    // Looks like we invalidate iterators or something when destroying
    // objects while looping through an inventory.  We'll just make a
    // second pass to be safe.
    //
    oItem = GetFirstItemInInventory( oSelf );
    while ( GetIsObjectValid(oItem) ) {
        DestroyObject( oItem );
        oItem = GetNextItemInInventory( oSelf );
    }
}
