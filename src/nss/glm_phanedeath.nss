//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_death
//group:   ds_ai
//used as: OnDamage
//date:    dec 23 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"
#include "inc_ds_records"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter         = OBJECT_SELF;
    object oKiller          = GetLastKiller();

    // Give Temporal Essence to anyone who's not already received it before
    object oPhaneHome = GetArea( oCritter );
    object oRewarded  = GetFirstObjectInArea( oPhaneHome );

    while( GetIsObjectValid( oRewarded ) )
    {
        if( GetIsPC( oRewarded ) )
        {
            int nDropped = GetPCKEYValue( oRewarded, "PhaneKill" );

            if( nDropped == 1 )
            {
                CreateItemOnObject( "timeessence", oRewarded, 1, "" );
                SetPCKEYValue( oRewarded, "PhaneKill", 1 );
                DelayCommand( 1.0, AR_ExportPlayer( oRewarded ) );
            }
        }

        oRewarded = GetNextObjectInArea( oPhaneHome );
    }


    if( GetLastKiller() != OBJECT_SELF && GetLocalInt( oCritter, L_ISDEAD ) != 1 ){

        // Set have died once, stops giving out multiple amounts of XP.
        SetLocalInt( oCritter, L_ISDEAD, 1 );

        // Reward XP.
        int nXPResult = RewardXPForKill( );

        // Generate treasure.
        GenerateLoot( oCritter, nXPResult );
    }
}
