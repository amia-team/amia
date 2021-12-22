/*  Supernatural Ability :: Palemaster :: Undead Graft: Paralyze

    --------
    Verbatim
    --------
    This script will allow the Palemaster to paralyze her foes if they fail a Will save:
        DC 10 + Palemaster Level + INT modifier.
    Note: Elves are immune to this special attack.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082906  kfw         Initial release.
    011307  disco       Bugfix: Break from GS and other invis effects
  20071104  disco       Updated to facilitate alternative attacks
  20071104  Braxton     Updated logic, prototypes and Commanding()
  20071104  killA       Updated with New PM attacks
  20091003  Terra       Script is now a spellscript, gives back the feat change if the touch attack missed
    ----------------------------------------------------------------------------

*/

//------------------------------------------------------------------------------
// includes
//------------------------------------------------------------------------------
#include "nw_i0_spells"
#include "amia_include"

//------------------------------------------------------------------------------
// Prototypes
//------------------------------------------------------------------------------
void BaseAttack( object oPC, object oVictim );
void Weakening( object oPC, object oVictim );
void Degenerative( object oPC, object oVictim );
void Commanding( object oPC, object oVictim );
void Destructive( object oPC, object oVictim );



//------------------------------------------------------------------------------
// Main
//------------------------------------------------------------------------------
void main( ){

    // Variables.
    object oPC          = OBJECT_SELF;
    object oVictim      = GetSpellTargetObject( );
    int nPlot           = GetPlotFlag( oVictim );
    int nAttackType     = GetLocalInt( oPC, "pm_attack" );

    //test, remove this if I forgot to
    if( GetPCPlayerName( oPC ) == "Terra_777" )
        nAttackType = 3;

    //Signal the spell events + some crap with dominate and control undead spell
    //So we pretend we're control undead instead.. Its not like anyone will notice! =3
    SignalEvent( oVictim, EventSpellCastAt( oPC, GetSpellId( ) , TRUE ) );

    if( TouchAttackMelee( oVictim ) > 0 ){

        if( nAttackType == 0 ){

            BaseAttack( oPC, oVictim );
        }
        else if( nAttackType == 1 ){

            Weakening( oPC, oVictim );
        }
        else if( nAttackType == 2 ){

            Degenerative( oPC, oVictim );
        }
        else if( nAttackType == 3 ){

            Commanding( oPC, oVictim );
        }
        else if( nAttackType == 4 ){

            Destructive( oPC, oVictim );
        }
    }
    else{
        IncrementRemainingFeatUses( oPC, FEAT_UNDEAD_GRAFT_1 );
    }
    return;
}

//------------------------------------------------------------------------------
// Functions
//------------------------------------------------------------------------------
void BaseAttack( object oPC, object oVictim ){


    int nPlot           = GetPlotFlag( oVictim );
    int nRacialType     = GetRacialType( oVictim );

    if( nPlot                                       ||
        nRacialType == RACIAL_TYPE_CONSTRUCT        ||
        nRacialType == RACIAL_TYPE_OOZE             ||
        nRacialType == RACIAL_TYPE_UNDEAD           ||
        nRacialType == RACIAL_TYPE_ELF              ){

        // Notify.
        SendMessageToPC( oPC, "<c€þ>- Undead Graft: Paralyze won't affect this creature. -" );
        return;
    }

    int nPM_rank        = GetLevelByClass( CLASS_TYPE_PALE_MASTER );
    int nINT_mod        = GetAbilityModifier( ABILITY_INTELLIGENCE );
    int nDC             = 10 + nPM_rank + nINT_mod;
    float fDuration     = TurnsToSeconds( nPM_rank );
    effect eParalyze    = SupernaturalEffect(
                                EffectLinkEffects(
                                EffectVisualEffect( VFX_DUR_PARALYZE_HOLD ),
                                EffectParalyze( ) ) );


    // Unsuccessful Will Save, paralyze the Victim.
    if( WillSave( oVictim, nDC, SAVING_THROW_TYPE_EVIL, oPC ) == 0 ){

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eParalyze, oVictim, fDuration );

    }

}

