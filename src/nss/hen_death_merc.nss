//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
// Maverick00053

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"


int RezChance(object oMaster);

void RaiseMe(object oCritter, location lLocation, object oMaster, string sTag, string sResRef);

void PMBuff(object oHench,object oMaster, string sTag);

int getPoints(object oMaster);
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter = OBJECT_SELF;
    object oKiller = GetLastKiller();
    object oMaster = GetMaster(oCritter);
    location lLocation = GetLocation(oCritter);
    string sTag = GetTag(oCritter);
    string sResRef = GetResRef(oCritter);
    int nHP = GetCurrentHitPoints(oCritter);


}

