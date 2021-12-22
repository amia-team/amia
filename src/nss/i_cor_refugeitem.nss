/* OnUse Event for Refuge Item from Cordor

If no hostiles are nearby, and PC is in the Nexus or a linked location, will
teleport the PC only back to Ildrar in Cordor and destroy the item.

Also checks to make sure no dominated critters are extracted from the epic
dungeons to run rampant elsewhere.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
28/01/15 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"

void ActivateItem()
{
    object oPC = GetItemActivator();

    //check is in valid area to use
    object oArea = GetArea( oPC );
    string sAreaTag = GetTag( oArea );

    if( sAreaTag != "cor_nexus" &&
        sAreaTag != "_nulltime" &&
        sAreaTag != "lab_massacre" )
    {
        SendMessageToPC( oPC, "This item is only strong enough to teleport the user from the Nexus in Cordor, or locations linked to the Nexus." );
        return;
    }

    //check for hostiles
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 30.0, GetLocation( oPC ), FALSE, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid( oTarget ) )
    {
        if( GetIsReactionTypeHostile( oTarget, oPC ) )
        {
            SendMessageToPC( oPC, "((OOC: You cannot use this item while hostile creatures are nearby.))" );
            return;
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 30.0, GetLocation( oPC ), FALSE, OBJECT_TYPE_CREATURE );
    }

    //check for dominated critters
    object oDominated = GetAssociate( ASSOCIATE_TYPE_DOMINATED, oPC );
    if( GetIsObjectValid( oDominated ) )
    {
        SafeDestroyObject( oDominated );
        SendMessageToPC( oPC, "The Refuge item does not allow you to teleport a dominated creature with you." );
    }

    //teleport
    object oHome = GetObjectByTag( "qst_lab_ildrar" );
    effect eVis = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_FIRE );
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, GetLocation( oPC ) );
    AssignCommand( oPC, ClearAllActions( ) );
    AssignCommand( oPC, JumpToObject( oHome ) );
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, GetLocation( oPC ) );

    //cleanup
    DestroyObject( OBJECT_SELF );
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
