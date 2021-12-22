#include "nwnx_effects"
#include "inc_td_itemprop"
#include "x0_i0_spells"

int DispelSpell( object oCaster, object oTarget, int nSpell, int nVsCL, int nDispelType );
int DispelEffectsAll( object oCaster, int nCL, object oTarget, int nMaxSpells=0, int nDispelType=0 );
string GetSpellName( int nSpell );
void RemoveItemEnchants( object oTarget, int nSpell );
int GetAlternativeCL( object oTarget, int nSpell );


/*void main(){
    SendMessageToPC( OBJECT_SELF, "Spells: " + IntToString( DispelEffectsAll( OBJECT_SELF, 20, OBJECT_SELF ) ) );
}*/

int GetAlternativeCL( object oTarget, int nSpell ){

    if( !GetIsObjectValid( oTarget ) )
        return 0;

    switch( nSpell ){

        case SPELLABILITY_AA_ARROW_OF_DEATH:
        case SPELLABILITY_AA_HAIL_OF_ARROWS:
        case SPELLABILITY_AA_IMBUE_ARROW:
        case SPELLABILITY_AA_SEEKER_ARROW_1:
        case SPELLABILITY_AA_SEEKER_ARROW_2:
        case SPELLABILITY_ACTIVATE_ITEM:
        case SPELLABILITY_AS_DARKNESS:
        case SPELLABILITY_AS_GHOSTLY_VISAGE:
        case SPELLABILITY_AS_IMPROVED_INVISIBLITY:
        case SPELLABILITY_AS_INVISIBILITY:
        case SPELLABILITY_AURA_BLINDING:
        case SPELLABILITY_AURA_COLD:
        case SPELLABILITY_AURA_ELECTRICITY:
        case SPELLABILITY_AURA_FEAR:
        case SPELLABILITY_AURA_FIRE:
        case SPELLABILITY_AURA_HORRIFICAPPEARANCE:
        case SPELLABILITY_AURA_MENACE:
        case SPELLABILITY_AURA_OF_COURAGE:
        case SPELLABILITY_AURA_PROTECTION:
        case SPELLABILITY_AURA_STUN:
        case SPELLABILITY_AURA_UNEARTHLY_VISAGE:
        case SPELLABILITY_AURA_UNNATURAL:
        case SPELLABILITY_BARBARIAN_RAGE:
        case SPELLABILITY_BATTLE_MASTERY:
        case SPELLABILITY_BG_BULLS_STRENGTH:
        case SPELLABILITY_BG_CONTAGION:
        case SPELLABILITY_BG_CREATEDEAD:
        case SPELLABILITY_BG_FIENDISH_SERVANT:
        case SPELLABILITY_BG_INFLICT_CRITICAL_WOUNDS:
        case SPELLABILITY_BG_INFLICT_SERIOUS_WOUNDS:
        case SPELLABILITY_BOLT_ABILITY_DRAIN_CHARISMA:
        case SPELLABILITY_BOLT_ABILITY_DRAIN_CONSTITUTION:
        case SPELLABILITY_BOLT_ABILITY_DRAIN_DEXTERITY:
        case SPELLABILITY_BOLT_ABILITY_DRAIN_INTELLIGENCE:
        case SPELLABILITY_BOLT_ABILITY_DRAIN_STRENGTH:
        case SPELLABILITY_BOLT_ABILITY_DRAIN_WISDOM:
        case SPELLABILITY_BOLT_ACID:
        case SPELLABILITY_BOLT_CHARM:
        case SPELLABILITY_BOLT_COLD:
        case SPELLABILITY_BOLT_CONFUSE:
        case SPELLABILITY_BOLT_DAZE:
        case SPELLABILITY_BOLT_DEATH:
        case SPELLABILITY_BOLT_DISEASE:
        case SPELLABILITY_BOLT_DOMINATE:
        case SPELLABILITY_BOLT_FIRE:
        case SPELLABILITY_BOLT_KNOCKDOWN:
        case SPELLABILITY_BOLT_LEVEL_DRAIN:
        case SPELLABILITY_BOLT_LIGHTNING:
        case SPELLABILITY_BOLT_PARALYZE:
        case SPELLABILITY_BOLT_POISON:
        case SPELLABILITY_BOLT_SHARDS:
        case SPELLABILITY_BOLT_SLOW:
        case SPELLABILITY_BOLT_STUN:
        case SPELLABILITY_BOLT_WEB:
        case SPELLABILITY_BREATH_PETRIFY:
        case SPELLABILITY_CHARMMONSTER:
        case SPELLABILITY_COMMAND_THE_HORDE:
        case SPELLABILITY_CONE_ACID:
        case SPELLABILITY_CONE_COLD:
        case SPELLABILITY_CONE_DISEASE:
        case SPELLABILITY_CONE_FIRE:
        case SPELLABILITY_CONE_LIGHTNING:
        case SPELLABILITY_CONE_POISON:
        case SPELLABILITY_CONE_SONIC:
        case SPELLABILITY_DC_DIVINE_WRATH:
        case SPELLABILITY_DETECT_EVIL:
        case SPELLABILITY_DIVINE_PROTECTION:
        case SPELLABILITY_DIVINE_STRENGTH:
        case SPELLABILITY_DIVINE_TRICKERY:
        case SPELLABILITY_DRAGON_BREATH_ACID:
        case SPELLABILITY_DRAGON_BREATH_COLD:
        case SPELLABILITY_DRAGON_BREATH_FEAR:
        case SPELLABILITY_DRAGON_BREATH_FIRE:
        case SPELLABILITY_DRAGON_BREATH_GAS:
        case SPELLABILITY_DRAGON_BREATH_LIGHTNING:
        case SPELLABILITY_DRAGON_BREATH_NEGATIVE:
        case SPELLABILITY_DRAGON_BREATH_PARALYZE:
        case SPELLABILITY_DRAGON_BREATH_SLEEP:
        case SPELLABILITY_DRAGON_BREATH_SLOW:
        case SPELLABILITY_DRAGON_BREATH_WEAKEN:
        case SPELLABILITY_DRAGON_FEAR:
        case SPELLABILITY_DRAGON_WING_BUFFET:
        case SPELLABILITY_DW_DEFENSIVE_STANCE:
        case SPELLABILITY_ELEMENTAL_SHAPE:
        case SPELLABILITY_EMPTY_BODY:
        case SPELLABILITY_EPIC_CURSE_SONG:
        case SPELLABILITY_EPIC_IMPROVED_WHIRLWIND:
        case SPELLABILITY_EPIC_MIGHTY_RAGE:
        case SPELLABILITY_EPIC_SHAPE_DRAGON:
        case SPELLABILITY_EPIC_SHAPE_DRAGONKIN:
        case SPELLABILITY_FEROCITY_1:
        case SPELLABILITY_FEROCITY_2:
        case SPELLABILITY_FEROCITY_3:
        case SPELLABILITY_GAZE_CHARM:
        case SPELLABILITY_GAZE_CONFUSION:
        case SPELLABILITY_GAZE_DAZE:
        case SPELLABILITY_GAZE_DEATH:
        case SPELLABILITY_GAZE_DESTROY_CHAOS:
        case SPELLABILITY_GAZE_DESTROY_EVIL:
        case SPELLABILITY_GAZE_DESTROY_GOOD:
        case SPELLABILITY_GAZE_DESTROY_LAW:
        case SPELLABILITY_GAZE_DOMINATE:
        case SPELLABILITY_GAZE_DOOM:
        case SPELLABILITY_GAZE_FEAR:
        case SPELLABILITY_GAZE_PARALYSIS:
        case SPELLABILITY_GAZE_PETRIFY:
        case SPELLABILITY_GAZE_STUNNED:
        case SPELLABILITY_GOLEM_BREATH_GAS:
        case SPELLABILITY_HELL_HOUND_FIREBREATH:
        case SPELLABILITY_HOWL_CONFUSE:
        case SPELLABILITY_HOWL_DAZE:
        case SPELLABILITY_HOWL_DEATH:
        case SPELLABILITY_HOWL_DOOM:
        case SPELLABILITY_HOWL_FEAR:
        case SPELLABILITY_HOWL_PARALYSIS:
        case SPELLABILITY_HOWL_SONIC:

        case SPELLABILITY_HOWL_STUN:
        case SPELLABILITY_INTENSITY_1:
        case SPELLABILITY_INTENSITY_2:
        case SPELLABILITY_INTENSITY_3:
        case SPELLABILITY_KRENSHAR_SCARE:
        case SPELLABILITY_LAY_ON_HANDS:
        case SPELLABILITY_LESSER_BODY_ADJUSTMENT:
        case SPELLABILITY_MANTICORE_SPIKES:
        case SPELLABILITY_MEPHIT_SALT_BREATH:
        case SPELLABILITY_MEPHIT_STEAM_BREATH:
        case SPELLABILITY_MINDBLAST:
        case SPELLABILITY_MUMMY_BOLSTER_UNDEAD:
        case SPELLABILITY_NEGATIVE_PLANE_AVATAR:
        case SPELLABILITY_PM_ANIMATE_DEAD:
        case SPELLABILITY_PM_DEATHLESS_MASTER_TOUCH:
        case SPELLABILITY_PM_SUMMON_GREATER_UNDEAD:
        case SPELLABILITY_PM_SUMMON_UNDEAD:
        case SPELLABILITY_PM_UNDEAD_GRAFT_1:
        case SPELLABILITY_PM_UNDEAD_GRAFT_2:
        case SPELLABILITY_PULSE_ABILITY_DRAIN_CHARISMA:
        case SPELLABILITY_PULSE_ABILITY_DRAIN_CONSTITUTION:
        case SPELLABILITY_PULSE_ABILITY_DRAIN_DEXTERITY:
        case SPELLABILITY_PULSE_ABILITY_DRAIN_INTELLIGENCE:
        case SPELLABILITY_PULSE_ABILITY_DRAIN_STRENGTH:
        case SPELLABILITY_PULSE_ABILITY_DRAIN_WISDOM:
        case SPELLABILITY_PULSE_COLD:
        case SPELLABILITY_PULSE_DEATH:
        case SPELLABILITY_PULSE_DISEASE:
        case SPELLABILITY_PULSE_DROWN:
        case SPELLABILITY_PULSE_FIRE:
        case SPELLABILITY_PULSE_HOLY:
        case SPELLABILITY_PULSE_LEVEL_DRAIN:
        case SPELLABILITY_PULSE_LIGHTNING:
        case SPELLABILITY_PULSE_NEGATIVE:
        case SPELLABILITY_PULSE_POISON:
        case SPELLABILITY_PULSE_SPORES:
        case SPELLABILITY_PULSE_WHIRLWIND:
        case SPELLABILITY_QUIVERING_PALM:
        case SPELLABILITY_RAGE_3:
        case SPELLABILITY_RAGE_4:
        case SPELLABILITY_RAGE_5:
        case SPELLABILITY_REMOVE_DISEASE:
        case SPELLABILITY_ROGUES_CUNNING:
        case SPELLABILITY_SEAHAG_EVILEYE:
        case SPELLABILITY_SMITE_EVIL:
        case SPELLABILITY_SMOKE_CLAW:
        case SPELLABILITY_SUMMON_ANIMAL_COMPANION:
        case SPELLABILITY_SUMMON_CELESTIAL:
        case SPELLABILITY_SUMMON_FAMILIAR:
        case SPELLABILITY_SUMMON_MEPHIT:
        case SPELLABILITY_SUMMON_SLAAD:
        case SPELLABILITY_SUMMON_TANARRI:
        case SPELLABILITY_TOUCH_PETRIFY:
        case SPELLABILITY_TROGLODYTE_STENCH:
        case SPELLABILITY_TRUMPET_BLAST:
        case SPELLABILITY_TURN_UNDEAD:
        case SPELLABILITY_TYRANT_FOG_MIST:
        case SPELLABILITY_WHIRLWIND:
        case SPELLABILITY_WHOLENESS_OF_BODY:
        case SPELLABILITY_WILD_SHAPE:


        case SPELL_SUMMON_SHADOW:
        case SPELL_EPIC_DRAGON_KNIGHT:
        case SPELL_SHADOW_EVADE: return GetHitDice( oTarget );
        default:break;
    }

    return GetHitDice( oTarget )/2;
}

