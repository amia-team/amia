/*  Dice Bag Roll pre. 1.67 Temporary until Convo Function Parameters are possible.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032006  kfw         Initial release
    022008  dg          Streamlined
    ----------------------------------------------------------------------------

    --------
    Verbatim
    --------
    Rolls a specific roll. This will all be changed once we can get function parms, woo!

*/

#include "inc_ds_info"



void main(){

    // Variables

    //this script is only called with ExecuteScript,
    //so it has the PC as OBJECT_SELF
    object oPC      = OBJECT_SELF;
    int nDie;
    int nMod;
    int nMod2;
    int nPCLevel;
    int nBAB;
    int nStrMod;
    int nDexMod;
    int nAC;
    int nSizeMod;
    string sMessage;

    //the nodes are set by the action scripts
    //at the start of a convo all nodes should be empty
    //you can do this by calling ds_actions_clean early in the convo
    int nNode       = GetLocalInt( oPC, "ds_node" );

    //
    if ( nNode < 10 ){

        //
        SetLocalInt( oPC, "dice_first_tier", nNode );
        return;
    }
    else if( nNode > 10 ){

        int nTier = GetLocalInt( oPC, "dice_first_tier");
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if( nTier == 1 ){
//1.11--------------------------------------------------------------------------------
//Roll D2
            if( nNode == 11 ){

                nDie    = d2( );

                // Roll dice
                AssignCommand(
                    oPC,
                    ActionSpeakString( "<c � >[?] <c f�>D2</c> = </c><c�  >" +
                    IntToString( nDie ) + "</c><c � > [?]</c>" ));

                return;
            }
//1.12--------------------------------------------------------------------------------
//Roll D3
            if( nNode == 12 ){

                nDie    = d3( );

                // Roll dice
                AssignCommand(
                    oPC,
                    ActionSpeakString( "<c � >[?] <c f�>D3</c> = </c><c�  >" +
                    IntToString( nDie ) + "</c><c � > [?]</c>" ));

                return;
            }
//1.13--------------------------------------------------------------------------------
//Roll D4
            if( nNode == 13 ){

                nDie    = d4( );

                // Roll dice
                AssignCommand(
                    oPC,
                    ActionSpeakString( "<c � >[?] <c f�>D4</c> = </c><c�  >" +
                    IntToString( nDie ) + "</c><c � > [?]</c>" ));

                return;
            }

//1.14--------------------------------------------------------------------------------
//Roll D6
            if( nNode == 14 ){
                nDie    = d6( );

                // Roll dice
                AssignCommand(
                    oPC,
                    ActionSpeakString( "<c � >[?] <c f�>D6</c> = </c><c�  >" +
                    IntToString( nDie ) + "</c><c � > [?]</c>" ));

                return;
            }
//1.15--------------------------------------------------------------------------------
//Roll D8
            if( nNode == 15 ){
                nDie    = d8( );

                // Roll dice
                AssignCommand(
                    oPC,
                    ActionSpeakString( "<c � >[?] <c f�>D8</c> = </c><c�  >" +
                    IntToString( nDie ) + "</c><c � > [?]</c>" ));

                return;
            }
//1.16--------------------------------------------------------------------------------
//Roll D10
            if( nNode == 16 ){
                nDie    = d10( );

                // Roll dice
                AssignCommand(
                    oPC,
                    ActionSpeakString( "<c � >[?] <c f�>D10</c> = </c><c�  >" +
                    IntToString( nDie ) + "</c><c � > [?]</c>" ));

                return;
            }

//1.17--------------------------------------------------------------------------------
//Roll D12
            if( nNode == 17 ){
                nDie    = d12( );

                // Roll dice
                AssignCommand(
                    oPC,
                    ActionSpeakString( "<c � >[?] <c f�>D12</c> = </c><c�  >" +
                    IntToString( nDie ) + "</c><c � > [?]</c>" ));

                return;
            }
//1.18--------------------------------------------------------------------------------
//Roll D20
            if( nNode == 18 ){

            nDie    = d20( );

                // Roll dice
                AssignCommand(
                    oPC,
                    ActionSpeakString( "<c � >[?] <c f�>D20</c> = </c><c�  >" +
                    IntToString( nDie ) + "</c><c � > [?]</c>" ));

                return;
            }
//1.19--------------------------------------------------------------------------------
//Roll Percentile (D100)

            if( nNode == 19 ){

                nDie    = d100( );

                // Roll dice
                AssignCommand(
                oPC,
                ActionSpeakString( "<c � >[?] <c f�>Percentile Dice: D100</c> = </c><c�  >" +
                IntToString( nDie ) + "</c><c � > [?]</c>" ));

                return;
            }
        }//End of Tier 1
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if( nTier == 2 ){
//2.11--------------------------------------------------------------------------------
//Roll Fortitude Save

            if( nNode == 11 ){

                nDie    = d20( );
                nMod    = GetFortitudeSavingThrow( oPC );

                // Roll dice
                AssignCommand(
                oPC,
        ActionSpeakString( "<c � >[?] <c f�>Fortitude Saving Throw</c> = D20: </c><c�  >" +
                IntToString( nDie ) +
                "</c><c � > + Modifier ( <c�  > " +
                IntToString( nMod ) +
                "</c><c � > ) = <c�  >" +
                IntToString( nDie + nMod ) +
                "</c><c � > [?]</c>" ));

                return;

            }
//2.12--------------------------------------------------------------------------------
//Roll Reflex Save

            if( nNode == 12 ){

                nDie    = d20( );
                nMod    = GetReflexSavingThrow( oPC );

                // Roll dice
                AssignCommand(
                oPC,
        ActionSpeakString( "<c � >[?] <c f�>Reflex Saving Throw</c> = D20: </c><c�  >" +
                IntToString( nDie ) +
                "</c><c � > + Modifier ( <c�  > " +
                IntToString( nMod ) +
                "</c><c � > ) = <c�  >" +
                IntToString( nDie + nMod ) +
                "</c><c � > [?]</c>" ));

                return;
            }
//2.13--------------------------------------------------------------------------------
//Roll Will Save

            if( nNode == 13 ){

                nDie    = d20( );
                nMod    = GetWillSavingThrow( oPC );

                // Roll dice
                AssignCommand(
                oPC,
        ActionSpeakString( "<c � >[?] <c f�>Will Saving Throw</c> = D20: </c><c�  >" +
                IntToString( nDie ) +
                "</c><c � > + Modifier ( <c�  > " +
                IntToString( nMod ) +
                "</c><c � > ) = <c�  >" +
                IntToString( nDie + nMod ) +
                "</c><c � > [?]</c>" ));

                return;
            }
        }//End of Tier 2
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if( nTier == 3 ){
//3.11--------------------------------------------------------------------------------
//Roll STR Check

            if( nNode == 11 ){

                nDie    = d20( );
                nMod    = GetAbilityModifier( ABILITY_STRENGTH, oPC );

                // Roll dice
                AssignCommand(
                oPC,
        ActionSpeakString( "<c � >[?] <c f�>Strength Check</c> = D20: </c><c�  >" +
                IntToString( nDie ) +
                "</c><c � > + Modifier ( <c�  > " +
                IntToString( nMod ) +
                "</c><c � > ) = <c�  >" +
                IntToString( nDie + nMod ) +
                "</c><c � > [?]</c>" ));

                return;

            }

//3.12--------------------------------------------------------------------------------
//Roll DEX Check

            if( nNode == 12 ){
                nDie    = d20( );
                nMod    = GetAbilityModifier( ABILITY_DEXTERITY, oPC );

                // Roll dice
                AssignCommand(
                oPC,
        ActionSpeakString( "<c � >[?] <c f�>Dexterity Check</c> = D20: </c><c�  >" +
                IntToString( nDie ) +
                "</c><c � > + Modifier ( <c�  > " +
                IntToString( nMod ) +
                "</c><c � > ) = <c�  >" +
                IntToString( nDie + nMod ) +
                "</c><c � > [?]</c>" ));

                return;
            }

//3.13--------------------------------------------------------------------------------
//Roll CON Check
            if( nNode == 13 ){
                nDie    = d20( );
                nMod    = GetAbilityModifier( ABILITY_CONSTITUTION, oPC );

                // Roll dice
                AssignCommand(
                oPC,
        ActionSpeakString( "<c � >[?] <c f�>Constitution Check</c> = D20: </c><c�  >" +
                IntToString( nDie ) +
                "</c><c � > + Modifier ( <c�  > " +
                IntToString( nMod ) +
                "</c><c � > ) = <c�  >" +
                IntToString( nDie + nMod ) +
                "</c><c � > [?]</c>" ));

            return;

        }

//3.14--------------------------------------------------------------------------------
//Roll WIS Check
            if( nNode == 14 ){
                nDie    = d20( );
                nMod    = GetAbilityModifier( ABILITY_WISDOM, oPC );

                // Roll dice
                AssignCommand(
                oPC,
        ActionSpeakString( "<c � >[?] <c f�>Wisdom Check</c> = D20: </c><c�  >" +
                IntToString( nDie ) +
                "</c><c � > + Modifier ( <c�  > " +
                IntToString( nMod ) +
                "</c><c � > ) = <c�  >" +
                IntToString( nDie + nMod ) +
                "</c><c � > [?]</c>" ));

                return;

            }

//3.15--------------------------------------------------------------------------------
//Roll INT Check
            if( nNode == 15 ){

                nDie    = d20( );
                nMod    = GetAbilityModifier( ABILITY_INTELLIGENCE, oPC );

                // Roll dice
                AssignCommand(
                oPC,
        ActionSpeakString( "<c � >[?] <c f�>Intelligence Check</c> = D20: </c><c�  >" +
                IntToString( nDie ) +
                "</c><c � > + Modifier ( <c�  > " +
                IntToString( nMod ) +
                "</c><c � > ) = <c�  >" +
                IntToString( nDie + nMod ) +
                "</c><c � > [?]</c>" ));

                return;

            }

//3.16--------------------------------------------------------------------------------
//Roll CHA Check
            if( nNode == 16 ){
                nDie    = d20( );
                nMod    = GetAbilityModifier( ABILITY_CHARISMA, oPC );

                // Roll dice
                AssignCommand(
                oPC,
        ActionSpeakString( "<c � >[?] <c f�>Charisma Check</c> = D20: </c><c�  >" +
                IntToString( nDie ) +
                "</c><c � > + Modifier ( <c�  > " +
                IntToString( nMod ) +
                "</c><c � > ) = <c�  >" +
                IntToString( nDie + nMod ) +
                "</c><c � > [?]</c>" ));

                return;
            }

        }//End of Tier 3

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if( nTier == 8 ){
//8.11--------------------------------------------------------------------------------
//Roll Animal Empathy Check

            if( nNode == 11 ){
nDie            = d20( );
nMod            = GetSkillRank( SKILL_ANIMAL_EMPATHY, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Animal Empathy Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }
//8.12--------------------------------------------------------------------------------
//Roll Appraise Check
            if( nNode == 12 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_APPRAISE, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Appraise Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;
            }
//8.13--------------------------------------------------------------------------------
//Roll Bluff Check
            if( nNode == 13 ){
nDie            = d20( );
nMod            = GetSkillRank( SKILL_BLUFF, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Bluff Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;
            }
//8.14--------------------------------------------------------------------------------
//Roll Concentration Check
            if( nNode == 14 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_CONCENTRATION, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Concentration Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;
            }
//8.15--------------------------------------------------------------------------------
//Roll Craft Armor Check
            if( nNode == 15 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_CRAFT_ARMOR, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Craft Armor Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;
            }
//8.16--------------------------------------------------------------------------------
//Roll Craft Trap Check
            if( nNode == 16 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_CRAFT_TRAP, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Craft Trap Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;

            }
//8.17--------------------------------------------------------------------------------
//Roll Craft Weapon Check

            if( nNode == 17 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_CRAFT_WEAPON, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Craft Weapon Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;
            }

//8.18--------------------------------------------------------------------------------
//Roll Disable Trap Check

            if( nNode == 18 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_DISABLE_TRAP, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Disable Trap Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }
//8.19--------------------------------------------------------------------------------
//Roll Discipline Check

            if( nNode == 19 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_DISCIPLINE, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Discipline Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }

//8.20--------------------------------------------------------------------------------
//Roll Heal Check

            if( nNode == 20 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_HEAL, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Heal Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;
            }

//8.21--------------------------------------------------------------------------------
//Roll Hide Check

            if( nNode == 21 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_HIDE, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Hide Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;
            }

//8.22--------------------------------------------------------------------------------
//Roll Intimdate Check

            if( nNode == 22 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_INTIMIDATE, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Intimidate Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }

//8.23--------------------------------------------------------------------------------
//Roll Listen Check

            if( nNode == 23 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_LISTEN, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Listen Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }

//8.24--------------------------------------------------------------------------------
//Roll Lore Check

            if( nNode == 24 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_LORE, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Lore Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;

            }

//8.25--------------------------------------------------------------------------------
//Roll Move Silently Check

            if( nNode == 25 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_MOVE_SILENTLY, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Move Silently Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;

            }
        }//End of Tier 8 (Sub Tier for Skills)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if( nTier == 9 ){
//9.11--------------------------------------------------------------------------------
//Roll Open Lock Check

            if( nNode == 11 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_OPEN_LOCK, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Open Lock Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;

            }

//9.12--------------------------------------------------------------------------------
//Roll Parry Check

            if( nNode == 12 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_PARRY, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Parry Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }

//9.13--------------------------------------------------------------------------------
//Roll Perform Check

            if( nNode == 13 ){


nDie            = d20( );
nMod            = GetSkillRank( SKILL_PERFORM, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Perform Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }

//9.14--------------------------------------------------------------------------------
//Roll Persuade Check

            if( nNode == 14 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_PERSUADE, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Persuade Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }

//9.15--------------------------------------------------------------------------------
//Roll Pick Pocket

            if( nNode == 15 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_PICK_POCKET, oPC );
//Fix for -50 on pickpocket dice rolls
if ( nMod != 0 ){

    nMod       += 50;

}
// N.B. we add 50 here because as standard, PCs get a -50 modifier to this skill
// If this changes in the future, comment out or remove the above lines.

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Pick Pocket Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }

//9.16--------------------------------------------------------------------------------
//Roll Search Check

            if( nNode == 16 ){


nDie            = d20( );
nMod            = GetSkillRank( SKILL_SEARCH, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Search Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }

//9.17--------------------------------------------------------------------------------
//Roll Set Trap Check

            if( nNode == 17 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_SET_TRAP, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Set Trap Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }
//9.18--------------------------------------------------------------------------------
//Roll Spellcraft Check

            if( nNode == 18 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_SPELLCRAFT, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Spellcraft Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;

        }

//9.19--------------------------------------------------------------------------------
//Roll Spot Check

            if( nNode == 19 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_SPOT, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Spot Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

    return;

            }

//9.20--------------------------------------------------------------------------------
//Roll Taunt Check

            if( nNode == 20 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_TAUNT, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Taunt Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;
            }

//9.21--------------------------------------------------------------------------------
//Roll Tumble Check

            if( nNode == 21 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_TUMBLE, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Tumble Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;
            }

//9.22--------------------------------------------------------------------------------
//Roll Use Magic Device Check

            if( nNode == 22 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_USE_MAGIC_DEVICE, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Use Magic Device Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;

            }

        }//End of Tier 9 (Sub Tier for Skills)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if( nTier == 5 ){
//5.11--------------------------------------------------------------------------------
//Counter Bluff Listen

            if( nNode == 11 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_LISTEN, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Listen Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;

            }

//5.12--------------------------------------------------------------------------------
//Counter Bluff Spot

            if( nNode == 12 ){

nDie            = d20( );
nMod            = GetSkillRank( SKILL_SPOT, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Spot Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;
            }

//5.13--------------------------------------------------------------------------------
//Counter Intimidate (3.0 rules)

            if( nNode == 13 ){

nDie        = d20( );
nMod        = GetHitDice( oPC );
nMod2       = GetAbilityModifier( ABILITY_WISDOM, oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Counter Intimidate Skill Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Character Level ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) + Wisdom modifier ( <c�  > " +
                        IntToString( nMod2 ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod + nMod2 ) +
                        "</c><c � > [?]</c>" )
                );

  return;

            }

//5.14--------------------------------------------------------------------------------
//Initiative Roll

            if( nNode == 14 ){

nDie        = d20( );
nMod        = GetAbilityModifier( ABILITY_DEXTERITY, oPC );
int nFeat   = 0;


                if( GetHasFeat( FEAT_IMPROVED_INITIATIVE, oPC )){

                    nFeat = 4;

                }

                if( GetHasFeat( FEAT_EPIC_SUPERIOR_INITIATIVE, oPC )){

                    nFeat = 8;

                }

                if( GetHasFeat( FEAT_THUG, oPC )){

                    nFeat += 2;

                }

                if( GetHasFeat( FEAT_BLOODED, oPC )){

                    nFeat += 2;

                }

    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Initiative</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Dexterity Modifier ( <c�  > " +
                        IntToString( nMod ) +
                        "</c><c � > ) + Feat Bonus ( <c�  > " +
                        IntToString( nFeat ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nMod + nFeat ) +
                        "</c><c � > [?]</c>" ));
   return;

            }

//5.15--------------------------------------------------------------------------------
//Rolling a STR Touch Attack


            if( nNode == 15 ){

                nDie            = d20( );
                nBAB            = GetBaseAttackBonus( oPC );
                nStrMod         = GetAbilityModifier( ABILITY_STRENGTH, oPC );
                nSizeMod        = 0;

                switch( GetCreatureSize( oPC ) ){

                    case CREATURE_SIZE_TINY:    nSizeMod = 2; break;
                    case CREATURE_SIZE_SMALL:   nSizeMod = 1; break;
                    case CREATURE_SIZE_LARGE:   nSizeMod = -1; break;
                    case CREATURE_SIZE_HUGE:    nSizeMod = -2; break;
                    default:                    break;

                }

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Strength Touch Attack</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Base Attack Bonus ( <c�  > " +
                        IntToString( nBAB ) +
                        "</c><c � > ) + Strength Modifier ( <c�  > " +
                        IntToString( nStrMod ) +
                        "</c><c � > ) + Size Modifier ( <c�  > " +
                        IntToString( nSizeMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nBAB + nStrMod + nSizeMod ) +
                        "</c><c � > [?]</c>" )
                );

                return;

            }

//5.16--------------------------------------------------------------------------------
//Rolling a DEX Touch Attack

            if( nNode == 16 ){

                nDie        = d20( );
                nBAB        = GetBaseAttackBonus( oPC );
                nDexMod     = GetAbilityModifier( ABILITY_DEXTERITY, oPC );
                nSizeMod    = 0;

                switch( GetCreatureSize( oPC ) ){

                    case CREATURE_SIZE_TINY:    nSizeMod = 2; break;
                    case CREATURE_SIZE_SMALL:   nSizeMod = 1; break;
                    case CREATURE_SIZE_LARGE:   nSizeMod = -1; break;
                    case CREATURE_SIZE_HUGE:    nSizeMod = -2; break;
                    default:                    break;

                }

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Dexterity Touch Attack</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Base Attack Bonus ( <c�  > " +
                        IntToString( nBAB ) +
                        "</c><c � > ) + Dexterity Modifier ( <c�  > " +
                        IntToString( nDexMod ) +
                        "</c><c � > ) + Size Modifier ( <c�  > " +
                        IntToString( nSizeMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nBAB + nDexMod + nSizeMod ) +
                        "</c><c � > [?]</c>" )
                );

                return;

            }

//5.17--------------------------------------------------------------------------------
//Rolling a WIS Touch Attack

            if( nNode == 17 ){

                nDie        = d20( );
                nBAB        = GetBaseAttackBonus( oPC );
                int nWisMod = GetAbilityModifier( ABILITY_WISDOM, oPC );
                nSizeMod    = 0;

                switch( GetCreatureSize( oPC ) ){

                    case CREATURE_SIZE_TINY:    nSizeMod = 2; break;
                    case CREATURE_SIZE_SMALL:   nSizeMod = 1; break;
                    case CREATURE_SIZE_LARGE:   nSizeMod = -1; break;
                    case CREATURE_SIZE_HUGE:    nSizeMod = -2; break;
                    default:                    break;

                }

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Wisdom Touch Attack</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Base Attack Bonus ( <c�  > " +
                        IntToString( nBAB ) +
                        "</c><c � > ) + Wisdom Modifier ( <c�  > " +
                        IntToString( nWisMod ) +
                        "</c><c � > ) + Size Modifier ( <c�  > " +
                        IntToString( nSizeMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nBAB + nWisMod + nSizeMod ) +
                        "</c><c � > [?]</c>" )
                );

                return;

            }

