// Continual Flame
//
// Permanent Light spell.  If cast on an item, item will get permanently
// get the property "light".  Previously existing permanent light properties
// will be removed!
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/17/2002 Brent Knowles    Initial release.
// 06/05/2003 Georg Zoeller    Added XP2 cast on item code.
// 02/15/2004 jpavelch         Changed to temporary duration on items due to
//                             player exploiting.
// 06/07/2008 Terra            Increased durination and added BoT page.

#include "x2_inc_spellhook"
#include "amia_include"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run
    // this spell.
    if (!X2PreSpellCastCode())
    {
        return;
    }
    int nDuration;
    int nMetaMagic;

    object oTarget = GetSpellTargetObject();

    int    nCL     = GetCasterLevel( OBJECT_SELF );

    //Declare major variables


    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_CONTINUAL_FLAME ) );

    if( nTransmutation == 2 )
    {
        effect eVis = (EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20));
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = SupernaturalEffect(EffectLinkEffects(eVis, eDur));
        object oAoeTarget = GetFirstObjectInShape( SHAPE_SPHERE , 20.0 , GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE );
        int iTouch = 0;

            while( GetIsObjectValid( oAoeTarget ) )
            {

                if( oAoeTarget != OBJECT_SELF)
                {
                //Preform touch attack check. Y'know those SDs
                iTouch = TouchAttackRanged(oAoeTarget, TRUE);

                    if( iTouch != 0 )
                    {

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DISPEL ), oAoeTarget );

                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAoeTarget, TurnsToSeconds( nCL ) );

                    }

                }
                // Caster gets lighted automaticly
                else
                {

                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DISPEL ), oAoeTarget );

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAoeTarget, TurnsToSeconds( nCL ) );

                }

            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 419, FALSE));

            oAoeTarget = GetNextObjectInShape( SHAPE_SPHERE , 20.0, GetSpellTargetLocation(), TRUE , OBJECT_TYPE_CREATURE );
            }


    }

    else
    {
        // Handle spell cast on item....
        if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CIGetIsCraftFeatBaseItem(oTarget))
        {
            // Do not allow casting on not equippable items
            if (!IPGetIsItemEquipable(oTarget))
            {
                // Item must be equipable...
                FloatingTextStrRefOnCreature(83326,OBJECT_SELF);
                return;
            }
            itemproperty ip = ItemPropertyLight (IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_WHITE);
            IPSafeAddItemProperty(oTarget, ip, NewHoursToSeconds(nCL+8), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,TRUE,TRUE);
        }
        else
        {

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 419, FALSE));

            switch( GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_LIGHT ) ) ){

                case 2: nTransmutation = VFX_DUR_LIGHT_GREY_20; break;
                case 3: nTransmutation = VFX_DUR_LIGHT_BLUE_20; break;
                case 4: nTransmutation = VFX_DUR_LIGHT_ORANGE_20; break;
                case 5: nTransmutation = VFX_DUR_LIGHT_PURPLE_20; break;
                case 6: nTransmutation = VFX_DUR_LIGHT_RED_20; break;
                case 7: nTransmutation = VFX_DUR_LIGHT_YELLOW_20; break;
                case 8: nTransmutation = VFX_DUR_ANTI_LIGHT_10; break;
                default:nTransmutation = VFX_DUR_LIGHT_WHITE_20;break;

            }

            effect eVis = (EffectVisualEffect(nTransmutation));
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eLink = ExtraordinaryEffect(EffectLinkEffects(eVis, eDur));

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        }
    }
}



