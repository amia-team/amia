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
            SetLocalString(activator, "beaconColor", "<c���>black</c>");
            SetLocalString(activator, "settlementFull", "<c���>Blue Lagoon</c>");
            SetVariables(activator);
        }
        else if (settlement == 21){
            SetLocalString(activator, "plcSet", "plc_solcyan");
            SetLocalString(activator, "beaconColor", "<c���>cyan</c>");
            SetLocalString(activator, "settlementFull", "<c���>The Dale</c>");
            SetVariables(activator);
        }
        else if (settlement == 23){
            SetLocalString(activator, "plcSet", "plc_solpurple");
            SetLocalString(activator, "beaconColor", "<cѦ�>purple</c>");
            SetLocalString(activator, "settlementFull", "<cѦ�>The Shrine of Eilistraee</c>");
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
            SetLocalString(activator, "beaconColor", "<cj� >green</c>");
            SetLocalString(activator, "settlementFull", "<cj� >Greengarden</c>");
            SetVariables(activator);
        }
        else if (settlement == 27){
            SetLocalString(activator, "plcSet", "plc_solpurple");
            SetLocalString(activator, "beaconColor", "<c���>pink</c>");
            SetLocalString(activator, "settlementFull", "<c���>Moonpier</c>");
            SetVariables(activator);
        }
        else if (settlement == 29){
            SetLocalString(activator, "plcSet", "plc_solgreen");
            SetLocalString(activator, "beaconColor", "<c|�;>emerald</c>");
            SetLocalString(activator, "settlementFull", "<c|�;>Oakmist Vale</c>");
            SetVariables(activator);
        }
        else if (settlement == 32){
            SetLocalString(activator, "plcSet", "plc_solorange");
            SetLocalString(activator, "beaconColor", "<c��y>orange</c>");
            SetLocalString(activator, "settlementFull", "<c��y>Ridgewood</c>");
            SetVariables(activator);
        }
        else if (settlement == 33){
            SetLocalString(activator, "plcSet", "plc_solwhite");
            SetLocalString(activator, "beaconColor", "<c���>white</c>");
            SetLocalString(activator, "settlementFull", "<c���>The Salandran Temple</c>");
            SetVariables(activator);
        }
        else if (settlement == 35){
            SetLocalString(activator, "plcSet", "plc_solred");
            SetLocalString(activator, "beaconColor", "<c�  >red</c>");
            SetLocalString(activator, "settlementFull", "<c�  >Southport</c>");
            SetVariables(activator);
        }
        else if (settlement == 36){
            SetLocalString(activator, "plcSet", "plc_solcyan");
            SetLocalString(activator, "beaconColor", "<cw��>turquoise</c>");
            SetLocalString(activator, "settlementFull", "<cw��>Traveller's Rest</c>");
            SetVariables(activator);
        }
        else if (settlement == 9){
            SetLocalString(activator, "plcSet", "plc_solorange");
            SetLocalString(activator, "beaconColor", "<c�w >brown</c>");
            SetLocalString(activator, "settlementFull", "<c�w >Whitestag Shore</c>");
            SetVariables(activator);
        }
        else if (settlement == 38){
            SetLocalString(activator, "plcSet", "plc_solblue");
            SetLocalString(activator, "beaconColor", "<cp|�>blue</c>");
            SetLocalString(activator, "settlementFull", "<cp|�>Winya Ravana</c>");
            SetVariables(activator);
        }
        else {
            SendMessageToAllDMs("Settlement name not entered correctly. Check the Beacon Activator's description for exact spelling and capitalization for the SetVarString command.");
        }
    }

    else if(isSpawned == 1){
        string settlementFull = GetLocalString(activator, "settlementFull");
        string beaconAlarm = "<c���>*All beacons on Amia isle darken. The threat to </c>"+settlementFull+"<c���> has passed.</c>";
        SetLocalString(activator, "beaconMessage", beaconAlarm);
        MassWhisper(activator);
        ExecuteScript("i_tlk_spawnplc", activator);
    }

    else {
        string settlementFull = GetLocalString(activator, "settlementFull");
        string beaconAlarm = "<c�oY>*All beacons on Amia isle suddenly come to life, shining with brilliant </c>"+color+"<c�oY> light! </c>"+settlementFull+"<c�oY> calls for aid urgently!</c>";
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

    SetName(activator,"<c���>"+settlementFull+" Beacon Activator</c>");
    SetDescription(activator, "Use this to activate your settlement's beacon and call for help. This activator is set to <c���>"+settlementFull+"</c>. Warning: This will activate all beacons across Amia and send up a Shout call-to-arms. Use this carefully.");
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
