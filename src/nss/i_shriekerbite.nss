/*  Death Domain Summon: Death Shrieker: OnHit: Cast Unique Spell.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    042206  kfw         Initial release.
    ----------------------------------------------------------------------------

    --------
    Verbatim
    --------
    Death Domain summon Death Shrieker's bite casts a PnP Phantasmal Killer spell.
    ---

*/

/* Includes */
#include "x2_inc_switches"

void main( ){

    // Variables
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch(nEvent ){

        case X2_ITEM_EVENT_ONHITCAST:{

            // Variables
            object oShrieker    = OBJECT_SELF;
            object oVictim      = GetSpellTargetObject( );

            // Will Save, DC 21
            if( WillSave( oVictim, 21, SAVING_THROW_TYPE_NEGATIVE, oShrieker ) < 1 ){

                // Fortitude Save, DC 21
                if( FortitudeSave( oVictim, 21, SAVING_THROW_TYPE_DEATH, oShrieker ) < 1 )
                    // Failure: Instant death.
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath( ), oVictim, 0.0 );

                // Will Save failed, Fortitude Save succeeded
                else
                    // 3D6 Negative energy damage.
                    ApplyEffectToObject(
                                        DURATION_TYPE_INSTANT,
                                        EffectLinkEffects(
                                                        EffectDamage( d6( 3 ), DAMAGE_TYPE_NEGATIVE ),
                                                        EffectVisualEffect( VFX_IMP_SONIC ) ),
                                        oVictim,
                                        0.0 );

            }

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
