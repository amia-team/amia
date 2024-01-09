// Include file for the custom summons.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- --------------------------------------------------
// 2012-05-27 Naivatkal        Altered Epic Shadowlord bonuses
// 2013-07-31 PoS              Redid the summon creature section
// 2020-10-28 Raphel Gray      Added changes to Epic Dragon Knight.
//
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_i0_spells"
#include "x2_inc_toollib"
#include "inc_ds_records"
#include "x2_inc_spellhook"
#include "inc_td_appearanc"
#include "amia_include"
#include "inc_td_shifter"
#include "nwnx_creature"
//-------------------------------------------------------------------------------
// prototypes: spell summons
//-------------------------------------------------------------------------------

//void main(){}

//used in nw_s0_animdead
void sum_AnimateDead( object oPC, int nCasterLevel, location lTarget );

//used in nw_s0_crundead, nCap = 1
//used in nw_s0_crgrund, nCap = 0
void sum_CreateUndead( object oPC, int nCap, int nCasterLevel, location lTarget );

// Black Blade of Disaster
void sum_BlackBlade( object oPC, int nCasterLevel, location lTarget );

// Shelgarn's Persistent Blade
void sum_PersistentBlade( object oPC, int nCasterLevel, location lTarget );

// Elemental Swarm
void sum_ElementalSwarm( object oPC, int nCasterLevel );

// Epic Spell: Dragon Knight
void sum_DragonKnight( object oPC, int nCasterLevel, location lTarget );

// Summon Shadow spells
//  SHADOW_CONJURATION_SUMMON_SHADOW
//  GREATER_SHADOW_CONJURATION_SUMMON_SHADOW
//  SHADES_SUMMON_SHADOW
void sum_Shadow( object oPC, int nSpell, int nCasterLevel, location lTarget );

// Gate
void sum_Gate( object oPC, int nCasterLevel, location lTarget );

// Planar Bindings
//  Greater planar binding
//  Lesser planar binding
//  Planar binding
//  Planar ally
void sum_PlanarBinding( object oPC, int nSpell, int nCasterLevel, location lTarget );

// Summon Creature I-IX
void sum_SummonCreature( object oPC, int nSpell, int nCasterLevel, location lTarget );

//Mummy Dust
void sum_MummyDust( object oPC, location lTarget );

//-------------------------------------------------------------------------------
// prototypes: feat summons
//-------------------------------------------------------------------------------

//nw_s0_summshad02
void sum_DeathDomainSummon( object oPC, int nCasterLevel, location lTarget );

//Black Guard's Create Undead ability
void sum_BG_CreateUndead( object oPC, location lTarget );

//Black Guard's Summon Fiend ability
void sum_BG_SummonFiend( object oPC, location lTarget );

//Shadow Dancer's Summon Shadow ability
void sum_SD_Shadow( object oPC, location lTarget );
// Function to apply SD summon buffs
void sd_sum_skinchange(object oPC, float fDuration);
void sd_sum_buff(object oPC, effect eLink, float fDuration);
effect sd_calc_buffs(int nShadowRank, object oPC);

//used in x2_s2_sumundead ( nCap = 1, turnbonus = 4, powerbonus = 2 )
//used in x2_s2_sumgrund ( nCap = 0, turnbonus = 6, powerbonus = 3 )
void sum_SummonUndead( object oPC, int nCap, int nTurnResistanceBonus, int nPowerPointBonus );

//-------------------------------------------------------------------------------
// prototypes: Buffing
//-------------------------------------------------------------------------------
//used in undead scripts
void FindSummonAndDoBonusTurnResistance( object oPC, string szSummonResRef, int nTurnBonus );

// a Cleric with the Animal Domain gets a nice buff on their summon
void FindSummonAndDoAnimalDomainBonuses( object oPC,string szSummonResRef );

//buffs shadows
void FindSummonAndDoShadowBonuses1( object oPC, string szSummonResRef );
void FindSummonAndDoShadowBonuses2( object oPC, string szSummonResRef );
void FindSummonAndDoShadowBonuses3( object oPC, string szSummonResRef );

//buff fiend
void FindSummonAndDoFiendBonuses( object oPC, string szSummonResRef );

//-------------------------------------------------------------------------------
// prototypes: Varia
//-------------------------------------------------------------------------------
//deals with the actual spawning of undead summons
void SpawnUndead( object oPC, location lLocation, float fDuration, int nPowerPoints, int nBonusTurnResistance=0, int nIsSpell=1 );

//selects one out of two elementals
string RandomParaElementalResRef();

//Returns a appropriate casterlevel
//if it is an undead druid levels will be counted out
//and PM levels will be used in the calculation aswell
//Returns the highest devine or arcane casterlevel
int GetPM_ArcaneOrDevineCasterLevels( object oPC , int nIsUndead = FALSE);

// Replacement for the old CustomSummon method. Creates a custom skin, name and portrait
// if the reskin widget exists, otherwise applies up to three visuals on a summon
// (set as local vars on the NPC).
void HandleSummonVisuals( object oPC, int nType );

// Replacement for the old methods to apply methods. Applies buffs to a summon depending
// on what type it is. Will probably expand later
void HandleSummonBuffs( object oPC, int nSummonType, int nBuffAmount, string sCreatureTag );

//----------------------------------------------------------
//UNDEAD
//----------------------------------------------------------
//used in nw_s0_animdead
//duration: 24 hrs (48 mins)
void sum_AnimateDead( object oPC, int nCasterLevel, location lTarget ){

    // Capped @ 14 powerpoints for non-PMs, 15 for PMs

    // vars
    int nPaleMasterLevel        = 0;
    int nTotalPowerPoints       = nCasterLevel;
    int nTurnResistanceBonus    = 0;

    // palemaster? , +2 turn resistance, palemaster bonus undead powerpoints, +1 undead powerpoint
    if ( ( nPaleMasterLevel = GetLevelByClass( CLASS_TYPE_PALEMASTER, oPC ) > 0 ) &&
         ( GetLastSpellCastClass( ) != CLASS_TYPE_CLERIC ) ){

        // palemaster bonus undead powerpoints
        nTotalPowerPoints += nPaleMasterLevel;

        // +1 undead powerpoint for being a palemaster spell-like ability
        nTotalPowerPoints++;

        // +2 turn resistance to undead summon, for being a palemaster spell-like ability
        nTurnResistanceBonus = 2;

        // 15 undead powerpoint cap
        if ( nTotalPowerPoints > 15 ){

            nTotalPowerPoints = 15;
        }
    }
    // clerics,sorcerers,wizards, no bonuses
    else{

        // 14 undead powerpoint cap
        if ( nTotalPowerPoints > 14 ){

            nTotalPowerPoints = 14;
        }
    }

    // summon the critter
    SpawnUndead( oPC, lTarget, NewHoursToSeconds(24), nTotalPowerPoints, nTurnResistanceBonus );
}

