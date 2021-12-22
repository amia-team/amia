/*! \file aoe_irraereb.nss
 * \brief Irraere's feather AOE OnHeartbeat event.
 *
 * All PCs and their associates are healed 2d6 hit points.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 10/09/2004 jpavelch         Initial release.
 * \endverbatim
 */


//! Heals a PC 2d6 hit points.
/*!
 * The improved healing visual is used.
 * \param oPC PC to be healed.
 */
void HealPlayer( object oPC )
{
    effect eHeal = EffectHeal( d6(2) );
    effect eVis = EffectVisualEffect( VFX_IMP_HEALING_G );
    eHeal = EffectLinkEffects( eHeal, eVis );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oPC );
}


//! Script entry point.
/*!
 * Heals each PC or PC-controlled creature within the area of effect
 * object.
 */
void main( )
{
    object oAOE = OBJECT_SELF;

    object oPC = GetFirstInPersistentObject( oAOE, OBJECT_TYPE_CREATURE );
    while ( GetIsPC(oPC) || GetIsPC(GetMaster(oPC)) ) {
        HealPlayer( oPC );
        oPC = GetNextInPersistentObject( oAOE, OBJECT_TYPE_CREATURE );
    }
}

