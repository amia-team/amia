#include "inc_lua"
#include "amia_include"
#include "inc_ds_records"
#include "inc_td_itemprop"
#include "inc_jj_string"
#include "cs_inc_leto"

//-------------------------------------------------------------------------------
// constants
//-------------------------------------------------------------------------------
//const int DOMAIN_AIR = 0;
//const int DOMAIN_ANIMAL = 1;
//const int DOMAIN_DEATH = 3;
//const int DOMAIN_DESTRUCTION = 4;
//const int DOMAIN_EARTH = 5;
//const int DOMAIN_EVIL = 6;
//const int DOMAIN_FIRE = 7;
//const int DOMAIN_GOOD = 8;
//const int DOMAIN_HEALING = 9;
//const int DOMAIN_KNOWLEDGE = 10;
//const int DOMAIN_MAGIC = 13;
//const int DOMAIN_PLANT = 14;
//const int DOMAIN_PROTECTION = 15;
//const int DOMAIN_STRENGTH = 16;
//const int DOMAIN_SUN = 17;
//const int DOMAIN_TRAVEL = 18;
//const int DOMAIN_TRICKERY = 19;
//const int DOMAIN_WAR = 20;
//const int DOMAIN_WATER = 21;
const int DOMAIN_BALANCE = 22;
const int DOMAIN_CAVERN =23;
const int DOMAIN_CHAOS = 24;
const int DOMAIN_CHARM = 25;
const int DOMAIN_COLD = 26;
const int DOMAIN_COMMUNITY = 27;
const int DOMAIN_COURAGE =  28;
const int DOMAIN_CRAFT = 29;
const int DOMAIN_DARKNESS = 30;
const int DOMAIN_DRAGON = 31;
const int DOMAIN_DREAM = 32;
const int DOMAIN_DROW = 33;
const int DOMAIN_DWARF = 34;
const int DOMAIN_ELF = 35;
const int DOMAIN_FATE = 36;
const int DOMAIN_GNOME = 37;
const int DOMAIN_HALFING = 38;
const int DOMAIN_HATRED = 39;
const int DOMAIN_ILLUSION = 40;
const int DOMAIN_LAW = 41;
const int DOMAIN_LUCK = 42;
const int DOMAIN_MOON = 43;
const int DOMAIN_NOBILITY = 44;
const int DOMAIN_ORC = 45;
const int DOMAIN_PORTAL = 46;
const int DOMAIN_RENEWAL = 47;
const int DOMAIN_REPOSE = 48;
const int DOMAIN_RETRIBUTION = 49;
const int DOMAIN_RUNE = 50;
const int DOMAIN_SCALYKIND = 51;
const int DOMAIN_SLIME = 52;
const int DOMAIN_SPELL = 53;
const int DOMAIN_TIME = 54;
const int DOMAIN_TRADE = 55;
const int DOMAIN_TYRANNY = 56;
const int DOMAIN_UNDEATH = 57;
const int DOMAIN_SUFFERING = 58;
//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//triggers the prayer routines
void Pray( object oPC );

//casts alignment effects on PC ( nClericLevels < 1 ) or party ( nClericLevels > 0 )
void CastAlignmentEffect( object oPC, object oIdol, int nClericLevels );

//casts domain effects on party
void CastDomainEffect( object oPC, int nDomain, int nClericLevels );

//looks if oPCs alignment matches the Idol's requirements
//returns 1 on success, 0 on failure
int MatchAlignment( object oPC, object oIdol );

//looks if oPCs domians matches the Idol's requirements
//returns the first matching domain on success, 0 on failure
int MatchDomain( object oPC, object oIdol, int nGetDomain2=0 );

//looks if oPCs domains and alignment matches his chosen god.
int MatchGod(object oPC);

//gets verbose name
string GetDomainName( int nDomain );

//gets verbose name
string GetAlignmentName( object oPC );

//sets a temporary flag on all PCs in party and area
void ApplyPrayerFlagsToPCs(object oPC, string sName, int nClericLevels);

//applies effect to all PCs in party and area
void ApplyPrayerEffectsToPCs( object oPC, effect eEffect, int nClericLevels, int nFullDuration=TRUE );

//applies effect to relevant NPCs in party and area
void ApplyPrayerEffectsToNPC( object oPC, effect eEffect, int nClericLevels, int nFullDuration=TRUE, int nNPCtype=0 );

//shows binding info
void DeityInfo( object oPC, object oIdol );

//transforms name to tag
string NameToTag( string sName );

//returns TRUE if this god has Animal or Plant domains
int IsValidDruidGod( object oIdol );

//returns success rate ( 40-100 ) of a layman's prayer
int GetSuccessRate( object oPC );

//tries to find or create an idol
object FindIdol( object oPC, string sGod );

//Switches first domain with new domain
void ChangeDomain(object oPC, int nDomain_1_2, int nNewDomain);

//Checks to see if domain feats are present, if not, adds them
void VerifyDomainFeats( object oPC, int nCount );

void Pray( object oPC ){

    //on your knees!
    AssignCommand( oPC, PlayAnimation( ANIMATION_LOOPING_MEDITATE, 1.0, 12.0 ) );

    //get god
    string sGod  = GetDeity( oPC );

    if ( sGod == "" ){

        SendMessageToPC( oPC, "The gods do not care for the Faithless..." );

        return;
    }

    //get idol
    object oIdol = FindIdol( oPC, sGod );

    if ( oIdol == OBJECT_INVALID ){

        SendMessageToPC( oPC, sGod+" holds no domain in Amia..." );

        return;
    }

    int nFallen = GetLocalInt( oPC, "Fallen" );

    if( nFallen )
    {
        DelayCommand( 5.0, SendMessageToPC( oPC, sGod+" ignores your prayer..." ) );

        return;
    }

    //one prayer a reset
    int PrayBlockTime = GetIsBlocked( oPC, "PrayBlock" );

    if ( PrayBlockTime > 0 ){

        SendMessageToPC( oPC, sGod+" doesn't want to be bothered by you right now." );
        SendMessageToPC( oPC, "You can pray again in "+IntToString( (PrayBlockTime/60) )+" minutes." );

        return;
    }

    //block prayer until next reset
    SetBlockTime( oPC, 60, 0, "PrayBlock" );

    //check alignment vs god
    int nAlignment  = MatchAlignment( oPC, oIdol );

    //check domains vs god
    int nDomain1 = MatchDomain( oPC, oIdol );
    int nDomain2 = MatchDomain( oPC, oIdol, 1 );

    //get cleric + druid levels
    int nClericLevels = GetLevelByClass( CLASS_TYPE_CLERIC , oPC );
    int nDruidLevels  = GetLevelByClass( CLASS_TYPE_DRUID , oPC );

    if ( nClericLevels > 0 && nClericLevels >= nDruidLevels && nAlignment == 1 ){

        //is cleric and has a compatible alignment

        DelayCommand( 5.0, SendMessageToPC( oPC, sGod+"'s power is demonstrated through your prayer!" ) );
        DelayCommand( 6.0, CastAlignmentEffect( oPC, oIdol, nClericLevels ) );

        if ( nDomain1 != -1 ){

            DelayCommand( 6.3, CastDomainEffect( oPC, nDomain1, nClericLevels ) );
        }

        if ( nDomain2 != -1 ){

            DelayCommand( 6.6, CastDomainEffect( oPC, nDomain2, nClericLevels ) );
        }
    }
    else if ( nDruidLevels > 0 && nAlignment == 1 && IsValidDruidGod( oIdol ) ){

        //is druid and has a compatible alignment and an valid druid god

        DelayCommand( 5.0, SendMessageToPC( oPC, sGod+"'s power is demonstrated through your prayer!" ) );
        DelayCommand( 6.0, CastAlignmentEffect( oPC, oIdol, nDruidLevels ) );

    }
    else if ( nAlignment == 1 ){

        //is not a cleric or druid but has a compatible alignment

        int nSuccessRate = GetSuccessRate( oPC );

        if ( d100() <= nSuccessRate ){

            DelayCommand( 5.0, SendMessageToPC( oPC, sGod+" blesses you!" ) );
            DelayCommand( 5.0, SendMessageToPC( oPC, "[Your chance on a blessing is "+IntToString( nSuccessRate )+" %]" ) );
            DelayCommand( 6.0, CastAlignmentEffect( oPC, oIdol, 0 ) );
        }
        else{

            DelayCommand( 5.0, SendMessageToPC( oPC, sGod+" ignores your prayer..." ) );
            DelayCommand( 5.0, SendMessageToPC( oPC, "[Your chance on a blessing is "+IntToString( nSuccessRate )+" %]" ) );
        }
    }
    else{

        //wrong alignment!

        SendMessageToPC( oPC, "Apparently "+sGod+" isn't too happy with you..." );
        SendMessageToPC( oPC, "[Your alignment is no longer valid for this god]" );
    }
}

