// Natural Camouflage
//
// The widget applies barkskin or stoneskin VFX to creatures or objects.
// A second use on an affected creature or object removes the effect.  Using
// the widget on the ground toggles between bark and stone VFX.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/06/2012 Mathias          Initial release.
//
//
#include "x2_inc_switches"
#include "inc_ds_records"

void ActivateItem( ) {

    // Variables.
    object      oTarget     = GetItemActivatedTarget();
    object      oPC         = GetItemActivator();
    object      oWidget     = GetItemActivated();
    location    lTarget     = GetLocation( oTarget );
    effect      eBark       = EffectVisualEffect( VFX_DUR_PROT_BARKSKIN );
    effect      eStone      = EffectVisualEffect( VFX_DUR_PROT_STONESKIN );
    effect      eEffects    = GetFirstEffect( oTarget );
    effect      eActiveVFX;
    int         bActive     = 0;

    // Checks if the target has active effects from the widget.
    while( GetIsEffectValid( eEffects ) ){

        // Find extraordinary visual effects.
        if ( ( GetEffectSubType( eEffects ) == SUBTYPE_EXTRAORDINARY ) && ( GetEffectType( eEffects ) == EFFECT_TYPE_VISUALEFFECT ) ) {

            // Save the effect.
            eActiveVFX  = eEffects;
            bActive     = 1;
        }
        eEffects = GetNextEffect( oTarget );
    }

    // Checks if effect is already active
    if (bActive) {

        // Removes it if so.
        RemoveEffect( oTarget, eActiveVFX );

    // If not active, start the effect.
    } else {

        // Checks to see if the target is an object.
        if ( GetIsObjectValid( oTarget ) ) {

            // Checks to see if the widget is set to bark mode.
            if ( GetName( oWidget ) == "Natural Camouflage - Bark" ) {

                // Apply bark as extraordinary effect
                eBark = ExtraordinaryEffect( eBark );
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBark, oTarget );

            // Or stone mode.
            } else if ( GetName( oWidget ) == "Natural Camouflage - Stone" ) {

                // Apply stone vfx as extraordinary effect
                eStone = ExtraordinaryEffect( eStone );
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eStone, oTarget );
            }

        // If target is not valid, toggle the name.
        } else {

            // Checks to see if the widget is set to bark mode.
            if ( GetName( oWidget ) == "Natural Camouflage - Bark" ) {

                // Change name to stone.
                SetName( oWidget, "Natural Camouflage - Stone");

            // Or stone mode.
            } else if ( GetName( oWidget ) == "Natural Camouflage - Stone" ) {

                // Change name to bark.
                SetName( oWidget, "Natural Camouflage - Bark");
            }
        }
    }
}

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;

        case X2_ITEM_EVENT_EQUIP:

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
    }
}
