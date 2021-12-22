// Has three different abilities depending on the target... takes two turn undead charges per use.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 22/10/2011 PaladinOfSune    Initial Release
//

#include "x2_inc_switches"

void DoLitany( object oPC, object oTarget );
void DoExorcism( object oPC, location lTarget );
void DoInvocation( object oPC );

void KillInvis( object oPC ){

    effect eEff = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEff ) ){
        nType=GetEffectType( eEff );

        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY )
            RemoveEffect( oPC, eEff );

        eEff = GetNextEffect( oPC );
    }
}

void ActivateItem()
{
    // Variables.
    object oPC          = GetItemActivator();
    object oTarget      = GetItemActivatedTarget();
    location lTarget    = GetItemActivatedTargetLocation();

    int x;
    for ( x = 0; x < 2; x++ ) {
        if( !GetHasFeat( FEAT_TURN_UNDEAD, oPC ) ) {
            FloatingTextStringOnCreature( "You do not have enough uses of Turn Undead to use this ability.", oPC, FALSE );
            return;
        }
        DecrementRemainingFeatUses( oPC, FEAT_TURN_UNDEAD );
    }

    // Perform it
    if( oPC == oTarget ) {
        DoInvocation( oPC );
    }
    else if( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ) {
        KillInvis( oPC );
        DoLitany( oPC, oTarget );
    }
    else {
        KillInvis( oPC );
        DoExorcism( oPC, lTarget );
    }
}

void DoInvocation( object oPC ) {

    //Declare major variables
    effect eSave        = EffectSavingThrowIncrease( SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR );
    effect eFear;

    effect eVFX1        = EffectVisualEffect( VFX_DUR_AURA_WHITE );
    effect eVFX2        = EffectVisualEffect( 689 );
    effect eVFX3        = EffectVisualEffect( VFX_FNF_LOS_HOLY_10 );

    effect eLink        = EffectLinkEffects( eVFX1, eVFX2 );
           eLink        = EffectLinkEffects( eSave, eLink );

    float  fDur         = RoundsToSeconds( 5 );

    AssignCommand( oPC, PlaySound( "vs_ncelestf_help" ) );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, fDur );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX3, oPC );

    //Get first target in the spell area
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation( oPC ) );
    while( GetIsObjectValid( oTarget ) )
    {
        //Only remove the fear effect from the people who are friends.
        if( GetIsFriend( oTarget ) )
        {
            eFear = GetFirstEffect( oTarget );
            //Get the first effect on the current target
            while( GetIsEffectValid( eFear ) )
            {
                if ( GetEffectType( eFear ) == EFFECT_TYPE_FRIGHTENED )
                {
                    //Remove any fear effects and apply the VFX impact
                    RemoveEffect( oTarget, eFear );
                }
                //Get the next effect on the target
                eFear = GetNextEffect( oTarget );
            }

            DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSave, oTarget, fDur ) );
        }
        //Get the next target in the spell area.
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation( oPC ) );
    }
}

void DoLitany( object oPC, object oTarget ) {

    int nDC                 = GetSkillRank( SKILL_CONCENTRATION, oTarget, FALSE ) + d20();
    effect eVFX1            = EffectVisualEffect( VFX_DUR_PDK_FEAR );
    effect eWeak1           = EffectDamageImmunityDecrease( DAMAGE_TYPE_BLUDGEONING, 5 );
    effect eWeak2           = EffectDamageImmunityDecrease( DAMAGE_TYPE_SLASHING, 5 );
    effect eWeak3           = EffectDamageImmunityDecrease( DAMAGE_TYPE_PIERCING, 5 );

    effect eLink            = EffectLinkEffects( eVFX1, eWeak1 );
           eLink            = EffectLinkEffects( eWeak2, eLink );
           eLink            = EffectLinkEffects( eWeak3, eLink );

    AssignCommand( oPC, PlaySound( "vs_ncelestf_warn" ) );

    if( GetIsSkillSuccessful( oPC, SKILL_TAUNT, nDC ) ) {
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, 30.0 );
    }
}