//used in nw_s0_crundead, nCap = 1
//used in nw_s0_crgrund, nCap = 0
//duration: 1 Round / ( Caster + PM ) Level
void sum_CreateUndead( object oPC, int nCap, int nCasterLevel, location lTarget ){

    // vars
    int nPaleMasterLevel        = 0;
    int nTotalPowerPoints       = nCasterLevel;

    // palemaster? , palemaster levels added to undead powerpoints
    if ( ( nPaleMasterLevel = GetLevelByClass( CLASS_TYPE_PALEMASTER, oPC ) > 0 ) &&
         ( GetLastSpellCastClass( ) != CLASS_TYPE_CLERIC ) ){

        // palemaster bonus undead powerpoints
        nTotalPowerPoints += nPaleMasterLevel;
    }

    // 22 undead powerpoint cap
    if ( nCap == 1 && nTotalPowerPoints > 27 ){

        nTotalPowerPoints = 27;
    }

    float fDuration = TurnsToSeconds( nTotalPowerPoints );

    // Extended metamagic ?
    if ( GetMetaMagicFeat() == METAMAGIC_EXTEND ){

        fDuration *= 2;
    }

    // summon the critter
    SpawnUndead( oPC, lTarget, fDuration, nTotalPowerPoints );
}

// Black Blade of Disaster
void sum_BlackBlade( object oPC, int nCasterLevel, location lTarget ){

    // vars
    float fDuration = RoundsToSeconds( nCasterLevel );

    // Dispel 'etherealness'.
    RemoveSpecificEffect( EFFECT_TYPE_ETHEREAL, oPC );

    // candy
    TLVFXPillar( VFX_DUR_DEATH_ARMOR, lTarget, 6, 0.2, 6.0, -2.0 );

    effect eSummon = EffectSummonCreature( "the_black_blade", VFX_NONE, 0.5, FALSE );

    // summon the dreaded Black Blade of Disaster!
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration );

    // Handle reskins/optional visuals.
    DelayCommand( 3.0, HandleSummonVisuals( oPC, 1 ) );

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    // cancel the original spell
    SetModuleOverrideSpellScriptFinished();
}

// Shelgarn's Persistent Blade
void sum_PersistentBlade( object oPC, int nCasterLevel, location lTarget ){

    // vars
    float fDuration = TurnsToSeconds( nCasterLevel );

    // candy
    effect eSummon  = EffectSummonCreature( "shelgarns_blade", VFX_DUR_DEATH_ARMOR, 1.0, 0 );

    // summon
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration );

    // Handle reskins/optional visuals.
    DelayCommand( 3.0, HandleSummonVisuals( oPC, 1 ) );

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    // cancel original spell
    SetModuleOverrideSpellScriptFinished();
}

// Elemental Swarm
void sum_ElementalSwarm( object oPC, int nCasterLevel ){

    // vars
    string szElem1 = RandomParaElementalResRef();
    string szElem2 = RandomParaElementalResRef();
    string szElem3 = RandomParaElementalResRef();
    string szElem4 = RandomParaElementalResRef();

    // summon the elementals
    effect eElementals = EffectSwarm( FALSE, szElem1, szElem2, szElem3, szElem4 );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eElementals, oPC, 0.0 );

    //time feedback
    SendMessageToPC( oPC, "Duration: permanent until summons are dead." );

    // cancel original spell
    SetModuleOverrideSpellScriptFinished();
}

// Epic Spell: Dragon Knight
void sum_DragonKnight( object oPC, int nCasterLevel, location lTarget ){

    //--------------------------------------------------------------------------------
    //GS + EDK nerf
    //--------------------------------------------------------------------------------

    if ( GetHasSpellEffect( SPELL_ETHEREALNESS, oPC ) ){

        RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
        SendMessageToPC( oPC, "Summoning level 23+ monsters removes GS." );
    }

    float fDuration     = RoundsToSeconds( nCasterLevel );

    // requirements

    if (!GetCanCastEpicSpells( oPC ) ) {

        SendMessageToPC( oPC, "You need either 20+ Cha, Int or Wis to cast this spell." );
        return;
    }
        object EDKItem = GetItemPossessedBy(oPC, "edk_choice");
        int iEDKChoice  = GetLocalInt( EDKItem, "edk_choice");
        int nGoodEvil   = GetAlignmentGoodEvil( oPC );
        string szDragon = "dragon_";

    switch (iEDKChoice)
    {
        case 0:
            //Nothing selected, user hasn't selected a Dragon yet or something has gone wrong!
               SendMessageToPC( oPC, "No Dragon has been selected, please select one with the Epic Dragon Knight Statue" );
               IncrementRemainingFeatUses( oPC, FEAT_EPIC_SPELL_DRAGON_KNIGHT );
               SetModuleOverrideSpellScriptFinished();
               return;
               break;
        case 1:
               szDragon+= "brass";
               break;
        case 2:
               szDragon+= "bronze";
               break;
        case 3:
               szDragon+= "copper";
               break;
        case 4:
               szDragon+= "gold";
               break;
        case 5:
               szDragon+= "g";
               break;
        case 6:
               szDragon+= "black";
               break;
        case 7:
               szDragon+= "blue";
               break;
        case 8:
               szDragon+= "green";
               break;
        case 9:
               szDragon+= "e";
               break;
        case 10:
               szDragon+= "white";
               break;
        case 11:
                szDragon+= "behir";
               break;
        case 12:
               szDragon+= "earth";
               break;
        case 13:
               szDragon+= "n";
               break;
        case 14:
               szDragon+= "shadow";
               break;
        case 15:
            // turns per level duration for casters with Greater Spell Focus: Necromancy
            if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oPC ) == TRUE ){
                        fDuration = TurnsToSeconds( nCasterLevel );
                    }
               szDragon+= "skele";
               break;
        }

    if (iEDKChoice != 15)
        {
             // turns per level duration for casters with Greater Spell Focus: Conjuration
             if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_CONJURATION, oPC ) == TRUE ){
                    fDuration = TurnsToSeconds( nCasterLevel );
                }
        }

    // candy
    effect eSummon = EffectSummonCreature( szDragon, 488, 5.0, 0 );

    // Summon the Dragon
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration );

    // make the dragon face the caster's foes
    float fPos = GetFacing( oPC );
    DelayCommand( 5.1, AssignCommand( GetNearestObjectByTag( szDragon, oPC ), SetFacing( fPos ) ) );

    // Handle reskins/optional visuals.
    DelayCommand( 7.0, HandleSummonVisuals( oPC, 1 ) );

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    // cancel original spell
    SetModuleOverrideSpellScriptFinished();
}

