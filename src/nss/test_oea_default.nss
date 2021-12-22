/*! \file sei_oea_default.nss
 * \brief ALFA Subraces default area OnEnter event.
 *
 * Sets/removes any penalties on a PC due to light sensitivity.
 * \verbatim
 * Revision History
 * Date       Name              Description
 * ---------- ----------------  --------------------------------------------
 * ?          Shir'le E. Illios Initial Release
 * 01/10/2004 jpavelch          Added user-defined event call.
 * 20050130   jking             Hook standard call.
 * 20050402   jking             Added connections management (area update)
 * 20051210   kfw               Disabled SEI, Added True Races vulnerability handling
 * 20051222   kfw               Map Reveal, checks integer var: CS_MAP_REVEAL equal to 1, to unfog
 * 20060226   kfw/Discosux      Testing Discosux's Ambience

 //imported from sei_oea_default
 * 031906  kfw         Code optimization.
 * 052006  kfw         Code optimization and bug fix: Improved Effect precision.
 * 062206  kfw         Bug fix. Bioware functions not working correctly.
 * 082206  kfw         Added light sensitivity support for Shadow Elf.

 * 20061022   Disco             Synced with sei_oea_default
  20070822  Disco       Added functions for testing
20071118        Disco      Libbed



 * \endverbatim
 */

#include "area_constants"
#include "inc_ds_records"
#include "ds_inc_ambience"

/* Prototype Definitions. */

void main( ){

    // Variables.
    object oArea        = OBJECT_SELF;
    object oPC          = GetEnteringObject( );

    // Bug out on non-PC
    if( !GetIsPC( oPC ) ){

        return;
    }

    log_exploit( oPC, oArea, "test_oea_default" );

    //store area visits
    db_onTransition( oPC, oArea );

    //set lights
    set_ambience( oPC, oArea);

    AreaHandleOnEnterEventDefault( oArea );

    return;

}


