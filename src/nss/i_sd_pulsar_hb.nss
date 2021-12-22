// See main file: i_sd_pulsar
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2015/12/12 BasicHuman       Initial Release.
//

#include "x2_i0_spells"

void main()
{
    object oItem = GetAreaOfEffectCreator();
    object oPC = GetItemPossessor(oItem);
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);

    int iCL = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC);

    int iDC = 10 + iCL;
    int iDamage = d4() + iCL;

    object oVictim=GetFirstInPersistentObject();
    while(oVictim!=OBJECT_INVALID)
    {
        if(GetIsEnemy(oVictim, oPC))
        {
            if(GetRacialType(oVictim)==RACIAL_TYPE_UNDEAD)
            {
                int iDamage = d4() + iCL;
                AssignCommand(oSummon,
                              ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                                  EffectHeal(iDamage),
                                                  oVictim));
            }
            else if(FortitudeSave(oVictim, iDC, SAVING_THROW_TYPE_NEGATIVE,oSummon))
            {
                int iDamage = d4() + iCL;
                AssignCommand(oSummon,
                              ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                                  EffectDamage(iDamage/2, DAMAGE_TYPE_NEGATIVE),
                                                  oVictim));
            }
            else
            {
                int iDamage = d4() + iCL;
                AssignCommand(oSummon,
                              ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                                  EffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE),
                                                  oVictim));
            }
        }
        oVictim = GetNextInPersistentObject();
    }

}
