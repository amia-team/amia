//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_td_glowy_eyes
//description: glowy eye toggle
//used as: item activation script
//date:    sep 22 08
//author:  Terra

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "nwnx_effects"
#include "inc_nwnx_events"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void ToggleGlowyEyes( object oPC );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            // item activate variables
            object oPC       = InstantGetItemActivator();
            object oItem     = InstantGetItemActivated();
            AssignCommand( oItem, ToggleGlowyEyes( oPC ) );

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
void ToggleGlowyEyes( object oPC )
{

int     iVFX    = GetLocalInt( OBJECT_SELF, "td_color" );
effect  eGlow   = GetFirstEffect( oPC );
int     iExists = FALSE;

    if( iVFX <= 0 )
    {
    SendMessageToPC( oPC, "FAILED TO GET GLOWING EYE DATA!" );
    return;
    }

    while( GetIsEffectValid( eGlow ) )
    {
        if( GetEffectSpellId( eGlow ) == 5134 )
        {
        iExists = TRUE;
        break;
        }
    eGlow = GetNextEffect( oPC );
    }

    if( iExists )
    {
    RemoveEffect( oPC, eGlow );
    SendMessageToPC( oPC, "Your glowing eyes faded" );
    return;
    }
    else
    {
    eGlow = SupernaturalEffect( EffectVisualEffect( iVFX ) );
    eGlow = SetEffectSpellID( eGlow, 5134 );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eGlow, oPC );
    SendMessageToPC( oPC, "Your glowing eyes flared up" );
    return;
    }

}


