// OnDisturbed event of loot divider.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/01/2004 jpavelch         Initial Release.
//


void AddDividerItem( object oItem, object oPC )
{
    SetLocalObject( oItem, "AR_LastOwner", oPC );
}

void RemoveDividerItem( object oItem, object oPC )
{
    object oLastOwner = GetLocalObject( oItem, "AR_LastOwner" );
    if ( oLastOwner != oPC ) {
        AssignCommand( OBJECT_SELF, ActionTakeItem(oItem, oPC) );

        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_LIGHTNING_M),
            GetLocation(oPC)
        );
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectDeath(TRUE),
            oPC
        );
        FloatingTextStrRefOnCreature( 30967, oPC );
    } else {
        DeleteLocalObject( oItem, "AR_LastOwner" );
    }
}


void main( )
{
    object oPC = GetLastDisturbed( );
    if ( !GetIsPC(oPC) ) return;

    object oItem = GetInventoryDisturbItem( );
    int nType = GetInventoryDisturbType( );

    switch ( nType ) {
        case INVENTORY_DISTURB_TYPE_ADDED:   AddDividerItem( oItem, oPC );    break;
        case INVENTORY_DISTURB_TYPE_REMOVED: RemoveDividerItem( oItem, oPC ); break;
    }
}
