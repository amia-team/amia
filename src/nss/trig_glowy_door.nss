/*  Trigger :: Glowy Door

    --------
    Verbatim
    --------
    This script will make the designated trigger-tag-stored door a certain color (stored as an integer on the trigger itself).

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    090906  kfw         Initial release.
    ----------------------------------------------------------------------------

*/


/* Constants. */
const string DOOR_TAG       = "cs_ref";
const string DOOR_VFX       = "cs_vfx";


void main( ){


    // Variables.
    object oTrigger         = OBJECT_SELF;
    string szDoorTag        = GetLocalString( oTrigger, DOOR_TAG );
    int nDoorVfx            = GetLocalInt( oTrigger, DOOR_VFX );
    object oDoor            = GetNearestObjectByTag( szDoorTag, oTrigger );


    // Apply the custom color.
    if( GetIsObjectValid( oDoor ) )
        ApplyEffectToObject(
                            DURATION_TYPE_PERMANENT,
                            SupernaturalEffect( EffectVisualEffect( nDoorVfx ) ),
                            oDoor );

    // Once-off, self-destruct the trigger.
    DestroyObject( oTrigger, 1.0 );

    return;

}