void CastAlignmentEffect( object oPC, object oIdol, int nClericLevels ){

    string sAlignment = GetLocalString( oIdol, "alignment" );
    int nVsGood       = 0;
    int nVsEvil       = 0;
    int nVisual;
    float fDuration   = 300.0 + ( nClericLevels * 20.0 );
    int nLevelBonus   = 0;

    if ( nClericLevels > -1 ){

        SendMessageToPC( oPC, " - Duration: "+FloatToString( fDuration, 5, 0 )+" seconds" );
    }

    if ( nClericLevels > 9 ){

        nLevelBonus = 1;
    }

    if ( sAlignment == "LG" || sAlignment == "NG" || sAlignment == "CG" ){

        nVisual     = VFX_IMP_GOOD_HELP;
        nVsEvil     = 2 + nLevelBonus;
    }
    else if ( sAlignment == "LN" || sAlignment == "NN" || sAlignment == "CN" ){

        nVisual     = VFX_IMP_UNSUMMON;
        nVsGood     = 1 + nLevelBonus;
        nVsEvil     = 1 + nLevelBonus;
    }
    else if ( sAlignment == "LE" || sAlignment == "NE" || sAlignment == "CE" ){

        nVisual     = VFX_IMP_EVIL_HELP;
        nVsGood     = 2 + nLevelBonus;
    }
    else{

        //error
        return;
    }

    if ( nClericLevels > -1 ){

        // I use nClericLevels == -1 to get the visuals without the other effects

        effect eVsGood      = EffectACIncrease( nVsGood, AC_DODGE_BONUS );
        effect eVsEvil      = EffectACIncrease( nVsEvil, AC_DODGE_BONUS );
        effect eVisual      = EffectVisualEffect( nVisual );

        eVsGood             = VersusAlignmentEffect( eVsGood, ALIGNMENT_ALL, ALIGNMENT_GOOD );
        eVsEvil             = VersusAlignmentEffect( eVsEvil, ALIGNMENT_ALL, ALIGNMENT_EVIL );

        SendMessageToPC( oPC, "Adding "+sAlignment+" alignment effects:" );
        ApplyPrayerEffectsToPCs( oPC, eVisual, nClericLevels, FALSE );

        SendMessageToPC( oPC, " - Extra AC vs Good, "+IntToString( nVsGood ) );
        ApplyPrayerEffectsToPCs( oPC, eVsGood, nClericLevels );

        SendMessageToPC( oPC, " - Extra AC vs Evil, "+IntToString( nVsEvil ) );
        ApplyPrayerEffectsToPCs( oPC, eVsEvil, nClericLevels );
    }
    else{

        //visuals
        effect eVisual      = EffectVisualEffect( nVisual );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVisual, oPC, 3.0 );
    }
}

