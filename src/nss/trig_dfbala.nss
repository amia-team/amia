// Natures Balance vfx:    A waypoint with the tag "wp_dfbala" is used for the center of the vfx.
void main(){

    // vars
    object oTrigger=OBJECT_SELF;

    object oDest=OBJECT_INVALID;

    object oSearch=GetFirstInPersistentObject(
        oTrigger,
        OBJECT_TYPE_WAYPOINT,
        PERSISTENT_ZONE_ACTIVE);

    while(oSearch!=OBJECT_INVALID){

        if(GetTag(oSearch)=="wp_bala"){

            oDest=oSearch;

            break;

        }

        oSearch=GetNextInPersistentObject(
            oTrigger,
            OBJECT_TYPE_WAYPOINT,
            PERSISTENT_ZONE_ACTIVE);

    }

    location lDest=GetLocation(oDest);

    // error checking
    if( (oTrigger==OBJECT_INVALID)  ||
        (oDest==OBJECT_INVALID)     ){

        return;

    }

    // resolve spawn status: spawn once only
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

    // resolve vfx status
    ApplyEffectAtLocation(
        DURATION_TYPE_PERMANENT,
        EffectAreaOfEffect(
            VFX_FNF_NATURES_BALANCE,
            "****",
            "****",
            "****"),
        lDest,
        0.0);

    return;

}
