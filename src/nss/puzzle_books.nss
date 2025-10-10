#include "nw_i0_generic"

// ---------- DEBUG ----------
int dbgEnabled(){ return GetLocalInt(OBJECT_SELF, "debug"); }
void dbg(object pc, string msg){
    if (!dbgEnabled()) return;
    string full = "PuzzleDebug: " + msg;
    if (GetIsObjectValid(pc)) SendMessageToPC(pc, full);
    PrintString(full);
}

int getReqCount(){ return GetLocalInt(OBJECT_SELF, "req_count"); }
int getRequireOrder(){ return GetLocalInt(OBJECT_SELF, "require_order"); }
string getReqTag(int i){ return GetLocalString(OBJECT_SELF, "req_tag_" + IntToString(i)); }
int getResetOnWrong(){ return GetLocalInt(OBJECT_SELF, "reset_on_wrong"); }

int getSeqIndex(){ return GetLocalInt(OBJECT_SELF, "seq_index"); }
void setSeqIndex(int n){ SetLocalInt(OBJECT_SELF, "seq_index", n); }

int isPuzzleDone(){ return GetLocalInt(OBJECT_SELF, "puzzle_done"); }
void markPuzzleDone(){ SetLocalInt(OBJECT_SELF, "puzzle_done", TRUE); }
void clearPuzzleDone(){ DeleteLocalInt(OBJECT_SELF, "puzzle_done"); }
float getCleanupDelay(){ float s = GetLocalFloat(OBJECT_SELF, "cleanup_delay");
    if (s <= 0.0) s = 120.0;
    return s;
}


object getFulfilledItem(int i){ return GetLocalObject(OBJECT_SELF, "fulfilled_item_" + IntToString(i)); }
void setFulfilledItem(int i, object item){ SetLocalObject(OBJECT_SELF, "fulfilled_item_" + IntToString(i), item); }
void clearFulfilledItem(int i){ DeleteLocalObject(OBJECT_SELF, "fulfilled_item_" + IntToString(i)); }

object getSpawnedObject(){ return GetLocalObject(OBJECT_SELF, "spawned_object"); }
void setSpawnedObject(object obj){ SetLocalObject(OBJECT_SELF, "spawned_object", obj); }
void clearSpawnedObject(){ DeleteLocalObject(OBJECT_SELF, "spawned_object"); }

void safeDestroy(object obj){
    if (GetIsObjectValid(obj)) DestroyObject(obj);
}

int isItemStillInSelfInventory(object item){
    if (!GetIsObjectValid(item)) return FALSE;
    object it = GetFirstItemInInventory(OBJECT_SELF);
    while (GetIsObjectValid(it)){
        if (it == item) return TRUE;
        it = GetNextItemInInventory(OBJECT_SELF);
    }
    return FALSE;
}

void verifyEject(object pc, object item){
    if (!GetIsObjectValid(item)) return;

    if (isItemStillInSelfInventory(item)){
        dbg(pc, "Fallback eject via CopyItem");
        object dup = CopyItem(item, pc, TRUE);
        if (GetIsObjectValid(dup) && GetItemPossessor(dup) == pc){
            DestroyObject(item);
            dbg(pc, "Fallback eject succeeded (CopyItem)");
        }
        else {
            dbg(pc, "CopyItem failed; leaving item in container to avoid data loss.");
        }
    }
    else {
        dbg(pc, "Eject verified: item no longer in container.");
    }
}

void ejectItemTo(object pc, object item){
    if (!GetIsObjectValid(pc) || !GetIsObjectValid(item)) return;

    dbg(pc, "Ejecting item tag=" + GetTag(item));
    DelayCommand(0.25f, AssignCommand(pc, ActionTakeItem(item, OBJECT_SELF)));
    DelayCommand(0.80f, verifyEject(pc, item));
}

void ejectAllItemsTo(object pc){
    object it = GetFirstItemInInventory(OBJECT_SELF);
    while (GetIsObjectValid(it)){
        ejectItemTo(pc, it);
        it = GetNextItemInInventory(OBJECT_SELF);
    }
}

