/*  Cordor Mythal Center : Blue Door.  */

void main( ){

    // Variables
    object oTrigger         = OBJECT_SELF;

    // Seek out the Temple of Waukeen's door and make it shiny yellow color.
    object oDoor = GetObjectByTag( "cordor_mythdoor1" );
    if( GetIsObjectValid( oDoor ) )
        ApplyEffectToObject(
                            DURATION_TYPE_PERMANENT,
                            SupernaturalEffect( EffectVisualEffect( VFX_DUR_GLOW_BLUE ) ),
                            oDoor );

    // Once-off, self-destruct
    DestroyObject( oTrigger, 1.0 );

    return;

}
