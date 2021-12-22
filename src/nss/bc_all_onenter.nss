/*  Bardic College - OnEnter Script.

    --------
    Verbatim
    --------
    Applies area effects on entering.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    101206  Aleph       Initial release.
    012107  Aleph       Doleful Chord parts removed.
    ----------------------------------------------------------------------------

*/

void main()
{
object oBook1 = GetObjectByTag("book1");
object oBook2 = GetObjectByTag("book2");

ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_GREATER_STONESKIN), oBook1);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_GREATER_STONESKIN), oBook2);

}

