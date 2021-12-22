//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai2_heartbeat
//group:   ds_ai2
//used as: AI
//date:    dec 23 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

void main(){

    object oCritter     = OBJECT_SELF;
    int nCount          = GetLocalInt( oCritter, L_INACTIVE );
    int nSunkill        = GetLocalInt( oCritter, F_SUNKILL );

    SetLocalInt( oCritter, L_INACTIVE, (nCount + 1) );

    if ( nSunkill ){

        object oArea = GetArea( oCritter );

        if ( GetIsDay() &&
            !GetIsAreaInterior( oArea )  &&
            GetIsAreaAboveGround( oArea ) ){

            effect eVis    = EffectVisualEffect( VFX_IMP_FLAME_M );
            effect eDamage = EffectDamage( d10( 10 ), DAMAGE_TYPE_FIRE );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oCritter );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oCritter );

            SpeakString( "*gets sunburned*" );
        }
    }

    if ( nCount == 50 && GetLocalInt( oCritter, "CS_DSPWN" ) == 1 ){

        //Warn a DM about inactive spawns
        //SendMessageToAllDMs( "DS AI message: "+GetName( oCritter )+" in "+GetName( GetArea( oCritter ) )+ " has been inactive for 5 minutes now and will be deleted." );

        SafeDestroyObject2( oCritter );
    }

    object oActivity = GetNearestObject( OBJECT_TYPE_CREATURE, oCritter );

    if( !GetIsObjectValid( oActivity ) )
    {
        SafeDestroyObject2( oCritter );
    }

    //Apply round counters to Phane abilities and call if applicable
    //Check for Dispelled Stasis Touch effects

    //Chronal Blast every 3 rounds
    if(GetLocalInt(oCritter, "CBCount") == 3)
    {
        ExecuteScript("glm_chronalblast", oCritter);
        SetLocalInt(oCritter, "CBCount", 1);
    }
    else if(GetLocalInt(oCritter, "CBCount") <=2)
    {
        int nCBCount = GetLocalInt(oCritter, "CBCount");
        SetLocalInt(oCritter, "CBCount", nCBCount + 1);
    }
    //Time Leach every 2 rounds
    if(GetLocalInt(oCritter, "TLCount") == 2)
    {
        ExecuteScript("glm_timeleach", oCritter);
        SetLocalInt(oCritter, "TLCount", 1);
    }
    else if(GetLocalInt(oCritter, "TLCount") <=1)
    {
        int nTLCount = GetLocalInt(oCritter, "TLCount");
        SetLocalInt(oCritter, "TLCount", nTLCount + 1);
    }
    //Stasis Touch every 10 rounds
    if(GetLocalInt(oCritter, "STCount") == 10)
    {
        ExecuteScript("glm_stasistouch", oCritter);
        SetLocalInt(oCritter, "STCount", 1);
    }
    else if(GetLocalInt(oCritter, "STCount") <=9)
    {
        int nSTCount = GetLocalInt(oCritter, "STCount");
        SetLocalInt(oCritter, "STCount", nSTCount + 1);
    }
}
