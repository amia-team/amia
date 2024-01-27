/*
    Amia Beacon Activation Script
    -Jes
*/

void SetVariables(object activator);
void MassWhisper(object activator);

void main()
{
    object activator  = GetItemActivated();
    object pc         = GetItemActivator();
    int settlement    = GetLocalInt(activator, "settlement");
    string color      = GetLocalString(activator, "beaconColor");
    string name       = GetName(activator, FALSE);
    int nameSet       = GetLocalInt(activator, "nameSet");
    int isSpawned     = GetLocalInt(activator, "HasSpawned");
    string plcSpawned = GetLocalString(activator,"plcSet");
    string settlementFull;

    if(nameSet != 1){
        if (settlement == 18){
            SetLocalString(activator, "plcSet", "plc_solpurple");
            SetLocalString(activator, "beaconColor", "<c¥¥¥>black</c>");
            SetLocalString(activator, "settlementFull", "<c¥¥¥>Blue Lagoon</c>");
            SetVariables(activator);
        }
        else if (settlement == 21){
            SetLocalString(activator, "plcSet", "plc_solcyan");
            SetLocalString(activator, "beaconColor", "<c´ÿÿ>cyan</c>");
            SetLocalString(activator, "settlementFull", "<c´ÿÿ>The Dale</c>");
            SetVariables(activator);
        }
        else if (settlement == 23){
            SetLocalString(activator, "plcSet", "plc_solpurple");
            SetLocalString(activator, "beaconColor", "<cÑ¦ÿ>purple</c>");
            SetLocalString(activator, "settlementFull", "<cÑ¦ÿ>The Shrine of Eilistraee</c>");
            SetVariables(activator);
        }
        else if (settlement == 6){
            SetLocalString(activator, "plcSet", "plc_solyellow");
            SetLocalString(activator, "beaconColor", "yellow");
            SetLocalString(activator, "settlementFull", "Fort Cystana");
            SetVariables(activator);
        }
        else if (settlement == 7){
            SetLocalString(activator, "plcSet", "plc_solgreen");
            SetLocalString(activator, "beaconColor", "<cjÙ >green</c>");
            SetLocalString(activator, "settlementFull", "<cjÙ >Greengarden</c>");
            SetVariables(activator);
        }
        else if (settlement == 27){
            SetLocalString(activator, "plcSet", "plc_solpurple");
            SetLocalString(activator, "beaconColor", "<cÿ¿ù>pink</c>");
            SetLocalString(activator, "settlementFull", "<cÿ¿ù>Moonpier</c>");
            SetVariables(activator);
        }
        else if (settlement == 29){
            SetLocalString(activator, "plcSet", "plc_solgreen");
            SetLocalString(activator, "beaconColor", "<c|ÿ;>emerald</c>");
            SetLocalString(activator, "settlementFull", "<c|ÿ;>Oakmist Vale</c>");
            SetVariables(activator);
        }
        else if (settlement == 32){
            SetLocalString(activator, "plcSet", "plc_solorange");
            SetLocalString(activator, "beaconColor", "<cÿÅy>orange</c>");
            SetLocalString(activator, "settlementFull", "<cÿÅy>Ridgewood</c>");
            SetVariables(activator);
        }
        else if (settlement == 33){
            SetLocalString(activator, "plcSet", "plc_solwhite");
            SetLocalString(activator, "beaconColor", "<cþþÿ>white</c>");
            SetLocalString(activator, "settlementFull", "<cþþÿ>The Salandran Temple</c>");
            SetVariables(activator);
        }
        else if (settlement == 35){
            SetLocalString(activator, "plcSet", "plc_solred");
            SetLocalString(activator, "beaconColor", "<cë  >red</c>");
            SetLocalString(activator, "settlementFull", "<cë  >Southport</c>");
            SetVariables(activator);
        }
        else if (settlement == 36){
            SetLocalString(activator, "plcSet", "plc_solcyan");
            SetLocalString(activator, "beaconColor", "<cwÿØ>turquoise</c>");
            SetLocalString(activator, "settlementFull", "<cwÿØ>Traveller's Rest</c>");
            SetVariables(activator);
        }
        else if (settlement == 9){
            SetLocalString(activator, "plcSet", "plc_solorange");
            SetLocalString(activator, "beaconColor", "<c´w >brown</c>");
            SetLocalString(activator, "settlementFull", "<c´w >Whitestag Shore</c>");
            SetVariables(activator);
        }
        else if (settlement == 38){
            SetLocalString(activator, "plcSet", "plc_solblue");
            SetLocalString(activator, "beaconColor", "<cp|ÿ>blue</c>");
            SetLocalString(activator, "settlementFull", "<cp|ÿ>Winya Ravana</c>");
            SetVariables(activator);
        }
        else {
            SendMessageToAllDMs("Settlement name not entered correctly. Check the Beacon Activator's description for exact spelling and capitalization for the SetVarString command.");
        }
    }

    else if(isSpawned == 1){
        string settlementFull = GetLocalString(activator, "settlementFull");
        string beaconAlarm = "<c¨ÿ°>*All beacons on Amia isle darken. The threat to </c>"+settlementFull+"<c¨ÿ°> has passed.</c>";
        SetLocalString(activator, "beaconMessage", beaconAlarm);
        MassWhisper(activator);
        ExecuteScript("i_tlk_spawnplc", activator);
    }

    else {
        string settlementFull = GetLocalString(activator, "settlementFull");
        string beaconAlarm = "<cÿoY>*All beacons on Amia isle suddenly come to life, shining with brilliant </c>"+color+"<cÿoY> light! </c>"+settlementFull+"<cÿoY> calls for aid urgently!</c>";
        SetLocalString(activator, "beaconMessage", beaconAlarm);
        MassWhisper(activator);
        ExecuteScript("i_tlk_spawnplc", activator);
    }
}



