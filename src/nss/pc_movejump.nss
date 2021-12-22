
// Added by PC: A moveto function which walks if a PC is in the area, or jumps if one is not
// This is here to get around the pathing "problems" introduced in patches 1.30 and 1.31


void MoveJump(object oMoveTo, int bRun=FALSE, float fRange=1.0f)
{
    object oPCArea = GetLocalObject(GetModule(),"oPCArea");
    if (oPCArea==GetArea(OBJECT_SELF) || oPCArea==GetArea(oMoveTo)
        || GetLocalInt(OBJECT_SELF,"bNoForceMove")) {
        // There is a PC in the area, walk normally
        SetLocalInt(OBJECT_SELF,"bForceMove",FALSE);
        }
    else {
        // There is no PC in the area, do a jump
        AssignCommand(OBJECT_SELF,JumpToObject(oMoveTo));
        SetLocalInt(OBJECT_SELF,"bForceMove",TRUE);
        }

}

void ActionMoveJump(object oMoveTo, int bRun=FALSE, float fRange=1.0f, float fPause=1.0)
{
    ActionDoCommand(MoveJump(oMoveTo,bRun,fRange));         // Check for PC and jump if not present
    ActionMoveToObject(oMoveTo,bRun,fRange);                // Start walking
    if (fPause>0.0)
        ActionWait(fPause);
}

/* Original code:
void MoveJump(object oMoveTo, int bRun=FALSE, float fRange=1.0f, float fPause=1.0)
{
    if (GetLocalObject(GetModule(),"oPCArea")==GetArea(OBJECT_SELF)
        || GetLocalInt(OBJECT_SELF,"bNoForceMove")) {
        // There is a PC in the area, walk normally
        ActionMoveToObject(oMoveTo,bRun,fRange);
        SetLocalInt(OBJECT_SELF,"bForceMove",FALSE);
        }
    else {
        // There is no PC in the area, do a forcemove
        ActionForceMoveToObject(oMoveTo,bRun,fRange,30.0);
        SetLocalInt(OBJECT_SELF,"bForceMove",TRUE);
        ActionDoCommand(SetLocalInt(OBJECT_SELF,"bForceMove",FALSE));
        }

    if (fPause>0.0)
        ActionWait(fPause);
}

void ActionMoveJump(object oMoveTo, int bRun=FALSE, float fRange=1.0f, float fPause=1.0)
{
    ActionDoCommand(MoveJump(oMoveTo,bRun,fRange,fPause));
}
*/
