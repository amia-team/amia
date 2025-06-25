#include "nwnx_magic"
#include "amia_include"
#include "x2_inc_itemprop"
#include "x0_i0_spells"

void main( ){

    object oPC = OBJECT_SELF;
    int ShifterID = GetLocalInt( OBJECT_SELF, "LAST_POLY_ID");
    object oPCKey       = GetItemPossessedBy(oPC, "ds_pckey");
    float fResize       = GetLocalFloat(oPCKey, "presize");

    DelayCommand( 0.5, RestoreSpellState( oPC ) );
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fResize);

    if(GetPCKEYValue(OBJECT_SELF,"lycanTailTransform")==1)
    {
     SetPCKEYValue(OBJECT_SELF,"lycanTailTransform",0);
     DelayCommand(0.1,SetCreatureTailType(GetPCKEYValue(OBJECT_SELF,"lycanTail"),OBJECT_SELF));
    }
}