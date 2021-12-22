// nw_s0_resserec - Ressurection
// Copyright (c) 2001 Bioware Corp.
//
// Brings a character back to life with full health.
// When cast on placeables, you get a default error message.
//  You can specify a different message in
//   X2_L_RESURRECT_SPELL_MSG_RESREF
//  You can turn off the message by setting the variable to -1.
//
// Revision History
// Date       Name                Description
// ---------- ------------------  --------------------------------------------
// 01/31/2001 Preston Watamaniuk  Initial Release
// 08/16/2003 jpavelch            Added reinitialization of subrace traits.
// 12/10/2005 kfw                 disabled SEI, True Races compatibility
// 2008/03/22 disco               new death system added
// 2008/03/25 disco               disabled VFX for DMs
// 2008/07/05 disco               new blindness/underwater system
// 2008/07/05 disco               new racial trait system

#include "x2_inc_spellhook"
#include "inc_ds_died"
#include "amia_include"

int CanBeRessurected( object oTarget, object oCaster );

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Get the spell target
    object oTarget = GetSpellTargetObject();
	object oModule = GetModule();
    // Check for blood stain due to rogue death in stealth.
    object oVictim;
    if ( GetTag(oTarget) == "MysteriousBloodStain" ) {
        oVictim = GetLocalObject( oTarget, "PlayerVictim" );
        if ( GetIsObjectValid(oVictim) )
            oTarget = oVictim;
    }

    if( !CanBeRessurected( oTarget, OBJECT_SELF ) ){

        SendMessageToPC( OBJECT_SELF, "Cannot raise this target yet!" );
        return;
    }

    if( (GetPCKEYValue( oTarget, "dead_in" )!= 0) && (GetPCKEYValue( oTarget, "dead_in" ) != GetLocalInt( oModule, "Module" )) )
    {
        SendMessageToPC( OBJECT_SELF, "Cannot raise this target; they died on the other server!" );
        return;
    }

    DeletePCKEYValue( oTarget, "dead_in" );

    //Check to make sure the target is dead first
    //Fire cast spell at event for the specified target
    if (GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESURRECTION, FALSE));
        if (GetIsDead(oTarget))
        {
            //-------------------------------------------------------------
            // Checks if target died under Stasis Touch effect
            //-------------------------------------------------------------
            if( GetLocalInt( oTarget, "StasisDeath" ) == 1 )
            {
                DeleteLocalInt( oTarget, "StasisDeath" );
            }

            //Declare major variables
            int nHealed = GetMaxHitPoints(oTarget);
            effect eRaise = EffectResurrection();
            effect eHeal = EffectHeal(nHealed + 10);
            effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
            //Apply the heal, raise dead and VFX impact effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));

            //---------------------------------------------------------
            //clean death settings
            //---------------------------------------------------------
            RemoveDeadStatus( oTarget );
        }
        else
        {
            if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                int nStrRef = GetLocalInt(oTarget,"X2_L_RESURRECT_SPELL_MSG_RESREF");
                if (nStrRef == 0)
                {
                    nStrRef = 83861;
                }
                if (nStrRef != -1)
                {
                     FloatingTextStrRefOnCreature(nStrRef,OBJECT_SELF);
                }
            }
        }
    }
}


int CanBeRessurected( object oTarget, object oCaster ){

    if( GetIsBlocked( oTarget, "ressurection_block" ) <= 0 || GetIsDM( oCaster ) || !GetIsPC( oCaster ) || oCaster == GetLocalObject( oTarget, "my_ressurector" ) || GetLocalInt( GetArea( oTarget ), "FreeRest" ) || GetLocalInt( GetArea( oTarget ), "ds_freezone" ) ){

        effect eEffect = GetFirstEffect( oTarget );
        while( GetIsEffectValid( eEffect ) ){

            if( GetEffectSubType( eEffect ) == SUBTYPE_SUPERNATURAL && GetEffectType( eEffect ) == EFFECT_TYPE_VISUALEFFECT && GetEffectSpellId( eEffect ) == -1 )
                RemoveEffect( oTarget, eEffect );

            DeleteLocalInt( oTarget, "ressurection_block" );
            DeleteLocalObject( oTarget, "my_ressurector" );
            eEffect = GetNextEffect( oTarget );
        }

        return TRUE;
    }
    return FALSE;
}
