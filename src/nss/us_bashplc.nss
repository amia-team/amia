//------------------------------------------------------------------------------
// Simple OnUse Placeable script to set the default click to Bash the PLC
//------------------------------------------------------------------------------

void main()
{
    object oPC = GetLastUsedBy();
    object oPLC = OBJECT_SELF;

    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, DoPlaceableObjectAction( oPLC, PLACEABLE_ACTION_BASH ) );
}
