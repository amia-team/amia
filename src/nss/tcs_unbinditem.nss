/*! \file tcs_unbinditem.nss
 * \brief Thayvian Crafting System unbind item.
 *
 * Conversation action to unset the cursed flag of the currently selected
 * item.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 03/24/2004 jpavelch         Initial release.
 * \endverbatim
 */


//! Script entry point.
/*!
 * Casts a fake spell at the PC for a flashy visual effect and
 * removes the \a cursed flag from the current item.
 * \par Local Variables Used
 * \li \a TCS_CurrentItem Item from which to remove flag.  Deleted.
 */
void main( )
{
    object oPC = GetPCSpeaker( );
    object oItem = GetLocalObject( oPC, "TCS_CurrentItem" );

    ActionCastFakeSpellAtObject(
        SPELL_REMOVE_CURSE,
        oPC
    );
    DelayCommand(
        2.0,
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_REMOVE_CONDITION),
            oPC
        )
    );

    SetItemCursedFlag( oItem, FALSE );
    DeleteLocalObject( oPC, "TCS_CurrentItem" );
}
