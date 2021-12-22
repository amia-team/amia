/*  i_ds_visualizer

--------
Verbatim
--------
Gives PC up to three custom visuals for permanent duration

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2013-06-24   PoS         Start of header
2015-03-24   PoS         Added optional support for targeting others
2017-08-04   msheeler    Added check to stop removal of Ioun stone visuals
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void add_visuals( object oPC, object oTarget, object oItem );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();

            if(!GetIsObjectValid(oTarget)) {
                oTarget = oPC;
            }

            add_visuals( oPC, oTarget, oItem );

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------


void add_visuals( object oPC, object oTarget, object oItem ){

    //variables
    int nVisual1            = GetLocalInt( oItem, "pc_vfx1" );
    int nVisual2            = GetLocalInt( oItem, "pc_vfx2" );
    int nVisual3            = GetLocalInt( oItem, "pc_vfx3" );
    int nVisualDur1         = GetLocalInt( oItem, "pc_vfx_dur1" );
    int nVisualDur2         = GetLocalInt( oItem, "pc_vfx_dur2" );
    int nVisualDur3         = GetLocalInt( oItem, "pc_vfx_dur3" );
    int nVisualSwitch       = GetLocalInt( oItem, "switch" );

    if( nVisualSwitch == 0 )
    {
        FloatingTextStringOnCreature( "Applying visuals:", oPC, FALSE );

        if( nVisual1 > 0 )
        {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVisual1 ), oTarget );
            FloatingTextStringOnCreature( "Visual 1: " + IntToString( nVisual1 ), oPC, FALSE );
        }
        if( nVisual2 > 0 )
        {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVisual2 ), oTarget );
            FloatingTextStringOnCreature( "Visual 2: " + IntToString( nVisual2 ), oPC, FALSE );
        }

        if( nVisual3 > 0 )
        {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVisual3 ), oTarget );
            FloatingTextStringOnCreature( "Visual 3: " + IntToString( nVisual3 ), oPC, FALSE );
        }

        if( nVisualDur1 > 0 )
        {
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( nVisualDur1 ) ), oTarget );
            FloatingTextStringOnCreature( "Perma Visual 1: " + IntToString( nVisualDur1 ), oPC, FALSE );
        }
        if( nVisualDur2 > 0 )
        {
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( nVisualDur2 ) ), oTarget );
            FloatingTextStringOnCreature( "Perma Visual 2: " + IntToString( nVisualDur2 ), oPC, FALSE );
        }
        if( nVisualDur3 > 0 )
        {
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( nVisualDur3 ) ), oTarget );
            FloatingTextStringOnCreature( "Perma Visual 3: " + IntToString( nVisualDur3 ), oPC, FALSE );
        }

        SetLocalInt( oItem, "switch", 1 );
        FloatingTextStringOnCreature( "...Done!", oPC, FALSE );
    }

    else if( nVisualSwitch == 1 ) {

        FloatingTextStringOnCreature( "Removing visuals:", oPC, FALSE );

        int i;

        effect eEffect = GetFirstEffect( oTarget );
        while ( GetIsEffectValid(eEffect) ) {

            if ( GetEffectType( eEffect ) == EFFECT_TYPE_VISUALEFFECT && GetEffectSubType( eEffect ) == SUBTYPE_SUPERNATURAL )
            {
                if (GetEffectSpellId(eEffect) != SPELL_IOUN_STONE_BLUE && GetEffectSpellId(eEffect) && SPELL_IOUN_STONE_DEEP_RED &&
                    GetEffectSpellId(eEffect) != SPELL_IOUN_STONE_DUSTY_ROSE && GetEffectSpellId(eEffect) != SPELL_IOUN_STONE_PALE_BLUE &&
                    GetEffectSpellId(eEffect) != SPELL_IOUN_STONE_PINK && GetEffectSpellId(eEffect) !=SPELL_IOUN_STONE_PINK_GREEN &&
                    GetEffectSpellId(eEffect) != SPELL_IOUN_STONE_SCARLET_BLUE)
                {
                    i++;
                    RemoveEffect( oTarget, eEffect );
                    FloatingTextStringOnCreature( "Removing visual no. " + IntToString( i ), oPC, FALSE );
                }
            }

            eEffect = GetNextEffect( oTarget );
        }

        SetLocalInt( oItem, "switch", 0 );
        FloatingTextStringOnCreature( "...Done!", oPC, FALSE );
    }
}