void RemoveItemEnchants( object oTarget, int nSpell ){

    int nIP = -1;

    switch( nSpell ){

        case SPELL_FLAME_WEAPON:
        case SPELL_DARKFIRE:
        case SPELL_KEEN_EDGE:
        case SPELL_MAGIC_WEAPON:
        case SPELL_GREATER_MAGIC_WEAPON:
        case SPELL_BLACKSTAFF:
        case SPELL_BLADE_THIRST: break;
        default: return;
    }

    itemproperty ipIP;
    object oItem = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oTarget );
    if( GetIsObjectValid( oItem ) ){

        ipIP = GetFirstItemProperty( oItem );
        while( GetIsItemPropertyValid( ipIP ) ){

            if( GetItemPropertyDurationType( ipIP ) == DURATION_TYPE_TEMPORARY ){

                RemoveItemProperty( oItem, ipIP );
                return;
            }

            ipIP = GetNextItemProperty( oItem );
        }
    }
    else
        return;

    oItem = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oTarget );
    if( GetIsObjectValid( oItem ) ){

        ipIP = GetFirstItemProperty( oItem );
        while( GetIsItemPropertyValid( ipIP ) ){

            if( GetItemPropertyDurationType( ipIP ) == DURATION_TYPE_TEMPORARY ){

                RemoveItemProperty( oItem, ipIP );
                return;
            }

            ipIP = GetNextItemProperty( oItem );
        }
    }
}

