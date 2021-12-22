//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_dc_spells
//description: This library holds custom spell spell constants and
//various utility functions in custom spells.
//used as: Library holding constants and functions
//date:    2013-06-7
//author:  PaladinOfSune

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_spellhook"

//-----------------------------------------------------------------------------
// Constants
//-----------------------------------------------------------------------------

const int DEMO_TRIO_MAGBLUE = 857;
const int DEMO_TRIO_FIRE    = 858;
const int DEMO_TRIO_ELEC    = 859;
const int DEMO_TRIO_COLD    = 860;
const int DEMO_TRIO_ACID    = 861;
const int DEMO_TRIO_EVIL    = 862;
const int DEMO_TRIO_HEAL    = 863;
const int DEMO_TRIO_HOLY    = 864;
const int DEMO_TRIO_NATR    = 865;
const int DEMO_TRIO_ODD     = 866;
const int DEMO_TRIO_SONC    = 867;
const int DEMO_CONE_SONIC   = 868;
const int DEMO_GLOBE        = 869;
const int DEMO_ORB_CHROMA   = 870;
const int DC_SPELL_R_0      = 871;
const int DC_SPELL_S_0      = 872;
const int DC_SPELL_R_1      = 873;
const int DC_SPELL_S_1      = 874;
const int DC_SPELL_R_2      = 875;
const int DC_SPELL_S_2      = 876;
const int DC_SPELL_R_3      = 877;
const int DC_SPELL_S_3      = 878;
const int DC_SPELL_R_4      = 879;
const int DC_SPELL_S_4      = 880;
const int DC_SPELL_R_5      = 881;
const int DC_SPELL_S_5      = 882;
const int DC_SPELL_R_6      = 883;
const int DC_SPELL_S_6      = 884;
const int DC_SPELL_R_7      = 885;
const int DC_SPELL_S_7      = 886;
const int DC_SPELL_R_8      = 887;
const int DC_SPELL_S_8      = 888;
const int DC_SPELL_R_9      = 889;
const int DC_SPELL_S_9      = 890;

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

// This runs a concentration check every 6 seconcs.
// If it fails it'll remove nSpell - if oTarget is passed in, it will remove
// nSpell from oTarget. Otherwise, it'll remove nSpell from oPC.
void Concentration( object oPC, int nSpell, object oTarget = OBJECT_INVALID );


// Custom spells are set to evocation spell school by default,
// so use this function to work out the proper DC.
// Don't use this if the school is supposed to be Evocation as it's set to that anyway.
int SetSpellSchool( object oPC, int sSchool );

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------


void Concentration( object oPC, int nSpell, object oTarget )
{
    int nAction = GetCurrentAction( oPC );

    // Caster has done nothing for the last round to break concentration?
    if ( nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT
        || nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT
        || nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP
        || nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL )
    {
        SendMessageToPC(oPC, "You broke your concentration!");

        if( oTarget == OBJECT_INVALID ) {
            RemoveEffectsBySpell( oPC, nSpell );
        }
        else
        {
            RemoveEffectsBySpell( oTarget, nSpell );
        }
        FloatingTextStringOnCreature( GetName( oTarget ), oPC, FALSE );
        FloatingTextStringOnCreature( IntToString( nSpell ), oPC, FALSE );
    }
    else
        DelayCommand( 6.0, Concentration( oPC, nSpell, oTarget ) );
}

int SetSpellSchool( object oPC, int nSchool )
{
    int nSpellSchool1;
    int nSpellSchool2;
    int nSpellSchool3;

    switch( nSchool )
    {
        case 1:
            nSpellSchool1 = FEAT_EPIC_SPELL_FOCUS_ABJURATION;
            nSpellSchool2 = FEAT_GREATER_SPELL_FOCUS_ABJURATION;
            nSpellSchool3 = FEAT_SPELL_FOCUS_ABJURATION;
        break;

        case 2:
            nSpellSchool1 = FEAT_EPIC_SPELL_FOCUS_CONJURATION;
            nSpellSchool2 = FEAT_GREATER_SPELL_FOCUS_CONJURATION;
            nSpellSchool3 = FEAT_SPELL_FOCUS_CONJURATION;
        break;

        case 3:
            nSpellSchool1 = FEAT_EPIC_SPELL_FOCUS_DIVINATION;
            nSpellSchool2 = FEAT_GREATER_SPELL_FOCUS_DIVINATION;
            nSpellSchool3 = FEAT_SPELL_FOCUS_DIVINATION;
        break;

        case 4:
            nSpellSchool1 = FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT;
            nSpellSchool2 = FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT;
            nSpellSchool3 = FEAT_SPELL_FOCUS_ENCHANTMENT;
        break;

        case 5:
            nSpellSchool1 = FEAT_EPIC_SPELL_FOCUS_EVOCATION;
            nSpellSchool2 = FEAT_GREATER_SPELL_FOCUS_EVOCATION;
            nSpellSchool3 = FEAT_SPELL_FOCUS_EVOCATION;
        break;

        case 6:
            nSpellSchool1 = FEAT_EPIC_SPELL_FOCUS_ILLUSION;
            nSpellSchool2 = FEAT_GREATER_SPELL_FOCUS_ILLUSION;
            nSpellSchool3 = FEAT_SPELL_FOCUS_ILLUSION;
        break;

        case 7:
            nSpellSchool1 = FEAT_EPIC_SPELL_FOCUS_NECROMANCY;
            nSpellSchool2 = FEAT_GREATER_SPELL_FOCUS_NECROMANCY;
            nSpellSchool3 = FEAT_SPELL_FOCUS_NECROMANCY;
        break;

        case 8:
            nSpellSchool1 = FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION;
            nSpellSchool2 = FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION;
            nSpellSchool3 = FEAT_SPELL_FOCUS_TRANSMUTATION;
        break;

        default:
            nSpellSchool1 = FEAT_EPIC_SPELL_FOCUS_EVOCATION;
            nSpellSchool2 = FEAT_GREATER_SPELL_FOCUS_EVOCATION;
            nSpellSchool3 = FEAT_SPELL_FOCUS_EVOCATION;
        break;
    }

    int nSpellDCBonus;

    if ( GetHasFeat( nSpellSchool1, oPC ) )
        nSpellDCBonus = 6;
    else if ( GetHasFeat( nSpellSchool2, oPC ) )
        nSpellDCBonus = 4;
    else if ( GetHasFeat( nSpellSchool3, oPC ) )
        nSpellDCBonus = 2;

    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_EVOCATION, oPC ) )
        nSpellDCBonus -= 6;
    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_EVOCATION, oPC ) )
        nSpellDCBonus -= 4;
    else if( GetHasFeat( FEAT_SPELL_FOCUS_EVOCATION, oPC ) )
        nSpellDCBonus -= 2;

    return nSpellDCBonus;
}

