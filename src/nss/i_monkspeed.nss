#include "x2_inc_switches"
#include "inc_nwnx_events"
#include "inc_lua"

//Get the level of which the pc achived monk level 3
//returns 0 on fail
int GetMonkSpeedLevel(object oPC){

    if(GetLevelByClass(CLASS_TYPE_MONK,oPC)<3)
        return 0;

    //If function doesnt exist then define it
    if(RunLua("return tostring(GetMonkSpeedLevel);")=="nil"){
        RunLua("function GetMonkSpeedLevel() local lvl;local cnt=0;for n=1,100 do lvl=nwn.GetLevelStat(OBJECT_SELF,n); if not lvl then return 0; elseif lvl.class==5 then cnt=cnt+1; end if cnt==3 then return n; end end return 0; end");
    }

    return StringToInt(ExecuteLuaFunction(oPC,"GetMonkSpeedLevel",""));;
}

void ActivateItem( object oPC )
{
    if(GetHasFeat(FEAT_MONK_ENDURANCE,oPC)){

        ExecuteLuaString(oPC,"nwn.RemoveFeat(OBJECT_SELF,"+IntToString(FEAT_MONK_ENDURANCE)+");");
        SendMessageToPC(oPC,"Removed monkspeed feat!");
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_SLOW),oPC);
    }
    else
    {
        int nLevel = GetMonkSpeedLevel(oPC);

        if(nLevel <= 0 && (GetIsDM(oPC) || GetIsDMPossessed(oPC)))
            nLevel = 1;

        if(nLevel > 0){
            ExecuteLuaString(oPC,"nwn.AddFeat(OBJECT_SELF,"+IntToString(FEAT_MONK_ENDURANCE)+","+IntToString(nLevel)+");");
            SendMessageToPC(oPC,"Added monkspeed to level "+IntToString(nLevel));
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_HASTE),oPC);
        }
        else
            SendMessageToPC(oPC,"Unable to find monk level 3 in levelstatlist!");
    }
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_INSTANT:
            ActivateItem( OBJECT_SELF );
            EVENTS_Bypass();
            break;
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( GetItemActivator() );
            break;
    }
}