string GetSpellName( int nSpell ){

    string sRef = Catch2DAString( "spells", "name", nSpell );
    return CatchStringByStrRef( StringToInt( sRef ) );
}

int DispelSpell( object oCaster, object oTarget, int nSpell, int nVsCL, int nDispelType ){

    /* Terra's caster level override
    int nFound = FALSE;
    int nCL = 0

    effect eSpell = GetFirstEffect( oTarget );
    while( GetIsEffectValid( eSpell ) ){

        if( GetEffectSpellId( eSpell ) == nSpell && GetEffectSubType( eSpell ) == SUBTYPE_MAGICAL ){
        //DOCUMENTATION: // && GetEffectType( eSpell ) != EFFECT_TYPE_VISUALEFFECT
            nFound=TRUE;
            if( GetEffectCasterLevel( eSpell ) > nCL )
                nCL = GetEffectCasterLevel( eSpell );
        }
        eSpell = GetNextEffect( oTarget );
    }

    if(!nFound)
        return 0;


    object oCaster = GetEffectCreator( eSpell );

    int nCLAlt = GetAlternativeCL( oCaster, nSpell );

    if( nCLAlt == 0 ){
        nCLAlt = GetAlternativeCL( oTarget, nSpell );
    }

    if( nCLAlt > nCL )
        nCL = nCLAlt;

    int nDice = d20();
    int nVS = 10 + nCL;

    if( (nDice+nVsCL) > nVS  ){

        eSpell = GetFirstEffect( oTarget );
        while( GetIsEffectValid( eSpell ) ){

            if( GetEffectSpellId( eSpell ) == nSpell ){
                RemoveEffect( oTarget, eSpell );
            }
            eSpell = GetNextEffect( oTarget );
        }

        return nCL;
    }

    return 0;
    */

    int enemyBase = 12; //thanks bioware
    int enemyHitDice = GetHitDice( oTarget );
    int casterCL = nVsCL;
    int casterd20 = d20();
    int casterRoll = casterd20 + casterCL;
    int enemyRoll = enemyBase + enemyHitDice;
    effect eSpell;

    // on tie, it hits
    if ( casterRoll >= enemyRoll ) {
        eSpell = GetFirstEffect( oTarget );
        while( GetIsEffectValid( eSpell ) ){

            if( GetEffectSpellId( eSpell ) == nSpell ){
                RemoveEffect( oTarget, eSpell );
            }
            eSpell = GetNextEffect( oTarget );
        }

        return casterCL;
    }
    return 0;
}

