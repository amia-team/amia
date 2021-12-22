/*  Customizer :: tracer

    --------
    Verbatim
    --------
    shifter item exploit tracer.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    011407  disco       Initial release.
    ----------------------------------------------------------------------------

*/

/* includes. */
#include "amia_include"


void main(){

    object oPC = GetPCSpeaker();

    //can't use #include "NW_I0_GENERIC"
    effect eLoop = GetFirstEffect( oPC );

    while ( GetIsEffectValid( eLoop ) ){

        if ( GetEffectType( eLoop ) == EFFECT_TYPE_POLYMORPH ){

            log_to_exploits( oPC, "Crafting "+SQLEncodeSpecialChars( GetName( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND ) ) ), GetResRef( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND ) ), GetAppearanceType( oPC ) );
            SendMessageToPC( oPC, "This exploit has been logged. DM Disco will come and hunt you down sooner or later." );
            break;

        }
        eLoop=GetNextEffect(oPC);
    }
}
