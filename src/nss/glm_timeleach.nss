//-------------------------------------------------------------
// Executed script for Time Leach ability
//--------------------------------------------------------------

void main()
{
    object oCritter = OBJECT_SELF;
    location lCritter = GetLocation(oCritter);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 200.0, lCritter, TRUE, OBJECT_TYPE_CREATURE);

    while(GetIsObjectValid(oTarget))
    {
        if (GetLocalInt(oTarget, "StasisTouch") == 2 && !GetIsDead(oTarget))
        {
            int iDrain = GetLocalInt(oTarget, "LevelDrain");
            iDrain = iDrain + 3;
            SetLocalInt(oTarget, "LevelDrain", iDrain);

            effect eHeal = EffectHeal(20);
            effect eBeam = EffectBeam(VFX_BEAM_ODD, oTarget, BODY_NODE_CHEST, FALSE);

            string sSpeak = "**Temporal energy siphons from the Phane's victims and heals its wounds!**";
            FloatingTextStringOnCreature(sSpeak, oCritter, FALSE);
            SpeakString(sSpeak, TALKVOLUME_TALK);

            DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCritter));
            DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oCritter, 2.0));
        }
        if (GetLocalInt(oTarget, "LevelDrain") >= 30)
        {
            int iDrain = GetLocalInt(oTarget, "LevelDrain");
            effect eDrain = EffectNegativeLevel(iDrain);
            int nCurrentHP = GetCurrentHitPoints(oTarget);
            effect eSmite = EffectDamage(nCurrentHP+50);

            effect eLoop = GetFirstEffect(oTarget);

            while (GetIsEffectValid(eLoop))
            {
                if (GetEffectCreator(eLoop) == oCritter)
                {
                    RemoveEffect(oTarget, eLoop);
                }
            eLoop = GetNextEffect(oTarget);
            }

            string sName = GetName(oTarget);
            string sSpeak = "**" + sName + " has fallen, entirely drained by the Phane...**";
            FloatingTextStringOnCreature(sSpeak, oCritter, FALSE);
            SpeakString(sSpeak, TALKVOLUME_TALK);

            DelayCommand(0.1, SetLocalInt(oTarget, "LevelDrain", 0));
            DelayCommand(0.1, SetLocalInt(oTarget, "StasisTouch", 1));
            DelayCommand(0.1, SetLocalInt(oTarget, "StasisDeath", 2));
            DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSmite, oTarget));
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 200.0, lCritter, TRUE, OBJECT_TYPE_CREATURE);
    }
}
