//-------------------------------------------------------------
// OnClick event for Temporal Soul Cyst
//--------------------------------------------------------------
void main()
{
    object oCyst = OBJECT_SELF;
    object oAttacker = GetPlaceableLastClickedBy();

    AssignCommand(oAttacker, ActionAttack(oCyst));
}
