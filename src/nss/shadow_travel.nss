/*
    Created: 10/24/2025
    Creator: TheLoafyOne
    Description: Script used to initiate a conversation file that teleports
    players to places via the shadowplane.
*/

void main() {
    string tDestination = GetScriptParam("destination");
    object tWaypoint = GetObjectByTag(tDestination);

    // Grab the first players location for teleporting
    location playerLoc = GetLocation(GetLastSpeaker());
    float teleportRadius = 7.0;
    effect teleSmoke = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    object leadPlayer = GetLastSpeaker();
    object partyMember = GetFirstFactionMember(leadPlayer, TRUE);

    // Teleport the first player then worry about the others
    if (tWaypoint != OBJECT_INVALID) {
    ApplyEffectToObject(DURATION_TYPE_INSTANT, teleSmoke,leadPlayer);
    DelayCommand(2.0f,AssignCommand(leadPlayer,JumpToObject(tWaypoint)));

    object objectsInSphere = GetFirstObjectInShape(SHAPE_SPHERE,teleportRadius,playerLoc,FALSE,OBJECT_TYPE_CREATURE);

    while(GetIsObjectValid(objectsInSphere) == TRUE) {
        while(GetIsObjectValid(partyMember) == TRUE) {
            if (GetIsPC(objectsInSphere) == TRUE && objectsInSphere == partyMember) {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, teleSmoke,partyMember);
                    DelayCommand(2.0f,AssignCommand(partyMember,JumpToObject(tWaypoint)));
            }
            partyMember = GetNextFactionMember(leadPlayer, TRUE);
        }
    objectsInSphere = GetNextObjectInShape(SHAPE_SPHERE,teleportRadius,playerLoc,FALSE,OBJECT_TYPE_CREATURE);
    }
    }

}