void CastDomainEffect( object oPC, int nDomain, int nClericLevels ){

    int nAmount;
    int nConstant;
    object oObject;
    string sDomain = GetDomainName( nDomain );

    SendMessageToPC( oPC, "Adding "+sDomain+" domain effects:" );
    switch(nDomain)
    {
        case DOMAIN_AIR: // = 0;
            nAmount = 20 + nClericLevels;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_ELECTRICITY ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectDamageImmunityIncrease( DAMAGE_TYPE_ELECTRICAL, nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Immunity vs Electrical damage, "+IntToString( nAmount )+"%" );
        break;
        case DOMAIN_ANIMAL: // = 1;
            nAmount = 1 + ( ( nClericLevels -1 ) / 7 );
            ApplyPrayerEffectsToNPC( oPC, EffectVisualEffect( VFX_IMP_HEAD_NATURE ), nClericLevels, TRUE, RACIAL_TYPE_ANIMAL );
            ApplyPrayerEffectsToNPC( oPC, EffectDamageIncrease( nAmount ), nClericLevels, TRUE, RACIAL_TYPE_ANIMAL );
            SendMessageToPC( oPC, "Boosting Animal companions..." );
        break;
        case DOMAIN_DEATH: // = 3;
            nAmount = 1 + ( ( nClericLevels -1 ) / 7 );
            ApplyPrayerEffectsToNPC( oPC, EffectVisualEffect( VFX_IMP_HEAD_ODD ), nClericLevels, TRUE, RACIAL_TYPE_UNDEAD );
            ApplyPrayerEffectsToNPC( oPC, EffectDamageIncrease( nAmount ), nClericLevels, TRUE, RACIAL_TYPE_UNDEAD );
            SendMessageToPC( oPC, "Boosting Undead companions..." );
        break;
        case DOMAIN_DESTRUCTION: // = 4;
            nAmount = 1 + ( ( nClericLevels -1 ) / 5 );
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_DUR_ELEMENTAL_SHIELD ), nClericLevels );
            ApplyPrayerEffectsToPCs( oPC, EffectDamageShield( nAmount, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE ), nClericLevels );
            SendMessageToPC( oPC, " - Damage shield, 1d6 + "+IntToString( nAmount )+" fire damage" );
        break;
        case DOMAIN_EARTH: // = 5;
            nAmount = 20 + nClericLevels;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_ACID ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectDamageImmunityIncrease( DAMAGE_TYPE_ACID, nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Immunity vs Acid damage, "+IntToString( nAmount )+"%" );
        break;
        case DOMAIN_EVIL: // = 6;
            nAmount = 2 + ( ( nClericLevels -1 ) / 7 );
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_DUR_PROTECTION_EVIL_MINOR ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, VersusAlignmentEffect( EffectDamageIncrease( nAmount ), ALIGNMENT_ALL, ALIGNMENT_GOOD ), nClericLevels );
            SendMessageToPC( oPC, " - Extra Damage, "+IntToString( nAmount )+" vs Good" );
        break;
        case DOMAIN_FIRE: // = 7;
            nAmount = 20 + nClericLevels;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_FIRE ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectDamageImmunityIncrease( DAMAGE_TYPE_FIRE, nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Immunity vs Fire damage, "+IntToString( nAmount )+"%" );
        break;
        case DOMAIN_GOOD: // = 8;
            nAmount = 2 + ( ( nClericLevels -1 ) / 7 );
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, VersusAlignmentEffect( EffectDamageIncrease( nAmount ), ALIGNMENT_ALL, ALIGNMENT_EVIL ), nClericLevels );
            SendMessageToPC( oPC, " - Extra Damage, "+IntToString( nAmount )+" vs Evil" );
        break;
        case DOMAIN_HEALING: // = 9;
            nAmount = 1 + ( ( nClericLevels -1 ) / 10 );
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEALING_S ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectRegenerate( nAmount, 6.0 ), nClericLevels );
            SendMessageToPC( oPC, " - Regeneration, +"+IntToString( nAmount ) );
        break;
        case DOMAIN_KNOWLEDGE: // = 10;
            nAmount = 1 + ( ( nClericLevels -1 ) / 5 );
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_MIND ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectSkillIncrease( SKILL_ALL_SKILLS, nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Skill boost, +"+IntToString( nAmount ) );
        break;
        case DOMAIN_MAGIC: // = 13;
            nAmount = 11 + ( ( nClericLevels -1 ) / 2 );
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_SONIC ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectSpellResistanceIncrease( nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Spell Resistance, +"+IntToString( nAmount ) );
        break;
        case DOMAIN_PLANT: // = 14;
            nAmount = 1 + ( ( nClericLevels -1 ) / 4 );
            if ( nAmount > 5 ){
                nAmount = 5;
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_DUR_PROT_BARKSKIN ), nClericLevels );
            ApplyPrayerEffectsToPCs( oPC, EffectACIncrease( nAmount, AC_NATURAL_BONUS ), nClericLevels );
            SendMessageToPC( oPC, " - AC increase, +"+IntToString( nAmount )+" natural" );
        break;
        case DOMAIN_PROTECTION: // = 15;
            nAmount = 20 + nClericLevels;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_DUR_ETHEREAL_VISAGE ), nClericLevels );
            ApplyPrayerEffectsToPCs( oPC, EffectConcealment( nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Concealment, "+IntToString( nAmount )+"%" );
        break;
        case DOMAIN_STRENGTH: // = 16;
            nAmount = 1 + ( ( nClericLevels -1 ) / 7 );
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_HEAL ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease( ABILITY_STRENGTH, nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Extra Strength, "+IntToString( nAmount ) );
        break;
        case DOMAIN_SUN: // = 17;
            nAmount = 2 + ( ( nClericLevels -1 ) / 7 );
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_HOLY ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, VersusRacialTypeEffect( EffectDamageIncrease( nAmount, DAMAGE_TYPE_DIVINE ), RACIAL_TYPE_UNDEAD ), nClericLevels );
            SendMessageToPC( oPC, " - Extra Damage, "+IntToString( nAmount )+" vs Undead" );
        break;
        case DOMAIN_TRAVEL: // = 18;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEALING_S ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectImmunity( IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE ), nClericLevels );
            SendMessageToPC( oPC, " - Immunity from movement decreases" );
        break;
        case DOMAIN_TRICKERY: // = 19;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEALING_S ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectInvisibility( INVISIBILITY_TYPE_NORMAL ), nClericLevels );
            SendMessageToPC( oPC, " - Invisibility" );
        break;
        case DOMAIN_WAR: // = 20;
            nAmount = 1 + ( ( nClericLevels -1 ) / 10 );
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_EVIL ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectDamageIncrease( nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Extra Damage, "+IntToString( nAmount ) );
        break;
        case DOMAIN_WATER: // = 21;
            nAmount = 20 + nClericLevels;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_COLD ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectDamageImmunityIncrease( DAMAGE_TYPE_COLD, nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Immunity vs Cold damage, "+IntToString( nAmount )+"%" );
        break;
        case DOMAIN_BALANCE: // = 22;
            nAmount = 1 + ( ( nClericLevels -1 ) / 7 );
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_MIND ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectSavingThrowIncrease(SAVING_THROW_WILL, nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Increased Will Save, " +IntToString( nAmount));
            break;
        case DOMAIN_CAVERN: // =23;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_DUR_MAGICAL_SIGHT ), nClericLevels);
            ApplyPrayerFlagsToPCs( oPC, "jj_cavern_domain", nClericLevels);
            SendMessageToPC( oPC, " - Immunity to Light Blindness");
            break;
        case DOMAIN_CHAOS: // = 24;
            nAmount = 1 + ( ( nClericLevels -1 ) / 7 );
            switch(nAmount)
            {
                case 1: nConstant = DAMAGE_BONUS_1; break;
                case 2: nConstant = DAMAGE_BONUS_2; break;
                case 3: nConstant = DAMAGE_BONUS_3; break;
                case 4: nConstant = DAMAGE_BONUS_4; break;
                default: nConstant = DAMAGE_BONUS_5; break;
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_ODD ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, VersusAlignmentEffect(EffectDamageIncrease(nConstant), ALIGNMENT_LAWFUL), nClericLevels);
            SendMessageToPC( oPC, " - Extra Damage Vs Law, " + IntToString( nAmount));
            break;
        case DOMAIN_CHARM: // = 25;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_MIND ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectSpellImmunity(SPELL_CHARM_PERSON), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSpellImmunity(SPELL_CHARM_MONSTER), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSpellImmunity(SPELL_CHARM_PERSON_OR_ANIMAL), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSpellImmunity(SPELL_MASS_CHARM), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSpellImmunity(SPELL_HOLD_PERSON), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSpellImmunity(SPELL_HOLD_MONSTER), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSpellImmunity(SPELL_DOMINATE_MONSTER), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSpellImmunity(SPELL_DOMINATE_PERSON), nClericLevels);
            SendMessageToPC( oPC, " - Immunity to Charm/Hold/Dominate Spells");
            break;
        case DOMAIN_COLD: // = 26;
            nAmount = 1 + ( ( nClericLevels - 1) / 10);
            switch(nAmount)
            {
                case 1: nConstant = DAMAGE_BONUS_1; break;
                case 2: nConstant = DAMAGE_BONUS_2; break;
                case 3: nConstant = DAMAGE_BONUS_3; break;
                default: nConstant = DAMAGE_BONUS_4; break;
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_FROST_L ), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageIncrease(nConstant, DAMAGE_TYPE_COLD), nClericLevels);
            SendMessageToPC( oPC, " - Bonus cold damage, " + IntToString(nAmount));
            break;
        case DOMAIN_COMMUNITY: // = 27;
            nAmount = 10;
            oObject = GetFirstObjectInShape(SHAPE_SPHERE,30.0, GetLocation(oPC));
            while (GetIsObjectValid(oObject))
            {
                if (GetIsPC(oPC) && ds_check_partymember(oPC, oObject))
                {
                    nAmount += 10;
                    if (nAmount == 100)
                        break;
                }
                oObject = GetNextObjectInShape(SHAPE_SPHERE,30.0, GetLocation(oPC));
            }
            ApplyPrayerEffectsToPCs(oPC, EffectVisualEffect(VFX_IMP_HOLY_AID), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs(oPC, EffectTemporaryHitpoints(nAmount), nClericLevels);
            SendMessageToPC(oPC, " - Temporary Hitpoints, " + IntToString(nAmount));
            break;
        case DOMAIN_COURAGE: // =  28;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_HEAD_MIND), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectImmunity(IMMUNITY_TYPE_FEAR), nClericLevels);
            SendMessageToPC( oPC, " - Immunity to Fear");
            break;
        case DOMAIN_CRAFT: // = 29;
            nAmount = 1 + ( ( nClericLevels - 1) / 5);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectSavingThrowIncrease(SAVING_THROW_ALL, nAmount, SAVING_THROW_TYPE_TRAP), nClericLevels);
            SendMessageToPC( oPC, " - Increased saves vs. traps, " + IntToString(nAmount));
            break;
        case DOMAIN_DARKNESS: // = 30;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_DUR_MAGICAL_SIGHT ), nClericLevels);
            ApplyPrayerFlagsToPCs( oPC, "jj_darkness_domain", nClericLevels);
            SendMessageToPC( oPC, " - Immunity to Light Blindness");
            break;
        case DOMAIN_DRAGON: // = 31;
            nAmount = 1;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_STARBURST_RED), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease(ABILITY_CHARISMA, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease(ABILITY_CONSTITUTION, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease(ABILITY_DEXTERITY, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease(ABILITY_STRENGTH, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease(ABILITY_WISDOM, nAmount), nClericLevels);
            SendMessageToPC( oPC, " - Increased Abilities, 1");
            break;
        case DOMAIN_DREAM: // = 32;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_DAZED_S), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectImmunity(IMMUNITY_TYPE_DAZED), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectImmunity(IMMUNITY_TYPE_STUN), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectImmunity(IMMUNITY_TYPE_SLEEP), nClericLevels);
            SendMessageToPC( oPC, " - Immunity to Sleep, Daze, Stun");
            break;
        case DOMAIN_DROW: // = 33;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectImmunity(IMMUNITY_TYPE_PARALYSIS), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectImmunity(IMMUNITY_TYPE_ENTANGLE), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectImmunity(IMMUNITY_TYPE_SLOW), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE), nClericLevels);
            SendMessageToPC( oPC, " - Freedom");
            break;
        case DOMAIN_DWARF: // = 34;
            nAmount = 1 + ( ( nClericLevels -1) / 7);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease(ABILITY_CONSTITUTION, nAmount), nClericLevels);
            SendMessageToPC( oPC, " - Constitution Bonus, " + IntToString(nAmount));
            break;
        case DOMAIN_ELF: // = 35;
            nAmount = 1 + ( ( nClericLevels -1) / 7);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease(ABILITY_DEXTERITY, nAmount), nClericLevels);
            SendMessageToPC( oPC, " - Dexterity Bonus, " + IntToString(nAmount));
            break;
        case DOMAIN_FATE: // = 36;
            nAmount = 1 + ( (nClericLevels -1) / 7);
            nConstant = d20();
            if (nConstant == 1)
            {
                nConstant = SAVING_THROW_ALL;
                SendMessageToPC( oPC, " - Universal Save Increase, " + IntToString(nAmount));
            }
            else
            {
                nConstant = d3();
                switch (nConstant)
                {
                    case 1:
                        nConstant = SAVING_THROW_FORT;
                        SendMessageToPC( oPC, " - Fort Save Increase, " + IntToString(nAmount));
                        break;
                    case 2:
                        nConstant = SAVING_THROW_REFLEX;
                        SendMessageToPC( oPC, " - Reflex Save Increase, " + IntToString(nAmount));
                        break;
                    case 3:
                        nConstant = SAVING_THROW_WILL;
                        SendMessageToPC( oPC, " - Will Save Increase, " + IntToString(nAmount));
                        break;
                }
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_PDK_OATH), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectSavingThrowIncrease(nConstant, nAmount), nClericLevels);
            break;
        case DOMAIN_GNOME: // = 37;
            nAmount = 1 + ( ( nClericLevels -1) / 7);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease(ABILITY_CHARISMA, nAmount), nClericLevels);
            SendMessageToPC( oPC, " - Charisma Bonus, " + IntToString(nAmount));
            break;
        case DOMAIN_HALFING: // = 38;
            nAmount = 1 + ( ( nClericLevels -1) / 7);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE_NO_SOUND), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSkillIncrease(SKILL_HIDE, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSkillIncrease(SKILL_MOVE_SILENTLY, nAmount), nClericLevels);
            SendMessageToPC( oPC, " - Hide/Move Silently Increase, " + IntToString(nAmount));
            break;
        case DOMAIN_HATRED: // = 39;
            nAmount = 1 + ( ( nClericLevels -1) / 7);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageShield(nAmount, DAMAGE_BONUS_1d4, DAMAGE_TYPE_DIVINE), nClericLevels);
            SendMessageToPC( oPC, " - Divine Damage Shield, d4 " + IntToString(nAmount));
            break;
        case DOMAIN_ILLUSION: // = 40;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEALING_S ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectInvisibility( INVISIBILITY_TYPE_NORMAL ), nClericLevels );
            SendMessageToPC( oPC, " - Invisibility" );
            break;
        case DOMAIN_LAW: // = 41;
            nAmount = 1 + ( ( nClericLevels -1 ) / 7 );
            switch(nAmount)
            {
                case 1: nConstant = DAMAGE_BONUS_1; break;
                case 2: nConstant = DAMAGE_BONUS_2; break;
                case 3: nConstant = DAMAGE_BONUS_3; break;
                case 4: nConstant = DAMAGE_BONUS_4; break;
                default: nConstant = DAMAGE_BONUS_5; break;
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_ODD ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, VersusAlignmentEffect(EffectDamageIncrease(nConstant),ALIGNMENT_CHAOTIC), nClericLevels);
            SendMessageToPC( oPC, " - Extra Damage Vs Chaos, " + IntToString( nAmount));
            break;
        case DOMAIN_LUCK: // = 42;
            nAmount = d6();
            switch (nAmount)
            {
                case 1:
                    nConstant = ABILITY_CHARISMA;
                    SendMessageToPC( oPC, " - Charisma Increase, 3");
                    break;
                case 2:
                    nConstant = ABILITY_CONSTITUTION;
                    SendMessageToPC( oPC, " - Constitution Increase, 3");
                    break;
                case 3:
                    nConstant = ABILITY_DEXTERITY;
                    SendMessageToPC( oPC, " - Dexterity Increase, 3");
                    break;
                case 4:
                    nConstant = ABILITY_INTELLIGENCE;
                    SendMessageToPC( oPC, " - Intelligence Increase, 3");
                    break;
                case 5:
                    nConstant = ABILITY_STRENGTH;
                    SendMessageToPC( oPC, " - Strength Increase, 3");
                    break;
                case 6:
                    nConstant = ABILITY_WISDOM;
                    SendMessageToPC( oPC, " - Wisdom Increase, 3");
                    break;
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectAbilityIncrease(nConstant, 3), nClericLevels);
            break;
        case DOMAIN_MOON: // = 43;
            nAmount = 1 + ( ( nClericLevels -1 ) / 7 );
            switch(nAmount)
            {
                case 1: nConstant = DAMAGE_BONUS_1; break;
                case 2: nConstant = DAMAGE_BONUS_2; break;
                case 3: nConstant = DAMAGE_BONUS_3; break;
                case 4: nConstant = DAMAGE_BONUS_4; break;
                default: nConstant = DAMAGE_BONUS_5; break;
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_HOLY ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, VersusRacialTypeEffect(EffectDamageIncrease(nConstant),RACIAL_TYPE_SHAPECHANGER), nClericLevels);
            SendMessageToPC( oPC, " - Extra Damage Vs Shapechangers, " + IntToString( nAmount));
            break;
        case DOMAIN_NOBILITY: // = 44;
            nAmount = 1 + ( ( nClericLevels -1) / 5);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_CHARM), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectSkillIncrease(SKILL_INTIMIDATE, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSkillIncrease(SKILL_PERSUADE, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSkillIncrease(SKILL_BLUFF, nAmount), nClericLevels);
            SendMessageToPC( oPC, " - Persuade/Intimidate/Bluff Increase, " + IntToString(nAmount));
            break;
        case DOMAIN_ORC: // = 45;
            nAmount = 1 + ( ( nClericLevels -1 ) / 7 );
            switch(nAmount)
            {
                case 1: nConstant = DAMAGE_BONUS_1; break;
                case 2: nConstant = DAMAGE_BONUS_2; break;
                case 3: nConstant = DAMAGE_BONUS_3; break;
                case 4: nConstant = DAMAGE_BONUS_4; break;
                default: nConstant = DAMAGE_BONUS_5; break;
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_EVIL ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, VersusRacialTypeEffect(EffectDamageIncrease(nConstant),RACIAL_TYPE_ELF), nClericLevels);
            SendMessageToPC( oPC, " - Extra Damage Vs Elves, " + IntToString( nAmount));
            break;
        case DOMAIN_PORTAL: // = 46;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_FNF_SUMMON_MONSTER_3 ), nClericLevels, FALSE);
            ApplyPrayerFlagsToPCs( oPC, "jj_portal_domain", nClericLevels);
            SendMessageToPC( oPC, " - Portal wands take no charges to use");
            break;
        case DOMAIN_RENEWAL: // = 47;
            nAmount = 2 + ( ( nClericLevels -1) / 5);
            if (nAmount > 10) nAmount = 10;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageResistance(DAMAGE_TYPE_FIRE, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageResistance(DAMAGE_TYPE_COLD, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageResistance(DAMAGE_TYPE_ACID, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageResistance(DAMAGE_TYPE_SONIC, nAmount), nClericLevels);
            SendMessageToPC( oPC, " - Elemental Resistance, " + IntToString(nAmount) + "/-");
        case DOMAIN_REPOSE: // = 48;
            nAmount = 1 + ( ( nClericLevels -1 ) / 7 );
            switch(nAmount)
            {
                case 1: nConstant = DAMAGE_BONUS_1; break;
                case 2: nConstant = DAMAGE_BONUS_2; break;
                case 3: nConstant = DAMAGE_BONUS_3; break;
                case 4: nConstant = DAMAGE_BONUS_4; break;
                default: nConstant = DAMAGE_BONUS_5; break;
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_HOLY ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, VersusRacialTypeEffect(EffectDamageIncrease(nConstant),RACIAL_TYPE_UNDEAD), nClericLevels);
            SendMessageToPC( oPC, " - Extra Damage Vs Undead, " + IntToString( nAmount));
            break;
        case DOMAIN_RETRIBUTION: // = 49;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_DUR_GLOW_RED ), nClericLevels);
            ApplyPrayerFlagsToPCs( oPC, "jj_retribution_domain", nClericLevels);
            SendMessageToPC( oPC, " - Explosion Upon Death");
            break;
        case DOMAIN_RUNE: // = 50;
            nAmount = 10 + 10 * (( nClericLevels -1 ) /3);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_DUR_PROT_STONESKIN ), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageReduction( 10, DAMAGE_POWER_PLUS_FIVE, nAmount), nClericLevels);
            SendMessageToPC( oPC, " - stoneskin (10/+5) stopping " + IntToString(nAmount) + " damage");
            break;
        case DOMAIN_SCALYKIND: // = 51;
            nAmount = 1 + ( ( nClericLevels -1) / 7);
            switch(nAmount)
            {
                case 1: nConstant = DAMAGE_BONUS_1; break;
                case 2: nConstant = DAMAGE_BONUS_2; break;
                case 3: nConstant = DAMAGE_BONUS_3; break;
                case 4: nConstant = DAMAGE_BONUS_4; break;
                default: nConstant = DAMAGE_BONUS_5; break;
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_ACID_L ), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageIncrease(nConstant, DAMAGE_TYPE_ACID), nClericLevels);
            SendMessageToPC( oPC, " - Bonus acid damage, " + IntToString(nAmount));
            break;
        case DOMAIN_SLIME: // = 52;
            nAmount = 20 + nClericLevels;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HEAD_ACID ), nClericLevels, FALSE );
            ApplyPrayerEffectsToPCs( oPC, EffectDamageImmunityIncrease( DAMAGE_TYPE_ACID, nAmount ), nClericLevels );
            SendMessageToPC( oPC, " - Immunity vs Acid damage, "+IntToString( nAmount )+"%" );
        break;
        case DOMAIN_SPELL: // = 53;
            nAmount = 1 + ( (nClericLevels -1) / 5);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSavingThrowIncrease(SAVING_THROW_ALL, nAmount, SAVING_THROW_TYPE_SPELL), nClericLevels);
            SendMessageToPC( oPC, " - Bonus Saves vs Spells, " + IntToString(nAmount));
            break;
        case DOMAIN_TIME: // = 54;
            nAmount = 1 + ( nClericLevels / 2);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_HASTE), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectMovementSpeedIncrease(nAmount), nClericLevels);
            SendMessageToPC( oPC, " - Movement Bonus, +%" + IntToString(nAmount));
            break;
        case DOMAIN_TRADE: // = 55;
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_DUR_SANCTUARY ), nClericLevels);
            ApplyPrayerFlagsToPCs( oPC, "jj_trade_domain", nClericLevels);
            SendMessageToPC( oPC, " - +5% on appraise checks with merchants");
            break;
        case DOMAIN_TYRANNY: // = 56;
            nAmount = 1 + ( nClericLevels / 5);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect(VFX_IMP_HEAD_EVIL), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, nAmount), nClericLevels);
            SendMessageToPC( oPC, " - Bludgeoning resist, " + IntToString(nAmount) + "/-");
            break;
        case DOMAIN_UNDEATH: // = 57;
            nAmount = 1 + ( ( nClericLevels -1) / 7);
            switch(nAmount)
            {
                case 1: nConstant = DAMAGE_BONUS_1; break;
                case 2: nConstant = DAMAGE_BONUS_2; break;
                case 3: nConstant = DAMAGE_BONUS_3; break;
                case 4: nConstant = DAMAGE_BONUS_4; break;
                default: nConstant = DAMAGE_BONUS_5; break;
            }
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_HARM ), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectDamageIncrease(nConstant, DAMAGE_TYPE_NEGATIVE), nClericLevels);
            SendMessageToPC( oPC, " - Bonus acid damage, " + IntToString(nAmount));
            break;
        case DOMAIN_SUFFERING: // = 58;
            nAmount = 1 + (nClericLevels / 5);
            ApplyPrayerEffectsToPCs( oPC, EffectVisualEffect( VFX_IMP_DEATH ), nClericLevels, FALSE);
            ApplyPrayerEffectsToPCs( oPC, EffectSavingThrowIncrease(SAVING_THROW_WILL, nAmount), nClericLevels);
            ApplyPrayerEffectsToPCs( oPC, EffectSavingThrowIncrease(SAVING_THROW_FORT, nAmount), nClericLevels);
            SendMessageToPC( oPC, " - Bonus to Will And Fort Saves, " + IntToString(nAmount));
            break;
    }

}