// Summon Shadow spells
//  SHADOW_CONJURATION_SUMMON_SHADOW
//  GREATER_SHADOW_CONJURATION_SUMMON_SHADOW
//  SHADES_SUMMON_SHADOW
void sum_Shadow( object oPC, int nSpell, int nCasterLevel, location lTarget ){

    int nBonus;               // used to determine scale of Shadow Buff
    int eVfx;
    string szShadowCreature = "shadow_";

    // calculate duration an summon limits
    float fDuration;

    // shadow conjuration: summon shadow
    if ( nSpell == SPELL_SHADOW_CONJURATION_SUMMON_SHADOW ){

        fDuration = NewHoursToSeconds( nCasterLevel );

        // limit to 10th HD shadows
        if ( nCasterLevel > 12 ){

            nCasterLevel = 12;
        }
    }
    // greater shadow conjuration: summon greater shadow
    else if (  nSpell == SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW ){

        nBonus    = 1;
        fDuration = TurnsToSeconds( nCasterLevel );

        // limit to 10th and 16th HD shadows
        if ( nCasterLevel > 18 ){

            nCasterLevel = 18;
        }
    }
    // shades: summon shadow [very powerful]
    else{

        nBonus    = 2;
        fDuration = RoundsToSeconds( nCasterLevel ) * 2;
    }

    // Extended metamagic
    if ( GetMetaMagicFeat() == METAMAGIC_EXTEND ){

        fDuration *= 2;
    }

    // toggle the appropriate spell level
    if ( nCasterLevel< 13 ){

        szShadowCreature +=  "1";
    }
    else if ( nCasterLevel< 19 ){

        szShadowCreature +=  "2";
    }
    else if ( nCasterLevel< 25 ){

        szShadowCreature +=  "3";
    }
    else{

        szShadowCreature +=  "4";
    }

    // delay shadow bonuses from spells until Shadow is summoned in-game
    if ( nBonus == 1 ){

        DelayCommand( 2.0, FindSummonAndDoShadowBonuses1( oPC, szShadowCreature ) );
    }
    else if ( nBonus == 2 ){

        DelayCommand( 2.0, FindSummonAndDoShadowBonuses2( oPC, szShadowCreature ) );
    }

    // summon the designated Shadow
    effect eSummon = EffectSummonCreature( szShadowCreature, VFX_FNF_SMOKE_PUFF, 0.0, 0 );

    ApplyEffectAtLocation(  DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration );

    // Handle reskins/optional visuals.
    DelayCommand( 2.5, HandleSummonVisuals( oPC, 1 ) );

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    // cancel original spell
    SetModuleOverrideSpellScriptFinished();
}


// Gate
void sum_Gate( object oPC, int nCasterLevel, location lTarget ){

    // vars
    int eVfx;
    string szGateCreature = "gate_";

    // duration( 1 round/level )
    float fDuration = RoundsToSeconds( nCasterLevel  ) * 2;

    int nMetaMagic = GetMetaMagicFeat();
    //Make metamagic extend check
    if (nMetaMagic == METAMAGIC_EXTEND ) {
        fDuration = fDuration * 2;   //Duration is +100%
    }

    // Shifter adjustments - Takes their CL in account
    if( GetIsPolymorphed( oPC ) && GetLevelByClass( CLASS_TYPE_SHIFTER, oPC ) > 0 )
    {
      fDuration = RoundsToSeconds( GetNewCasterLevel(oPC)  ) * 2;
      nCasterLevel = GetNewCasterLevel(oPC);
    }

    // Determining the duration above means that adding 2 to the CL doesn't
    // affect the duration for Portal Domain clerics.
    if ( GetHasFeat( 1198 ) ){

        nCasterLevel += 2;
    }


    // Handle reskins/optional visuals.
    DelayCommand( 3.0, HandleSummonVisuals( oPC, 1 ) );



    //--------------------------------------------------------------------------------
    //GS + Gate nerf
    //--------------------------------------------------------------------------------

    if ( nCasterLevel > 21 && GetHasSpellEffect( SPELL_ETHEREALNESS ) ){

        RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
        SendMessageToPC( oPC, "Summoning level 23+ monsters removes GS." );
    }


    // toggle the appropriate spell level
    // 27-30
    if ( nCasterLevel > 26 ){

        szGateCreature +=  "3_";
    }
    // 22-26
    else if ( nCasterLevel > 21 ){

        szGateCreature +=  "2_";
    }
    // 17-21
    else{

        szGateCreature +=  "1_";
    }

    // toggle the appropriate alignment
    int nGoodEvil = GetAlignmentGoodEvil( oPC  );
    int nLawChaos = GetAlignmentLawChaos( oPC  );

    // evil
    eVfx = VFX_FNF_SUMMON_GATE;
    // evil on the good-evil axis, lawful on the law-chaos axis, summon devils
    if ( nGoodEvil == ALIGNMENT_EVIL && nLawChaos == ALIGNMENT_LAWFUL ){

        szGateCreature +=  "le";
    }
    // evil on the good-evil axis, chaotic or neutral on the law-chaos axis, summon demons
    else if ( nGoodEvil == ALIGNMENT_EVIL  && ( nLawChaos == ALIGNMENT_CHAOTIC ) ){

        szGateCreature +=  "ce";
    }
    else if ( nGoodEvil == ALIGNMENT_EVIL  && ( nLawChaos == ALIGNMENT_NEUTRAL ) ){

        szGateCreature +=  "ne";
    }
    // neutral on the good-evil axis, summon neutral outsiders
    else if ( nGoodEvil == ALIGNMENT_NEUTRAL ){

        // neutral vfx
        eVfx = VFX_FNF_SUMMON_MONSTER_3;
        szGateCreature +=  "n";
    }
    // good on the good-evil axis, summon celestial
    else{

        // good vfx
        eVfx = VFX_FNF_SUMMON_CELESTIAL;
        szGateCreature +=  "g";
    }


    // planar creature effect
    effect eSummon  = EffectSummonCreature( szGateCreature, eVfx, 1.0, 0 );

    // summon the creature
    DelayCommand( 3.0, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration ) );

    // Handle reskins/optional visuals.
    DelayCommand( 5.0, HandleSummonVisuals( oPC, 1 ) );

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    // cancel original spell
    SetModuleOverrideSpellScriptFinished();
}


/*  Greater planar binding
    Lesser planar binding
    Planar binding
    Planar ally             */
