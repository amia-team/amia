// OnHeartbeat event for the gauntlet trap controllers.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 08/26/2003 jpavelch         Initial Release.
//

// heartbeat for master trap control

void main(){

    location lSelf   = GetLocation( OBJECT_SELF );
    object oCreature = GetFirstObjectInShape( SHAPE_SPHERE, 15.0, lSelf );
    object oTrap;
    string sTag;
    int nSpell;
    int nTrap;

    while ( GetIsObjectValid(oCreature) ) {

        if ( ( GetIsPC(oCreature) || GetIsPC( GetMaster( oCreature ) ) ) && !GetIsDead( oCreature ) ) {

            nTrap = Random( 8 );
            sTag  =  "MiniGlobeTrap_" + IntToString( nTrap );
            oTrap = GetNearestObjectByTag( sTag, oCreature );

            if (      sTag == "MiniGlobeTrap_0" ) { nSpell = SPELL_ISAACS_GREATER_MISSILE_STORM; }
            else if ( sTag == "MiniGlobeTrap_1" ) { nSpell = SPELL_HORRID_WILTING; }
            else if ( sTag == "MiniGlobeTrap_2" ) { nSpell = SPELL_FIREBALL; }
            else if ( sTag == "MiniGlobeTrap_3" ) { nSpell = SPELL_BIGBYS_GRASPING_HAND; }
            else if ( sTag == "MiniGlobeTrap_4" ) { nSpell = SPELL_CHAIN_LIGHTNING; }
            else if ( sTag == "MiniGlobeTrap_5" ) { nSpell = SPELL_MELFS_ACID_ARROW; }
            else if ( sTag == "MiniGlobeTrap_6" ) { nSpell = SPELL_ISAACS_LESSER_MISSILE_STORM; }
            else if ( sTag == "MiniGlobeTrap_7" ) { nSpell = SPELL_HORRID_WILTING; }

            AssignCommand( oTrap, ActionCastSpellAtObject( nSpell, oCreature, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE ) );
        }

        oCreature = GetNextObjectInShape( SHAPE_SPHERE, 15.0, lSelf );
    }
}