void SetVariables(object activator){
    object pc             = GetItemActivator();
    object activator      = GetItemActivated();
    string settlementFull = GetLocalString(activator, "settlementFull");
    string plcSpawned     = GetLocalString(activator,"plcSet");

    SetName(activator,"<cýÿÍ>"+settlementFull+" Beacon Activator</c>");
    SetDescription(activator, "Use this to activate your settlement's beacon and call for help. This activator is set to <cýÿÍ>"+settlementFull+"</c>. Warning: This will activate all beacons across Amia and send up a Shout call-to-arms. Use this carefully.");
    SendMessageToPC(pc, "Beacon Activator attuned to "+settlementFull+"!");
    SetLocalString(activator, "SpawnPLC1", plcSpawned);
    SetLocalString(activator, "SpawnPLC2", plcSpawned);
    SetLocalString(activator, "SpawnPLC3", plcSpawned);
    SetLocalString(activator, "SpawnPLC4", plcSpawned);
    SetLocalString(activator, "SpawnPLC5", plcSpawned);
    SetLocalString(activator, "SpawnPLC6", plcSpawned);
    SetLocalString(activator, "SpawnPLC7", plcSpawned);
    SetLocalString(activator, "SpawnPLC8", plcSpawned);
    SetLocalString(activator, "SpawnPLC9", plcSpawned);
    SetLocalString(activator, "SpawnPLC10", plcSpawned);
    SetLocalString(activator, "SpawnPLC11", plcSpawned);
    SetLocalString(activator, "SpawnPLC12", plcSpawned);
    SetLocalString(activator, "SpawnPLC13", plcSpawned);
    SetLocalInt(activator, "nameSet", 1);
}

void MassWhisper(object activator){
  object pc =  GetFirstPC();
  string beaconAlarm = GetLocalString(activator, "beaconMessage");

  while(GetIsObjectValid(pc) == TRUE)
  {
    SendMessageToPC(pc, "-----");
    SendMessageToPC(pc, "-----");
    SendMessageToPC(pc, beaconAlarm);
    SendMessageToPC(pc, "-----");
    SendMessageToPC(pc, "-----");
    pc = GetNextPC();
  }
}