void sum_PlanarBinding( object oPC, int nSpell, int nCasterLevel, location lTarget ){

    // local vars
    string szPlanarCreature = "planar_";
    int eVfx;
    int nDC                 = GetSpellSaveDC();
    object oVictim          = GetSpellTargetObject();

    // duration( 1 turn/level )
    float fDuration = TurnsToSeconds( nCasterLevel );

    // extended metamagic ?
    if ( GetMetaMagicFeat() == METAMAGIC_EXTEND ){

        fDuration *= 2;
    }

    /*  Outsider targetted mode */
    // Blocked planar ally as its not supposed to work like planar binding
    // Go to summon part instead if its planar binding
    if ( oVictim != OBJECT_INVALID && ( GetRacialType( oVictim ) == RACIAL_TYPE_OUTSIDER ) && nSpell != SPELL_PLANAR_ALLY){

        // duration( 1 round/ 2 levels )
        fDuration = RoundsToSeconds( nCasterLevel/2 );

        // extended metamagic ?
        if ( GetMetaMagicFeat() == METAMAGIC_EXTEND ){

            fDuration *= 2;
        }

        // resolve spell resistance check
        if ( MyResistSpell( oPC, oVictim )< 1 ){

            // resolve will save
            if ( WillSave( oVictim, nDC, SAVING_THROW_TYPE_SPELL, oPC )< 1 ){

                // binding vfx
                effect eBind = EffectLinkEffects( EffectVisualEffect( VFX_DUR_PARALYZE_HOLD ), EffectCutsceneParalyze() );

                // slap it on
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBind, oVictim, fDuration );
            }
        }
    }

    /*  Monster summoning mode  */
    // toggle the appropriate spell level
    else{

        if ( nSpell == SPELL_LESSER_PLANAR_BINDING ){

            szPlanarCreature +=  "1_";
        }
        else if ( nSpell == SPELL_PLANAR_BINDING || nSpell == SPELL_PLANAR_ALLY ){

            szPlanarCreature +=  "2_";
        }
        else{

            szPlanarCreature +=  "3_";
        }

        // toggle the appropriate alignment
        int nGoodEvil = GetAlignmentGoodEvil( oPC );
        int nLawChaos = GetAlignmentLawChaos( oPC );

        // evil
        eVfx = VFX_FNF_SUMMON_GATE;
        // evil on the good-evil axis, lawful on the law-chaos axis, summon devils
        if ( nGoodEvil == ALIGNMENT_EVIL && nLawChaos == ALIGNMENT_LAWFUL ){

            szPlanarCreature +=  "le";
        }
        // evil on the good-evil axis, chaotic or neutral on the law-chaos axis, summon demons
        else if ( nGoodEvil == ALIGNMENT_EVIL && ( nLawChaos == ALIGNMENT_NEUTRAL ) ){

            szPlanarCreature +=  "ne";
        }
        else if ( nGoodEvil == ALIGNMENT_EVIL && ( nLawChaos == ALIGNMENT_CHAOTIC ) ){

            szPlanarCreature +=  "ce";
        }
        // neutral on the good-evil axis, summon neutral outsiders
        else if ( nGoodEvil == ALIGNMENT_NEUTRAL ){

            // neutral vfx [same as good, couldn't find anything else decent]
            eVfx = VFX_FNF_SUMMON_MONSTER_3;
            szPlanarCreature +=  "n";
        }
        // good on the good-evil axis, summon celestial
        else{

            // good vfx
            eVfx = VFX_FNF_SUMMON_CELESTIAL;
            szPlanarCreature +=  "g";
        }


    // planar creature effect
    effect eSummon  = EffectSummonCreature( szPlanarCreature, eVfx, 1.0, 0 );

    // summon the creature
    DelayCommand( 3.0, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration ) );

    // Handle reskins/optional visuals.
    DelayCommand( 5.0, HandleSummonVisuals( oPC, 1 ) );

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );
    }
    // cancel original spell
    SetModuleOverrideSpellScriptFinished();
}


// Summon Creature I-IX
void sum_SummonCreature( object oPC, int nSpell, int nCasterLevel, location lTarget ){

    // Summon visual.
    int nVFX;

    // Spell duration.
    float fDuration;

    // Construct the creature tag string.
    string sCreatureTag = "summon_";

    // The summon type to get from the PC Key.
    int nType;

    // Attack Bonus applied to summon, scaling on spell level.
    int nAB;

    // Determine the type of summon line chosen and use it to continue our construction.
    // Items always default to Animal.
    object oCastFromItem = GetSpellCastItem();

    if ( GetIsObjectValid( oCastFromItem ) )
    {
         sCreatureTag += "a_";
    }
    else
    {
        nType = GetPCKEYValue( oPC, "SummonType" );
        switch ( nType )
        {
            case 0:     sCreatureTag += "a_";    break; // Animal
            case 1:     sCreatureTag += "e_";    break; // Elemental
            case 2:     sCreatureTag += "v_";    break; // Vermin
            case 3:     sCreatureTag += "c_";    break; // Celestial
            case 4:     sCreatureTag += "f_";    break; // Fiendish
            case 5:     sCreatureTag += "w_";    break; // Wild
            default:    sCreatureTag += "a_";    break; // Error handling
        }
    }

    // Determine the summon spell used and use it to finish our construction.
    switch ( nSpell )
    {
        case SPELL_SUMMON_CREATURE_I:
            sCreatureTag += "1";
            nVFX = VFX_FNF_SUMMON_MONSTER_1;
            break;

        case SPELL_SUMMON_CREATURE_II:
            sCreatureTag += "2";
            nVFX = VFX_FNF_SUMMON_MONSTER_1;
            break;

        case SPELL_SUMMON_CREATURE_III:
            sCreatureTag += "3";
            nVFX = VFX_FNF_SUMMON_MONSTER_1;
            nAB = 1;
            break;

        case SPELL_SUMMON_CREATURE_IV:
            sCreatureTag += "4";
            nVFX = VFX_FNF_SUMMON_MONSTER_2;
            nAB = 1;
            break;

        case SPELL_SUMMON_CREATURE_V:
            sCreatureTag += "5";
            nVFX = VFX_FNF_SUMMON_MONSTER_2;
            nAB = 2;
            break;

        case SPELL_SUMMON_CREATURE_VI:
            sCreatureTag += "6";
            nVFX = VFX_FNF_SUMMON_MONSTER_2;
            nAB = 2;
            break;

        case SPELL_SUMMON_CREATURE_VII:
            sCreatureTag += "7";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            nAB = 3;
            break;

        case SPELL_SUMMON_CREATURE_VIII:
            sCreatureTag += "8";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            nAB = 4;
            break;

        case SPELL_SUMMON_CREATURE_IX:
            sCreatureTag += "9";
            nVFX = VFX_FNF_SUMMON_MONSTER_3;
            nAB = 4;
            break;

        default:
            sCreatureTag += "1";
            nVFX = VFX_FNF_SUMMON_MONSTER_1;
            break;
    }

    // Give the first level spell a boost for low levels.
    if ( nSpell == SPELL_SUMMON_CREATURE_I )    fDuration = NewHoursToSeconds( nCasterLevel );
    else                                        fDuration = TurnsToSeconds( nCasterLevel );

    // Was it cast as extended?
    if ( GetMetaMagicFeat() == METAMAGIC_EXTEND ) fDuration *= 2;

    // The summon creature effect.
    effect eSummonCreature = EffectSummonCreature( sCreatureTag, nVFX, 1.0, 0 );

    // Now we summon it.
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummonCreature, lTarget, fDuration );

    // Handle reskins/optional visuals.
    DelayCommand( 2.0, HandleSummonVisuals( oPC, 1 ) );

    // Handle optional buffs.
    DelayCommand( 3.0, HandleSummonBuffs( oPC, 0, nAB, sCreatureTag ) );

    // Spit out some duration feedback to the PC.
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    // Finally, cancel the original spell.
    SetModuleOverrideSpellScriptFinished();
}

