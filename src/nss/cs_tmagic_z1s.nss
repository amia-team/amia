/* Area tilemagic

    cs_tilemagic = ice (426), water (401), grass (402), lava fountain (349), lava (350), cavefloor (406), sewer water (461).

*/

// includes
#include "x2_inc_toollib"

void main(){

    // vars
    object oPC=GetEnteringObject();
    object oArea=GetArea(oPC);
    int nTileVfx=GetLocalInt(
        oArea,
        "cs_tilemagic");

    // resolve spawn status
    if(GetLocalInt(
        oArea,
        "spawned")==1){

        return;

    }
    else{

        TLChangeAreaGroundTiles(
            oArea,
            nTileVfx,
            32,
            32);

        DelayCommand(
            1.0,
            RecomputeStaticLighting(oArea));

    }

    return;

}
