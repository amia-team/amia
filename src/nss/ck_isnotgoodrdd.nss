/*! \file chk_isgoodrdd.nss
 * \brief Conversation conditional to check for non good-aligned RDDs.
 *
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 12/23/2004 jpavelch         Initial release.
 * \endverbatim
 */

//! Script entry point.
/*!
 * Returns TRUE if the PC speaker is an RDD and of non-good alignment.
 */
int StartingConditional( )
{
    object oPC = GetPCSpeaker( );

    int nRDD = GetLevelByClass( CLASS_TYPE_DRAGON_DISCIPLE, oPC );
    if ( nRDD < 1 ) return FALSE;

    int nAlign = GetAlignmentGoodEvil( oPC );
    if ( nAlign == ALIGNMENT_GOOD ) return FALSE;

    return TRUE;
}
