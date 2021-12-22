// Conversation action to fall over (good for drunks).
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050312   jking            Initial release.
//

void main()
{
    if (d2() == 2)
        AssignCommand(OBJECT_SELF,
            ActionPlayAnimation(
                (d2() == 2) ? ANIMATION_LOOPING_DEAD_BACK :
                              ANIMATION_LOOPING_DEAD_FRONT, 0.8f, 20.0f));
}
