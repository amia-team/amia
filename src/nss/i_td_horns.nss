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

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
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

int     iVFX    = GetLocalInt( OBJECT_SELF, "td_horn" );
effect  eGlow   = GetFirstEffect( oPC );
int     iExists = FALSE;

    if( iVFX <= 0 )
    {
    SendMessageToPC( oPC, "FAILED TO GET HORN DATA!" );
    return;
    }

    while( GetIsEffectValid( eGlow ) )
    {
        if( GetEffectCreator( eGlow ) == OBJECT_SELF )
        {
        iExists = TRUE;
        break;
        }
    eGlow = GetNextEffect( oPC );
    }

    if( iExists )
    {
    RemoveEffect( oPC, eGlow );
    SendMessageToPC( oPC, "Your horns were concealed" );
    return;
    }
    else
    {
    eGlow = SupernaturalEffect( EffectVisualEffect( iVFX ) );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eGlow, oPC );
    SendMessageToPC( oPC, "Your horns were revealed" );
    return;
    }

}


