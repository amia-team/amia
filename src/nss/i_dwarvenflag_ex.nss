// See main file: i_dwarvenflag
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2015/12/12 BasicHuman       Initial Release.

void main()
{
    object oAOECreator = GetAreaOfEffectCreator();
    object oExitingCreature = GetExitingObject();

    effect e = GetFirstEffect(oExitingCreature);
    while(GetIsEffectValid(e))
    {
        if(GetEffectCreator(e) == oAOECreator)
        {
            RemoveEffect(oExitingCreature, e);
        }
        e = GetNextEffect(oExitingCreature);
    }
}
