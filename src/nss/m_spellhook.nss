// Module spell hook.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/23/2004 jpavelch         Initial release.
// 20050314   jking            Added spell-use login/logout tracking to
//                             defeat cheating (Courtesy of Selmak).
// 20050314   jking            Also moved all the component checks for
//                             spells in here and got rid of all the
//                             individual overrides.
// 09/24/2005 bbillington      Added in summon replacements.
// 10/20/2005 bbillington      Added in replacement for Persistant Blade.
// 12/29/2005 kfw              No-PvP variable bypassed if Raise or Resurrection is the spell being cast.
// 12/29/2005 kfw              Monsters allowed access to Amia spells.
// 07/06/2006 kfw              Allow original spellscripts to execute.
// 07/06/2006 kfw              Greater sanctuary & Black Blade of Disaster cannot be simultaneously cast.
// 10/01/2006 kfw              Neutral Summons added. Thx's to PaladinOfSune!
// 2006/12/30 Disco            Added a few lines for custom summon name/skin/portrait
// 2007/04/20 Disco            Changed a few durations: Gate and Shades now go for 2 rounds / level
// 2007/04/20 Disco            Removed 5000 GP for Gate
// 2008/01/19 Disco            Libbed all the summons; Was a mess.
// 2008/03/08 Terra            Added support for feat summons as they now trigger spellhook which also puts a stop to summoning in the entry area.
// 2008/03/08 Terra            Fixed scribescroll routines.
// 2008/07/03 Terra            Blocked spells from items from being crafted CraftSpell()
// 2011/08/13 Selmak           Fixes for scribing Raise Dead, Resurrection
//                             and fixes for Fallen using potions and stuff
// 2011/10/04 Selmak           Recompile: Animal, Portal and Death domains
//                             changed in inc_ds_summons in accordance with
//                             domain changes.
// 2011/10/08 Selmak           Potion crafting fixes.
// 2011/11/06 Selmak           Recompile: Animal domain again.
// 2013/01/10 Glim             Fixed Tenser's to allow PC made potion usage.
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "x2_inc_switches"
#include "spell_components"
#include "inc_ds_summons"

// global vars
int nSpell = GetSpellId();

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//Returns TRUE if nSpell is blocked from scrollscribing
//Go to the implemention to modify the list
int BlockedFromScribing(int nSpell);

//Is the PC allowed to cast epic spells?
int AllowedToCastEpicSpell( int nSpell, object oPC );

//Get the highest level casterclass
int GetCasterClass( object oPC );

const int WARLOCK = 57;

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------//

