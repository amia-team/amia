/*  Item :: Feat: Track : OnUse [Self]

    --------
    Verbatim
    --------
    This script will make a Lore check and reveal zone-based monster information.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082706  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"


/* Constants. */
const string MONSTER_PREFIX     = "monster";
const string BOSS_PREFIX        = "boss";


/* Prototypes. */

// Gets the monster's type as a readable string.
string GetMonsterType( object oMonster );


void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            location lOrigin    = GetLocation( oPC );
            object oArea        = GetArea( oPC );
            int nD20            = d20( );
            int nLoreSkillMod   = GetSkillRank( SKILL_LORE, oPC );
            string szResult     = "Failure";
            string szMonster    = "";
            int nCount          = 0;


            // Make a Wilderness check, roll must equal 20; or equal or exceed DC 25.
            if( nD20 == 20 || nD20 + nLoreSkillMod > 25 )
                szResult = "Success";

            FloatingTextStringOnCreature(
                "<c þ >[?] <c fþ>Wilderness (Lore) Skill Check *"               +
                szResult                                                        +
                "*</c> = D20: </c><cþ  >"                                       +
                IntToString( nD20 )                                             +
                "</c><c þ > + Modifier ( <cþ  > "                               +
                IntToString( nLoreSkillMod )                                    +
                "</c><c þ > ) = <cþ  >"                                         +
                IntToString( nD20 + nLoreSkillMod )                             +
                "</c><c þ > vs. DC <cþ  >25</c> [?]</c>",
                oPC,
                FALSE );


            // Failure, notify, bug out.
            if( szResult == "Failure" ){

                FloatingTextStringOnCreature(
                    "<c þ >- Tracking : <cþ  >You notice nothing that indicates the passing of any creature.</c> -</c>",
                    oPC,
                    FALSE );

                break;

            }


            // Iterate through spawn selection (if applicable).
            while( GetLocalString( oArea, MONSTER_PREFIX + IntToString( nCount ) ) != "" )
                nCount++;


            // Spawn present, randomly choose one, and display it for the player.
            if( nCount ){

                // Variables.
                float fDuration     = RoundsToSeconds( 2 );
                string szMonster    = "";

                // Random selection.
                nCount = Random( nCount );

                // 50% chance to get boss info.
                if( d100( ) <= 50 && GetLocalString( oArea, BOSS_PREFIX ) != "" )
                    szMonster = GetLocalString( oArea, BOSS_PREFIX );
                else
                    szMonster = GetLocalString( oArea, MONSTER_PREFIX + IntToString( nCount ) );


                // Display.
                object oMonster = CreateObject( OBJECT_TYPE_CREATURE, szMonster, lOrigin );

                // If it was plot before, unplot it.
                if( GetPlotFlag( oMonster ) )
                    SetPlotFlag( oMonster, FALSE );

                // Paralyze it.
                DelayCommand( 0.1,
                    ApplyEffectToObject(
                        DURATION_TYPE_PERMANENT,
                        SupernaturalEffect(
                            EffectLinkEffects(
                                EffectLinkEffects(
                                    EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION ),
                                    EffectCutsceneParalyze( ) ),
                                EffectVisualEffect( VFX_DUR_PARALYZE_HOLD ) ) ),
                        oMonster ) );

                // Make it invulnerable to attack.
                DelayCommand( 0.2, SetPlotFlag( oMonster, TRUE ) );

                // Despawn in 2 rounds.
                DestroyObject( oMonster, fDuration );

                // Notify the player.
                FloatingTextStringOnCreature(
                    "<c þ >- Tracking : <c fþ>You notice the markings of " + GetMonsterType( oMonster ) + " creature.</c> -</c>",
                    oPC,
                    FALSE );

            }
            // No spawn present, notify the player.
            else
                FloatingTextStringOnCreature(
                    "<c þ >- Tracking : <cþ  >You notice nothing that indicates the passing of any creature.</c> -</c>",
                    oPC,
                    FALSE );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}


/* Prototype Definitions. */

// Gets the monster's type as a readable string.
string GetMonsterType( object oMonster ){

    // Variables.
    int nRacialType     = GetRacialType( oMonster );

    // Get selection string.
    switch( nRacialType ){
        case RACIAL_TYPE_ABERRATION:                    return( "an aberration" );
        case RACIAL_TYPE_ANIMAL:                        return( "an animal" );
        case RACIAL_TYPE_BEAST:                         return( "a beast" );
        case RACIAL_TYPE_CONSTRUCT:                     return( "a construct" );
        case RACIAL_TYPE_DRAGON:                        return( "a dragon" );
        case RACIAL_TYPE_DWARF:                         return( "a dwarf" );
        case RACIAL_TYPE_ELEMENTAL:                     return( "an elemental" );
        case RACIAL_TYPE_ELF:                           return( "an elf" );
        case RACIAL_TYPE_FEY:                           return( "a fey" );
        case RACIAL_TYPE_GIANT:                         return( "a giant" );
        case RACIAL_TYPE_GNOME:                         return( "a gnome" );
        case RACIAL_TYPE_HALFELF:                       return( "a half-elf" );
        case RACIAL_TYPE_HALFLING:                      return( "a halfling" );
        case RACIAL_TYPE_HALFORC:                       return( "a half-orc" );
        case RACIAL_TYPE_HUMAN:                         return( "a human" );
        case RACIAL_TYPE_HUMANOID_GOBLINOID:            return( "a goblin" );
        case RACIAL_TYPE_HUMANOID_MONSTROUS:            return( "a montrous" );
        case RACIAL_TYPE_HUMANOID_ORC:                  return( "an orc" );
        case RACIAL_TYPE_HUMANOID_REPTILIAN:            return( "a reptilian" );
        case RACIAL_TYPE_MAGICAL_BEAST:                 return( "a magical beast" );
        case RACIAL_TYPE_OOZE:                          return( "an ooze" );
        case RACIAL_TYPE_OUTSIDER:                      return( "an outsider" );
        case RACIAL_TYPE_SHAPECHANGER:                  return( "a shapechanger" );
        case RACIAL_TYPE_UNDEAD:                        return( "an undead" );
        case RACIAL_TYPE_VERMIN:                        return( "a vermin" );
        default:                                        return( "an unknown" );
    }

    return( "unknown" );

}
