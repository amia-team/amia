/*  Blackguard PrC PnP Spells.

    --------
    Verbatim
    --------
    This script is the main handler for the Blackguard PrC PnP spells.
    Specifically the spells are activated via the Unique Power of widgets.
    The widget names are used to determine the spell to cast.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    051506  Aleph       Initial release.
    010811  PoS         Edited Unholy Sword and Demon Flesh.
    011211  PoS         Removed +1 from Corrupt Weapon, now stacks w/ Unholy Sword.
    050612  Glim        Added function for Corrupt Weapon and Unholy Sword to be
                        applied to Gauntlets if there is no weapon in hand.
    091812  Glim        Added in auto switching from old Aura of Despair widget
                        to the new one with unlimited uses per day.
    042715  PoS         Reverted Aura of Despair behaviour to being widget based.
    021015  Mav         Buffed the spells (Corrupted Weapon, Demon Flesh, Veil of Shadow,
                        and Unholy Avenger) slightly to make up for single cast
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "x2_i0_spells"
#include "x2_inc_itemprop"
#include "X2_inc_switches"
#include "x2_inc_toollib"
#include "amia_include"

/* Prototypes. */

// This function will check whether the blackguard has sufficient rank and Wisdom score.
int CheckLevelAndWisdomScore( object oPC, int nBGD_rank, int nWisdomScore, int nRequiredRank, int nRequiredWisdomScore );


