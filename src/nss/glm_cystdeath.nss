//-------------------------------------------------------------
// OnDeath event for Temporal Soul Cyst
//--------------------------------------------------------------

void main()
{
    object oCyst = OBJECT_SELF;
    location lCyst = GetLocation(oCyst);

    object oTarget = GetLocalObject(oCyst, "trapedsoul");

    effect eVFX = EffectVisualEffect(VFX_IMP_DEATH_WARD, FALSE);
    effect eLoop = GetFirstEffect(oTarget);
    string sCreator = GetLocalString(oTarget, "CystTag");

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);

    while (GetIsEffectValid(eLoop))
    {
        object oCreator = GetEffectCreator(eLoop);
        string sTest = GetTag(oCreator);
        if (sTest == sCreator)
        {
            RemoveEffect(oTarget, eLoop);
        }
        eLoop = GetNextEffect(oTarget);
    }

    string sName = GetName(oTarget);
    string sSpeak = "**" + sName + " has been freed!**";
    FloatingTextStringOnCreature(sSpeak, oCyst, FALSE);
    SpeakString(sSpeak, TALKVOLUME_TALK);

    SetLocalInt(oTarget, "TrapSoul", 1);
    DelayCommand(0.5, SetLocalInt(oTarget, "HasPhaneAbility", 1));
}
