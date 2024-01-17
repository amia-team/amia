/*
    Amia Beacon Activation Script
    -Jes
*/

void SetVariables(object activator);

void main()
{
    object activator  = GetItemActivated();
    object pc         = GetItemActivator();
    string settlement = GetLocalString(activator, "settlement");
    string color      = GetLocalString(activator, "beaconColor");
    string name       = GetName(activator, FALSE);
    int nameSet       = GetLocalInt(activator, "nameSet");
    int isSpawned     = GetLocalInt(activator, "HasSpawned");
    string plcSpawned = GetLocalString(activator,"plcSet");
    int validName;
    string settlementFull;

    if(nameSet != 1){
        if (settlement == "Lagoon"){
            SetLocalString(activator, "plcSet", "plc_solpurple");
            SetLocalString(activator, "beaconColor", "black");
            SetLocalString(activator, "settlementFull", "Blue Lagoon");
            SetVariables(activator);
        }
        else if (settlement == "Dale"){
            SetLocalString(activator, "plcSet", "plc_solcyan");
            SetLocalString(activator, "beaconColor", "cyan");
            SetLocalString(activator, "settlementFull", "The Dale");
            SetVariables(activator);
        }
        else if (settlement == "Shrine"){
            SetLocalString(activator, "plcSet", "plc_solpurple");
            SetLocalString(activator, "beaconColor", "purple");
            SetLocalString(activator, "settlementFull", "The Shrine of Eilistraee");
            SetVariables(activator);
        }
        else if (settlement == "Cystana"){
            SetLocalString(activator, "plcSet", "plc_solyellow");
            SetLocalString(activator, "beaconColor", "yellow");
            SetLocalString(activator, "settlementFull", "Fort Cystana");
            SetVariables(activator);
        }
        else if (settlement == "Greengarden"){
            SetLocalString(activator, "plcSet", "plc_solgreen");
            SetLocalString(activator, "beaconColor", "green");
            SetLocalString(activator, "settlementFull", "Greengarden");
            SetVariables(activator);
        }
        else if (settlement == "Moonpier"){
            SetLocalString(activator, "plcSet", "plc_solpurple");
            SetLocalString(activator, "beaconColor", "pink");
            SetLocalString(activator, "settlementFull", "Moonpier");
            SetVariables(activator);
        }
        else if (settlement == "Oakmist"){
            SetLocalString(activator, "plcSet", "plc_solgreen");
            SetLocalString(activator, "beaconColor", "emerald");
            SetLocalString(activator, "settlementFull", "Oakmist Vale");
            SetVariables(activator);
        }
        else if (settlement == "Ridgewood"){
            SetLocalString(activator, "plcSet", "plc_solorange");
            SetLocalString(activator, "beaconColor", "orange");
            SetLocalString(activator, "settlementFull", "Ridgewood");
            SetVariables(activator);
        }
        else if (settlement == "Salandran"){
            SetLocalString(activator, "plcSet", "plc_solwhite");
            SetLocalString(activator, "beaconColor", "white");
            SetLocalString(activator, "settlementFull", "The Salandran Temple");
            SetVariables(activator);
        }
        else if (settlement == "Southport"){
            SetLocalString(activator, "plcSet", "plc_solred");
            SetLocalString(activator, "beaconColor", "red");
            SetLocalString(activator, "settlementFull", "Southport");
            SetVariables(activator);
        }
        else if (settlement == "TRest"){
            SetLocalString(activator, "plcSet", "plc_solcyan");
            SetLocalString(activator, "beaconColor", "turquoise");
            SetLocalString(activator, "settlementFull", "Traveller's Rest");
            SetVariables(activator);
        }
        else if (settlement == "Whitestag"){
            SetLocalString(activator, "plcSet", "plc_solorange");
            SetLocalString(activator, "beaconColor", "brown");
            SetLocalString(activator, "settlementFull", "Whitestag");
            SetVariables(activator);
        }
        else if (settlement == "Winya"){
            SetLocalString(activator, "plcSet", "plc_solblue");
            SetLocalString(activator, "beaconColor", "blue");
            SetLocalString(activator, "settlementFull", "Winya Ravana");
            SetVariables(activator);
        }
        else {
            SendMessageToAllDMs("Settlement name not entered correctly. Check the Beacon Activator's description for exact spelling and capitalization for the SetVarString command.");
        }
    }

    else if(isSpawned == 1){
        string settlementFull = GetLocalString(activator, "settlementFull");
        SpeakString("*All beacons on Amia isle darken. The threat to "+settlementFull+" has passed.",2);
        ExecuteScript("i_tlk_spawnplc", activator);
    }

    else {
        string settlementFull = GetLocalString(activator, "settlementFull");
        SpeakString("*All beacons on Amia isle suddenly come to life, shining with brilliant "+color+" light! "+settlementFull+" calls for aid urgently!",2);
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
    SetLocalInt(activator, "validName", 1);
}
