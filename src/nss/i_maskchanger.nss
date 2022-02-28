#include "inc_masks"
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC = GetItemActivator();
    object oMaskBox = GetItemActivated();
    int nMask = GetLocalInt(oPC, "fw_mask");
    int nMaskSetup = GetLocalInt(oMaskBox, "maskSetup");
    string scriptCalled = GetLocalString(oPC, "ds_action");

    if (nMaskSetup == 0)
        {
            SetLocalString( oPC, "ds_action", "i_maskchanger" );
            if (scriptCalled == "") {
                AssignCommand( oPC, ActionStartConversation( oPC, "maskracesel_conv", TRUE, FALSE ) );
            }
            int nNode = GetLocalInt( oPC, "ds_node" );
            if (nNode != 0)
            {
                nMaskSetup = nNode;
                SetLocalInt(oMaskBox, "maskSetup", nMaskSetup);
                SendMessageToPC(oPC,"Your race has been set.");
                DeleteLocalString(oPC, "ds_action");
            }
         } else {
            int nMaskRace = nMaskSetup;
            if(scriptCalled != "" && scriptCalled == "i_maskchanger")
            {
                int nNode = GetLocalInt( oPC, "ds_node" );
                changeMask(oPC, nNode, nMask, nMaskRace, oMaskBox);
            }
            else
            {
                //event variables
                int nEvent  = GetUserDefinedItemEventNumber();
                int nResult = X2_EXECUTE_SCRIPT_END;

                switch (nEvent){

                    case X2_ITEM_EVENT_ACTIVATE:

                        if(nMask == 0)
                        {
                            SetLocalString( oPC, "ds_action", "i_maskchanger" );
                            SetLocalObject( oPC, "ds_target", oPC );
                            AssignCommand( oPC, ActionStartConversation( oPC, "maskchanger_conv", TRUE, FALSE ) );
                        }
                        else
                        {
                            AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD) ) ;
                            effect eLoop=GetFirstEffect(oPC);
                            while (GetIsEffectValid(eLoop))
                            {
                                if (GetEffectType(eLoop)==EFFECT_TYPE_VISUALEFFECT)
                                {
                                    RemoveEffect(oPC, eLoop);
                                }
                                eLoop=GetNextEffect(oPC);
                            }
                            SetLocalInt(oPC, "fw_mask", 0);
                        }
                    break;
                }
            //Pass the return value back to the calling script
            SetExecutedScriptReturnValue(nResult);
         }
    }
}
