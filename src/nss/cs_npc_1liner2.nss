/*  NPC :: OnConversation :: Voice Chat Hello OR Sound VFX

    --------
    Verbatim
    --------
    This script will speak a 1-liner to the player based on a voice chat: Hello OR a string ref stored Sound anim.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    071106  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Constants. */
const string SOUND_REF  = "cs_sound_vfx";

void main( ){

    // Variables.
    object oNPC         = OBJECT_SELF;
    string szSoundRef   = GetLocalString( oNPC, SOUND_REF );

    // Try voiceset first.
    if( szSoundRef == "" )
        PlayVoiceChat( VOICE_CHAT_HELLO );
    // Otherwise, play the stored sound anim.
    else
        PlaySound( szSoundRef );

    return;

}