int MatchAlignment( object oPC, object oIdol ){

    string sAlignment = GetAlignmentName( oPC );

    //match PCs domain with Idol's list
    if ( GetLocalInt( oIdol, "al_"+sAlignment ) == 1 ){

        return 1;
    }
    else{

        return 0;
    }
}

int MatchDomain( object oPC, object oIdol, int nGetDomain2=0 ){
    int iDomain = GetDomain(oPC,nGetDomain2+1);
    int i;
    for (i = 1; i < 7; i++)
    {
        if (GetLocalInt( oIdol, "dom_"+IntToString(i)) == iDomain)
            return iDomain;
    }
    return -1;
}

int MatchGod(object oPC){
    object oIdol    = FindIdol(oPC, GetDeity(oPC));
    if (!GetIsObjectValid(oIdol))
        return 0;
    return MatchDomain(oPC,oIdol,0) != -1 &&
        MatchDomain(oPC,oIdol,1) != -1 &&
        MatchAlignment(oPC,oIdol);
}

string GetDomainName( int nDomain ){
    string sDomainVar = Catch2DAString("domains", "LABEL", nDomain);
    return GetStringSentenceCase(sDomainVar);
}

string GetAlignmentName( object oPC ){

    string sAlignment;
    int nLawChaos   = GetAlignmentLawChaos( oPC );
    int nGoodEvil   = GetAlignmentGoodEvil( oPC );

    //get first character of the PC's alignment
    if ( nLawChaos == ALIGNMENT_LAWFUL ){

        sAlignment = "L";
    }
    else if ( nLawChaos == ALIGNMENT_CHAOTIC ){

        sAlignment = "C";
    }
    else{

        sAlignment = "N";
    }

    //get second character
    if ( nGoodEvil == ALIGNMENT_GOOD ){

        sAlignment = sAlignment + "G";
    }
    else if ( nGoodEvil == ALIGNMENT_EVIL ){

        sAlignment = sAlignment + "E";
    }
    else{

        sAlignment = sAlignment + "N";
    }

    return sAlignment;
}

