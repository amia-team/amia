//::///////////////////////////////////////////////
//:: FileName xa_s_openhvmer
//:://////////////////////////////////////////////
void main()
{

    // Either open the store with that tag or let the user know that no store exists.
    object oStore = GetNearestObjectByTag("xa_m_hvmerch");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
        OpenStore(oStore, GetPCSpeaker());
    else
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
