// Item event script for Irraere's Feather.
//

#include "x2_inc_switches"

// A holy symbol appears at the target location followed by a persistant fog.
// All non-hostiles that enter the fog are restored.  Those remaining in the
// fog are healed 2d6 hit points per round.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );
    location lTarget = GetLocation( oPC );

    effect eAOE =   EffectAreaOfEffect(
                        AOE_PER_FOGMIND,
                        "aoe_irraerea",
                        "aoe_irraereb",
                        "****"
                    );
    int nDuration = 3;

    effect eImpact = EffectVisualEffect( VFX_FNF_WORD );
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
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
