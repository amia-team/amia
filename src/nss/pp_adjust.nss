//////////////////////////////////////////////////////////////////////////
// Pickpocket Replacement Package
// by James E. King, III (jking@prospeed.net) - MagnumMan
//////////////////////////////////////////////////////////////////////////
//
// ChangeLog
// YYYYMMDD WHO Notes
// -------- --- ----------------------------------------------------------
// 20050528 JEK Initial Release
// 20051226 kfw Disabled VFX removal, Players can only lose PP ranks by Rebuilding, DMs must check the PP status then.
// 20050520 kfw Optimized for greater effect precision.
// 20071222 disco merged into three files
//////////////////////////////////////////////////////////////////////////

//
// We do this in a separate script so that the supernatural effect
// to decrease the pickpocket skill returns that it was created by this
// player.  Then when we're scanning to remove it we can check to see
// if it is a supernatural effect that was created by PC.  This should
// interfere less with subrace implementations like ALFA.
//
// BioWare didn't make it so you could query the skill that an EffectSkillDecrease
// type effect affects... which kinda sucks!
//

#include "pp_utils"

void main( ){

    // Variables.
    object oPC          = OBJECT_SELF;
    object oModule      = GetModule( );

    // Bard, Rogue, Assassin, Shadowdancer, Harper Scout can all pickpocket,
    // no other classes can.  So if anyone has at least one level in any of
    // these classes then they need their Pickpocket skill to be nerfed and
    // they need the pickpocket tool.

    if( PP_HighestClassLevel( oPC ) ){

        // Pickpocket penalty.
        effect eDisablePick = EffectSkillDecrease(SKILL_PICK_POCKET, PP_SKILL_DIFFERENCE);
               eDisablePick = SupernaturalEffect (eDisablePick);

        // Iterate player's current effects and apply if penalty doesn't exist.
        effect eEffect = GetFirstEffect( oPC );

        while( GetIsEffectValid( eEffect ) ){

            // System penalty effect, don't apply again.
            if( GetEffectType( eEffect ) == EFFECT_TYPE_SKILL_DECREASE  &&
                GetEffectCreator( eEffect) == oModule                   )
                return;

            eEffect = GetNextEffect( oPC );

        }

        // Pickpocket penalties doesn't exist, apply them.
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eDisablePick, oPC );

        // Pickpocket tool doesn't exist, issue it.
        if( !GetIsObjectValid( GetItemPossessedBy( oPC, PP_TOOL_TAG ) ) )
            CreateItemOnObject( PP_TOOL_RESREF, oPC );

        // Log the pickpocket adjustments.
        PP_Debug( "Pickpocket", GetName(oPC) + " has been adjusted for having pickpocket skills." );

    }

    return;

}
