//script        car_keeptrap
//developer     msheeler
//date          8/12/2016

//description   fires off a large explotion doing 40d6 fire damage to all creatures in the AoE

#include "amia_include"

void main()
{
    //variables
    object oTripper = GetEnteringObject();
    object oTarget;
    object oTrigger = OBJECT_SELF;
    int nDamage;
    effect eExplode;
    effect eDamage;
    effect eDamageVisual;
    location lTrigger = GetLocation (oTrigger);

    if ( GetIsBlocked() )
    {
        return;
    }

    //only fire if it was a PC entering
    if (GetIsPC (oTripper))
    {
        //we're about to fire, lets block this so it only happens once every 15 minutes
        SetBlockTime( oTrigger, 15 );

        //Set off the explosion
        eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);

        //get targets in AoE
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTrigger, FALSE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget))
        {
            //determine individual damage
            nDamage = d6(40);
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 40, SAVING_THROW_TYPE_FIRE);

            //set up effects
            eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            eDamageVisual =  EffectVisualEffect(VFX_IMP_FLAME_M);
            if(nDamage > 0)
            {
                //apply effects
                ApplyEffectToObject (DURATION_TYPE_INSTANT, eDamageVisual, oTarget);
                ApplyEffectToObject (DURATION_TYPE_INSTANT, eDamage, oTarget);
            }
            //Get next target in the sequence
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTrigger, FALSE, OBJECT_TYPE_CREATURE);
        }
    }
}
