//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ioldiskexit
//group:   Iol Disk Custom Ioun Stone
//used as: OnExit Aura script for Augmented Summoning aura
//date:    August 21, 2014
//author:  Glim

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oTarget = GetExitingObject();
    object oCaster = GetAreaOfEffectCreator( OBJECT_SELF );
    effect eRemove;

    if( GetAssociate( ASSOCIATE_TYPE_FAMILIAR, oCaster ) == oTarget ||
        GetAssociate( ASSOCIATE_TYPE_ANIMALCOMPANION, oCaster ) == oTarget ||
        GetAssociate( ASSOCIATE_TYPE_SUMMONED, oCaster ) == oTarget )
    {
        eRemove = GetFirstEffect( oTarget );
        while( GetIsEffectValid( eRemove ) )
        {
            if( GetEffectCreator( eRemove ) == OBJECT_SELF )
            {
                RemoveEffect( oTarget, eRemove );
            }
            eRemove = GetNextEffect( oTarget );
        }
    }
}
