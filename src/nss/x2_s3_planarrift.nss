// Black Blade of Disaster's Planar Rift On Hit

//::///////////////////////////////////////////////
//:: OnHit CastSpell: Planarrift
//:: x2_s3_planarrift
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////

//  modified by kfw to fix the Planar Rift low DC bug (oSpellOrigin -> oFeedback)

#include "x0_i0_spells"
void main()
{


   object oItem;        // The item casting triggering this spellscript
   object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
   object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

   // fill the variables
   oSpellOrigin = OBJECT_SELF;
   oSpellTarget = GetSpellTargetObject();
   oItem        =  GetSpellCastItem();
   object oFeedback = GetMaster(OBJECT_SELF);

    if (!GetIsObjectValid(oFeedback))
    {
        oFeedback = OBJECT_SELF;
    }

   // fixed up the DC bug
   int nDC = 10+GetCasterLevel(oFeedback);

   if (GetIsObjectValid(oItem))
   {
        if (GetIsObjectValid(oSpellTarget))
        {

           if (MyResistSpell(oFeedback,oSpellTarget) == 0)
           {
               if( FortitudeSave(oSpellTarget,nDC,SAVING_THROW_TYPE_DEATH,oFeedback) == 0)
               {
                    // Can't affect Time Stopped creatures
                    if( GetHasSpellEffect( SPELL_TIME_STOP, GetSpellTargetObject() ) ) {
                        return;
                    }

                    effect eDeath = EffectDeath(TRUE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oSpellTarget);
               }
           }
        }
   }
}
