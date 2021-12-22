/*  ds_cordor_shops

--------
Verbatim
--------
Generic shop opener with greeting

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
08-29-06  Disco       Start of header
------------------------------------------------------------------

*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "nw_i0_plot"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    object oPC=GetPCSpeaker();
    string sNPCName=GetName(OBJECT_SELF);
    string sNPCtag=GetTag(OBJECT_SELF);
    object oStore = GetNearestObjectByTag(sNPCtag+"_s");

    if ( oStore == OBJECT_INVALID ) {
        oStore = CreateObject( OBJECT_TYPE_STORE, sNPCtag, GetLocation(OBJECT_SELF), FALSE, sNPCtag+"_s" );
    }

    if(sNPCName=="Biagribo Peshgather"){
        AssignCommand(OBJECT_SELF, SpeakString("Want a nice glass of ale?!"));
    }
    else if(sNPCName=="Dent Addams"){
        AssignCommand(OBJECT_SELF, SpeakString("Wine? Ale? Spirits? Best there is!"));
    }
    else if(sNPCName=="Alie Kelteel"){
        AssignCommand(OBJECT_SELF, SpeakString("Wine? Ale? .... a glass of milk, perhaps?"));
    }
    else if(sNPCName=="Gerthma the Butcher"){
        AssignCommand(OBJECT_SELF, SpeakString("You? Meat?"));
    }
    else if(sNPCName=="Balfalan the Baker"){
        AssignCommand(OBJECT_SELF, SpeakString("You won't find any finer bread, I assure you!"));
    }
    else if(sNPCName=="Signor the Herbalist"){
        AssignCommand(OBJECT_SELF, SpeakString("Appetisers? Energisers? Base products? Tell me what you need!"));
    }
    else if(sNPCName=="Seedy Neville"){
        AssignCommand(OBJECT_SELF, SpeakString("Ale? Or sumfink ... stronger? I gots the best stuff der is!"));
    }
    else{
        AssignCommand(OBJECT_SELF, SpeakString("Have a look!"));
    }

    if(oStore != OBJECT_INVALID){
        OpenStore(oStore, oPC,0,0);
        db_trace_shop( GetPCSpeaker(), oStore, OBJECT_SELF );
    }
    else{
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}