void main( ){

    // Variables.
    int nEvent              = GetUserDefinedItemEventNumber( );
    int nResult             = X2_EXECUTE_SCRIPT_END;
    object oPC              = GetItemActivator( );
    location lPC_loc        = GetLocation( oPC );
    int nBGD_rank           = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
    object oWidget          = GetItemActivated( );
    string szItemName       = GetName( oWidget );
    int nWisdomScore        = GetAbilityScore( oPC, ABILITY_WISDOM, TRUE );
    object oItem            = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    object oBracer          = GetItemInSlot( INVENTORY_SLOT_ARMS, oPC);
    float fDuration         = TurnsToSeconds( nBGD_rank );
    float fDurationLong     = HoursToSeconds( nBGD_rank );
    int nDuration           = FloatToInt( fDuration );
    int nDurationLong       = FloatToInt( fDurationLong );

    if ( !nBGD_rank ){

        return;
    }

    //Smackd down, same as in the spellhook
    if ( GetLocalInt( oPC, "Fallen" ) == 1 )
    {
        FloatingTextStringOnCreature( "The plea to your deity is not heard...", oPC, FALSE );

        //Tell the spell to stop running.
        SetModuleOverrideSpellScriptFinished();

        return;
    }

    // Check player; valid item; and Unique Power.
    if( !GetIsPC( oPC ) && !GetIsObjectValid( oItem ) && nEvent != X2_ITEM_EVENT_ACTIVATE ){
        SetExecutedScriptReturnValue( nEvent );
        return;
    }

    /* Determine which spell was accessed. */

    // Corrupt Weapon.
    if( szItemName == "Blackguard Spell: Corrupt Weapon"    &&
        CheckLevelAndWisdomScore( oPC, nBGD_rank, nWisdomScore, 0, 11 ) ){

        // Candy.
        ApplyEffectToObject(    DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_LOS_EVIL_20 ), oPC );

        // To prevent stacking Corrupt Weapon spells on top of each other.
        if ( GetIsBlocked( oPC, "blade_corrupted" ) > 0 ) {
            return;
        }

        // Evil visual effect.
        if ( GetIsObjectValid(oItem) == TRUE ) {
        IPSafeAddItemProperty(  oItem, ItemPropertyVisualEffect( ITEM_VISUAL_EVIL ),
                                fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE );
        }
        else {
        IPSafeAddItemProperty(  oBracer, ItemPropertyVisualEffect( ITEM_VISUAL_EVIL ),
                                fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE );
        }

        // Negative Damage 2d6 vs. Good alignments.
        if ( GetIsObjectValid(oItem) == TRUE ) {
        IPSafeAddItemProperty(  oItem,
                                ItemPropertyDamageBonusVsAlign(
                                                                IP_CONST_ALIGNMENTGROUP_GOOD,
                                                                IP_CONST_DAMAGETYPE_NEGATIVE,
                                                                IP_CONST_DAMAGEBONUS_2d6        ),
                                fDuration,
                                X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, TRUE );
        }
        else {
        IPSafeAddItemProperty(  oBracer,
                                ItemPropertyDamageBonusVsAlign(
                                                                IP_CONST_ALIGNMENTGROUP_GOOD,
                                                                IP_CONST_DAMAGETYPE_NEGATIVE,
                                                                IP_CONST_DAMAGEBONUS_2d6        ),
                                fDuration,
                                X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, TRUE );
        }
        SetBlockTime( oPC, 1, nDuration, "blade_corrupted" );
    }



    // Demon Flesh.
    if ( szItemName == "Blackguard Spell: Demon Flesh"    &&
        CheckLevelAndWisdomScore( oPC, nBGD_rank, nWisdomScore, 0, 11 ) ){

        // Variables.
        int nAC_Bonus   = nBGD_rank / 3;

        // Minimum bonus +1.
        if( nAC_Bonus < 1 )
            nAC_Bonus = 1;

        // Maximum bonus +3.
        if( nAC_Bonus > 5 )
            nAC_Bonus = 5;

        // +1 NAC per 4 levels of Blackguard.
        ApplyEffectToObject(    DURATION_TYPE_TEMPORARY, EffectACIncrease( nAC_Bonus, AC_NATURAL_BONUS ),
                                oPC, fDurationLong );

        // Candy.
        ApplyEffectToObject(    DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH ), oPC );

    }



    // Aura of Despair.
    if( szItemName == "Blackguard Spell: Aura of Despair" ){

        // Aura of Despair spell.
        ExecuteScript( "bg_despair", oPC );
    }



    // Veil of Shadow.
    if( szItemName == "Blackguard Spell: Veil of Shadow"    &&
        CheckLevelAndWisdomScore( oPC, nBGD_rank, nWisdomScore, 3, 12 ) ){

        // Visual Effect: Gray glow.
        ApplyEffectToObject(    DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_GLOW_GREY ),
                                oPC, fDuration );

        // Veil of Shadow.
        if(nBGD_rank >= 12)
        {
           ApplyEffectToObject(    DURATION_TYPE_TEMPORARY, EffectConcealment( 50 ),
                                oPC, fDuration );
        }
        else if(nBGD_rank >= 9)
        {
           ApplyEffectToObject(    DURATION_TYPE_TEMPORARY, EffectConcealment( 40 ),
                                oPC, fDuration );
        }
        else if(nBGD_rank >= 6)
        {
           ApplyEffectToObject(    DURATION_TYPE_TEMPORARY, EffectConcealment( 30 ),
                                oPC, fDuration );
        }
        else
        {
           ApplyEffectToObject(    DURATION_TYPE_TEMPORARY, EffectConcealment( 20 ),
                                oPC, fDuration );
        }


        // Candy.
        ApplyEffectToObject(    DURATION_TYPE_INSTANT,  EffectVisualEffect( VFX_IMP_DEATH_WARD ), oPC );

    }



    // Darkness.
    if( szItemName == "Blackguard Spell: Darkness"          &&
        CheckLevelAndWisdomScore( oPC, nBGD_rank, nWisdomScore, 3, 12 ) ){

        // Hack to immunize caster from effects of the Darkness spell.
        RemoveSpecificEffect( EFFECT_TYPE_INVISIBILITY, oPC );

        // Fire the Darkness spellscript, check within for detail.
        ExecuteScript( "bg_dark", oPC );

    }



    // Deeper Darkness.
    if( szItemName == "Blackguard Spell: Deeper Darkness"   &&
        CheckLevelAndWisdomScore( oPC, nBGD_rank, nWisdomScore, 6, 13 ) )

        // Fire the Deeper Darkness spellscritp, check within for detail.
        ExecuteScript( "bg_deepdark", oPC );



    // Abyssal Might.
    if( szItemName == "Blackguard Spell: Abyssal Might"     &&
        CheckLevelAndWisdomScore( oPC, nBGD_rank, nWisdomScore, 6, 13 ) ){

        // STR +2, CON +2, DEX +2 boost.
        ApplyEffectToObject(    DURATION_TYPE_TEMPORARY,
                                EffectLinkEffects(
                                    EffectLinkEffects(
                                                    EffectAbilityIncrease( ABILITY_STRENGTH, 2 ),
                                                    EffectAbilityIncrease( ABILITY_CONSTITUTION, 2 ) ),
                                    EffectAbilityIncrease( ABILITY_DEXTERITY, 2 )
                                ),
                                oPC,
                                fDuration );

        // Candy.
        ApplyEffectToObject(    DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HARM ), oPC );

        ApplyEffectToObject(    DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_PROTECTION_EVIL_MAJOR ),
                                oPC, fDuration );

    }



    // Unholy Sword.
    if( szItemName == "Blackguard Spell: Unholy Sword"    &&
        CheckLevelAndWisdomScore( oPC, nBGD_rank, nWisdomScore, 8, 14 ) ){

        // Duration: 2 Round per Blackguard Level.
        fDuration = RoundsToSeconds( nBGD_rank*2 );
        nDuration = FloatToInt( fDuration );

        // Candy.
        TLVFXPillar( VFX_IMP_EVIL_HELP, lPC_loc, 4, 0.0, 6.0 );
        DelayCommand( 1.0, ApplyEffectAtLocation(
                                                DURATION_TYPE_INSTANT,
                                                EffectVisualEffect( VFX_IMP_SUPER_HEROISM),
                                                lPC_loc ) );

        // To prevent stacking Unholy Sword spells on top of each other.
        if ( GetIsBlocked( oPC, "blade_unholy" ) > 0 ) {
            return;
        }

        // Negative 1d6 vs. Good alignments.
        if ( GetIsObjectValid(oItem) == TRUE ) {
        IPSafeAddItemProperty(  oItem,
                                ItemPropertyDamageBonusVsAlign(
                                                            IP_CONST_ALIGNMENTGROUP_GOOD,
                                                            IP_CONST_DAMAGETYPE_DIVINE,
                                                            IP_CONST_DAMAGEBONUS_1d6        ),
                                fDuration,
                                X2_IP_ADDPROP_POLICY_IGNORE_EXISTING,
                                FALSE,
                                TRUE );
        }
        else {
        IPSafeAddItemProperty(  oBracer,
                                ItemPropertyDamageBonusVsAlign(
                                                            IP_CONST_ALIGNMENTGROUP_GOOD,
                                                            IP_CONST_DAMAGETYPE_DIVINE,
                                                            IP_CONST_DAMAGEBONUS_1d6        ),
                                fDuration,
                                X2_IP_ADDPROP_POLICY_IGNORE_EXISTING,
                                FALSE,
                                TRUE );
        }

        // On Hit: Greater Dispel DC 20.
        if ( GetIsObjectValid(oItem) == TRUE ) {
        IPSafeAddItemProperty(  oItem,
                                ItemPropertyOnHitProps(
                                                        IP_CONST_ONHIT_GREATERDISPEL,
                                                        IP_CONST_ONHIT_SAVEDC_20,
                                                        IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS ),
                                fDuration,
                                X2_IP_ADDPROP_POLICY_KEEP_EXISTING,
                                TRUE );
        }
        else {
        IPSafeAddItemProperty(  oBracer,
                                ItemPropertyOnHitProps(
                                                        IP_CONST_ONHIT_GREATERDISPEL,
                                                        IP_CONST_ONHIT_SAVEDC_20,
                                                        IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS ),
                                fDuration,
                                X2_IP_ADDPROP_POLICY_KEEP_EXISTING,
                                TRUE );
        }

        // Enhancement +5.
        if ( GetIsObjectValid(oItem) == TRUE ) {
        IPSafeAddItemProperty(  oItem,
                                ItemPropertyEnhancementBonus( 5 ),
                                fDuration,
                                X2_IP_ADDPROP_POLICY_KEEP_EXISTING,
                                TRUE );
        }
        else {
        IPSafeAddItemProperty(  oBracer,
                                ItemPropertyEnhancementBonus( 5 ),
                                fDuration,
                                X2_IP_ADDPROP_POLICY_KEEP_EXISTING,
                                TRUE );
        }

        // Visual Effect: Unholy!
        if ( GetIsObjectValid(oItem) == TRUE ) {
        IPSafeAddItemProperty(  oItem,
                                ItemPropertyVisualEffect( ITEM_VISUAL_EVIL ),
                                fDuration,
                                X2_IP_ADDPROP_POLICY_KEEP_EXISTING,
                                TRUE );
        }
        else {
        IPSafeAddItemProperty(  oBracer,
                                ItemPropertyVisualEffect( ITEM_VISUAL_EVIL ),
                                fDuration,
                                X2_IP_ADDPROP_POLICY_KEEP_EXISTING,
                                TRUE );
        }

        SetBlockTime( oPC, 1, nDuration, "blade_unholy" );
    }

    SetExecutedScriptReturnValue( nEvent );
    return;

}


/* Prototype Definitions. */

// This function will check whether the blackguard has sufficient rank and Wisdom score.
int CheckLevelAndWisdomScore( object oPC, int nBGD_rank, int nWisdomScore, int nRequiredRank, int nRequiredWisdomScore ){

    // Check rank.
    if( nBGD_rank < nRequiredRank ){
        SendMessageToPC( oPC,   "- You need " + IntToString( nRequiredRank )    +
                                " levels of Blackguard to cast this spell! -" );
        return( 0 );
    }

    // Check Wisdom score.
    if( nWisdomScore < nRequiredWisdomScore ){
        SendMessageToPC( oPC,   "- You need at least " + IntToString( nRequiredWisdomScore )    +
                                " Wisdom score to cast this spell! -" );
        return( 0 );
    }

    // All checked out ok.
    return( 1 );

}
