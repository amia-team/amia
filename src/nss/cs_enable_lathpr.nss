// Enables the Temple of Lathander's protection
void main(){

    // vars
    object oTrigger=OBJECT_SELF;
    object oDest=GetObjectByTag("Pedestal");

    // resolve spawn status: spawn only once
    if(GetLocalInt(
        oTrigger,
        "spawned")==1){

        return;

    }
    else{

        SetLocalInt(
            oTrigger,
            "spawned",
            1);

    }

    // enable Lathander's protection
    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        EffectVisualEffect(497),
        oDest,
        0.0);

    return;

}
