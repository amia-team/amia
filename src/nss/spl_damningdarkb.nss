/*
    Custom Spell:
    Damning Darkness
    - Level 4 Ranged
    - Darkness AoE effect plus damage per round applied
        through OnHeartbeat AoE script.

    AoE Heartbeat Script
*/

#include "x0_i0_spells"

void main()
{
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect( VFX_IMP_DESTRUCTION );
    int nDamage;
    effect eDam;
    float fDelay;
    int nDice;

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    //Get the first object in the persistant AOE
    object oTarget = GetFirstInPersistentObject( );

    while( GetIsObjectValid( oTarget ) )
    {
        //Prevent multiple copies from stacking damage
        if( spellsIsTarget( oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator( ) ) &&
            GetLocalInt( oTarget, "DamnDark" ) != 1 )
        {
            fDelay = GetRandomDelay(0.75, 2.25);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_DARKNESS ) );

            nDamage = d6( 2 );

            //Enter Metamagic conditions
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                nDamage = 6 * nDice; //Damage is at max
            }

            //Enter Metamagic conditions
            if (nMetaMagic == METAMAGIC_EMPOWER)
            {
                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
            }

            //Apply Damage and VFX
            eDam = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE );
            effect eLink = EffectLinkEffects( eDam, eVis );
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget ) );

            //Prevent multiple copies from stacking damage
            SetLocalInt( oTarget, "DamnDark", 1 );
            DelayCommand( 1.0, SetLocalInt( oTarget, "DamnDark", 0 ) );
        }
        //Get the next target in the AOE
        oTarget = GetNextInPersistentObject();
    }
}
