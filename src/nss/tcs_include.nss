/*! \file tcs_include.nss
 * \brief Thayvian Craft System include file.
 *
 * Functions to enchant Thayvian Crafting System items.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 03/24/2004 jpavelch         Initial release.
 * 2007/05/13 disco            stripped
 * \endverbatim
 */


//! Checks for a Thayvian Crafting System item.
/*!
 * Returns \a TRUE if an item is part of the Thayvian Crafting
 * System.
 * \param oItem Item to be checked.
 * \return \a TRUE if Thayvian, otherwise \a FALSE.
 */
int TCS_GetIsThayvian( object oItem );

// Returns TRUE if the item is part of the Thayvian Crafting System.
//
int TCS_GetIsThayvian( object oItem )
{
    if ( !GetIsObjectValid(oItem) )
        return FALSE;

    string sTag = GetTag( oItem );

    return ( GetSubString(sTag, 0, 3) == "tc_"
            || GetSubString(sTag, 0, 4) == "tcc_" );
}


