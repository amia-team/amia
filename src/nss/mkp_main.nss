// Make Placeables.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/25/2004 jpavelch         Initial release.
//

//
// Constants
//
const int SHAFT_OF_LIGHT = 1;
const int MAGIC_SPARKS = 2;
const int FLAME = 3;


// Creates a shaft of light at the target location.
//
object CreateShaftOfLight( location lTarget, string sModifier )
{
    object oShaft = CreateObject(
                        OBJECT_TYPE_PLACEABLE,
                        "plc_sol" + sModifier,
                        lTarget
                    );
    return oShaft;
}

// Creates magic sparks at the target location.
//
object CreateMagicSparks( location lTarget, string sModifier )
{
    object oSparks = CreateObject(
                         OBJECT_TYPE_PLACEABLE,
                         "plc_magic" + sModifier,
                         lTarget
                     );
    return oSparks;
}

// Creates a flamg at the target location.
//
object CreateFlame( location lTarget, string sModifier )
{
    object oFlame = CreateObject(
                        OBJECT_TYPE_PLACEABLE,
                        "plc_flame" + sModifier,
                        lTarget
                    );
    return oFlame;
}


void main( )
{
    object oPC = OBJECT_SELF;

    object oWand = GetLocalObject( oPC, "MKP_Wand" );
    location lTarget = GetLocalLocation( oWand, "MKP_TargetLocation" );
    int nState = GetLocalInt( oWand, "MKP_State" );
    string sModifier = GetLocalString( oWand, "MKP_Modifier" );

    object oPlaceable;
    switch ( nState ) {
        case SHAFT_OF_LIGHT:
            oPlaceable = CreateShaftOfLight( lTarget, sModifier );
            break;

        case MAGIC_SPARKS:
            oPlaceable = CreateMagicSparks( lTarget, sModifier );
            break;

        case FLAME:
            oPlaceable = CreateFlame( lTarget, sModifier );
            break;
    }

    float fDuration = GetLocalFloat( oWand, "MKP_Duration" );
    AssignCommand( GetArea(oPC), DelayCommand(fDuration, DestroyObject(oPlaceable)) );

    DeleteLocalObject( oPC, "MKP_Wand" );
    DeleteLocalLocation( oWand, "MKP_TargetLocation" );
    DeleteLocalInt( oWand, "MKP_State" );
    DeleteLocalString( oWand, "MKP_Modifier" );
//    DeleteLocalFloat( oWand, "MKP_Duration" );
}
