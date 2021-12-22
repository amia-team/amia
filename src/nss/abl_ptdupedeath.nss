/*
    Custom NPC Ability:
    Past Time Duplicate Death
    - When a Past Time Duplicate dies, the PC it was a copy of must make a Will
    save vs. DC 35 or be stunned for 1d4 rounds from watching "themself" die.
*/

void main()
{
    object oCritter = OBJECT_SELF;
    object oTarget = GetLocalObject( oCritter, "CopiedPC" );

    //Will DC35 to save vs. 1d4 rounds stunned (watched itself die)
    if( WillSave( oTarget, 35 ) == 0 )
    {
        //apply stun
        effect eStun = EffectKnockdown();
        eStun = SupernaturalEffect(eStun);
        int iStun = d4(1) * 6;
        float fStun = IntToFloat(iStun);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fStun);
        string sStun = "Having just witnessed your own death, your mind reels and you find yourself unable to act while you come to terms.";
        AssignCommand(oTarget, SpeakString(sStun, TALKVOLUME_WHISPER));
    }
}
