 #include "inc_hats"
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC = GetItemActivator();
    object oHatBox = GetItemActivated();
    int nHat = GetLocalInt(oPC, "fw_hat");
    int nHatSetup = GetLocalInt(oHatBox, "hatSetup");
    string scriptCalled = GetLocalString(oPC, "ds_action");

    if (nHatSetup == 0)
        {
            SetLocalString( oPC, "ds_action", "i_hatchanger" );
            if (scriptCalled == "") {
                AssignCommand( oPC, ActionStartConversation( oPC, "hatracesel_conv", TRUE, FALSE ) );
            }
            int nNode = GetLocalInt( oPC, "ds_node" );
            if (nNode != 0)
            {
                nHatSetup = nNode;
                SetLocalInt(oHatBox, "hatSetup", nHatSetup);
                SendMessageToPC(oPC,"Your race has been set.");
                DeleteLocalString(oPC, "ds_action");
            }
         } else {
            int nHatRace = nHatSetup;
            if(scriptCalled != "" && scriptCalled == "i_hatchanger")
            {
                int nNode = GetLocalInt( oPC, "ds_node" );
                changeHat(oPC, nNode, nHat, nHatRace, oHatBox);
            }
            else
            {
                //event variables
                int nEvent  = GetUserDefinedItemEventNumber();
                int nResult = X2_EXECUTE_SCRIPT_END;

                switch (nEvent){

                    case X2_ITEM_EVENT_ACTIVATE:

                        if(nHat == 0)
                        {
                            SetLocalString( oPC, "ds_action", "i_hatchanger" );
                            SetLocalObject( oPC, "ds_target", oPC );
                            AssignCommand( oPC, ActionStartConversation( oPC, "hatchanger_conv", TRUE, FALSE ) );
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
                            SetLocalInt(oPC, "fw_hat", 0);
                        }
                    break;
                }
            //Pass the return value back to the calling script
            SetExecutedScriptReturnValue(nResult);
         }
    }
}
