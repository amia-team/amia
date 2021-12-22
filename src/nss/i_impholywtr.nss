#include "x2_inc_switches"
#include "X0_I0_SPELLS"

void ActivateItem()
{
    object oPC = GetItemActivator();
    float maxThrowingDist = 15.0;

    object oTarget = GetNearestCreature(CREATURE_TYPE_RACIAL_TYPE, RACIAL_TYPE_UNDEAD, oPC);

    if(oTarget == OBJECT_INVALID)
    {
        SendMessageToPC(oPC, "The potion breaks on your target but seems to have no effect.");
        return;
    }
    else
    {
        // Check the cooldown. Since this is a bomb, it should not be allowed to be used more than once per round.
        int nTime = GetRunTime( );
	int nLastTime = GetLocalInt( oPC, "bomb_timestamp" );
        float nLast = IntToFloat( nTime-nLastTime);
        SetLocalInt( oPC, "bomb_timestamp", nTime );
        SendMessageToPC(GetFirstPC(), "Timer: "+ IntToString(nTime));
        if( nLast >= 6.0 || nLastTime == 0 )
        {
            // TouchAttackRanged() is not firing. Always reports 0.
            int bAB = GetBaseAttackBonus(oPC);
            int bAC = GetAC(oTarget);
            int rolledbAB = d20(1) + bAB;

            if(rolledbAB > bAC)
            {
                float distanceBetween = GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget));
                if (distanceBetween < maxThrowingDist)
                {
                    int nDamage = nDamage = d10(5);
                    effect eSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
                    effect ePulseCold = EffectVisualEffect(86);
                    effect eLink = EffectLinkEffects( eSun, ePulseCold );
                    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL);
                    SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_GRENADE_HOLY, TRUE));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                    SendMessageToPC(oPC, "The undead suffers " + IntToString(nDamage) + " from your holy water!");
                }
            }
            else
            {
                SendMessageToPC(oPC, "The undead dodged your holy water bomb!");
            }
            DelayCommand( 6.0f, FloatingTextStringOnCreature( "<c þ >You can now throw a holy bomb again!</c>", oPC, FALSE ) );
        }
	else
	{
		SendMessageToPC(oPC, "You must wait until this holy bomb is ready to be used again!");
	}
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
