/*  Panel :: OnUsed :: PlaySound

    --------
    Verbatim
    --------
    This script will play some audio whenever someone uses the panel.
    Designated audio stored on panel as string, see constant.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062306  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

const string AUDIO_REF  = "cs_sound_vfx";

void main( ){

    // Variables.
    object oPanel       = OBJECT_SELF;
    object oPC          = GetLastUsedBy( );
    string szAudioRef   = GetLocalString( oPanel, AUDIO_REF );

    // Play audio.
    AssignCommand( oPC, PlaySound( szAudioRef ) );

    return;

}