void DoExorcism( object oPC, location lTarget ) {

    // Turning power
    int nClericLevel        = GetLevelByClass( CLASS_TYPE_CLERIC, oPC );
    int nPaladinLevel       = GetLevelByClass( CLASS_TYPE_PALADIN, oPC );
    int nBlackguardlevel    = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
    int nTotalLevel         = GetHitDice( oPC );

    int nTurnLevel          = nClericLevel;
    int nClassLevel         = nClericLevel;

    // Stacks with Blackguard OR Paladin
    if((nBlackguardlevel - 2) > 0 && (nBlackguardlevel > nPaladinLevel))
    {
        nClassLevel += (nBlackguardlevel - 2);
        nTurnLevel  += (nBlackguardlevel - 2);
    }
    else if((nPaladinLevel - 2) > 0)
    {
        nClassLevel += (nPaladinLevel -2);
        nTurnLevel  += (nPaladinLevel - 2);
    }

    // Make a turning check roll
    int nChrMod             = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nTurnCheck          = d20() + nChrMod;              //The roll to apply to the max HD of undead that can be turned --> nTurnLevel
    int nTurnHD             = d6(2) + nChrMod + nClassLevel;   //The number of HD of undead that can be turned.

    //Determine the maximum HD of the undead that can be turned.
    if(nTurnCheck <= 0)
    {
        nTurnLevel -= 4;
    }
    else if(nTurnCheck >= 1 && nTurnCheck <= 3)
    {
        nTurnLevel -= 3;
    }
    else if(nTurnCheck >= 4 && nTurnCheck <= 6)
    {
        nTurnLevel -= 2;
    }
    else if(nTurnCheck >= 7 && nTurnCheck <= 9)
    {
        nTurnLevel -= 1;
    }
    else if(nTurnCheck >= 10 && nTurnCheck <= 12)
    {
        //Stays the same
    }
    else if(nTurnCheck >= 13 && nTurnCheck <= 15)
    {
        nTurnLevel += 1;
    }
    else if(nTurnCheck >= 16 && nTurnCheck <= 18)
    {
        nTurnLevel += 2;
    }
    else if(nTurnCheck >= 19 && nTurnCheck <= 21)
    {
        nTurnLevel += 3;
    }
    else if(nTurnCheck >= 22)
    {
        nTurnLevel += 4;
    }

    AssignCommand( oPC, PlaySound( "vs_ncelestf_bat2" ) );

    //Gets all creatures in a 20m radius around the caster and turns them or not.  If the creatures
    //HD are 1/2 or less of the nClassLevel then the creature is destroyed.
    int nCnt = 1;
    int nHD, nRacial, nHDCount, bValid, nDamage;
    nHDCount = 0;

    // Turned visual
    effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eTurned = EffectTurned();
    effect eLink = EffectLinkEffects(eVisTurn, eTurned);

    // Turned death
    effect eDeath = SupernaturalEffect( EffectDeath( TRUE ) );

    // Fire off impact visual
    effect eImpactVis = EffectVisualEffect(VFX_FNF_WORD);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTarget);

    //Get nearest enemy within 20m (60ft)
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
    while(GetIsObjectValid(oTarget) && nHDCount < nTurnHD)
    {
        if(!GetIsFriend(oTarget))
        {
            nRacial = GetRacialType(oTarget);

            nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
            if(nHD <= nTurnLevel && nHD <= (nTurnHD - nHDCount))
            {
                //Check the various domain turning types
                if(nRacial == RACIAL_TYPE_UNDEAD)
                {
                    bValid = TRUE;
                }
                else if (nRacial == RACIAL_TYPE_OUTSIDER )
                {
                    bValid = TRUE;
                }

                //Apply results of the turn
                if( bValid == TRUE)
                {
                    if((nClassLevel/2) >= nHD)
                    {
                        if (nRacial == RACIAL_TYPE_OUTSIDER)
                        {
                            effect ePlane2 = EffectVisualEffect(VFX_IMP_UNSUMMON);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, ePlane2, oTarget);
                        }

                        effect ePlane2 = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);

                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_TURN_UNDEAD));
                        //Destroy the target
                        DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    }
                    else
                    {
                        //Turn the target
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_TURN_UNDEAD));
                        AssignCommand(oTarget, ActionMoveAwayFromObject(oPC, TRUE));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nClassLevel + 5));
                    }
                    nHDCount = nHDCount + nHD;
                }
            }
            bValid = FALSE;
        }
        nCnt++;
        oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE, oPC, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
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
