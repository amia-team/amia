/*  ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
2007-11-19  disco       Uses PCKEY system now
    ----------------------------------------------------------------------------
*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"


//Put this on action taken in the conversation editor
void main(){

    // Variables
    object oPC = GetPCSpeaker();


    object oTarget;

    oTarget = GetObjectByTag("nb_glouraboss");

    //Visual effects can't be applied to waypoints, so if it is a WP
    //the VFX will be applied to the WP's location instead

    int nInt;
    nInt = GetObjectType(oTarget);

    if (nInt != OBJECT_TYPE_WAYPOINT){

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MASS_HEAL), oTarget);
    }
    else {

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MASS_HEAL), GetLocation(oTarget));
    }

    DestroyObject( oTarget, 3.0 );

    return;

}

