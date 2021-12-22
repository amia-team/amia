// Item event script for bard lyrics.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/21/2004 jjjerm           Initial release.
//

#include "x2_inc_switches"


// Returns the ID of the spell that should be cast.
//
int GetLyricSpell( object oItem )
{
    string sResref = GetResRef( oItem );
    if ( sResref == "firesong" )
        return SPELL_INCENDIARY_CLOUD;
    else if ( sResref == "healingsong" )
        return SPELL_MASS_HEAL;
    else if ( sResref == "shadowsong" )
        return SPELL_SHADOW_SHIELD;
    else if ( sResref == "sightsong" )
        return SPELL_TRUE_SEEING;
    else if ( sResref == "stonesong" )
        return SPELL_GREATER_STONESKIN;
    else if ( sResref == "stormsong" )
        return SPELL_GREAT_THUNDERCLAP;
    else if ( sResref == "warsong" )
        return SPELL_BATTLETIDE;
    else if ( sResref == "alarmsong" )
        return SPELL_GLYPH_OF_WARDING;
    else if ( sResref == "icesong" )
        return SPELL_ICE_STORM;
    else if ( sResref == "sovsong" )
        return SPELL_STORM_OF_VENGEANCE;

    return SPELL_HORRID_WILTING;
}

// If the bard has any performs left, decrements a use and casts a spell.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    if ( !GetHasFeat(FEAT_BARD_SONGS, oPC) ) {
         SendMessageToPCByStrRef( oPC, 40063 );
        return;
    }

    if ( !GetIsObjectValid(oItem) ) {
        SendMessageToPC( oPC, "Item is invalid!" );
        return;
    }

    DecrementRemainingFeatUses( oPC, FEAT_BARD_SONGS );
    AssignCommand( oPC, PlaySound( "as_cv_flute2" ) );

    int nSpell = GetLyricSpell( oItem );

    AssignCommand(
        oPC,
        ActionCastSpellAtObject(
            nSpell,
            oPC,
            METAMAGIC_ANY,
            TRUE,
            0,
            PROJECTILE_PATH_TYPE_DEFAULT,
            TRUE
        )
    );
}


void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
