// Default OnExit event of an area.
//
// Revision History
// Date       Name               Description
// ---------- ----------------   ---------------------------------------------
// 01/10/2004 jpavelch           Initial Release
// 20050130   jking              Moved constants out into common header
// 062206     kfw                Bug fix. Bioware functions not working correctly.
// 082106     kfw                Added light sensitivity support for the Shadow Elf.
// 111106     disco              Trace familar on exit
// 2008-07-05 disco              Put all area effects cleanup stuff RemoveEffectsBySpell( oPC, 836 );

#include "area_constants"
#include "amia_include"

void main( ){

    // Variables.
    object oPC          = GetExitingObject( );

    if( !GetIsPC( oPC ) )
        return;

    AreaHandleOnExitEventDefault(OBJECT_SELF);

    return;

}