int DispelEffectsAll( object oCaster, int nCL, object oTarget, int nMaxSpells, int nDispelType ){

    int nId = GetSpellId();

    //Stolen from x0_i0_spells
    if( nId > -1 ){
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {

            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, FALSE));
        }
    }
    int nDspCL = 0;
    string sList = "|";
    string sCurrent;
    int nSpell;
    int nCnt;

    /* RaveN randomizer for Dispels, mostly to keep non-mord spells relevant. */
    int isPvP = FALSE;
    // The bonus gets applied more often in PvP by subtracting this value from the bonus roll.
    int iPvPPenalty = 25;
    int iDisqualify = FALSE;
    int iBonusRoll;
    int iMultiplier = 1;
    // Final Calculated roll for Caster
    int iBonusDiceRoll;
    // The likelyhood that this bonus will be applied in a dispel
    int iBonusMod;
    // Number of times this bonus can be applied per dispel.
    int iBonusCounter = 0;
    // The maximum levels someone can be apart for this bonus to be applied.
    int iMaxDiff = -7;
    // Account for the roll in dispel indepdently
    int iCasterLevelRoll;
    // For spell caster benefit
    int iCasterBenefit = 0;
    int iCalcCasterCL = GetCasterLevel( oCaster );
    int iCalcTargetCL = GetCasterLevel( oTarget );
    // Can be negative
    int iCalcDiff = iCalcCasterCL - iCalcTargetCL;
    // The maximum benefit to someone's roll that someone can get for being a better caster than the victim.
    int iMaxCasterBenefit = 5;
    if( iCalcDiff >= iMaxCasterBenefit ) {
        iCasterBenefit = iMaxCasterBenefit;
    } else if ( iCalcDiff > 0 ) {
        iCasterBenefit = iCalcDiff;
    } else if ( iCalcDiff <= iMaxDiff ) {
        iCasterBenefit = 0;
        // Disqualify the caster from being given a bonus, too much of a difference in spellcaster levels.
        iDisqualify = TRUE;
        iBonusMod = 0;
    } else {
        iCasterBenefit = 0;
    }

    // Adjust for Caster Level Ceiling
    if( nDispelType == SPELL_MORDENKAINENS_DISJUNCTION ){
        // Changing this only impacts the rolls later on
        if(nCL > 40) nCL = 40;
        // This will not work for mordenkainen's disjunction.
        iDisqualify = TRUE;
        iBonusMod = 0;
        iBonusCounter = 0;
    } else if ( nDispelType == SPELL_GREATER_DISPELLING ) {
        if(nCL > 15) nCL = 15;
        iBonusMod = 100;
        iBonusCounter = 3;
    } else if ( nDispelType == SPELL_DISPEL_MAGIC ) {
        if(nCL > 10) nCL = 10;
        iBonusMod = 50;
        iBonusCounter = 2;
    } else if ( nDispelType == SPELL_LESSER_DISPEL ) {
        if(nCL > 5) nCL = 5;
        iBonusMod = 25;
        iBonusCounter = 1;
    }

    // Are caster / victim both players or player controlled summons?
    if( ( GetIsPC( oCaster )  || GetIsPossessedFamiliar( oCaster ) ) && ( GetIsPC( oTarget )  || GetIsPossessedFamiliar( oTarget ) ) ) {
        isPvP = TRUE;
        iBonusMod = 100;
    }
    // The rate at which the bonus can occur per source of cast.
    int iOccurencePercent = 10;
    // Another randomizer
    int iRandom;
    int addedCL = 0;

    // check for feats
    if (GetHasFeat (FEAT_SPELL_FOCUS_ABJURATION, oCaster))
    {
        addedCL += 2;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCaster))
    {
        addedCL += 2;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCaster))
    {
        addedCL += 2;
    }

    int nVictimLastDispelled = GetLocalInt( oTarget, "dispel_timer" );
    if ( nVictimLastDispelled > 0 ) {
        // Check to see if someone already get a bonus from dispelling this person in the last x(30) seconds?
        int nTime = GetRunTime();
        int nCooldown = 30;
        if( ( nVictimLastDispelled + nCooldown ) < nTime )
        {
            // enough time has elapsed reset it, and let it bonus roll
            SetLocalInt( oTarget, "dispel_timer", nTime );
        }
        else
        {
            // not enough time, cancel bonus
            iBonusCounter = 0;
        }
    } else {
        int nTime = GetRunTime();
        SetLocalInt( oTarget, "dispel_timer", nTime );
    }

    effect eSpell = GetFirstEffect( oTarget );
    while( GetIsEffectValid( eSpell ) ){

        iMultiplier = 1;

        if ( iBonusCounter > 0 ) {
            // Calculate the bonus! if one is to be had!
            iBonusRoll = Random(100);
            iRandom = Random(100);

            // Do we have a bonus mod to apply? Also, make sure we aren't disqualified.
            if( iBonusMod >= iBonusRoll && iOccurencePercent >= iRandom && !iDisqualify ) {

                iBonusDiceRoll = iBonusRoll - iCasterBenefit;

                // Roll for bonus to caster in PvP.
                if( isPvP == TRUE ) {
                    // In PvP this effect is more likely to occur by a lot.  ~50%.
                    iBonusDiceRoll = iBonusDiceRoll - iPvPPenalty;
                    if( iBonusDiceRoll <= 0 ) iBonusDiceRoll = 1;
                }

                if( iBonusDiceRoll >= 1 && iBonusDiceRoll <= 5 ) {
                    // 1-5 = *4 Multiplier
                    iMultiplier = 4;
                } else if ( iBonusDiceRoll >= 6 && iBonusDiceRoll <= 20 ) {
                    iMultiplier = 3;
                } else if ( iBonusDiceRoll >= 21 && iBonusDiceRoll <= 50 ) {
                    iMultiplier = 2;
                } else { // 51 - 100
                    iMultiplier = 1;
                }
            }

        }

        nSpell = GetEffectSpellId( eSpell );

        if( nSpell > -1 && GetEffectSubType( eSpell ) == SUBTYPE_MAGICAL ){

            // Use up a bonus roll, since it worked
            if( iMultiplier > 1 ) {
                iBonusCounter = iBonusCounter - 1;
            }

            if( ( nDspCL = DispelSpell( oCaster, oTarget, nSpell, ( ( nCL * iMultiplier ) + addedCL ), nDispelType ) ) > 0 ){

            sCurrent = GetSpellName( nSpell );
            RemoveItemEnchants( oTarget, nSpell );
            if(oCaster==oTarget){
                SendMessageToPC( oCaster, "<cÈ2þ>Self Dispelled: " + sCurrent+" ("+IntToString( nDspCL )+")</c>" );
            }
            else{
                SendMessageToPC( oCaster, "<cÈ2þ>Dispelled "+ GetName( oTarget )+": " + sCurrent+"</c>" );
                if(GetIsPC(oTarget))
                    SendMessageToPC( oTarget, "<cÈ2þ>Dispelled "+ GetName( oTarget )+": " + sCurrent+" ("+IntToString( nDspCL )+")</c>" );
            }

            if( ++nCnt == nMaxSpells && nMaxSpells > 0 )
                return nCnt;
            }
            /* Next level Terra stuff, it's amazing, but not in use.
            sCurrent = IntToString( nSpell );
            if( FindSubString( sList, "|"+sCurrent+"|" ) == -1 ){

                if( d2() == 1 )
                    sList += sCurrent + "|";
                else
                    sList = "|" + sCurrent + sList;
            }
            */
        }

        eSpell = GetNextEffect( oTarget );
    }

    //SendMessageToPC( oCaster, "List: " + sList );
    /* More Terra stuff
    int nNext = FindSubString(sList,"|");
    int nStart;
    int nCnt = 0;
    int nDspCL = 0;
    int isPC = GetIsPC( oTarget ) || GetIsDMPossessed( oTarget ) || GetIsDM( oTarget );
    while(TRUE){

        nStart = nNext;
        nNext = FindSubString(sList,"|",nStart+1);

        if(nNext == -1)
            break;

        nSpell = StringToInt( GetSubString( sList, nStart+1, nNext-nStart-1 ) );

        if( ( nDspCL = DispelSpell( oTarget, nSpell, nCL ) ) > 0 ){

            sCurrent = GetSpellName( nSpell );
            RemoveItemEnchants( oTarget, nSpell );
            if(oCaster==oTarget){
                SendMessageToPC( oCaster, "<cÈ2þ>Self Dispelled: " + sCurrent+" ("+IntToString( nDspCL )+")</c>" );
            }
            else{
                SendMessageToPC( oCaster, "<cÈ2þ>Dispelled "+ GetName( oTarget )+": " + sCurrent+"</c>" );
                if(isPC)
                    SendMessageToPC( oTarget, "<cÈ2þ>Dispelled "+ GetName( oTarget )+": " + sCurrent+" ("+IntToString( nDspCL )+")</c>" );
            }

            if( ++nCnt == nMaxSpells && nMaxSpells > 0 )
                return nCnt;
        }
    }
    */

    return nCnt;
}