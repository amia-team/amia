/*  dg_onuse_tagvfx

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032008  dg          Initial Release
    ----------------------------------------------------------------------------

    --------
    Verbatim
    --------
    A script for applying permanent visual effects based on the name of the
    sVFX variable of OBJECT_SELF.

*/

void main()
{


string sVFX = GetLocalString( OBJECT_SELF, "sVFX" );

int nVFX    = StringToInt( sVFX );

effect eVFX = EffectVisualEffect( nVFX );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX, OBJECT_SELF );


}
