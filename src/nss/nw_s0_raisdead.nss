// Raise Dead Spell
// Brings a character back to life with 1 HP.
//
// Revision History
// Date       Name                Description
// ---------- ------------------- --------------------------------------------
// 01/31/2001 Preston Watamaniuk  Initial Release.
// 10/14/2003 jpavelch            Added re-initialization of subrace traits.
// 21/10/2005 kfw                 disabled SEI, True Races compatibility
// 2008/03/22 disco               new death system added
// 2008/07/05 disco               new racial trait system


#include "x2_inc_spellhook"
#include "inc_ds_died"
#include "amia_include"

int CanBeRessurected( object oTarget, object oCaster );

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


    //Declare major variables
    object oTarget = GetSpellTargetObject();

    effect eRaise = EffectResurrection();
    effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
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

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAISE_DEAD, FALSE));
    if(GetIsDead(oTarget))
    {
        //-------------------------------------------------------------
        // Checks if target died under Stasis Touch effect
        //-------------------------------------------------------------
        if( GetLocalInt( oTarget, "StasisDeath" ) == 1 )
        {
            string sBlocked = "This being has all but crumbled to dust; a Resurrection will be required to bring it back to life.";
            FloatingTextStringOnCreature( sBlocked, oTarget, TRUE );
            SpeakString( sBlocked, TALKVOLUME_TALK );
        }
        else
        {
            //Apply raise dead effect and VFX impact
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);

            //---------------------------------------------------------
            //clean death settings
            //---------------------------------------------------------
            RemoveDeadStatus( oTarget );
        }
    }
}
