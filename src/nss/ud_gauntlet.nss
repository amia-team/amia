// User-defined events for the Guantlet of Terror area.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Initial Release.
// 01/30/2004 jpavelch         Added trigger spawn user-defined functions.
// 20050130   jking            Hooked standard handler.
//

#include "area_constants"

// Sets up the spells used by each mini-globe.  There are three sets of globes
// and each globe with the same tag casts the same spell.
//
void InitTraps( )
{
    int i;
    for ( i=0; i<3; ++i ) {
        SetLocalInt( GetObjectByTag("MiniGlobeTrap_0", i), "MySpell", SPELL_ISAACS_GREATER_MISSILE_STORM );
        SetLocalInt( GetObjectByTag("MiniGlobeTrap_1", i), "MySpell", SPELL_HORRID_WILTING );
        SetLocalInt( GetObjectByTag("MiniGlobeTrap_2", i), "MySpell", SPELL_FIREBALL );
        SetLocalInt( GetObjectByTag("MiniGlobeTrap_3", i), "MySpell", SPELL_BIGBYS_GRASPING_HAND );
        SetLocalInt( GetObjectByTag("MiniGlobeTrap_4", i), "MySpell", SPELL_CHAIN_LIGHTNING );
        SetLocalInt( GetObjectByTag("MiniGlobeTrap_5", i), "MySpell", SPELL_MELFS_ACID_ARROW );
        SetLocalInt( GetObjectByTag("MiniGlobeTrap_6", i), "MySpell", SPELL_ISAACS_LESSER_MISSILE_STORM );
        SetLocalInt( GetObjectByTag("MiniGlobeTrap_7", i), "MySpell", SPELL_HORRID_WILTING );
    }
}

void main( )
{
    int nEvent = GetUserDefinedEventNumber( );
    switch ( nEvent ) {
        case INITIALIZE: InitTraps( );               break;
    }
}