void Weakening( object oPC, object oVictim ){

    int nPM_rank        = GetLevelByClass( CLASS_TYPE_PALE_MASTER );
    int nINT_mod        = GetAbilityModifier( ABILITY_INTELLIGENCE );
    int nDC             = 10 + nPM_rank + nINT_mod;
    int nFort           = FortitudeSave( oVictim, nDC, SAVING_THROW_TYPE_NONE, oPC );
    int nDice           = d6();
    float fDuration     = TurnsToSeconds( nPM_rank );
    effect eParalyze    = SupernaturalEffect( EffectLinkEffects( EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), EffectAbilityDecrease( ABILITY_STRENGTH, nDice) ) );

    if( nFort == 0 ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eParalyze, oVictim, fDuration );
    }

}

void Degenerative( object oPC, object oVictim ){

    int nPM_rank        = GetLevelByClass( CLASS_TYPE_PALE_MASTER );
    int nINT_mod        = GetAbilityModifier( ABILITY_INTELLIGENCE );
    int nDC             = 10 + nPM_rank + nINT_mod;
    int nFort           = FortitudeSave( oVictim, nDC, SAVING_THROW_TYPE_NONE, oPC );
    int nDrain          = 1;
    float fDuration     = TurnsToSeconds( nPM_rank );
    effect eParalyze    = SupernaturalEffect( EffectLinkEffects( EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),EffectNegativeLevel(nDrain) ) );


    if ( nFort == 0 ){

        //Apply the VFX impact and effects
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eParalyze, oVictim, fDuration );
    }
}

void Commanding( object oPC, object oVictim ){

    if ( GetIsPC( oVictim ) || GetIsPossessedFamiliar( oVictim ) || GetIsDMPossessed( oVictim ) ){

        return;
    }

    if ( GetHitDice( oVictim ) > 22 && GetHasSpellEffect( SPELL_ETHEREALNESS ) ){

        RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
        SendMessageToPC( oPC, "Dominating level 23+ monsters removes GS." );
    }


    if ( GetRacialType( oVictim ) == RACIAL_TYPE_UNDEAD ){

        if( GetIsObjectValid( GetMaster( oVictim ) ) ){
            SendMessageToPC( oPC, "Cannot steal other' undeads! Buy/create/summon/build your own!" );
            return;
        }

        //Vars
        int nPM_rank    = GetLevelByClass( CLASS_TYPE_PALE_MASTER )
                        + GetLevelByClass( CLASS_TYPE_SORCERER )
                        + GetLevelByClass( CLASS_TYPE_WIZARD );
        int nDC         = GetLevelByClass( CLASS_TYPE_PALE_MASTER )+GetAbilityModifier( ABILITY_INTELLIGENCE )+10;
        //For some reason a dominate effect does not work here, so run the actual dominate spell since there is something fishy about it
        SetLocalInt( oPC, "pm_override_dc", nDC );
        SetLocalInt( oPC, "pm_override_cl", nPM_rank );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectBeam( VFX_BEAM_DISINTEGRATE, oPC, BODY_NODE_HAND ), oVictim, 2.0 );
        AssignCommand( oPC, ActionCastSpellAtObject( SPELL_CONTROL_UNDEAD, oVictim, METAMAGIC_ANY, TRUE, nPM_rank, PROJECTILE_PATH_TYPE_DEFAULT, TRUE ) );
    }
}

void Destructive( object oPC, object oVictim ){

    int nPM_rank        = GetLevelByClass( CLASS_TYPE_PALE_MASTER );
    int nINT_mod        = GetAbilityModifier( ABILITY_INTELLIGENCE );
    int nDC             = 10 + nPM_rank + nINT_mod;
    int nFort           = FortitudeSave( oVictim, nDC, SAVING_THROW_TYPE_NONE, oPC );
    int nDice           = d6();
    float fDuration     = TurnsToSeconds( nPM_rank );
    effect eParalyze    = SupernaturalEffect( EffectLinkEffects( EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), EffectAbilityDecrease( ABILITY_CONSTITUTION, nDice) ) );

    if ( nFort == 0 ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eParalyze, oVictim, fDuration );
    }
}
