// Default OnExit event of an area.
//
// Revision History
// Date       Name               Description
// ---------- ----------------   ---------------------------------------------
// 01/10/2004 jpavelch           Initial Release
// 20050130   jking              Moved constants out into common header
// 062206     kfw                Bug fix. Bioware functions not working correctly.
// 11-11-2006 disco              Trace familar on exit
// 2007-05-20 disco              Removed trace familar on exit, added underwater support
// 2008-07-06 disco              removed racial traits stuff
// 2009-09-04 disco              Inserted area_constants stuff
// 2013-10-23 Glim               Added removal of variable based VFX to PC's OnExit
// 2015-06-30 Faded Wings        Instancing
// 2019-07-17 Tarnus             Commented dynamic area stuff out for EE to work
//#include "fw_include"

void glm_removeflavorVFX( object oArea, object oPC );

void main( ){

    // Variables.
    object oArea        = OBJECT_SELF;
    object oPC          = GetExitingObject( );
    int nCount          = GetLocalInt( oArea, "PlayerCount" ) - 1;

    if( !GetIsPC( oPC ) ){

        return;
    }

    if ( nCount < 0 ){

        nCount = 0;
    }

    SetLocalInt( oArea, "PlayerCount", nCount );

    //VFX Removal from PCs
    int nAreaVFXApplied = GetLocalInt( oPC, "AreaVFXApplied" );

    if( nAreaVFXApplied == TRUE )
    {
        int nVFXDelay = GetLocalInt( oArea, "VFXDelay" );
        DelayCommand( IntToFloat( nVFXDelay ), glm_removeflavorVFX( oArea, oPC ) );
    }

    //fw_instanceLeave(oArea);

    return;
}

void glm_removeflavorVFX( object oArea, object oPC )
{
    int nAreaVFXApplied = GetLocalInt( oPC, "AreaVFXApplied" );

    if( nAreaVFXApplied == TRUE )
    {
        int nAreaVFX = GetLocalInt( oArea, "AreaVFX" );

        effect eRemove = GetFirstEffect( oPC );
        while( GetIsEffectValid( eRemove ) )
        {
            if( GetEffectCreator( eRemove ) == oArea )
            {
                RemoveEffect( oPC, eRemove );
                DeleteLocalInt( oPC, "AreaVFXApplied" );
            }
            eRemove = GetNextEffect( oPC );
        }
    }
}
