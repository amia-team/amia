// Knight Commander feat: Entreatment
//
// Causes all nearby targets to attack the KC.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2011 PoS              Initial Release.
//

#include "NW_I0_SPELLS"
#include "x2_i0_spells"

void main()
{
    // Declare main variables.
    object oPC = OBJECT_SELF;
    int eTaunt = GetSkillRank( SKILL_TAUNT, oPC );

    effect eVFX = EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE);

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oPC );

    //Cycle through the targets within the spell shape until an invalid object is captured.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation( oPC ), TRUE, OBJECT_TYPE_CREATURE );
    while ( GetIsObjectValid( oTarget ) )
    {
        if( GetIsReactionTypeHostile( oTarget, oPC ) )
        {
            if( !MySavingThrow( SAVING_THROW_WILL, oTarget, eTaunt + d20(), SAVING_THROW_TYPE_NONE, oPC ) ) {

                // Break their action queue.
                AssignCommand( oTarget, ClearAllActions() );

                // Cause them to attack the PC if only not a PC themselves.
                if( !GetIsPC( oTarget ) && GetChallengeRating( oTarget ) < 42.0 )
                {
                    AssignCommand( oTarget, ActionAttack( oPC ) );
                    SetLocalInt( oTarget, "AI_TOGGLE", 1 );
                    SetLocalObject( oTarget, "L_CURRENTTARGET", oPC );
                    DelayCommand( 30.0, DeleteLocalInt( oTarget, "AI_TOGGLE" ) );
                    DelayCommand( 30.0, DeleteLocalInt( oTarget, "L_CURRENTTARGET" ) );
                }

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectAttackDecrease( 2 ), oTarget, 30.0 );
            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation( oPC ), TRUE, OBJECT_TYPE_CREATURE);
    }
}
