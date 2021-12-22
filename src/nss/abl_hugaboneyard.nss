/*
    Custom NPC Only Ability:
    Hug A Boneyard
    - Finds the nearest Boneyard and moves towards it, ignoring everything else.
*/

void HugABoneyard( object oCritter );

void main()
{
    object oCritter = OBJECT_SELF;

    //find the Boneyard and move towards it, ignoreing everything else
    DelayCommand( 2.0, HugABoneyard( oCritter ) );
}

void HugABoneyard( object oCritter )
{
    object oNewBossPos = GetLocalObject( oCritter, "Boneyard" );
    ClearAllActions();
    AssignCommand( oCritter, ActionForceMoveToObject( oNewBossPos, TRUE, 0.0 ) );
    DelayCommand( 4.0, ExecuteScript( "abl_hugaboneyard", oCritter ) );
}