void resetPuzzle(object pc, int alsoEjectAll){
    int reqCount = getReqCount();

    if (alsoEjectAll){
        dbg(pc, "Reset-on-wrong: ejecting all items and resetting puzzle.");
        ejectAllItemsTo(pc);
    } else {
        dbg(pc, "Resetting puzzle state.");
    }

    int i = 1;
    for ( ; i <= reqCount; i++){
        clearFulfilledItem(i);
    }
    setSeqIndex(0);
    clearPuzzleDone();
}

void scheduleCleanupAndReset(float delaySeconds){
    int reqCount = getReqCount();

    dbg(OBJECT_INVALID, "Scheduling cleanup/reset in " + FloatToString(delaySeconds, 0, 2) + "s");

    object spawned = getSpawnedObject();
    if (GetIsObjectValid(spawned)){
        int spawnedType = GetObjectType(spawned);
        int noDestroy = GetLocalInt(OBJECT_SELF, "no_destroy");

        if (spawnedType == OBJECT_TYPE_ITEM){
            dbg(OBJECT_INVALID, "Spawned object is an ITEM; skipping despawn.");
            DelayCommand(delaySeconds, clearSpawnedObject());
        }
        else {
            SetPlotFlag(spawned, FALSE);
            if (noDestroy != 1){
                DelayCommand(delaySeconds, safeDestroy(spawned));
            }
            DelayCommand(delaySeconds, clearSpawnedObject());
        }
    }

    int i = 1;
    for ( ; i <= reqCount; i++){
        object itm = getFulfilledItem(i);
        SetPlotFlag(itm, FALSE);
        if (GetIsObjectValid(itm)) DelayCommand(delaySeconds, safeDestroy(itm));
        DelayCommand(delaySeconds, clearFulfilledItem(i));
    }
    DelayCommand(delaySeconds, clearPuzzleDone());
    DelayCommand(delaySeconds, setSeqIndex(0));
}

int countFulfilledUnordered(){
    int reqCount = getReqCount();
    int fulfilled = 0;
    int i = 1;
    for ( ; i <= reqCount; i++){
        if (GetIsObjectValid(getFulfilledItem(i))) fulfilled++;
    }
    return fulfilled;
}

int acceptFirstMatchingSlotUnordered(string tag, object item){
    int reqCount = getReqCount();
    int i = 1;
    for ( ; i <= reqCount; i++){
        if (!GetIsObjectValid(getFulfilledItem(i))){
            if (getReqTag(i) == tag){
                setFulfilledItem(i, item);
                dbg(OBJECT_INVALID, "Unordered accept: matched slot " + IntToString(i) + " for tag=" + tag);
                return TRUE;
            }
        }
    }
    return FALSE;
}

