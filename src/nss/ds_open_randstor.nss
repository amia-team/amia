/*  ds_open_dyestore

    --------
    Verbatim
    --------
    Opens a dyestore. This shops is dynamically filled,
    so I didn't use the standard Amia open shop script.
    If the shop isn't available the party is over.

    ---------
    Changelog
    ---------
    Date              Name        Reason
    ------------------------------------------------------------------
    04-30-2006        disco       start of header
    ------------------------------------------------------------------

*/


void main(){
    object oStore = GetNearestObjectByTag("ds_random_store");
    if (GetObjectType(oStore) == OBJECT_TYPE_STORE){
        OpenStore(oStore, GetPCSpeaker());
    }
    else{
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}
