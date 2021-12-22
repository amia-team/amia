// update the demiplane player status
void main(){

    // vars
    object oArea=OBJECT_SELF;
    object oPC=GetEnteringObject();
    int nPlayersPresent=GetLocalInt(
        oArea,
        "cs_players_present");

    if(GetIsDM(oPC)==FALSE){

        SetLocalInt(
            oArea,
            "cs_players_present",
            --nPlayersPresent);

    }

    return;

}
