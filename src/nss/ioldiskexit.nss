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

    int IsMultiplePMSummon(object oTarget)
    {
        if (GetSubString(GetResRef(oTarget), 0, 10) == "undead_hen") return TRUE;
        return FALSE;
    }
        
    int IsMultipleWarlockSummon(object oTarget)
    {
        if (GetSubString(GetResRef(oTarget), 0, 3) == "wlk") return TRUE;
        return FALSE;
    }

    if (GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oCaster) == oTarget ||
        GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oCaster) == oTarget ||
        GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster) == oTarget ||
        GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oCaster) == oTarget)
    {
        eRemove = GetFirstEffect( oTarget );
        while( GetIsEffectValid( eRemove ) )
        {
            if( GetEffectTag( eRemove ) == "iolite_summ_effect" )
            {
                RemoveEffect( oTarget, eRemove );
            }
            eRemove = GetNextEffect( oTarget );
        }
    }
}
