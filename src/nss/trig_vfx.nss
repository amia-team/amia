/* Universal vfx'er:    An integer variable "cs_vfx" is referenced from visualeffects.2da
                        A plc with the tag "cs_vfx" is used as the center for the vfx       */
void main(){

    // vars
    object oTrigger=OBJECT_SELF;

    int nVFX=GetLocalInt(
        oTrigger,
        "cs_vfx");

    object oDest=GetNearestObjectByTag(
        "cs_vfx",
        oTrigger,
        1);

    // error control
    if( (oTrigger==OBJECT_INVALID)  ||
        (oDest==OBJECT_INVALID)     ||
        (nVFX<0)                    ){

        return;

    }

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
        EffectVisualEffect(nVFX),
        oDest,
        0.0);

    return;

}