void sum_MummyDust( object oPC, location lTarget ){
   // requirements

    if ( !GetCanCastEpicSpells( oPC ) ) {

        SendMessageToPC( oPC, "You need either 20+ Cha, Int or Wis to cast this spell." );
        return;
    }

    //--------------------------------------------------------------------------------
    //GS + Dust nerf
    //--------------------------------------------------------------------------------

    if ( GetHasSpellEffect( SPELL_ETHEREALNESS, oPC ) ){

        RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
        SendMessageToPC( oPC, "Summoning level 23+ monsters removes GS." );

    }

    int nDuration       = GetPM_ArcaneOrDevineCasterLevels( oPC , FALSE );
    float fDuration;
    effect eSummon;
    int nEpicSchool;
    int iSummon         = GetPCKEYValue( oPC, "jj_MummyDust_Choice");
    int nAlign          = GetAlignmentGoodEvil( oPC );
    string sResRef;



    switch (iSummon)
    {
        case 2: //Outsider
           if (nAlign == ALIGNMENT_GOOD)
           {
               eSummon     = EffectSummonCreature("mc_dustyoutg",VFX_FNF_SUMMON_CELESTIAL,1.0f);
               sResRef     = "mc_dustyoutg";
           }
           else if (nAlign == ALIGNMENT_EVIL)
           {
               eSummon     = EffectSummonCreature("mc_dustyoute",VFX_FNF_SUMMON_GATE,1.0f);
               sResRef     = "mc_dustyoute";
           }
           else
           {
               eSummon     = EffectSummonCreature("mc_dustyoutsider",VFX_FNF_SUMMON_GATE,1.0f);
               sResRef     = "mc_dustyoutsider";
           }
           nEpicSchool = FEAT_EPIC_SPELL_FOCUS_CONJURATION;
        break;
        case 3: //Construct
           eSummon     = EffectSummonCreature("mc_dustyconstruct",VFX_FNF_SUMMON_MONSTER_3,0.5f);
           sResRef     = "mc_dustyconstruct";
           nEpicSchool = FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION;
        break;
        case 4: //Magical Beast
           eSummon     = EffectSummonCreature("mc_dustyanimal",VFX_FNF_SUMMON_MONSTER_3,0.5f);
           sResRef     = "mc_dustyanimal";
           nEpicSchool = FEAT_EPIC_SPELL_FOCUS_CONJURATION;
        break;
        case 5: //Elemental
           eSummon     = EffectSummonCreature("mc_dustyelementa",VFX_FNF_SUMMON_MONSTER_3,0.5f);
           sResRef     = "mc_dustyelementa";
           nEpicSchool = FEAT_EPIC_SPELL_FOCUS_EVOCATION;
           break;
        default://If the PC doesn't have the book or chose Undead.
           nDuration   = GetPM_ArcaneOrDevineCasterLevels( oPC , TRUE );
           eSummon     = EffectSummonCreature("cs_dustymummyf1",VFX_FNF_SUMMON_EPIC_UNDEAD,1.0f);
           sResRef     = "cs_dustymummyf1";
           nEpicSchool = FEAT_EPIC_SPELL_FOCUS_NECROMANCY;
        break;
    }
    if (GetHasFeat(nEpicSchool))
        fDuration = NewHoursToSeconds(nDuration);
    else
        fDuration = TurnsToSeconds(nDuration);

    eSummon = ExtraordinaryEffect( eSummon );
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration );

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    // Handle reskins/optional visuals.
    DelayCommand( 2.0, HandleSummonVisuals( oPC, 1 ) );

    // cancel original spell
    SetModuleOverrideSpellScriptFinished();
}


//-------------------------------------------------------------------------------
// functions: feat summons
//-------------------------------------------------------------------------------

//nw_s0_summshad02
void sum_DeathDomainSummon( object oPC, int nCasterLevel, location lTarget ){

    // Variables
    string szSummon          = "";
    nCasterLevel = GetLevelByClass( CLASS_TYPE_CLERIC, oPC );

    // Summon selected depends on Caster Level

    if (      nCasterLevel < 8  ){

    szSummon  =  "dd_undead_1u";
    }
    else if ( nCasterLevel < 12  ){

        szSummon  =  "dd_undead_2u";
    }
    else if ( nCasterLevel < 17  ){

        szSummon  =  "dd_undead_3u";
    }
    else if ( nCasterLevel < 22  ){

        szSummon  =  "dd_undead_4u";
    }
    else if ( nCasterLevel < 27  ){

            if ( GetHasSpellEffect( SPELL_ETHEREALNESS, oPC ) ){

            RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
            SendMessageToPC( oPC, "Summoning level 23+ monsters removes GS." );

            }

        szSummon  =  "dd_undead_5u";
    }
    else{

            if ( GetHasSpellEffect( SPELL_ETHEREALNESS, oPC ) ){

            RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
            SendMessageToPC( oPC, "Summoning level 23+ monsters removes GS." );

            }

        szSummon  =  "dd_undead_6u";
    }

    //set summon effect
    effect eSummon  =  EffectSummonCreature( szSummon, VFX_FNF_PWKILL, 1.0 );

    //Apply VFX impact and summon effect
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, lTarget, NewHoursToSeconds( 24 ) );

    // Handle reskins/optional visuals.
    DelayCommand( 2.0, HandleSummonVisuals( oPC, 1 ) );

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( NewHoursToSeconds( 24 ) ) )+" seconds." );

    SetModuleOverrideSpellScriptFinished();
}

void sum_BG_CreateUndead( object oPC, location lTarget ){

    // Blackguard level
    int nBlackguardRank             = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );

    // vars
    string szBlackguardUndead       = "undead_";
    float fDuration                 = TurnsToSeconds( nBlackguardRank );

    // 3rd - 6th level gets a Skeleton
    if ( nBlackguardRank < 6 ){

        szBlackguardUndead += "1";

        // special duration for lower level BG's - so their summon lasts a bit longer
        fDuration = NewHoursToSeconds( nBlackguardRank );
    }
    // 6th - 11th level gets a Wraith
    else if ( nBlackguardRank < 12 ){

        szBlackguardUndead += "2";
    }
    // 12th - 20th level gets a Dread wraith
    else{

        szBlackguardUndead += "3";
    }

    // summon the undead
    effect eSummon = EffectSummonCreature( szBlackguardUndead, VFX_IMP_RAISE_DEAD, 0.5, 0 );

    // candy
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration );

    // Handle reskins/optional visuals.
    DelayCommand( 2.0, HandleSummonVisuals( oPC, 1 ) );

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    SetModuleOverrideSpellScriptFinished();
}