//5.18--------------------------------------------------------------------------------
//Report Touch Attack AC

            if( nNode == 18 ){

// object oBracers  = ( GetItemInSlot( INVENTORY_SLOT_ARMS, oPC ));
//Arm items are sometimes deflection and sometimes armor bonus

//Getting the various armors that we will subtract from the whole AC
            object oArmor   = ( GetItemInSlot( INVENTORY_SLOT_CHEST, oPC ));
            object oNeck    = ( GetItemInSlot( INVENTORY_SLOT_NECK, oPC ));
            object oShield  = ( GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC ));

// Get the AC value
            int nArmorAC    = GetItemACValue( oArmor );
            int nNeckAC     = GetItemACValue( oNeck );
            int nShieldAC    = GetItemACValue( oShield );
            int nAddedArmor = nArmorAC + nNeckAC + nShieldAC;

            int nAC = GetAC( oPC ) - nAddedArmor;



            //int nNatural = 0;

//Unsure whether to check for these or not.
//GetHasSpellEffect( SPELL_MAGE_ARMOR, oPC )
//GetHasSpellEffect( SPELL_EPIC_MAGE_ARMOR, oPC )


//This next block removes the Dragon Armor Bonus from the AC as it is natural
//and is not included in a touch attack

                if( GetHasFeat( FEAT_DRAGON_ARMOR, oPC )){

                    if( GetLevelByClass( FEAT_EPIC_RED_DRAGON_DISC, oPC ) < 8 ){

                        nAC = nAC - 1;

                    }

                    if( GetLevelByClass( FEAT_EPIC_RED_DRAGON_DISC, oPC ) > 7 &&
                        GetLevelByClass( FEAT_EPIC_RED_DRAGON_DISC, oPC ) < 15 ){

                        nAC = nAC - 2;

                    }

                    if( GetLevelByClass( FEAT_EPIC_RED_DRAGON_DISC, oPC ) > 14 &&
                        GetLevelByClass( FEAT_EPIC_RED_DRAGON_DISC, oPC ) < 20 ){

                        nAC = nAC - 3;

                    }

                    if( GetLevelByClass( FEAT_EPIC_RED_DRAGON_DISC, oPC ) > 19 ){

                        nAC = nAC - 4;

                    }

                }


                if( GetHasFeat( FEAT_EPIC_ARMOR_SKIN , oPC ) == TRUE ){

                    nAC = nAC - 2;

                    }

                if( GetHasFeat( FEAT_DODGE, oPC ) == 1 ){

                    nAC = nAC + 1;

                    }

    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] My Touch Attack AC is: </c><c�  >" +
                        IntToString( nAC ) + "</c><c � > [?]</c>" )
                );

   return;

            }