void ApplyPrayerFlagsToPCs(object oPC, string sName, int nClericLevels)
{
    float fDuration = 300.0 + ( nClericLevels * 20.0 );

    if ( nClericLevels == 0 ){
        return;
    }

    object oPartyMember = GetFirstFactionMember( oPC );
    object oArea        = GetArea( oPC );

    while( GetIsPC( oPartyMember ) ){

        if ( oArea == GetArea( oPartyMember ) ){

            float fReapply = fDuration + 1.0;
            SetLocalInt( oPartyMember, sName, nClericLevels);
            DelayCommand( fDuration, DeleteLocalInt( oPartyMember, sName) );
            DelayCommand( fReapply, ApplyAreaAndRaceEffects( oPC ) );
            SendMessageToPC( oPC, " - Applied effect to "+GetName( oPartyMember ) );
        }

        oPartyMember = GetNextFactionMember( oPC );
    }
}

void ApplyPrayerEffectsToPCs( object oPC, effect eEffect, int nClericLevels, int nFullDuration=TRUE ){

    float fDuration = 300.0 + ( nClericLevels * 20.0 );

    if ( nFullDuration == FALSE ){

        //a short (visual) effect
        fDuration = 3.0;
    }

    if ( nClericLevels == 0 ){

        //no cleric, use effect on self
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPC, fDuration );
        return;
    }

    object oPartyMember = GetFirstFactionMember( oPC );
    object oArea        = GetArea( oPC );

    while( GetIsPC( oPartyMember ) ){

        if ( oArea == GetArea( oPartyMember ) ){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPartyMember, fDuration );

            if (  GetEffectType( eEffect ) != EFFECT_TYPE_VISUALEFFECT ){

                SendMessageToPC( oPC, " - Applied effect to "+GetName( oPartyMember ) );
            }
        }

        oPartyMember = GetNextFactionMember( oPC );
    }
}