void sum_BG_SummonFiend( object oPC, location lTarget ){

    // vars
    object oPC      = OBJECT_SELF;

    // Blackguard level
    int nBlackguardRank = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );

    string szBlackguardFiend;
    float fDuration = TurnsToSeconds(nBlackguardRank);

    // 5th - 14th level
    if ( nBlackguardRank < 15 ){

        szBlackguardFiend = "planar_2_";

        // special duration for lower level BG's - so their summon lasts a bit longer
        fDuration = NewHoursToSeconds( nBlackguardRank );
    }
    // 15th - 20th level
    else{

        szBlackguardFiend += "gate_1_";
    }

    // toggle the alignment
    int nLawChaos = GetAlignmentLawChaos( oPC );

    // AL LE
    if ( nLawChaos == ALIGNMENT_LAWFUL ){

        szBlackguardFiend += "le";
    }
    else if ( nLawChaos == ALIGNMENT_NEUTRAL ){

        szBlackguardFiend += "ne";
    }
    // AL C/N-E
    else{

        szBlackguardFiend += "ce";
    }

    // Blackguard has the Epic Fiendish Servant feat ?
    if ( GetHasFeat( FEAT_EPIC_EPIC_FIEND, oPC ) == TRUE ){

        switch( nLawChaos ){

            case ALIGNMENT_CHAOTIC: szBlackguardFiend  =  "contractedkelvez";  break;
            case ALIGNMENT_LAWFUL:  szBlackguardFiend  =  "summonedamnizubo";  break;
            default:                szBlackguardFiend  =  "arcanaloth";        break;
        }

        fDuration = NewHoursToSeconds( 24 );

        // delay bonus buff until the fiend has actually spawned, else it'll miss!
        DelayCommand( 4.0, FindSummonAndDoFiendBonuses( oPC, szBlackguardFiend ) );
    }

    // summon the fiend
    effect eBlackguardFiend = EffectSummonCreature( szBlackguardFiend, VFX_FNF_SUMMON_GATE, 3.0, 0 );

    // candy
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eBlackguardFiend, lTarget, fDuration );

    // Handle reskins/optional visuals.
    DelayCommand( 4.0, HandleSummonVisuals( oPC, 1 ) );

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    SetModuleOverrideSpellScriptFinished();
}

void sum_SD_Shadow( object oPC, location lTarget )
{
    // get Shadowdancer level
    int nShadowRank         = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC );
    float fDuration         = TurnsToSeconds( nShadowRank );
    string szShadowCreature = "sd_shadow_";
    effect eLink;

    // Epic Shadowlord Shadow
    if ( GetHasFeat( FEAT_EPIC_EPIC_SHADOWLORD, oPC ) == TRUE )
    {
        if ( GetHasSpellEffect( SPELL_ETHEREALNESS, oPC ) )
        {
            RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
            SendMessageToPC( oPC, "Summoning level 23+ monsters removes GS." );
        }

        szShadowCreature+="4";
        eLink = sd_calc_buffs(nShadowRank, oPC);
        fDuration = fDuration*2.0;
    }
    // 13th HD Shadow
    else if ( nShadowRank < 7 )
    {
        szShadowCreature+="1";
        eLink = sd_calc_buffs(nShadowRank, oPC);
    }
    // 19th HD Shadow
    else if ( nShadowRank < 10 )
    {
        szShadowCreature+="2";
        eLink = sd_calc_buffs(nShadowRank, oPC);
    }
    // 25th HD Shadow
    else
    {
        if ( GetHasSpellEffect( SPELL_ETHEREALNESS, oPC ) )
        {
            RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
            SendMessageToPC( oPC, "Summoning level 23+ monsters removes GS." );
        }

        szShadowCreature+="3";
        eLink = sd_calc_buffs(nShadowRank, oPC);
    }

    // summon the Shadow
    effect eShadowSummon = EffectSummonCreature( szShadowCreature, VFX_FNF_SMOKE_PUFF, 1.0, 0 );

    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eShadowSummon, lTarget, fDuration );
    // Set a custom clone appearance and shadow effect of user.
    DelayCommand( 2.5, sd_sum_skinchange( oPC, fDuration) );

    // Handle reskins/optional visuals.
    DelayCommand( 3.0, HandleSummonVisuals( oPC, 1 ) );

    // Call function to buff summon
    DelayCommand(4.0, sd_sum_buff(oPC, eLink, fDuration));

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    SetModuleOverrideSpellScriptFinished();
}

// Function to apply SD summon buffs
void sd_sum_skinchange(object oPC, float fDuration)
{
    object oAssociate = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    int nAppearance = GetAppearanceType(oPC);
    int nGender = GetGender(oPC);
    int nTail = GetCreatureTailType(oPC);
    int nWings = GetCreatureWingType(oPC);
    int nRFoot = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT,oPC);
    int nLFoot = GetCreatureBodyPart(CREATURE_PART_LEFT_FOOT,oPC);
    int nRShin = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,oPC);
    int nLShin = GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,oPC);
    int nRThigh = GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,oPC);
    int nLThigh = GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,oPC);
    int nPelvis = GetCreatureBodyPart(CREATURE_PART_PELVIS,oPC);
    int nTorso = GetCreatureBodyPart(CREATURE_PART_TORSO,oPC);
    int nBelt = GetCreatureBodyPart(CREATURE_PART_BELT,oPC);
    int nNeck = GetCreatureBodyPart(CREATURE_PART_NECK,oPC);
    int nRFore = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM,oPC);
    int nLFore = GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,oPC);
    int nRBicep = GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,oPC);
    int nLBicep = GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,oPC);
    int nRShoulder = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER,oPC);
    int nLShoulder = GetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER,oPC);
    int nRHand = GetCreatureBodyPart(CREATURE_PART_RIGHT_HAND,oPC);
    int nLHand = GetCreatureBodyPart(CREATURE_PART_LEFT_HAND,oPC);
    int nHead = GetCreatureBodyPart(CREATURE_PART_HEAD,oPC);
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);


    if (oAssociate == OBJECT_INVALID)
    {
        SendMessageToPC(oPC, "No summon found!");
        return;
    }
    else
    {
      SetCreatureAppearanceType(oAssociate,nAppearance);
      NWNX_Creature_SetGender(oAssociate,nGender);
      SetCreatureWingType(nWings,oAssociate);
      SetCreatureTailType(nTail,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT,nRFoot,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT,nLFoot,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,nRShin,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,nLShin,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,nRThigh,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,nLThigh,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_PELVIS,nPelvis,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_TORSO,nTorso,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_BELT,nBelt,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_NECK,nNeck,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM,nRFore,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,nLFore,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,nRBicep,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,nLBicep,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER,nRShoulder,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER,nLShoulder,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND,nRHand,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_LEFT_HAND,nLHand,oAssociate);
      SetCreatureBodyPart(CREATURE_PART_HEAD,nHead,oAssociate);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oAssociate, fDuration);
    }
}

