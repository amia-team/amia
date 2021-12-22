/*! \file qst_clmoradel.nss
 * \brief Scripted quests Corpse of Moradel coffin closed.
 *
 * OnClosed event of Moradel's coffin.  If her corpse is in the coffin when
 * the PC closes it, the PC is moved to the mid-point of the quest.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 08/05/2004 jpavelch         Initial release.
 * \endverbatim
 */

#include "quests_inc"


//! Script entry point.
/*!
 * Checks the coffin for object with tag \p MoradelsRemains.  If present,
 * makes a pretty visual over the coffin and destroys the corpse.  Uses
 * tag \p Gustav to advance the PC to mid-point.
 */
void main( )
{
    object oPC = GetLastClosedBy( );
    if ( !GetIsPC(oPC) ) return;

    object oCoffin = OBJECT_SELF;
    object oCorpse = GetItemPossessedBy( oCoffin, "MoradelsRemains" );

    if ( !GetIsObjectValid(oCorpse) )
        return;

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES),
        GetLocation(oCoffin)
    );

    DestroyObject( oCorpse );

    // Verify status of quest for this PC.
    int nStatus = QST_GetStatus( oPC, QST_GUSTAV_TAG );
    if ( nStatus == QST_STARTED )
        QST_MidQuest( oPC, QST_GUSTAV_TAG );
}
