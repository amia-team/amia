/*! \file chk_isgoodrdd.nss
 * \brief Conversation conditional to check for good-aligned RDDs.
 *
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 07/04/2004 jpavelch         Initial release.
 * 12/14/2004 jpavelch         Using QST_* constants.
 * \endverbatim
 */

//! Script entry point.
/*!
 * Returns TRUE if the PC speaker is an RDD and of good alignment.
 */
int StartingConditional( )
{
    object oPC = GetPCSpeaker( );

    int nRDD = GetLevelByClass( CLASS_TYPE_DRAGON_DISCIPLE, oPC );
    if ( nRDD < 1 ) return FALSE;

    int nAlign = GetAlignmentGoodEvil( oPC );
    if ( nAlign != ALIGNMENT_GOOD ) return FALSE;

    return TRUE;
}
