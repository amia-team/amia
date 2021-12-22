//http://www.amiaworld.net/phpBB3/viewtopic.php?f=8&t=72351
//Butterflies of Bewilderment

#include "inc_ds_records"
#include "x2_inc_spellhook"
//custom spell constants
#include "inc_dc_spells"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "nwnx_effects"

void Circle( location lOrigo, string sResRef, float fResolution, float fRadius, float fDuration ){

    vector v = GetPositionFromLocation( lOrigo );
    vector new;
    location l;
    float n=0.0;
    object oArea = GetAreaFromLocation( lOrigo );
    object oObj;
    int nTag = 0;

    while( n<360.0 ){

        new.x = fRadius * cos( n ) + v.x;
        new.y = fRadius * sin( n ) + v.y;
        new.z = v.z;
        l = Location( oArea, new, n );
        oObj = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, l, FALSE, sResRef+IntToString( nTag ) );
        if( fDuration > 0.0 )
            DestroyObject( oObj, fDuration );
        n+=fResolution;
        nTag++;
    }
}

void main(){

    location lTarget = GetSpellTargetLocation();

    effect eAoe = EffectAreaOfEffect( 33, "****", "td_aur_butter", "td_aur_but_exit" );
    Circle( lTarget, "plc_butterflies", 360.0/20.0, 6.7, 12.0 );
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAoe, lTarget, RoundsToSeconds( GetCasterLevel( OBJECT_SELF ) ) );
    SetLocalInt( OBJECT_SELF, "ButterfliesCL", GetCasterLevel( OBJECT_SELF ) );
}
