//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_death
//group:   ds_ai
//used as: OnDamage
//date:    dec 23 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter         = OBJECT_SELF;
    object oKiller          = GetLastKiller();
    location lCritter = GetLocation(oCritter);
    object oTarget = GetLocalObject(oCritter, "CopiedPC");
    string sPCName = GetName(oTarget);

    if(!GetIsDead(oTarget))
    {
        //Will DC35 to save vs. 1d4 rounds stunned (watched itself die)
        if (WillSave(oTarget, 35) == 0)
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

    if( GetLastKiller() != OBJECT_SELF && GetLocalInt( oCritter, L_ISDEAD ) != 1 ){

        // Set have died once, stops giving out multiple amounts of XP.
        SetLocalInt( oCritter, L_ISDEAD, 1 );

        // Reward XP.
        int nXPResult = RewardXPForKill( );

        // Generate treasure.
        GenerateLoot( oCritter, nXPResult );
    }
}
