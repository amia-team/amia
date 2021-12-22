// Golem Scramble - Makes all constructs within a huge radius
// suffer paralyzation for 5 rounds.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 08/30/2006 bbillington      Initial Release
//

// Includes
#include "x2_inc_switches"
#include "amia_include"

void main(){

    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_EQUIP:{

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );

        }
        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC=GetItemActivator();
            location lDest=GetItemActivatedTargetLocation();
            effect eParalyze = EffectCutsceneParalyze();
            effect eVFX1 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
            effect eVFX2 = EffectVisualEffect(VFX_DUR_PARALYZED);

            //log
            log_exploit( oPC, GetArea(oPC), "Item used: Gearheart" );

            // Initial visual effect
            ApplyEffectAtLocation(
               DURATION_TYPE_INSTANT,
               EffectVisualEffect(VFX_FNF_LOS_NORMAL_20),
               lDest,
               0.0);

            // Cycle through spell range
            object oTarget=GetFirstObjectInShape(
               SHAPE_SPHERE,
               RADIUS_SIZE_HUGE,
               lDest,
               TRUE,
               OBJECT_TYPE_CREATURE|OBJECT_TYPE_AREA_OF_EFFECT);

            while(oTarget!=OBJECT_INVALID){

               // Only target's hostile
               if(GetIsEnemy(
                  oTarget,
                  oPC)==TRUE){

                  // If it's a construct, go ahead
                  if(GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT){

                     // Apply visuals
                     ApplyEffectToObject(
                        DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_IMP_LIGHTNING_M),
                        oTarget);

                     ApplyEffectToObject(
                        DURATION_TYPE_TEMPORARY,
                        eVFX1,
                        oTarget,
                        RoundsToSeconds(5));

                     ApplyEffectToObject(
                        DURATION_TYPE_TEMPORARY,
                        eVFX2,
                        oTarget,
                        RoundsToSeconds(5));

                     // Paralyze them!
                     ApplyEffectToObject(
                        DURATION_TYPE_TEMPORARY,
                        eParalyze,
                        oTarget,
                        RoundsToSeconds(5));

                     }

               }

                  // Find next target that's within range
                  oTarget=GetNextObjectInShape(
                     SHAPE_SPHERE,
                     RADIUS_SIZE_HUGE,
                     lDest,
                     TRUE,
                     OBJECT_TYPE_CREATURE|OBJECT_TYPE_AREA_OF_EFFECT);

            }

        }

    }

}




