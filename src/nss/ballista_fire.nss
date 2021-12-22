// Put in OnUsed on a ballista with the string variable fire_target and the name of the waypoint,
//to get it to fire at the target. Also needs the ammunitiom in order to fire reserf for ammo is ballista_ammo
// Created by Dicey and RaveN


               void main()
{
    string sDeny;

    object oPC = GetLastUsedBy();

    if (!GetIsPC(oPC)) return;

    if (GetItemPossessedBy(oPC, "ballista_ammo")== OBJECT_INVALID) {

       sDeny="*the ballista isn't loaded, get some ammunition!*";

       SendMessageToPC(oPC, sDeny);

       return;
    }

    AssignCommand(OBJECT_SELF, ActionSpeakString("*The ballista fires off an exploding bolt at the targeted area!*"));

    object oCaster = oPC;

    // object oTarget;

    string sWaypointName = GetLocalString( OBJECT_SELF, "fire_target" );
    object oWaypoint = GetWaypointByTag( sWaypointName );

    //used in locations
    location lWaypoint = GetLocation( oWaypoint );

    AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_ISAACS_GREATER_MISSILE_STORM, lWaypoint, METAMAGIC_MAXIMIZE, TRUE, PROJECTILE_PATH_TYPE_DEFAULT,TRUE));

    object oItem;
    oItem = GetFirstItemInInventory(oPC);

    while (GetIsObjectValid(oItem)) {
        if (GetTag(oItem)=="ballista_ammo") DestroyObject(oItem);

        oItem = GetNextItemInInventory(oPC);
   }

}