void main( ){
    //Debug
    //string sMessage = "SPELLHOOK Spell id = "+IntToString( GetSpellId() );
    //SendMessageToPC(OBJECT_SELF,sMessage);

    object oCaster   = OBJECT_SELF;
    int nCasterLevel = GetCasterLevel( oCaster );
    location lTarget = GetSpellTargetLocation();

    if( GetIsObjectValid( oCaster ) == FALSE ){

        return;
    }

    // Cast Raise or Resurrection irrespective of PvP settings
    if( (nSpell==SPELL_RAISE_DEAD)      ||
        (nSpell==SPELL_RESURRECTION)    ){
        return;
    }

    /* Check if this is a no-casting zone.

        kfw: No-PvP variable bypassed if Raise or Resurrection is the spell being cast

    */
    object oArea = GetArea( oCaster );

    /*else if( !GetIsObjectValid(GetSpellCastItem( )) && GetIsPolymorphed(oCaster)){

        int nShape = GetLocalInt( oCaster, "poly_shape");
        int ok = nSpell != StringToInt(Catch2DAString("polymorph","SPELL1",nShape));
        ok = ok && (nSpell != StringToInt(Catch2DAString("polymorph","SPELL2",nShape)));
        ok = ok && (nSpell != StringToInt(Catch2DAString("polymorph","SPELL3",nShape)));

        if(!ok){

            SetModuleOverrideSpellScriptFinished( );
            SendMessageToPC( oCaster, "Nope." );
            return;
        }
    }*/

    if( !AllowedToCastEpicSpell( nSpell, oCaster ) ){

        SetModuleOverrideSpellScriptFinished( );
        SendMessageToPC( oCaster, "You do not have not have the required ability score to cast epicspells." );
        return;
    }

    if( GetHasEffect( EFFECT_TYPE_SPELL_FAILURE, oCaster ) ){

        if( GetHasSpellEffect( SPELL_ETHEREALNESS, oCaster ) ){


            SetModuleOverrideSpellScriptFinished( );
            SendMessageToPC( oCaster, "You cannot cast spells while under the effect of spell failure!" );
            return;
        }
        else if( ( GetHasSpellEffect( SPELL_TENSERS_TRANSFORMATION, oCaster ) || GetHasSpellEffect( 307, oCaster ) ) && GetBaseItemType( GetSpellCastItem( ) ) != BASE_ITEM_POTIONS && GetBaseItemType( GetSpellCastItem( ) ) != BASE_ITEM_ENCHANTED_POTION ){

            SetModuleOverrideSpellScriptFinished( );
            SendMessageToPC( oCaster, "You can only use potions when under this effect!" );
            return;
        }

    }

    //Fallen paladin hack
    if ( GetSpellCastItem() == OBJECT_INVALID ){
        if ( GetLastSpellCastClass() == CLASS_TYPE_PALADIN ||
             GetLastSpellCastClass() == CLASS_TYPE_DRUID ||
             GetLastSpellCastClass() == CLASS_TYPE_CLERIC ){

            if ( GetLocalInt( oCaster, "Fallen" ) == 1 ){

                FloatingTextStringOnCreature( "The plea to your deity is not heard...", oCaster, FALSE );

                //Tell the spell to stop running.
                SetModuleOverrideSpellScriptFinished();

                return;
            }
        }
    }

    // Check if this spell requires a component
    if ( CheckForSpellComponent() == FALSE ) {

        SetModuleOverrideSpellScriptFinished( );
        SendMessageToPC( oCaster, "You do not have the required component for this spell." );
        return;
    }



    switch( nSpell ){

        //Negative Plane Avatar (Cleric Death Domain Feat)
        case 383:                                               sum_DeathDomainSummon( oCaster, nCasterLevel, lTarget );break;

        //Create undead
        case SPELL_CREATE_UNDEAD:                               sum_CreateUndead( oCaster, 1, nCasterLevel, lTarget );break;
        case SPELL_CREATE_GREATER_UNDEAD:                       sum_CreateUndead( oCaster, 0, nCasterLevel, lTarget ); break;
        //BG CreateUndead
        case 609:                                               sum_BG_CreateUndead( oCaster, lTarget );break;

        //PM Variant
        case SPELLABILITY_PM_SUMMON_UNDEAD:                     sum_SummonUndead( oCaster, 1, 4, 2 );break;
        case SPELLABILITY_PM_SUMMON_GREATER_UNDEAD:             sum_SummonUndead( oCaster, 0, 6, 3 );break;
        //Animate Dead
        case SPELL_ANIMATE_DEAD:                                sum_AnimateDead( oCaster, nCasterLevel, lTarget ); break;

        //PM Variant
        case SPELLABILITY_PM_ANIMATE_DEAD:                      sum_AnimateDead( oCaster, nCasterLevel, lTarget );break;

        // Black Blade of Disaster
        case SPELL_BLACK_BLADE_OF_DISASTER:                     sum_BlackBlade( oCaster, nCasterLevel, lTarget ); break;

        // Shelgarn's Persistent Blade
        case SPELL_SHELGARNS_PERSISTENT_BLADE:                  sum_PersistentBlade( oCaster, nCasterLevel, lTarget ); break;

        // Elemental Swarm
        case SPELL_ELEMENTAL_SWARM:                             sum_ElementalSwarm( oCaster, nCasterLevel ); break;

        // Epic Spell: Dragon Knight
        case SPELL_EPIC_DRAGON_KNIGHT:                          sum_DragonKnight( oCaster, nCasterLevel, lTarget ); break;

        // Epic Spell: Mummy Dust
        case SPELL_EPIC_MUMMY_DUST:                             sum_MummyDust( oCaster, lTarget ); break;

        // Summon Shadow spells
        case SPELL_SHADOW_CONJURATION_SUMMON_SHADOW:            sum_Shadow( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW:    sum_Shadow( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_SHADES_SUMMON_SHADOW:                        sum_Shadow( oCaster, nSpell, nCasterLevel, lTarget ); break;

        // Gate
        case SPELL_GATE:                                        sum_Gate( oCaster, nCasterLevel, lTarget ); break;

        /*  Greater planar binding
            Lesser planar binding
            Planar binding
            Planar ally             */
        case SPELL_GREATER_PLANAR_BINDING:                      sum_PlanarBinding( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_LESSER_PLANAR_BINDING:                       sum_PlanarBinding( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_PLANAR_BINDING:                              sum_PlanarBinding( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_PLANAR_ALLY:                                 sum_PlanarBinding( oCaster, nSpell, nCasterLevel, lTarget ); break;

        // BG Fiend
        case 610:                                               sum_BG_SummonFiend( oCaster, lTarget );break;

        // Summon Creature I-IX
        case SPELL_SUMMON_CREATURE_I:                           sum_SummonCreature( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_SUMMON_CREATURE_II:                          sum_SummonCreature( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_SUMMON_CREATURE_III:                         sum_SummonCreature( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_SUMMON_CREATURE_IV:                          sum_SummonCreature( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_SUMMON_CREATURE_V:                           sum_SummonCreature( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_SUMMON_CREATURE_VI:                          sum_SummonCreature( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_SUMMON_CREATURE_VII:                         sum_SummonCreature( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_SUMMON_CREATURE_VIII:                        sum_SummonCreature( oCaster, nSpell, nCasterLevel, lTarget ); break;
        case SPELL_SUMMON_CREATURE_IX:                          sum_SummonCreature( oCaster, nSpell, nCasterLevel, lTarget ); break;

        default:{

            // Allow the original spellscripts to execute.
            SetExecutedScriptReturnValue( X2_EXECUTE_SCRIPT_CONTINUE );

            break;
        }
    }

    return;

}


//-------------------------------------------------------------------------------
int AllowedToCastEpicSpell( int nSpell, object oPC ){

    switch( nSpell ){

        //Hellball
        case 636:break;
        //Mummy Dust
        case 637:break;
        //Dragon Knight
        case 638:break;
        //Mage Armor
        case 639:break;
        //Ruin
        case 640:break;
        //Epicwarding
        case 695:break;

        default:return TRUE;
    }

    if( GetIsObjectValid( GetSpellCastItem( ) ) ){

        return TRUE;
    }
    int nClass  = GetCasterClass( oPC );

    int nAbility= -1;
    switch( nClass ){

        case CLASS_TYPE_CLERIC: nAbility = ABILITY_WISDOM;break;
        case CLASS_TYPE_DRUID: nAbility = ABILITY_WISDOM;break;
        case CLASS_TYPE_SORCERER: nAbility = ABILITY_CHARISMA;break;
        case CLASS_TYPE_WIZARD: nAbility = ABILITY_INTELLIGENCE;break;
        case CLASS_TYPE_BARD: nAbility = ABILITY_CHARISMA;break;
        default:return TRUE;
    }


    if( GetAbilityScore( oPC, nAbility, TRUE ) < 20 ){


        return FALSE;
    }

    return TRUE;
}

int GetCasterClass( object oPC ){

    int nLevel, nHigh, nClass, nLoop, nTemp;
    nHigh = -1;
    for( nLoop = 1; nLoop <= 3; nLoop++ ){

        nClass  = GetClassByPosition( nLoop, oPC );
        if( nClass == CLASS_TYPE_CLERIC     ||
            nClass == CLASS_TYPE_DRUID      ||
            nClass == CLASS_TYPE_SORCERER   ||
            nClass == CLASS_TYPE_WIZARD     ||
            nClass == CLASS_TYPE_BARD       ){

            nTemp = GetLevelByPosition( nLoop, oPC );
            if( nTemp > nLevel ){

                nLevel = nTemp;
                nHigh  = nClass;
            }
        }
    }
    return nHigh;
}
