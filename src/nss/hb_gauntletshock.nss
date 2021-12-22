// OnHeartbeat event for the gauntlet shocker.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Initial Release.
//


// Cast chain lightning at the first PC we find in the kill zone.
//
void main()
{


    location lSelf = GetLocation( OBJECT_SELF );
    object oCreature = GetFirstObjectInShape( SHAPE_SPHERE, 6.5, lSelf );
    while ( GetIsObjectValid(oCreature) ) {
        if ( GetIsPC(oCreature) ) {
            ActionCastSpellAtObject(
                SPELL_CHAIN_LIGHTNING,
                oCreature,
                METAMAGIC_ANY,
                TRUE,
                0,
                PROJECTILE_PATH_TYPE_DEFAULT,
                TRUE
            );

            break;
        }

        oCreature = GetNextObjectInShape( SHAPE_SPHERE, 6.5, lSelf );
    }
}
