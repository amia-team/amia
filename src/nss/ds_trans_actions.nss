//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_actions
//group:   transmutation
//used as: action script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
string SetSpell( object oPC, int sSpell, int nOption, string sMessage );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC  = OBJECT_SELF;
    int nNode   = GetLocalInt( oPC, "ds_node" );
    int nSpell  = GetLocalInt( oPC, "ds_spell" );
    string sMessage;

    if ( !nSpell ){

        SetLocalInt( oPC, "ds_spell", nNode );
        return;
    }

    //reading
    AssignCommand( oPC, ActionPlayAnimation( ANIMATION_FIREFORGET_READ ) );

    //get convo node
    switch ( nSpell ) {

        case 0:     sMessage = "Error!"; break;

        //flame weapon
        case 1: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_FLAME_WEAPON, 1, "Flame Weapon: Damagetype set to Fire" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_FLAME_WEAPON, 2, "Flame Weapon: Damagetype set to Cold" );  break;
                case 3:     sMessage = SetSpell( oPC, SPELL_FLAME_WEAPON, 3, "Flame Weapon: Damagetype set to Electrical" );  break;
            }

            break;
        }

        //acid arrow
        case 2: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_MELFS_ACID_ARROW, 1, "Acid Arrow: Damagetype set to Acid" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_MELFS_ACID_ARROW, 2, "Acid Arrow: Damagetype set to Poison" );  break;
            }

            break;
        }

        //cone of cold
        case 3: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_CONE_OF_COLD, 1, "Cone of Cold: Damagetype set to Cold" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_CONE_OF_COLD, 2, "Cone of Cold: Damagetype set to Acid" );  break;
                case 3:     sMessage = SetSpell( oPC, SPELL_CONE_OF_COLD, 3, "Cone of Cold: Damagetype set to Electrical" );  break;
                case 4:     sMessage = SetSpell( oPC, SPELL_CONE_OF_COLD, 4, "Cone of Cold: Damagetype set to Fire" );  break;
            }

            break;
        }

        //Bless Weapon
        case 4: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_BLESS_WEAPON, 1, "Bless Weapon: Damagetype set to Divine" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_BLESS_WEAPON, 2, "Bless Weapon: Damagetype set to Positive" );  break;
            }

            break;
        }

        //Knock
        case 5: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_KNOCK, 1, "Knock: Opens Doors" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_KNOCK, 2, "Knock: Creates Lockpicks" );  break;
            }

            break;
        }

        //Fireball
        case 6: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_FIREBALL, 1, "Fireball: Damagetype set to Fire" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_FIREBALL, 2, "Fireball: Damagetype set to Acid" );  break;
            }

            break;
        }

        //Darkfire
        case 7: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_DARKFIRE, 1, "Darkfire: Damagetype set to Fire" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_DARKFIRE, 2, "Darkfire: Damagetype set to Cold" );  break;
                case 3:     sMessage = SetSpell( oPC, SPELL_DARKFIRE, 3, "Darkfire: Damagetype set to Electrical" );  break;
            }

            break;
        }

        //Ice Storm
        case 8: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_ICE_STORM, 1, "Ice Storm: Damagetype set to Bludgeoning" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_ICE_STORM, 2, "Ice Storm: Damagetype set to Piercing" );  break;
            }

            break;
        }

        //Call Lightning
        case 9: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_CALL_LIGHTNING, 1, "Call Lightning: Damagetype set to Electrical" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_CALL_LIGHTNING, 2, "Call Lightning: Damagetype set to Acid" );  break;
                case 3:     sMessage = SetSpell( oPC, SPELL_CALL_LIGHTNING, 3, "Call Lightning: Damagetype set to Cold" );  break;
                case 4:     sMessage = SetSpell( oPC, SPELL_CALL_LIGHTNING, 4, "Call Lightning: Damagetype set to Fire" );  break;
            }

            break;
        }

        //Greater Ruin
        case 10: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_EPIC_RUIN, 1, "Greater Ruin: Effective against Constructs (default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_EPIC_RUIN, 2, "Greater Ruin: Effective against Undead (default)" );  break;
            }

            break;
        }

        //Dirge
        case 11: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_DIRGE, 1, "Dirge: Drains STR/DEX (default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_DIRGE, 2, "Dirge: Drains INT/WIS" );  break;
                case 3:     sMessage = SetSpell( oPC, SPELL_DIRGE, 3, "Pulse Dirge: Drains STR/DEX" );  break;
                case 4:     sMessage = SetSpell( oPC, SPELL_DIRGE, 4, "Pulse Dirge: Drains INT/WIS" );  break;
            }

            break;
        }

        case 12: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_MESTILS_ACID_SHEATH, 1, "Acid Sheath: Acid Damage (default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_MESTILS_ACID_SHEATH, 2, "Acid Sheath: Cold Damage" );  break;
                case 3:     sMessage = SetSpell( oPC, SPELL_MESTILS_ACID_SHEATH, 3, "Acid Sheath: Fire Damage" );  break;
            }

            break;
        }

        case 13: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_CONTINUAL_FLAME, 1, "Continual Light: Continual Light (default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_CONTINUAL_FLAME, 2, "Continual Light: Area of effect" );  break;
            }

            break;
        }

        case 14: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_GREATER_MAGIC_WEAPON, 1, "Greater Magic Weapon: Target Melee Weapons (default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_GREATER_MAGIC_WEAPON, 2, "Greater Magic Weapon: Target Ranged Weapons" );  break;
            }

            break;
        }

        case 15: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_ETHEREALNESS, 1, "Greater sanctuary: Add invisibility keep strong summon. (default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_ETHEREALNESS, 2, "Greater sanctuary: Add Greater sanctuary effect, unsummon your summon and release your dominated creatures (if they're 23+)." );  break;
            }

            break;
        }

        case 16: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_GREAT_THUNDERCLAP, 1, "Great Thunderclap: Will for stun, fortitude for deafened and reflex for knockdown. (default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_GREAT_THUNDERCLAP, 2, "Great Thunderclap: damage 6d per casterlevel sonic and electrical damage capped to 10d6 for each making it 20d6 total damage. Will for half sonic. Evasion for half electrical damage" );  break;
            }

            break;
        }

        case 17: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_MAGIC_CIRCLE_AGAINST_GOOD, 1, "Circle Against Alignment: Circle Against Evil/Good (Default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_MAGIC_CIRCLE_AGAINST_GOOD, 2, "Circle Against Alignment: Circle Against Chaos/Law" );  break;
            }

            break;
        }

        case 18: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_WEIRD, 1, "Weird: Will and Fortitude vs mind and death. (Default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_WEIRD, 2, "Weird: Will vs fear and Fort vs d8 damage per casterlevel, capped at 20d8." );  break;
            }

            break;
        }

        case 19: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_LIGHT, 1, "Light: White (default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_LIGHT, 2, "Light: Green" );  break;
                case 3:     sMessage = SetSpell( oPC, SPELL_LIGHT, 3, "Light: Blue" );  break;
                case 4:     sMessage = SetSpell( oPC, SPELL_LIGHT, 4, "Light: Orange" );  break;
                case 5:     sMessage = SetSpell( oPC, SPELL_LIGHT, 5, "Light: Purple" );  break;
                case 6:     sMessage = SetSpell( oPC, SPELL_LIGHT, 6, "Light: Red" );  break;
                case 7:     sMessage = SetSpell( oPC, SPELL_LIGHT, 7, "Light: Yellow" );  break;
                case 8:     sMessage = SetSpell( oPC, SPELL_LIGHT, 8, "Light: Anti light" );  break;

            }

            break;
        }

        case 20: {

            switch ( nNode ) {

                case 1:     sMessage = SetSpell( oPC, SPELL_BULLS_STRENGTH, 1, "Ability: Single target: d4+1 bonus (default)" );  break;
                case 2:     sMessage = SetSpell( oPC, SPELL_BULLS_STRENGTH, 2, "Ability: AOE: +2 regardless of metamagic. Does not stack with itself or the non-bot variant" );  break;

            }

            break;
        }
        default:    sMessage = "Error!";    break;
    }

    //feedback
    SendMessageToPC( oPC, sMessage );
}

//just to make things a bit easier to read.
string SetSpell( object oPC, int nSpell, int nOption, string sMessage ){

    string sSpell = "ds_spell_"+IntToString( nSpell );

    SetLocalInt( oPC, sSpell, nOption );

    PlaySound("gui_dm_alert");

    return sMessage;
}
