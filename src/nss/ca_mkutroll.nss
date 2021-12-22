// Conversation action to create an undead troll.

void MakeUndead( object oPC )
{
    object oUndead = CreateObject(
                         OBJECT_TYPE_CREATURE,
                         "ar_utroll",
                         GetLocation(oPC)
                     );
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD),
        GetLocation(oUndead)
    );

    SetAssociateListenPatterns( oUndead );
//    SetLocalInt( oUndead, "NW_COM_MODE_COMBAT", ASSOCIATE_COMMAND_ATTACKNEAREST );
    SetLocalInt( oUndead, "NW_COM_MODE_MOVEMENT", ASSOCIATE_COMMAND_FOLLOWMASTER );
    AddHenchman( oPC, oUndead );
}

void main( )
{
    object oPC = GetPCSpeaker( );

    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0) );

    object oAssociate = GetAssociate( ASSOCIATE_TYPE_HENCHMAN, oPC );
    if ( GetIsObjectValid(oAssociate) )
        DestroyObject( oAssociate );

    DelayCommand( 3.0, MakeUndead(oPC) );
}
