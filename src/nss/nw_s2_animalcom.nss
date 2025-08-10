//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons a Druid's animal companion
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
//::Appended cs_boost_com togheter
#include "inc_td_appearanc"
#include "inc_ds_summons"

void main()
{
    //Yep thats it
    SummonAnimalCompanion();

    // Handle reskins/optional visuals.
    DelayCommand( 2.0, HandleSummonVisuals( OBJECT_SELF, 2 ) );
}