void tryCompleteAndSpawn(object pc){
    if (isPuzzleDone()){ dbg(pc, "Already completed; ignoring."); return; }

    int reqCount = getReqCount();
    if (reqCount <= 0){
        dbg(pc, "req_count is 0 or unset. Ensure lowercase locals are set.");
        return;
    }

    int done = getRequireOrder() ? getSeqIndex() : countFulfilledUnordered();
    dbg(pc, "Completion check: done=" + IntToString(done) + " / req_count=" + IntToString(reqCount));
    if (done < reqCount) return;

    string spawnResref      = GetLocalString(OBJECT_SELF, "spawn_resref");
    string spawnWpTag       = GetLocalString(OBJECT_SELF, "spawn_wp_tag");
    string spawnNewTag      = GetLocalString(OBJECT_SELF, "spawn_new_tag");
    string spawnNewName     = GetLocalString(OBJECT_SELF, "spawn_new_name");
    string spawnNewBio      = GetLocalString(OBJECT_SELF, "spawn_new_bio");
    string spawnNewPortrait = GetLocalString(OBJECT_SELF, "spawn_new_portrait");
    int spawnNewSkin        = GetLocalInt(OBJECT_SELF, "spawn_new_skin");
    string winMessage       = GetLocalString(OBJECT_SELF, "win_message");
    int spawnType           = GetLocalInt(OBJECT_SELF, "spawn_object_type");

    if (spawnType == 0) spawnType = OBJECT_TYPE_PLACEABLE;
    if (spawnResref == "" || spawnWpTag == ""){
        dbg(pc, "Missing spawn_resref or spawn_wp_tag; cannot spawn.");
        return;
    }
    object wp = GetObjectByTag(spawnWpTag);
    if (!GetIsObjectValid(wp)) wp = GetNearestObjectByTag(spawnWpTag, OBJECT_SELF);
    if (!GetIsObjectValid(wp)){ dbg(pc, "Waypoint not found for tag=" + spawnWpTag); return; }
    location loc = GetLocation(wp);
    dbg(pc, "Spawning resref=" + spawnResref + " at WP tag=" + spawnWpTag);
    object spawned = CreateObject(spawnType, spawnResref, loc, FALSE);
    if (GetIsObjectValid(spawned) && spawnNewTag != ""){
        SetTag(spawned, spawnNewTag);
        if(spawnNewName != ""){
            SetName(spawned, spawnNewName);
        }
        if(spawnNewBio != ""){
            SetDescription(spawned, spawnNewBio);
        }
        if(spawnNewPortrait != ""){
            SetPortraitResRef(spawned, spawnNewPortrait);
        }
        if(spawnNewSkin != 0 && spawnType == 1){
            SetCreatureAppearanceType(spawned, spawnNewSkin);
        }
        dbg(pc, "Spawned! New Tag: " + spawnNewTag + ". New Name: " + spawnNewName + ". New Bio: " + spawnNewBio + "." );
        if(winMessage != ""){
            FloatingTextStringOnCreature(winMessage, pc, TRUE, TRUE);
        };
    }
    else if (GetIsObjectValid(spawned)){
        dbg(pc, "Spawned without new tag.");
    }
    else {
        dbg(pc, "CreateObject failed (invalid resref/type?).");
    }
    setSpawnedObject(spawned);
    markPuzzleDone();

    float delaySeconds = getCleanupDelay();

    dbg(pc, "Using cleanup_delay=" + FloatToString(delaySeconds, 0, 2) + "s");

    scheduleCleanupAndReset(delaySeconds);
}

