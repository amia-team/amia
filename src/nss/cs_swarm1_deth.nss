// Completed by Kungfoowiz on the 24th September 2005.

// Version 1.0.

// This script removes the effects of elemental swarm correctly.



void main()
{
    // Elemental Swarm
    // vars
    object oElemental=OBJECT_SELF;

    /* if applicable
        1. remove paraelemental special vfx
        2. reset vars
       on the paraelemental's foes in a 30ft. radius */

    // cycle thru all foes
    object oVictim=GetFirstObjectInShape(
        SHAPE_SPHERE,
        30.0,
        GetLocation(oElemental),
        FALSE,
        OBJECT_TYPE_CREATURE);

    while(GetIsObjectValid(oVictim)==TRUE)
    {

        // get next foe, if the current foe is the paraelemental itself
        if(oVictim==oElemental){

            oVictim=GetNextObjectInShape(
                SHAPE_SPHERE,
                30.0,
                GetLocation(oElemental),
                FALSE,
                OBJECT_TYPE_CREATURE);

            continue;
        }

        // cycle thru all vfxs on the current foe
        effect eRemoveVFX=GetFirstEffect(oVictim);
        while(GetIsEffectValid(eRemoveVFX)==TRUE){

            // if the vfx was created by the paraelemental, remove it an reset the vfx var
            if(GetEffectCreator(eRemoveVFX)==oElemental){

                RemoveEffect(
                    oVictim,
                    eRemoveVFX);

                if(GetTag(oElemental)=="pelemental_ice"){

                    SetLocalInt(
                        oVictim,
                        "ice_chilled",
                        0);

                }
                else{

                    SetLocalInt(
                        oVictim,
                        "caught_on_fire",
                        0);

                }

                break;

            }

            eRemoveVFX=GetNextEffect(oVictim);

        }

        oVictim=GetNextObjectInShape(
            SHAPE_SPHERE,
            30.0,
            GetLocation(oElemental),
            FALSE,
            OBJECT_TYPE_CREATURE);

    }

}