// Function to set SD summon buffs based on SD level
effect sd_calc_buffs(int nShadowRank, object oPC)
{
    effect eACIncrease;
    effect eSaveInc;
    effect eImmIncSla;
    effect eImmIncBlu;

    if (nShadowRank == 14)
    {
        // Instantiating the effects
        eACIncrease = EffectACIncrease(1, AC_DODGE_BONUS);
        eSaveInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);
    }

    else if (nShadowRank == 15)
    {
        // Instantiating the effects
        eACIncrease = EffectACIncrease(1, AC_DODGE_BONUS);
        eSaveInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);
        eImmIncSla = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 10);
        eImmIncBlu = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 10);
    }

    else if (nShadowRank == 16)
    {
        // Instantiating the effects
        eACIncrease = EffectACIncrease(2, AC_DODGE_BONUS);
        eSaveInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
        eImmIncSla = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 10);
        eImmIncBlu = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 10);
    }

    else if (nShadowRank == 17)
    {
        // Instantiating the effects
        eACIncrease = EffectACIncrease(2, AC_DODGE_BONUS);
        eSaveInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
        eImmIncSla = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 20);
        eImmIncBlu = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 20);
    }

    else if (nShadowRank == 18)
    {
        // Instantiating the effects
        eACIncrease = EffectACIncrease(3, AC_DODGE_BONUS);
        eSaveInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, 3, SAVING_THROW_TYPE_ALL);
        eImmIncSla = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 20);
        eImmIncBlu = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 20);
    }

    else if (nShadowRank == 19)
    {
        // Instantiating the effects
        eACIncrease = EffectACIncrease(3, AC_DODGE_BONUS);
        eSaveInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, 3, SAVING_THROW_TYPE_ALL);
        eImmIncSla = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 30);
        eImmIncBlu = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 30);
    }

    else if (nShadowRank == 20)
    {
        // Instantiating the effects
        eACIncrease = EffectACIncrease(6, AC_DODGE_BONUS);
        eSaveInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, 6, SAVING_THROW_TYPE_ALL);
        eImmIncSla = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 50);
        eImmIncBlu = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 50);
    }

    effect eLink = EffectLinkEffects(eACIncrease, eSaveInc);
    eLink = EffectLinkEffects(eLink, eImmIncSla);
    eLink = EffectLinkEffects(eLink, eImmIncBlu);

    return eLink;
}

// Function to apply SD summon buffs
void sd_sum_buff(object oPC, effect eLink, float fDuration)
{
    object oAssociate = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);

    if (oAssociate == OBJECT_INVALID)
    {
        SendMessageToPC(oPC, "No summon found!");
        return;
    }

    else
    {
        // Apply the buffs
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAssociate, fDuration);
    }
}


//used in x2_s2_sumundead ( nCap = 1, turnbonus = 4, powerbonus = 2 )
//used in x2_s2_sumgrund ( nCap = 0, turnbonus = 6, powerbonus = 3 )
//duration: 1 hour / ( Caster + PM ) Level
void sum_SummonUndead( object oPC, int nCap, int nTurnResistanceBonus, int nPowerPointBonus ){

    // spellcaster powerpoints + palemaster bonus undead powerpoints
    int nTotalPowerPoints  = GetLevelByClass( CLASS_TYPE_PALEMASTER, oPC );

    nTotalPowerPoints += GetLevelByClass( CLASS_TYPE_SORCERER, oPC );
    nTotalPowerPoints += GetLevelByClass( CLASS_TYPE_WIZARD, oPC );

    // +3 undead powerpoint for being a palemaster spell-like ability
    nTotalPowerPoints += nPowerPointBonus;

    location lLoc = GetSpellTargetLocation();

    // 28 undead powerpoint cap for sumundead
    if ( nCap == 1 && nTotalPowerPoints > 28 ){

        nTotalPowerPoints = 28;
    }

    // summon the critter
    SpawnUndead( oPC, lLoc, NewHoursToSeconds( nTotalPowerPoints ), nTotalPowerPoints, nTurnResistanceBonus, 0 );
}


//-------------------------------------------------------------------------------
// functions: BUFFING
//-------------------------------------------------------------------------------

void FindSummonAndDoBonusTurnResistance(

    object  oPC,
    string  szSummonResRef,
    int     nTurnBonus ){

    // vfx
    effect eTurnResBonus     = EffectTurnResistanceIncrease( nTurnBonus );
    effect eTurnVFX          = EffectVisualEffect( VFX_FNF_LOS_HOLY_30 );

    // wrap it all up
    effect eTurnBonus = EffectLinkEffects( eTurnResBonus, eTurnVFX );

    // find the critter
    object oSummon = GetNearestObjectByTag( szSummonResRef, oPC );

    // power em up
    if ( GetIsPC( oSummon  ) == FALSE  ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eTurnBonus, oSummon, 0.0 );
    }
}

// a Cleric with the Animal Domain gets a nice buff on their summon
void FindSummonAndDoAnimalDomainBonuses( object oPC,string szSummonResRef ){

    // +2 Strength
    effect eSTR = EffectAbilityIncrease( ABILITY_STRENGTH, 2 );

    // +4 Constitution
    effect eCON = EffectAbilityIncrease( ABILITY_CONSTITUTION, 4 );

    // +1 Attack bonus
    effect eAB = EffectAttackIncrease( 1 );

    // +1 Armor class
    effect eAC = EffectACIncrease( 1, AC_NATURAL_BONUS );

    // Bless vfx
    effect eAnimalDomainVFX     = EffectVisualEffect( VFX_FNF_LOS_HOLY_30 );

    // wrap it all up
    effect eAnimalDomainBonus   = EffectLinkEffects( eSTR, eCON );
    eAnimalDomainBonus          = EffectLinkEffects( eAnimalDomainBonus, eAB );
    eAnimalDomainBonus          = EffectLinkEffects( eAnimalDomainBonus, eAC );
    eAnimalDomainBonus          = EffectLinkEffects( eAnimalDomainBonus, eAnimalDomainVFX );

    // find the critter
    object oSummon = GetNearestObjectByTag( szSummonResRef, oPC );

    // slap it on
    if ( GetIsPC( oSummon ) == FALSE ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eAnimalDomainBonus, oSummon, 0.0 );
    }
}

void FindSummonAndDoShadowBonuses1( object oPC, string szSummonResRef ){

    effect eBuff = EffectTurnResistanceIncrease( 1 );
    eBuff = EffectLinkEffects( eBuff, EffectAbilityIncrease( ABILITY_DEXTERITY, 2 ) );
    eBuff = EffectLinkEffects( eBuff, EffectRegenerate( 1, 6.0 ) );
    eBuff = EffectLinkEffects( eBuff, EffectVisualEffect( VFX_IMP_SUPER_HEROISM ) );
    eBuff = SupernaturalEffect( eBuff );

    // find the critter
    object oSummon = GetNearestObjectByTag( szSummonResRef, oPC );

    // slap it on
    if ( GetIsPC( oSummon ) == FALSE ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oSummon, 0.0 );
    }
}

void FindSummonAndDoShadowBonuses2( object oPC, string szSummonResRef ){

    effect eBuff = EffectTurnResistanceIncrease( 2 );

    eBuff = EffectLinkEffects( eBuff, EffectAbilityIncrease( ABILITY_DEXTERITY, 4 ) );
    eBuff = EffectLinkEffects( eBuff, EffectRegenerate( 2, 6.0 ) );
    eBuff = EffectLinkEffects( eBuff, EffectVisualEffect( VFX_IMP_SUPER_HEROISM ) );
    eBuff = SupernaturalEffect( eBuff );

    // find the critter
    object oSummon = GetNearestObjectByTag( szSummonResRef, oPC );

    // slap it on
    if ( GetIsPC( oSummon ) == FALSE ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oSummon, 0.0 );
    }
}

