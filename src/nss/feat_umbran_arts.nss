/*
    Umbran Arts Feat Integration

*/

void NightEyes(object oPC);
void TenebrousTempo(object oPC);
void VestmentOfShadows(object oPC);

void main()
{
    object oPC = OBJECT_SELF;
    int nSpellID = GetSpellId();

    if(nSpellID == 995)
    {
       NightEyes(oPC);
    }
    else if(nSpellID == 996)
    {
       TenebrousTempo(oPC);
    }
    else if(nSpellID == 997)
    {
      VestmentOfShadows(oPC);
    }


    //Fire cast spell at event for the specified target
    SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
}

void NightEyes( object oPC)
{
    // Effect variables
    effect eUltravision  = EffectUltravision();
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eLink = EffectLinkEffects(eVis,eUltravision);

    // Apply it on use.
    ApplyEffectToObject( DURATION_TYPE_PERMANENT,eLink, oPC );

    // Private message upon activation
    FloatingTextStringOnCreature( "<cþ>- Night Eyes activated -</c>", oPC, FALSE );
}

void TenebrousTempo( object oPC )
{

    effect eShadow = EffectLinkEffects( EffectMovementSpeedIncrease( 25 ), EffectVisualEffect( VFX_DUR_AURA_PULSE_GREY_BLACK ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( eShadow ), oPC, TurnsToSeconds( GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC ) ) );
    // Private message upon activation
    FloatingTextStringOnCreature( "<cþ>- Tenebrous Tempo activated -</c>", oPC, FALSE );
}


void VestmentOfShadows( object oPC )
{

    // Used for duration/AC.
    int nDuration   = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC );

    // Visual variables.
    effect eVFX     = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );
    effect eFNF     = EffectVisualEffect( VFX_IMP_AC_BONUS );

    // Effects
    effect eImmunity = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,50);
    effect eDeath = EffectImmunity( IMMUNITY_TYPE_DEATH );

    // Link it all together.
    effect eLink = EffectLinkEffects( eVFX, eDeath );

    // Apply to the PC.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eFNF, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImmunity, oPC, TurnsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds( nDuration ) );
    FloatingTextStringOnCreature( "<cþ>- Vestment Of Shadows -</c>", oPC, FALSE );

}