void ApplyPrayerEffectsToNPC( object oPC, effect eEffect, int nClericLevels, int nFullDuration=TRUE, int nNPCtype=0 ){

    float fDuration = 300.0 + ( nClericLevels * 20.0 );

    if ( nFullDuration == FALSE ){

        //a short (visual) effect
        fDuration = 3.0;
    }

    object oPartyMember = GetFirstFactionMember( oPC, FALSE );
    object oArea        = GetArea( oPC );

    if ( nNPCtype == RACIAL_TYPE_UNDEAD ){

        SendMessageToPC( oPC, " - [debug] Looking for undead partymembers..." );
    }

    while( GetIsObjectValid( oPartyMember ) == TRUE ){

        if ( oArea == GetArea( oPartyMember ) ){

            if ( nNPCtype == RACIAL_TYPE_UNDEAD ){

                if ( nNPCtype == RACIAL_TYPE_UNDEAD ) {

                    SendMessageToPC( oPC, " [debug] "+GetName( oPartyMember )+" is undead" );
                }
                else{

                    SendMessageToPC( oPC, " [debug] "+GetName( oPartyMember )+" is not undead" );
                }
            }

            if ( GetRacialType( oPartyMember ) == nNPCtype ){

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPartyMember, fDuration );
                SendMessageToPC( oPC, " - Applied effect to "+GetName( oPartyMember ) );
            }
            else if ( nNPCtype == RACIAL_TYPE_ANIMAL && GetRacialType( oPartyMember ) == RACIAL_TYPE_MAGICAL_BEAST ){

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPartyMember, fDuration );
                SendMessageToPC( oPC, " - Applied effect to "+GetName( oPartyMember ) );
            }
            else if ( nNPCtype == RACIAL_TYPE_ANIMAL && GetRacialType( oPartyMember ) == RACIAL_TYPE_VERMIN ){

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPartyMember, fDuration );
                SendMessageToPC( oPC, " - Applied effect to "+GetName( oPartyMember ) );
            }
            else if ( nNPCtype == RACIAL_TYPE_ANIMAL && GetRacialType( oPartyMember ) == RACIAL_TYPE_BEAST ){

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPartyMember, fDuration );
                SendMessageToPC( oPC, " - Applied effect to "+GetName( oPartyMember ) );
            }
        }

        oPartyMember = GetNextFactionMember( oPC, FALSE );
    }
}

void DeityInfo( object oPC, object oIdol ){

    string sMessage1 = GetLocalString( oIdol, "name" ) + " supports these domains: ";
    string sMessage2 = "You have the following domains: ";
    string sMessage3 = GetLocalString( oIdol, "name" ) + " allows these alignments: ";
    string sMessage4 = "Your alignment is: " + GetAlignmentName( oPC );
    string sDomain;
    int i;

    for ( i = 1; i < 7; ++i){

        sDomain = GetDomainName( GetLocalInt(oIdol, "dom_" + IntToString(i)) );
        sMessage1 = sMessage1 + " " + sDomain + " ";
    }
    if (GetLevelByClass(CLASS_TYPE_CLERIC,oPC))
    {
        sMessage2 = sMessage2 + " " + IntToString(GetDomain(oPC,1)) + " ";
        sMessage2 = sMessage2 + " " + IntToString(GetDomain(oPC,2)) + " ";
    }
    if ( GetLocalInt( oIdol, "al_LG" ) == 1 ){

        sMessage3 = sMessage3 + " LG ";
    }
    if ( GetLocalInt( oIdol, "al_NG" ) == 1 ){

        sMessage3 = sMessage3 + " NG ";
    }
    if ( GetLocalInt( oIdol, "al_CG" ) == 1 ){

        sMessage3 = sMessage3 + " CG ";
    }
    if ( GetLocalInt( oIdol, "al_LN" ) == 1 ){

        sMessage3 = sMessage3 + " LN ";
    }
    if ( GetLocalInt( oIdol, "al_NN" ) == 1 ){

        sMessage3 = sMessage3 + " NN ";
    }
    if ( GetLocalInt( oIdol, "al_CN" ) == 1 ){

        sMessage3 = sMessage3 + " CN ";
    }
    if ( GetLocalInt( oIdol, "al_LE" ) == 1 ){

        sMessage3 = sMessage3 + " LE ";
    }
    if ( GetLocalInt( oIdol, "al_NE" ) == 1 ){

        sMessage3 = sMessage3 + " NE ";
    }
    if ( GetLocalInt( oIdol, "al_CE" ) == 1 ){

        sMessage3 = sMessage3 + " CE ";
    }

    SendMessageToPC( oPC, sMessage3 );
    SendMessageToPC( oPC, sMessage4 );
    SendMessageToPC( oPC, sMessage1 );
    SendMessageToPC( oPC, sMessage2 );
}