void handleAdded(object pc, object item){
    if (!GetIsObjectValid(item)) return;

    string wrongMessage = GetLocalString(OBJECT_SELF, "wrong_message");
    string rightMessage = GetLocalString(OBJECT_SELF, "right_message");
    int reqCount        = getReqCount();
    int requireOrder    = getRequireOrder();
    int resetWrong      = getResetOnWrong();

    dbg(pc, "OnDisturbed: ADDED item tag=" + GetTag(item)
              + " | req_count=" + IntToString(reqCount)
              + " | require_order=" + IntToString(requireOrder)
              + " | seq_index=" + IntToString(getSeqIndex()));
    if (isPuzzleDone()){
        dbg(pc, "Puzzle already done; ADDED ignored.");
        return;
    }
    if (reqCount <= 0){
        dbg(pc, "req_count <= 0; container not configured. Ejecting item.");
        ejectItemTo(pc, item);
        return;
    }

    string tag = GetTag(item);

    if (requireOrder){
        int seq = getSeqIndex();
        if (seq >= reqCount){
            dbg(pc, "All items already placed; attempting completion.");
            tryCompleteAndSpawn(pc);
            return;
        }

        string expected = getReqTag(seq + 1);
        dbg(pc, "Ordered mode: expected=" + expected + ", got=" + tag);

        if (expected == "" || tag != expected){
            if (resetWrong){
                resetPuzzle(pc, TRUE);
                if(wrongMessage != ""){
                    FloatingTextStringOnCreature(wrongMessage, pc, TRUE, TRUE);
                }
            }
            else {
                dbg(pc, "Wrong item for slot; ejecting.");
                ejectItemTo(pc, item);
                if(wrongMessage != ""){
                    FloatingTextStringOnCreature(wrongMessage, pc, TRUE, TRUE);
                }
            }
        return;
    }

        if (tag == expected){
            setFulfilledItem(seq + 1, item);
            setSeqIndex(seq + 1);
            dbg(pc, "Accepted item for slot " + IntToString(seq + 1) + ".");
            if(rightMessage != ""){
                FloatingTextStringOnCreature(rightMessage, pc, TRUE, TRUE);
            }
            if (getSeqIndex() >= reqCount) tryCompleteAndSpawn(pc);
        }
        else {
            dbg(pc, "Wrong item for slot; ejecting.");
            if(wrongMessage != ""){
                FloatingTextStringOnCreature(wrongMessage, pc, TRUE, TRUE);
            }
            ejectItemTo(pc, item);
        }
    }
    else {
        dbg(pc, "Unordered mode: trying to match " + tag);
        if (acceptFirstMatchingSlotUnordered(tag, item)){
            int cnt = countFulfilledUnordered();
            dbg(pc, "Accepted (not cursed). Fulfilled " + IntToString(cnt) + "/" + IntToString(reqCount));
            if (cnt >= reqCount) tryCompleteAndSpawn(pc);
        }
        else {
            if (resetWrong){
                resetPuzzle(pc, TRUE);
                if(wrongMessage != ""){
                    FloatingTextStringOnCreature(wrongMessage, pc, TRUE, TRUE);
                }
            }
            else {
                dbg(pc, "Tag not needed or already fulfilled; ejecting.");
                ejectItemTo(pc, item);
                if(wrongMessage != ""){
                    FloatingTextStringOnCreature(wrongMessage, pc, TRUE, TRUE);
                }
            }
        }
    }
}

void handleRemoved(object pc, object item){
    dbg(pc, "OnDisturbed: REMOVED/STOLEN item tag=" + (GetIsObjectValid(item) ? GetTag(item) : "INVALID"));
    if (!GetIsObjectValid(item)) return;

    int reqCount = getReqCount();
    int i = 1;

    for ( ; i <= reqCount; i++){
        object fi = getFulfilledItem(i);
        if (fi == item){
            clearFulfilledItem(i);
            dbg(pc, "Removed an accepted item from slot " + IntToString(i) + "; clearing that slot.");
            break;
        }
    }
    if (getRequireOrder()){
        int newSeq = 0;
        for (i = 1; i <= reqCount; i++){
            object fi = getFulfilledItem(i);
            if (GetIsObjectValid(fi) && isItemStillInSelfInventory(fi)){
                newSeq = i;
            } else {
                break;
            }
        }
        setSeqIndex(newSeq);
        dbg(pc, "Ordered mode: seq_index recalculated to " + IntToString(newSeq));
    }
}

void main(){
    object pc;
    int disturbType;
    object item;

    pc          = GetLastDisturbed();
    disturbType = GetInventoryDisturbType();
    item        = GetInventoryDisturbItem();

    if (dbgEnabled()){
        string t = "UNKNOWN";
        if (disturbType == INVENTORY_DISTURB_TYPE_ADDED)   t = "ADDED";
        if (disturbType == INVENTORY_DISTURB_TYPE_REMOVED) t = "REMOVED";
        if (disturbType == INVENTORY_DISTURB_TYPE_STOLEN)  t = "STOLEN";
        dbg(pc, "OnDisturbed fired. Type=" + t
                 + " | Placeable=" + GetTag(OBJECT_SELF)
                 + " | PC=" + (GetIsObjectValid(pc) ? GetName(pc) : "INVALID"));
    }

    switch (disturbType){
        case INVENTORY_DISTURB_TYPE_ADDED:   handleAdded(pc, item);   break;
        case INVENTORY_DISTURB_TYPE_REMOVED:
        case INVENTORY_DISTURB_TYPE_STOLEN:  handleRemoved(pc, item); break;
    }
}
