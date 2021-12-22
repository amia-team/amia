// Gut Berzerker
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050312   jking            Initial release.
//

#include "x2_inc_switches"

void ActivateItem()
{
    object oPC   = GetItemActivator( );
    object oItem = GetItemActivated( );

    int iResult = FortitudeSave(oPC, 18, SAVING_THROW_TYPE_ACID);
    switch (iResult) {
        case 0:
            FloatingTextStringOnCreature("Your Gut is Berzerk!", oPC, TRUE);
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 0.7f, 12.0f));
            {
                effect eAcidDamage = EffectDamage(d4() + 1, DAMAGE_TYPE_ACID);
                effect eAcidSplash = EffectVisualEffect(VFX_COM_HIT_ACID);
                effect eLink       = EffectLinkEffects(eAcidDamage, eAcidSplash);

                ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oPC);
            }
            break;
        case 1:
        case 2:
        default:
            FloatingTextStringOnCreature("Nothing Much Happens", oPC, TRUE);
            if (Random(100) + 1 < 40)
                AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
            else
                AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK));

            effect eDumb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 2);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDumb, oPC, 60.0);
            break;
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
