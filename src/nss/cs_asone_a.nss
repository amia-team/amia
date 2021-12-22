// As One (OnEnter Aura)
//
// Creates an area of effect that lowers Spell Resistance and saves versus spells when inside.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/10/2012 PoS              Initial Release.
//

#include "X0_I0_SPELLS"

void main()
{
    // Variables.
    object  oTarget                 = GetEnteringObject();
    object  oModule                 = GetModule();
    object  oPC                     = GetLocalObject( oModule, "asone_user" );

    effect  ePenalty1;
    effect  ePenalty2;
    effect  eLink;
    string  sName                   = GetName( oTarget );

    // These results are defined here so we can output the results later to the target and user.
    int     nSpellcraftDC           = GetSkillRank( SKILL_SPELLCRAFT, oPC );
    int     nSpellcraftSave         = GetSkillRank( SKILL_SPELLCRAFT, oTarget );

    int     nRandom1                = d20();
    int     nRandom2                = d20();

    int     nSpellcraftDCTotal      = nSpellcraftDC + nRandom1;
    int     nSpellcraftSaveTotal    = nSpellcraftSave + nRandom2;

    int     nResult                 = nSpellcraftDCTotal - nSpellcraftSaveTotal;

    // Works on friendlies, neutrals and hostiles, but not the user.
    if( oTarget == oPC )
    {
        return;
    }

    // Stacking check.
    if( GetLocalInt( oTarget, "As_One_Penalty" ) == 1 )
    {
        return;
    }

    if( nResult >= 0 ) // The penalty varies based on how much they failed by
    {
        if( nResult > 0 && nResult <= 5 )
        {
            ePenalty1 = EffectSpellResistanceDecrease( 2 );
            ePenalty2 = EffectSavingThrowDecrease( SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_SPELL );
            DelayCommand( 1.0, FloatingTextStringOnCreature( "As strange and utterly sublime as the event around Beldor seems, the magical currents about him can be read well enough to dodge the brunt of its effects.", oTarget, FALSE ) );
        }
        if( nResult > 5 && nResult <= 10 )
        {
            ePenalty1 = EffectSpellResistanceDecrease( 4 );
            ePenalty2 = EffectSavingThrowDecrease( SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_SPELL );
            DelayCommand( 1.0, FloatingTextStringOnCreature( "As strange and utterly sublime as the event around Beldor seems, the magical currents about him can be read well enough to dodge the brunt of its effects.", oTarget, FALSE ) );
        }
        if( nResult > 10 && nResult <= 15 )
        {
            ePenalty1 = EffectSpellResistanceDecrease( 8 );
            ePenalty2 = EffectSavingThrowDecrease( SAVING_THROW_ALL, 3, SAVING_THROW_TYPE_SPELL );
            DelayCommand( 1.0, FloatingTextStringOnCreature( "This arcane phenomenon appears to be elusive in its true nature. What is clear, however, is that being within its promixity renders you more vulnerable to the Weave.", oTarget, FALSE ) );
        }
        if( nResult > 15 && nResult <= 20 )
        {
            ePenalty1 = EffectSpellResistanceDecrease( 10 );
            ePenalty2 = EffectSavingThrowDecrease( SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_SPELL );
            DelayCommand( 1.0, FloatingTextStringOnCreature( "This arcane phenomenon appears to be elusive in its true nature. What is clear, however, is that being within its promixity renders you more vulnerable to the Weave.", oTarget, FALSE ) );
        }
        if( nResult > 20 && nResult <= 25 )
        {
            ePenalty1 = EffectSpellResistanceDecrease( 12 );
            ePenalty2 = EffectSavingThrowDecrease( SAVING_THROW_ALL, 5, SAVING_THROW_TYPE_SPELL );
            DelayCommand( 1.0, FloatingTextStringOnCreature( "This mind-bending anomaly appears as if beyond comprehension. The awe-inspiring power of the event bears down upon you, reducing your resistance to the Weave itself.", oTarget, FALSE ) );
        }
        if( nResult > 25 )
        {
            ePenalty1 = EffectSpellResistanceDecrease( 12 );
            ePenalty2 = EffectSavingThrowDecrease( SAVING_THROW_ALL, 6, SAVING_THROW_TYPE_SPELL );
            DelayCommand( 1.0, FloatingTextStringOnCreature( "This mind-bending anomaly appears as if beyond comprehension. The awe-inspiring power of the event bears down upon you, reducing your resistance to the Weave itself.", oTarget, FALSE ) );
        }

        eLink = EffectLinkEffects( ePenalty1, ePenalty2 );
        eLink = ExtraordinaryEffect( eLink );

        // Apply the penalty.
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, 30.0 );

        // Output the info to the user and target.
        FloatingTextStringOnCreature( "<c þþ><c  þ>"+sName+"</c> : Spellcraft Save : *failure* : (" +IntToString( nSpellcraftSave )+ " + " +IntToString( nRandom2 )+ " = " +IntToString( nSpellcraftSaveTotal )+ " vs. DC: " +IntToString( nSpellcraftDCTotal )+ ")</c>", oPC, FALSE );
        FloatingTextStringOnCreature( "<c þþ><c  þ>"+sName+"</c> : Spellcraft Save : *failure* : (" +IntToString( nSpellcraftSave )+ " + " +IntToString( nRandom2 )+ " = " +IntToString( nSpellcraftSaveTotal )+ " vs. DC: " +IntToString( nSpellcraftDCTotal )+ ")</c>", oTarget, FALSE );

        // Have to assign the command to the target, since when the aura dies this won't trigger.
        SetLocalInt( oTarget, "As_One_Penalty", 1 );
        AssignCommand( oTarget, DelayCommand( 30.0, DeleteLocalInt( oTarget, "As_One_Penalty" ) ) );
    }
    else
    {
         // Output the info to the user and target.
         FloatingTextStringOnCreature( "<c þþ><c  þ>"+sName+"</c> : Spellcraft Save : *success* : (" +IntToString( nSpellcraftSave )+ " + " +IntToString( nRandom2 )+ " = " +IntToString( nSpellcraftSaveTotal )+ " vs. DC: " +IntToString( nSpellcraftDCTotal )+ ")</c>", oPC, FALSE );
         FloatingTextStringOnCreature( "<c þþ><c  þ>"+sName+"</c> : Spellcraft Save : *success* : (" +IntToString( nSpellcraftSave )+ " + " +IntToString( nRandom2 )+ " = " +IntToString( nSpellcraftSaveTotal )+ " vs. DC: " +IntToString( nSpellcraftDCTotal )+ ")</c>", oTarget, FALSE );
    }
}
