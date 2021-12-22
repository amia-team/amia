//-------------------------------------------------------------------------------
//COMMENTS: I will make this script universal and integrate it with Bustier's Dyechest
//COMMENTS: the script is a bit of a mess, as I am still undecided on Bobo's language
//-------------------------------------------------------------------------------
// Bobo's commands
// Set ambience template: 'ambience #template'

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "amia_include"
//#include "nw_i0_generic"
#include "x2_inc_itemprop"
#include "ds_inc_ambience"


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    int iMatch = GetListenPatternNumber();
    int nMatch = GetMatchedSubstringsCount();
    int nError=0;
    int i=0;
    string sInput;
    object oShouter = GetLastSpeaker();
    object oPC=GetLocalObject(OBJECT_SELF, "oActivator");
    object oArea=GetArea(oPC);

    ClearAllActions(); //just to be sure

    //if the password matches, and is spoken by the right person then continue
    if(iMatch == 30440 && GetIsObjectValid(oShouter) && oShouter == oPC){

        //get the part AFTER the password
        while(i<nMatch){
            if(i==1){
                sInput=GetStringLowerCase(GetMatchedSubstring(i));
            }
            i++;
        }

        if(sInput=="close" || sInput=="begone"){
             DestroyObject(OBJECT_SELF,1.0);         //destroy Bobo
        }
        else if(sInput=="stay"){
             ClearAllActions();                      //park Bobo somewhere
        }
        else {
             tha_override_template(oPC, oArea, sInput);
             ActionForceFollowObject(oPC,1.0);       //to let Bobo follow you
        }
    }
    /*
    //no clue what this does
    if( GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT){
        SignalEvent(OBJECT_SELF, EventUserDefined(1004));
    }*/
}


