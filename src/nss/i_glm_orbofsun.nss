/* Orb of the Sun - Radius Based Hallow Effect - Ranallas Atarel Dal (Glim)

Toggles a persistent Hallow effect in a radius around the wielder.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
12/20/12 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"

//------------------------------------------------------------------------------
// prototypes
//------------------------------------------------------------------------------
void ToggleItem( object oItem );

//------------------------------------------------------------------------------
// main
//------------------------------------------------------------------------------
void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );
    object oItem;

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            oItem = GetItemActivated();
            AssignCommand( oItem, ToggleItem( oItem ) );
            break;
    }
}

void ToggleItem( object oItem )
{
    object oPC = GetItemPossessor( oItem );
    int iToggle = GetLocalInt(oPC, "Hallowed");

    effect eAura = EffectAreaOfEffect( AOE_MOB_INVISIBILITY_PURGE, "****", "glm_orbofsunhrtb", "****" );
           eAura = MagicalEffect( eAura );
    effect eLight = EffectVisualEffect( VFX_DUR_LIGHT_YELLOW_20 );
           eLight = MagicalEffect( eLight );

    if(iToggle <= 1)
    {
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eAura, oPC );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLight, oPC );
        SetLocalInt(oPC, "Hallowed", 2);
    }
    else if(iToggle == 5)
    {
        effect eLoop = GetFirstEffect( oPC );

        while ( GetIsEffectValid( eLoop ) )
        {
            if ( GetEffectType( eLoop ) == EFFECT_TYPE_AREA_OF_EFFECT &&
                 GetEffectCreator( eLoop ) == oItem &&
                 GetEffectSubType( eLoop ) == SUBTYPE_MAGICAL )
            {
                RemoveEffect( oPC, eLoop );
            }
            eLoop = GetNextEffect( oPC );
        }
        SetLocalInt(oPC, "Hallowed", 1);
    }
    else
    {
        iToggle = GetLocalInt(oPC, "Hallowed") + 1;
        SetLocalInt(oPC, "Hallowed", iToggle);
    }
}
