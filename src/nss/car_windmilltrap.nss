void main()
{
    int nDC = 40;
    int nSave = GetLocalInt( OBJECT_SELF, "save_type" );
    int nCount;
    string sMessage1;
    string sMessage2;
    effect eWeaken1;
    effect eWeaken2;

    object oTarget = GetFirstInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );

    nCount = GetLocalInt( oTarget, GetName( OBJECT_SELF ) );

    // read PC alignment for DC modification and messages
    if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)

    {
        nDC = nDC + 3;
        sMessage1 = "The pervasive, brooding, overwhelming sense of evil that fills this place begins to sap your strength.";
        sMessage2 = "The longer you remain in this building the harder it gets to fight off the brooding, pervassive evil that fills this place.";
    }

    else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
    {
       nDC = nDC;
       sMessage1 = "The overwhelming sense of evil that fills this place weighs on your soul and begins to sap your strength.";
       sMessage2 = "The longer you remain in this building the harder it is to shrug off the sense of evil that continues to weight on you and sap your strength.";
    }

    else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
    {
       nDC = nDC -3;
       sMessage1 = "The powerful, dominating sense that fills this place weighs on you and begins to sap your own strength.";
       sMessage2 = "The longer you remain in this building the harder it is to shrug off the dominating sense that fills this place and it continues to sap your strenth.";
    }

    else
    {
       SendMessageToPC ( oTarget, "debug: script failure please notify development team" );
    }

    if( nCount == 10 )
    {
        // reset count to 0
        nCount = 0;
        SetLocalInt( oTarget, GetName( OBJECT_SELF ), nCount );

        while( GetIsObjectValid( oTarget ) )
        {

            // Will save vs. effects
            if( WillSave( oTarget, nDC, SAVING_THROW_TYPE_EVIL, OBJECT_SELF ) == 0 )
            {
                effect eWeaken1 = SupernaturalEffect( EffectAbilityDecrease(ABILITY_CONSTITUTION , 1 ) );
                effect eWeaken2 = SupernaturalEffect( EffectSavingThrowDecrease(SAVING_THROW_WILL, 1 ) );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWeaken1, oTarget, 600.0 );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWeaken2, oTarget, 600.0 );

                //check which message to send and then give PC feedback.
                if( GetLocalObject( oTarget, GetName( OBJECT_SELF ) ) != OBJECT_SELF )
                {
                    SendMessageToPC( oTarget, sMessage1);
                    SetLocalObject( oTarget, GetName( OBJECT_SELF ), OBJECT_SELF );
                }
                else
                {
                    SendMessageToPC( oTarget, sMessage2 );
                }
            }

            oTarget = GetNextInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );
        }
    }

    // we didn't run the check yet up the count by 1 more round
    else
    {
        nCount = nCount + 1;
        SetLocalInt( oTarget, GetName( OBJECT_SELF ), nCount );
    }
}
