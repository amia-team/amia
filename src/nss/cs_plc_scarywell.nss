// Scary well, jus says Boo to the player once
void main(){

    // vars
    object oPC=GetLastUsedBy();

    // resolve frequency status
    if(GetLocalInt(
        oPC,
        "cs_scary_well")==1){

        return;

    }

    SetLocalInt(
        oPC,
        "cs_scary_well",
        1);

    FloatingTextStringOnCreature(
        "*You hear a hideous voice from within the well* Boo!",
        oPC,
        FALSE);

    return;

}
