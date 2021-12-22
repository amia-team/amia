/* Cloud of Flies - Custom VFX Toggle - Lucius Blackwater (Dead)

Toggles the cloud of flies VFX on the user.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
06/27/12 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"

void ActivateItem()
{
    object oPC = GetItemActivator();
    effect eFlies = EffectVisualEffect(VFX_DUR_FLIES);
    eFlies = SupernaturalEffect(eFlies);
    int iToggle = GetLocalInt(oPC, "LordofFlies");
    object oCreator = OBJECT_SELF;

    if(iToggle <= 1)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFlies, oPC);
        SetLocalInt(oPC, "LordofFlies", 2);
    }
    else if(iToggle = 2)
    {
        effect eLoop = GetFirstEffect( oPC );

        while ( GetIsEffectValid( eLoop ) )
        {
            if ( GetEffectType( eLoop ) == EFFECT_TYPE_VISUALEFFECT &&
                 GetEffectCreator( eLoop ) == oCreator &&
                 GetEffectSubType( eLoop ) == SUBTYPE_SUPERNATURAL )
            {
                RemoveEffect( oPC, eLoop );
            }
            eLoop = GetNextEffect( oPC );
        }
        SetLocalInt(oPC, "LordofFlies", 1);
    }
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
