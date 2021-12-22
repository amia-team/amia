// mad_plc_ondeath
// OnDeath script for Placables. Allowing them to have two states.
//  New/Functioning, and Destroyed.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/12/2015 M'A.D            Initial Build.
//
//
//Variables placed onto the placable to be broke'd.
//  str sResRef     Blueprint ResRef of the Placable replacing original
//  str sName       Name of new 'broken' placable
//  str sDesc       Description of new 'broken' placable
void main()
{
    object oBrokePlc = CreateObject(
                            OBJECT_TYPE_PLACEABLE,
                            GetLocalString(OBJECT_SELF, "sResRef"),
                            GetLocation(OBJECT_SELF));

    SetName(oBrokePlc, GetLocalString(OBJECT_SELF, "sName"));
    SetDescription(oBrokePlc, GetLocalString(OBJECT_SELF, "sDesc"));
    SetUseableFlag(oBrokePlc, TRUE);
    SetPlotFlag(oBrokePlc, TRUE);
}