void FindSummonAndDoShadowBonuses3( object oPC, string szSummonResRef ){

    effect eBuff = EffectAbilityIncrease( ABILITY_DEXTERITY, 6 );
    eBuff = EffectLinkEffects( eBuff, EffectRegenerate( 2, 6.0));
    eBuff = EffectLinkEffects( eBuff, EffectSpellResistanceIncrease( 5 + GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC ) ) );

    //candy
    eBuff = EffectLinkEffects( eBuff, EffectVisualEffect( VFX_IMP_SUPER_HEROISM ) );
    eBuff = SupernaturalEffect( eBuff );

    // find the critter
    object oSummon = GetNearestObjectByTag( szSummonResRef, oPC);

    // slap it on
    if ( GetIsPC( oSummon ) == FALSE ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oSummon, 0.0 );
    }
}

void FindSummonAndDoFiendBonuses( object oPC, string szSummonResRef ){

    // +1 Armor class per 2 levels of blackguard
    effect eBuff = EffectACIncrease( ( GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC )/2 ), AC_DODGE_BONUS );

    // +4 Strength
    eBuff = EffectLinkEffects( eBuff, EffectAbilityIncrease( ABILITY_STRENGTH, 4 ) );

    // +1 Regeneration
    eBuff = EffectLinkEffects( eBuff, EffectRegenerate( 1, 6.0 ) );

    // SR  =  5 + Blackguard level
    eBuff = EffectLinkEffects( eBuff, EffectSpellResistanceIncrease( 5 + GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC ) ) );

    //candy
    eBuff = EffectLinkEffects( eBuff, EffectVisualEffect( VFX_IMP_SUPER_HEROISM ) );

    eBuff = SupernaturalEffect( eBuff );

    // find the critter
    object oSummon = GetNearestObjectByTag( szSummonResRef, oPC );

    // Improved evasion
    itemproperty ipImprovedEvasion  = ItemPropertyImprovedEvasion();
    object oFiendHide               = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oSummon );

    IPSafeAddItemProperty( oFiendHide, ipImprovedEvasion, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );

    // slap it on
    if( GetIsPC( oSummon ) == FALSE ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oSummon, 0.0 );
    }
}



//-------------------------------------------------------------------------------
// functions: varia
//-------------------------------------------------------------------------------
void SpawnUndead( object oPC, location lTarget, float fDuration, int nPowerPoints, int nBonusTurnResistance=0, int nIsSpell=1 ){

    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    //--------------------------------------------------------------------------------
    //GS + Summon nerf
    //--------------------------------------------------------------------------------

    if ( GetHasSpellEffect( SPELL_ETHEREALNESS, oPC ) && nPowerPoints > 23 ){

        RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
        SendMessageToPC( oPC, "Summoning level 23+ monsters removes GS." );
    }

    // vars
    int nVfx        = VFX_FNF_SUMMON_UNDEAD;
    string szUndead = "undead_";

    // determine undead hd based on undead powerpoints
    // 5  - 8
    if( nPowerPoints < 9 ){

        szUndead   += "1";
    }
    // 9  - 14
    else if ( nPowerPoints < 15 ){

        szUndead   += "2";
    }
    // 15 - 19
    else if ( nPowerPoints < 20 ){

        szUndead   += "3";
    }
    // 20 - 23
    else if ( nPowerPoints < 24 ){

        nVfx        =VFX_IMP_HARM;
        szUndead   += "4";
    }
    // 24 - 27
    else if ( nPowerPoints < 28 ){

        nVfx        =VFX_IMP_HARM;
        szUndead   += "5";
    }
    // 28 - 31
    else if ( nPowerPoints < 32 ){

        nVfx        = VFX_IMP_HARM;
        szUndead   += "6";
    }
    // 32 - 33, the Winterwight can only be accessed by Palemasters =))
    else{

        nVfx        = 496;       // the nice summon undead vfx, meheheh
        szUndead   += "7";
    }

    effect eUndeadSummon = EffectSummonCreature( szUndead, nVfx, 1.0, 0 );

    // summon
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eUndeadSummon, lTarget, fDuration );

    // bonus turning resistance for summons cast by Palemasters
    if ( nBonusTurnResistance > 0 ){

        DelayCommand( 1.0, FindSummonAndDoBonusTurnResistance( oPC, szUndead, nBonusTurnResistance ) );
    }

    // Handle reskins/optional visuals.
    DelayCommand( 1.5, HandleSummonVisuals( oPC, 1 ) );

    SetModuleOverrideSpellScriptFinished();

}

string RandomParaElementalResRef(){

    if ( d2( 1 ) == 1 ){

        return( "pelemental_magma" );
    }
    else{

        return( "pelemental_ice" );
    }
}

int GetPM_ArcaneOrDevineCasterLevels( object oPC , int nIsUndead = FALSE)
{
    int iDruid          = GetLevelByClass(CLASS_TYPE_DRUID,oPC);
    int iCleric         = GetLevelByClass(CLASS_TYPE_CLERIC,oPC);
    int iPM             = GetLevelByClass(CLASS_TYPE_PALEMASTER,oPC);
    int iSorceror       = GetLevelByClass(CLASS_TYPE_SORCERER,oPC);
    int iWizard         = GetLevelByClass(CLASS_TYPE_WIZARD,oPC);

    int iArcane         = iSorceror + iWizard;
    int iDevine         = iCleric + iDruid;

    //Its a undead summon!
    if(nIsUndead)
    {
    iArcane += iPM;
    }
    //Which one is higher?
    if(iDevine > iArcane)return iDevine;

    return iArcane;

}

void HandleSummonVisuals( object oPC, int nType )
{
    if( !CustomSummonAppearance( oPC, nType, GetItemPossessedBy( oPC, "ds_summ_change" ) ) )
    {
        object oSummon = GetAssociate( ASSOCIATE_TYPE_SUMMONED, oPC );

        if      ( nType == 1 ) oSummon = GetAssociate( ASSOCIATE_TYPE_SUMMONED, oPC );
        else if ( nType == 2 ) oSummon = GetAssociate( ASSOCIATE_TYPE_ANIMALCOMPANION, oPC );
        else if ( nType == 3 ) oSummon = GetAssociate( ASSOCIATE_TYPE_FAMILIAR, oPC );


        int    nVFX1   = GetLocalInt( oSummon, "VFX_1" );
        int    nVFX2   = GetLocalInt( oSummon, "VFX_2" );
        int    nVFX3   = GetLocalInt( oSummon, "VFX_3" );

        if( nVFX1 ) ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( nVFX1 ), oSummon );
        if( nVFX2 ) ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( nVFX2 ), oSummon );
        if( nVFX3 ) ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( nVFX3 ), oSummon );
    }
}

void HandleSummonBuffs( object oPC, int nSummonType, int nBuffAmount, string sCreatureTag )
{
    effect eBuff1;
    int nBuff1;

    object oSummon = GetNearestObjectByTag( sCreatureTag, oPC );

    switch ( nSummonType )
    {
        case 0:
            eBuff1 = EffectAttackIncrease( nBuffAmount );
            nBuff1 = 1;
            break; // Summon Creature

        default:
            break; // We do nothing here...
    }

    if( nBuff1 )
    {
        eBuff1 = SupernaturalEffect( eBuff1 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff1, oSummon );
    }
}