string NameToTag( string sName ){

    //We need to capitalise the string if not already caps
    sName = GetStringSentenceCase( sName );

    if ( FindSubString( sName, " ") == -1 ){

        // not found
        return "idol2_" + sName;
    }

    int i;
    string sReturn = "";
    string sChar;
    string sRight;

    int nLength = GetStringLength( sName );

    // Loop over every character and replace spaces
    for ( i=0; i<nLength; i++ ){

        sChar = GetSubString( sName, i, 1 );

        if ( sChar == " " ){

            //We get the rest of the string, if there is any
            sRight = GetStringRight( sName, nLength - i - 1 );
            if ( sRight != "" ){
                //If there is more text and it doesn't start with a space,
                //capitalise that too.
                if ( GetStringLeft( sRight, 1 ) != " " ){

                    sName = GetStringLeft( sName, i ) + GetStringSentenceCase( sRight );
                    // We've just decreased the string length by 1, need to
                    // update and put the cursor back a step just to be safe
                    nLength--;
                    i--;
                }
            }

            sReturn += "";
        }
        else{

            sReturn += sChar;

        }
    }

    //One exception to the rule, the 'of' and 'and' are not capitalised.
    if ( sReturn == "QueenOfAirAndDarkness" ) sReturn = "QueenofAirandDarkness";
    return "idol2_" + sReturn;
}

int IsValidDruidGod( object oIdol ){

    int nReturn = FALSE;
    int nLoop;

    for ( nLoop = 1; nLoop <= 6; nLoop++ ){

        if ( GetLocalInt( oIdol, "dom_"+IntToString(nLoop) ) == DOMAIN_ANIMAL ||
             GetLocalInt( oIdol, "dom_"+IntToString(nLoop) ) == DOMAIN_PLANT  ||
	     GetLocalInt( oIdol, "dom_"+IntToString(nLoop) ) == DOMAIN_MOON  ||  
	     GetLocalInt( oIdol, "dom_"+IntToString(nLoop) ) == DOMAIN_SUN  ||
             GetLocalInt( oIdol, "druid_deity" ) == 1 ){
             nReturn = TRUE;
             break;
        }
    }

    return nReturn;
}

int GetSuccessRate( object oPC ){

    int SuccessRate = 40;

    SuccessRate = SuccessRate + ( 2 * GetLevelByClass( CLASS_TYPE_BLACKGUARD , oPC ) );
    SuccessRate = SuccessRate + ( 2 * GetLevelByClass( CLASS_TYPE_DIVINECHAMPION , oPC ) );
    SuccessRate = SuccessRate + ( 2 * GetLevelByClass( CLASS_TYPE_PALADIN , oPC ) );
    SuccessRate = SuccessRate + ( 2 * GetLevelByClass( CLASS_TYPE_RANGER , oPC ) );

    return SuccessRate;
}

object FindIdol( object oPC, string sGod  ){

    if ( sGod == "" ){

        SendMessageToPC( oPC, "The gods do not care for the Faithless..." );

        return OBJECT_INVALID;
    }

    object oIdol = GetObjectByTag( NameToTag( sGod ) );

    if ( GetIsObjectValid( oIdol ) ){

        return oIdol;
    }

    //try to recreate from DB
    string sQuery = "SELECT * FROM idols WHERE name = '"+sGod+"' LIMIT 1";

    SQLExecDirect( sQuery );

    if ( SQLFetch( ) != SQL_SUCCESS ){

        SendMessageToPC( oPC, sGod+" holds no domain in Amia..." );

        return OBJECT_INVALID;
    }

    oIdol = CreateObject( OBJECT_TYPE_WAYPOINT, "ds_storage", GetLocation( oPC ), FALSE, SQLGetData( 4 ) );

