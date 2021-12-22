/*  i_blooddagger

--------
Verbatim
--------


---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
06-14-06  Disco       Start of header
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void ActivateItem()
{

    // If we target self, heal all party members in the line of sight fully
    // and damage the holder by 50%.   NOTE in some cases line of sight may
    // be pretty far distance, but practically most areas are not all that open.

    // If we target another PC, damage them 2 points.  For roleplaying
    // a divine alignment test.

    object oTarget    = GetItemActivatedTarget();
    object oPC        = GetItemActivator();
    object oPCArea    = GetArea(oPC);
    int iDamage;
    effect eHeal, eDrain, eVisual;

    if ( oPC == oTarget ) {

        SendMessageToPC( oPC, "The blade sucks life out of you to pass to your party");

        object oPartyMember = GetFirstFactionMember(oPC, TRUE);

        while (GetIsObjectValid(oPartyMember)) {

            if (oPC != oPartyMember || oPCArea == GetArea(oPartyMember)){

                iDamage = GetMaxHitPoints(oPartyMember) - GetCurrentHitPoints(oPartyMember);

                if( iDamage > 10 ) {  // don't mess with itty bitty damage

                    if (LineOfSightObject(oPC, oPartyMember)) {   // expensive

                        // heal the party member fully
                        eHeal = EffectHeal( iDamage );
                        eVisual = EffectVisualEffect(31);

                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPartyMember);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPartyMember);

                        SendMessageToPC( oPC, "[Healing applied to "+GetName(oPartyMember)+"]");

                    }
                }
            }

            oPartyMember = GetNextFactionMember(oPC, TRUE);

        }

        // now ouchie!
        int iDamage = GetCurrentHitPoints(oPC) / 2;
        effect eDrain = EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
        effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDrain, oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPC);

        SendMessageToPC( oPC, "[Drain damage applied to "+GetName(oPC)+"]");
    }
    else if (GetIsPC(oTarget)) {

        int iDamage = 2;
        effect eDrain = EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
        effect eVisual = EffectVisualEffect(VFX_IMP_HOLY_AID);

        SendMessageToPC( oTarget, "The blade burns ice cold as it bites into your palm.");
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDrain, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);

        SendMessageToPC( oPC, "[Cold damage applied to "+GetName(oTarget)+"]");

    }

    return;

}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
