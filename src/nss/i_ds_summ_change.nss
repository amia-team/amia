/*  i_ds_summ_change

--------
Verbatim
--------
Gives summons a custom name, skin and portrait

---------
Changelog
---------

Date    Name        Reason
------------------------------------------------------------------
122506  Disco       Start of header
091708  Terra       Upgraded to be able to copy full appearance template
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_td_appearanc"
//#include "aps_include"
//#include "amia_include"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void change_summon( object oPC, object oTarget, object oItem );

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

            if ( GetResRef( oItem ) == "ds_summon_change" ){

                change_summon( oPC, oTarget, oItem );
            }


        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------

void change_summon( object oPC, object oTarget, object oItem )
{

        if ( !GetIsDM( oPC ) ){
        //if(FALSE){

            SendMessageToPC(oPC, "Only a DM can activate this item.");

            return;
        }

        int iAdv = GetLocalInt( oItem, "skin_adv_mode" );

        if( GetItemActivatedTarget() == oItem && iAdv != 1 )
        {
        SetLocalInt( oItem , "skin_adv_mode", 1 );
        SendMessageToPC( oPC, "Summon skinchanger set to advanced mode, it will now copy the full appearance template.");
        return;
        }
        else if( GetItemActivatedTarget() == oItem && iAdv != 0 )
        {
        SetLocalInt( oItem , "skin_adv_mode", 0 );
        SendMessageToPC( oPC, "Summon skinchanger set to basic mode, it will now only copy name, appearance, portait and tail.");
        return;
        }

        if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ){

            SendMessageToPC( oPC, "You can only use this item on a creature!" );
            return;
        }

    if( GetLocalString( oItem , "temp_target") == "" )
    {

        string sVariable;

        if ( GetAssociateType( oTarget ) ==  ASSOCIATE_TYPE_FAMILIAR ){
        sVariable     = "familiar";
        }
        else if ( GetAssociateType( oTarget ) ==  ASSOCIATE_TYPE_ANIMALCOMPANION ){
        sVariable     = "companion";
        }
        else if ( GetAssociateType( oTarget ) ==  ASSOCIATE_TYPE_SUMMONED ){
        sVariable     = GetResRef( oTarget );
        }
        else{

            SendMessageToPC( oPC, "You must target a summon first to attune this item!" );
            return;
        }
        SetLocalString( oItem, "temp_target", sVariable);

        SendMessageToPC( oPC, "Summon Changer initialized to "+GetName( oTarget )+" ("+sVariable+")\n now target the creature that has the desired appearance." );

        SendMessageToPC( oPC, "-* The widget is in"+(iAdv ? " Advanced" : " Basic")+" mode. *-");

        SetLocalString( oItem, "temp_name", GetName( oTarget ) );

        SetName( oItem, "Summon Changer: Initialised" );
    }
    else
    {
        string sName = GetLocalString( oItem , "temp_name");
        string sType = GetLocalString( oItem , "temp_target");

        if(iAdv == 1)SaveADVAppearanceToItem( oTarget, oItem, sType );
        else{
            if( GetAppearanceType( oTarget ) > 6 )
            SaveBasicAppearance( oTarget, sType, oItem );
            else
            {
            SendMessageToPC( oPC, "Cannot skinchange summons with player models, set widget to advanced mode if you want to clone a pc model appearance by targeting the widget with the widget." );
            return;
            }

        }


        sName += iAdv ? " Advanced" : " Basic";

        if( GetSubString(GetDescription( oItem ), 0, 3) == "OOC" )
        SetDescription(oItem, "This widget holds skinchanges for the following:\n"+sName );

        else
        SetDescription(oItem, GetDescription( oItem )+"\n"+sName );

        DelayCommand(3.0,DeleteLocalString( oItem, "temp_target" ));
        DelayCommand(3.0,DeleteLocalString( oItem, "temp_name" ));
        DeleteLocalInt(oItem, "skin_adv_mode");

        SetName( oItem, "Summon Changer: Attuned" );

        SendMessageToPC( oPC, "Summon Changer attuned, it can now be given to the desired PC" );

    }
}