    SetLocalString( oIdol, "name", SQLGetData( 5 ) );
    SetLocalString( oIdol, "alignment", SQLGetData( 6 ) );
    SetLocalInt( oIdol, "al_CE", StringToInt( SQLGetData( 7 ) ) );
    SetLocalInt( oIdol, "al_CG", StringToInt( SQLGetData( 8 ) ) );
    SetLocalInt( oIdol, "al_CN", StringToInt( SQLGetData( 9 ) ) );
    SetLocalInt( oIdol, "al_LE", StringToInt( SQLGetData( 10 ) ) );
    SetLocalInt( oIdol, "al_LG", StringToInt( SQLGetData( 11 ) ) );
    SetLocalInt( oIdol, "al_LN", StringToInt( SQLGetData( 12 ) ) );
    SetLocalInt( oIdol, "al_NE", StringToInt( SQLGetData( 13 ) ) );
    SetLocalInt( oIdol, "al_NG", StringToInt( SQLGetData( 14 ) ) );
    SetLocalInt( oIdol, "al_NN", StringToInt( SQLGetData( 15 ) ) );
/*
    SetLocalInt( oIdol, "dom_Air", StringToInt( SQLGetData( 16 ) ) );
    SetLocalInt( oIdol, "dom_Animal", StringToInt( SQLGetData( 17 ) ) );
    SetLocalInt( oIdol, "dom_Death", StringToInt( SQLGetData( 18 ) ) );
    SetLocalInt( oIdol, "dom_Destruction", StringToInt( SQLGetData( 19 ) ) );
    SetLocalInt( oIdol, "dom_Earth", StringToInt( SQLGetData( 20 ) ) );
    SetLocalInt( oIdol, "dom_Evil", StringToInt( SQLGetData( 21 ) ) );
    SetLocalInt( oIdol, "dom_Fire", StringToInt( SQLGetData( 22 ) ) );
    SetLocalInt( oIdol, "dom_Good", StringToInt( SQLGetData( 23 ) ) );
    SetLocalInt( oIdol, "dom_Healing", StringToInt( SQLGetData( 24 ) ) );
    SetLocalInt( oIdol, "dom_Knowledge", StringToInt( SQLGetData( 25 ) ) );
    SetLocalInt( oIdol, "dom_Magic", StringToInt( SQLGetData( 26 ) ) );
    SetLocalInt( oIdol, "dom_Plant", StringToInt( SQLGetData( 27 ) ) );
    SetLocalInt( oIdol, "dom_Protection", StringToInt( SQLGetData( 28 ) ) );
    SetLocalInt( oIdol, "dom_Strength", StringToInt( SQLGetData( 29 ) ) );
    SetLocalInt( oIdol, "dom_Sun", StringToInt( SQLGetData( 30 ) ) );
    SetLocalInt( oIdol, "dom_Travel", StringToInt( SQLGetData( 31 ) ) );
    SetLocalInt( oIdol, "dom_Trickery", StringToInt( SQLGetData( 32 ) ) );
    SetLocalInt( oIdol, "dom_War", StringToInt( SQLGetData( 33 ) ) );
    SetLocalInt( oIdol, "dom_Water", StringToInt( SQLGetData( 34 ) ) );
    SetLocalInt( oIdol, "dom_Balance", StringToInt(SQLGetData(35)));
    SetLocalInt( oIdol, "dom_Cavern", StringToInt(SQLGetData(36)));
    SetLocalInt( oIdol, "dom_Chaos", StringToInt(SQLGetData(37)));
    SetLocalInt( oIdol, "dom_Charm", StringToInt(SQLGetData(38)));
    SetLocalInt( oIdol, "dom_Cold", StringToInt(SQLGetData(39)));
    SetLocalInt( oIdol, "dom_Community", StringToInt(SQLGetData(40)));
    SetLocalInt( oIdol, "dom_Courage", StringToInt(SQLGetData(41)));
    SetLocalInt( oIdol, "dom_Craft", StringToInt(SQLGetData(42)));
    SetLocalInt( oIdol, "dom_Darkness", StringToInt(SQLGetData(43)));
    SetLocalInt( oIdol, "dom_Dragon", StringToInt(SQLGetData(44)));
    SetLocalInt( oIdol, "dom_Dream", StringToInt(SQLGetData(45)));
    SetLocalInt( oIdol, "dom_Drow", StringToInt(SQLGetData(46)));
    SetLocalInt( oIdol, "dom_Elf", StringToInt(SQLGetData(47)));
    SetLocalInt( oIdol, "dom_Fate", StringToInt(SQLGetData(48)));
    SetLocalInt( oIdol, "dom_Gnome", StringToInt(SQLGetData(49)));
    SetLocalInt( oIdol, "dom_Halfling", StringToInt(SQLGetData(50)));
    SetLocalInt( oIdol, "dom_Hatred", StringToInt(SQLGetData(51)));
    SetLocalInt( oIdol, "dom_Illusion", StringToInt(SQLGetData(52)));
    SetLocalInt( oIdol, "dom_Law", StringToInt(SQLGetData(53)));
    SetLocalInt( oIdol, "dom_Luck", StringToInt(SQLGetData(54)));
    SetLocalInt( oIdol, "dom_Moon", StringToInt(SQLGetData(55)));
    SetLocalInt( oIdol, "dom_Nobility", StringToInt(SQLGetData(56)));
    SetLocalInt( oIdol, "dom_Orc", StringToInt(SQLGetData(57)));
    SetLocalInt( oIdol, "dom_Portal", StringToInt(SQLGetData(58)));
    SetLocalInt( oIdol, "dom_Renewal", StringToInt(SQLGetData(59)));
    SetLocalInt( oIdol, "dom_Repose", StringToInt(SQLGetData(60)));
    SetLocalInt( oIdol, "dom_Retribution", StringToInt(SQLGetData(61)));
    SetLocalInt( oIdol, "dom_Rune", StringToInt(SQLGetData(62)));
    SetLocalInt( oIdol, "dom_Scalykind", StringToInt(SQLGetData(63)));
    SetLocalInt( oIdol, "dom_Slime", StringToInt(SQLGetData(64)));
    SetLocalInt( oIdol, "dom_Spell", StringToInt(SQLGetData(65)));
    SetLocalInt( oIdol, "dom_Time", StringToInt(SQLGetData(66)));
    SetLocalInt( oIdol, "dom_Trade", StringToInt(SQLGetData(67)));
    SetLocalInt( oIdol, "dom_Tyranny", StringToInt(SQLGetData(68)));
    SetLocalInt( oIdol, "dom_Undeath", StringToInt(SQLGetData(69)));
    SetLocalInt( oIdol, "dom_Suffering", StringToInt(SQLGetData(70)));
*/

    return oIdol;
}


void ChangeDomain(object oPC, int nDomain_1_2, int nNewDomain)
{
    string szModification;



    int nOldDomain = GetDomain(oPC,nDomain_1_2);

    int nOtherDomain;

    if ( nDomain_1_2 == 1)  nOtherDomain = GetDomain(oPC,2);
    else                    nOtherDomain = GetDomain(oPC,1);


    if ( nNewDomain == nOtherDomain ){

        SendMessageToPC( oPC, "Domain change failed, you already have " + GetDomainName(nOtherDomain) + " domain!" );
        return;
    }

    SendMessageToPC(oPC, "Changing your domain from: " + GetDomainName(nOldDomain) + " to " + GetDomainName(nNewDomain));
    int nOldFeat = StringToInt(Get2DAString("domains", "GrantedFeat", nOldDomain));
    NWNX_Creature_RemoveFeat(oPC, nOldFeat);
    NWNX_Creature_SetDomain(oPC, CLASS_TYPE_CLERIC, nDomain_1_2, nNewDomain);
    //ExecuteLuaString(oPC,"nwn.SetGetDomain(OBJECT_SELF,"+IntToString(nDomain_1_2)+","+IntToString(nNewDomain)+");");

    VerifyDomainFeats( oPC, 5 );
    //szModification = "replace 'Feat', "+IntToString(nOldFeat)+", DeleteParent;";




    // Update the character.
    //DelayCommand( 3.0, ExportSingleCharacter( oPC ) );
    //DelayCommand( 3.0, ExportAllCharacters() );
    //DelayCommand( 5.0, ModifyPC( oPC, szModification ) );

    SetPCKEYValue(oPC, "jj_changed_domain_" + IntToString(nDomain_1_2), 1);

    if (GetLocalInt(oPC, "Fallen") &&
        !GetIsObjectValid(GetItemPossessedBy(oPC, "dg_fall"))  &&
        MatchGod(oPC)) {
        //This removes the fallen state.
        DeleteLocalInt( oPC, "Fallen");

        //unfall
        AssignCommand( oPC, ActionCastSpellAtObject( 832, oPC, 1, TRUE, 0, 1, TRUE ) );

        //Feedback
        SendMessageToPC( oPC, "You have been redeemed because your domains now match your god's." );
        DelayCommand( 3.0, SendMessageToAllDMs( GetName( oPC )+" has been redeemed!" ) );
    }
}

void VerifyDomainFeats( object oPC, int nCount ){

    int nReVerify = 0;

    int nDomain_1 = GetDomain(oPC,1);
    int nDomain_2 = GetDomain(oPC,2);

    int nFeat_1 = StringToInt(Get2DAString("domains", "GrantedFeat", nDomain_1));
    int nFeat_2 = StringToInt(Get2DAString("domains", "GrantedFeat", nDomain_2));

    if (!GetHasFeat( nFeat_1, oPC ) ){

        NWNX_Creature_AddFeat(oPC, nFeat_1);
        //ExecuteLuaString(oPC,"nwn.AddFeat(OBJECT_SELF,"+IntToString(nFeat_1)+",0);");
        nReVerify = 1;

    }

    if (!GetHasFeat( nFeat_2, oPC ) ){

        //ExecuteLuaString(oPC,"nwn.AddFeat(OBJECT_SELF,"+IntToString(nFeat_2)+",0);");
        NWNX_Creature_AddFeat(oPC, nFeat_2);
        nReVerify = 1;

    }

    nCount--;

    if ( nReVerify ){

         if ( nCount > 0 ){

            DelayCommand( 0.2, VerifyDomainFeats( oPC, nCount ) );

         }
         else{

             SendMessageToPC( oPC, "Tried to verify your domain feats were added but failed." );

         }

    }
    else{

        SendMessageToPC( oPC, "Verified that your domain feats were added." );

    }

}


