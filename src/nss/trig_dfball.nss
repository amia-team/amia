// Delayed blast fireball vfx:    A waypoint with the tag "wp_dfball" is used for the center of the fireball vfx.
void main(){

    // vars
    object oTrigger=OBJECT_SELF;

    object oDest=OBJECT_INVALID;

    object oSearch=GetFirstInPersistentObject(
        oTrigger,
        OBJECT_TYPE_WAYPOINT,
        PERSISTENT_ZONE_ACTIVE);

    while(oSearch!=OBJECT_INVALID){

        if(GetTag(oSearch)=="wp_dfball"){

            oDest=oSearch;

            break;

        }

        oSearch=GetNextInPersistentObject(
            oTrigger,
            OBJECT_TYPE_WAYPOINT,
            PERSISTENT_ZONE_ACTIVE);

    }

    location lDest=GetLocation(oDest);

    // resolve spawn status: spawn once only
    if( GetLocalInt( oTrigger, "spawned") )
        return;

    SetLocalInt( oTrigger, "spawned", TRUE);

    // resolve vfx status
    ApplyEffectAtLocation(
        DURATION_TYPE_PERMANENT,
        EffectAreaOfEffect(
            AOE_PER_DELAY_BLAST_FIREBALL,
            "****",
            "****",
            "****"),
        lDest,
        0.0);

    return;

}
