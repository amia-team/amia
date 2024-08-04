#include "nwnx_creature"

//Get the level of which the pc achived monk level 3
//returns 0 on fail
int GetMonkSpeedLevel(object oPC){

    if(GetLevelByClass(CLASS_TYPE_MONK,oPC)<3)
        return 0;
    else{
        return GetLevelByClass(CLASS_TYPE_MONK,oPC);
    }
}

void ActivateItem( object oPC )
{
    if(GetHasFeat(FEAT_MONK_ENDURANCE,oPC)){

        NWNX_Creature_RemoveFeat(oPC, FEAT_MONK_ENDURANCE);
        SendMessageToPC(oPC,"Removed monkspeed feat!");
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_SLOW),oPC);
    }
    else
    {
        int nLevel = GetMonkSpeedLevel(oPC);

        if(nLevel <= 0 && (GetIsDM(oPC) || GetIsDMPossessed(oPC)))
            nLevel = 1;

        if(nLevel > 0){
            NWNX_Creature_AddFeat(oPC, FEAT_MONK_ENDURANCE);
            SendMessageToPC(oPC,"Added monkspeed to level "+IntToString(nLevel));
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_HASTE),oPC);
        }
        else
            SendMessageToPC(oPC,"Unable to find monk level 3 in levelstatlist!");
    }
}

void main( )
{
    object oPC = GetItemActivator();

    ActivateItem(oPC);
}
