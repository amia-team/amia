const string RECALL_STONE = "recall_stone";
const string LVAR_RECALL_WP = "recall_destination";
const string LVAR_PORTAL_LOC = "portal_location";
//void main (){}
void Recall_ChangeItemName(object player, string newName);
void Recall_SetWaypointTag(object player, string newTag);
string Recall_GetWaypointTag(object player);
location Recall_GetWaypointLocation(object player);

void Recall_SetWaypointTag(object player, string newTag)
{
    object item = GetItemPossessedBy(player, RECALL_STONE);
    SetLocalString(item, LVAR_RECALL_WP, newTag);
}

void Recall_ChangeItemName(object player, string newName)
{
   object item = GetItemPossessedBy(player, RECALL_STONE);
   SetName(item, newName);
}

location Recall_GetWaypointLocation(object player)
{
    object wp = GetObjectByTag(Recall_GetWaypointTag(player));
    location recallLocation = GetLocation(wp);

    return recallLocation;
}

string Recall_GetWaypointTag(object player)
{
    return GetLocalString(GetItemPossessedBy(player, RECALL_STONE), LVAR_RECALL_WP);
}
