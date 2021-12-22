/*  NPC :: Harold Twirly : Conversation : Action 1

    --------
    Verbatim
    --------
    This will make the player sing a song!

    ---------
    Changelog
    ---------
    Date        Name        Reason
    ----------------------------------------------------------------------------
    012607      kfw         Initial.
    ----------------------------------------------------------------------------
*/

void main( ){

    // Variables.
    object oPC          = GetPCSpeaker( );


    // Bardsong.
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        EffectVisualEffect( VFX_DUR_BARD_SONG ),
        oPC,
        2.0 );

    return;

}