//5.19--------------------------------------------------------------------------------
//Roll Grapple Check

            if( nNode == 19 ){

nDie        = d20( );
nBAB        = GetBaseAttackBonus( oPC );
nStrMod     = GetAbilityModifier( ABILITY_STRENGTH, oPC );
nSizeMod    = 0;

    switch( GetCreatureSize( oPC ) ){

        case CREATURE_SIZE_TINY:    nSizeMod = -8; break;
        case CREATURE_SIZE_SMALL:   nSizeMod = -4; break;
        case CREATURE_SIZE_LARGE:   nSizeMod = 4; break;
        case CREATURE_SIZE_HUGE:    nSizeMod = 8; break;
        default:                    break;

    }

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] <c f�>Grapple Check</c> = D20: </c><c�  >" +
                        IntToString( nDie ) +
                        "</c><c � > + Base Attack Bonus ( <c�  > " +
                        IntToString( nBAB ) +
                        "</c><c � > ) + Strength Modifier ( <c�  > " +
                        IntToString( nStrMod ) +
                        "</c><c � > ) + Size Modifier ( <c�  > " +
                        IntToString( nSizeMod ) +
                        "</c><c � > ) = <c�  >" +
                        IntToString( nDie + nBAB + nStrMod + nSizeMod ) +
                        "</c><c � > [?]</c>" )
                );

   return;

            }

