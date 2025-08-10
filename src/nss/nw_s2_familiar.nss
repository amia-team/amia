//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
//::Terra; Le twidled cs_boost_fam inhere.
#include "inc_td_appearanc"
#include "inc_ds_summons"

void main()
{
    //Yep thats it
    SummonFamiliar( OBJECT_SELF );

    // Handle reskins/optional visuals.
    DelayCommand( 2.0, HandleSummonVisuals( OBJECT_SELF, 3 ) );
}