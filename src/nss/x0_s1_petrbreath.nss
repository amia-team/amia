//::///////////////////////////////////////////////////
//:: X0_S1_PETRBREATH
//:: Petrification breath monster ability.
//:: Fortitude save (DC 17) or be turned to stone permanently.
//:: This will be changed to a temporary effect.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////

// @@@ AmiaAddition leave this overridden to prevent permanent petrification

#include "x0_i0_spells"

void main()
{
    object oTarget = GetSpellTargetObject();
    int nHitDice = GetHitDice(OBJECT_SELF);


    location lTargetLocation = GetSpellTargetLocation();

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
        int nSpellID = GetSpellId();
        object oSelf = OBJECT_SELF;
        DelayCommand(fDelay,  DoPetrification(nHitDice, oSelf, oTarget, nSpellID, 17));

        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);
    }



}