//5.20--------------------------------------------------------------------------------
//Report Flat-footed AC

            if( nNode == 20 ){

nDexMod = GetAbilityModifier( ABILITY_DEXTERITY, oPC );
nAC = GetAC( oPC );

    if( GetHasFeat( FEAT_UNCANNY_DODGE_1, oPC ) ||
        GetHasFeat( FEAT_UNCANNY_DODGE_2, oPC ) ||
        GetHasFeat( FEAT_UNCANNY_DODGE_3, oPC ) ||
        GetHasFeat( FEAT_UNCANNY_DODGE_4, oPC ) ||
        GetHasFeat( FEAT_UNCANNY_DODGE_5, oPC ) ||
        GetHasFeat( FEAT_UNCANNY_DODGE_6, oPC ) ){

            nAC = GetAC( oPC );

        }

    else if( nDexMod >= 0 ){

            nAC = GetAC( oPC ) - nDexMod;

        }


    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] My Flat-footed AC is: </c><c�  >" +
                        IntToString( nAC ) +
                        "</c><c � > [?]</c>" )
                );

   return;

            }
//5.21--------------------------------------------------------------------------------
//Report regular AC

            if( nNode == 21 ){

nAC = GetAC( oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] My Armor Class is: </c><c�  >" +
                        IntToString( nAC ) +
                        "</c><c � > [?]</c>" )
                );

  return;

            }

//5.22--------------------------------------------------------------------------------
//Report Alignment

            if( nNode == 22 ){

                sMessage = GetAlignmentName( GetAlignmentLawChaos( oPC ) )+GetAlignmentName( GetAlignmentGoodEvil( oPC ) );
                sMessage = "<c � >[?] My alignment is: </c><c�  >" + sMessage + "</c><c � > [?]</c>";

                AssignCommand( oPC, ActionSpeakString( sMessage ) );

                return;
            }

//5.23--------------------------------------------------------------------------------
//Report Character Level

            if( nNode == 23 ){

nPCLevel = GetHitDice( oPC );

    // Roll dice
    AssignCommand(
        oPC,
        ActionSpeakString( "<c � >[?] My character level is: </c><c�  >" +
                        IntToString( nPCLevel ) +
                        "</c><c � > [?]</c>" )
                );

   return;
            }
        }//End if Tier 5
//------------------------------------------------------------------------------

    }//End of Node Checks
}


