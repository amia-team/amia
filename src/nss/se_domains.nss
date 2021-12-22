//-------------------------------------------------------------------------------
// Header
//-------------------------------------------------------------------------------
// script:  se_domains
// group:   Spells
// used as: spell script
// date:    10 July 2011
// author:  Selmak
// Notes:   Script for Amia-specific domains with active effects
//          Functions are stored in inc_domains
//
//


//-------------------------------------------------------------------------------
// Changelog
//-------------------------------------------------------------------------------
//
// 2011-10-04   Selmak      Repose domain power summons using the updated code
//                          from inc_ds_summons.
// 2011-10-05   Selmak      Repose domain, updated to use cleric levels to
//                          determine caster power level like everything else.
//-------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------

#include "inc_domains"


//-------------------------------------------------------------------------------
// Main
//-------------------------------------------------------------------------------

void main()
{

    int nSpell      = GetSpellId();

    object oPC      = OBJECT_SELF;

    location lTarg  = GetSpellTargetLocation();

    if ( nSpell == SPELLABILITY_DIVINEWISDOM ){

        domain_DivineWisdom( oPC );

    }
    else if ( nSpell == SPELLABILITY_GLIBNESS ){

        domain_BewitchingGlibness( oPC );

    }
    else if ( nSpell == SPELLABILITY_LIONSVALOUR ){

        domain_ValourOfLions( oPC );

    }
    else if ( nSpell == SPELLABILITY_ARTISAN ){

        domain_ArtisansMastery( oPC );

    }
    else if ( nSpell == SPELLABILITY_SHROUDS ){

        domain_ShroudsOfShade( oPC, lTarg );

    }
    else if ( nSpell == SPELLABILITY_BRAVER ){

        domain_BraverOfNightmares( oPC );

    }
    else if ( nSpell == SPELLABILITY_FATESTRANDS ){

        domain_FickleStrandsOfFate( oPC );

    }
    else if ( nSpell == SPELLABILITY_SEETHINGASSAULT ){

        domain_SeethingAssault( oPC );

    }
    else if ( nSpell == SPELLABILITY_FORTUNESWHEEL ){

        domain_FortunesWheel( oPC );

    }
    else if ( nSpell == SPELLABILITY_NOBLESMARCH ){

        domain_NoblesMarch( oPC );

    }
    else if ( nSpell == SPELLABILITY_RAPIDREGROWTH ){

        domain_RapidRegrowth( oPC );

    }
    else if ( nSpell == SPELLABILITY_SWIFTVENGEANCE ){

        domain_SwiftVengeance( oPC );

    }
    else if ( nSpell == SPELLABILITY_HALFLING_SKILL ){

        domain_HalfingSkill( oPC );

    }
    else if ( nSpell == SPELLABILITY_ORC_STRENGTH ){

        domain_OrcStrength( oPC );

    }
    else if ( nSpell == SPELLABILITY_REPOSE_SUMMON ){

        domain_ReposeDomainSummon( oPC, lTarg );

    }
}
//-------------------------------------------------------------------------------

