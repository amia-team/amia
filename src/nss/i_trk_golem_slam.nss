/* OnHit for Annihilator Slam - Tarkuul Guard Golem

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
05/09/13 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"

void GemSlam()
{
    object oCritter = OBJECT_SELF;
    object oVictim = GetSpellTargetObject();
    int nFort;
    int nWill;
    int nSR = GetSpellResistance( oVictim );
    int nCasterCheck = d20(1) + 30;
    //Check to make sure it's only being used once per round max
    if( GetLocalInt( oCritter, "GemSlamUsed" ) >= 1 )
    {
       return;
    }

    //randomly choose from the 5 finger enchantments
    int nRandom = Random( 5 ) + 1;

    if( nRandom == 1 )
    {
        //Enervation
        nFort = FortitudeSave( oVictim, 35, SAVING_THROW_TYPE_NEGATIVE, oCritter );
        if( nSR <= nCasterCheck && nFort == 1 )
        {
            effect eDrain = EffectNegativeLevel( d4(1) );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eDrain, oVictim );
            SetLocalInt( oCritter, "GemSlamUsed", 1 );
            DelayCommand( 6.0, SetLocalInt( oCritter, "GemSlamUsed", 0 ) );
        }
    }
    else if( nRandom == 2 )
    {
        //Ghoul Touch
        nFort = FortitudeSave( oVictim, 33, SAVING_THROW_TYPE_NEGATIVE, oCritter );
        if( nSR <= nCasterCheck && TouchAttackMelee( oVictim, TRUE ) != 0 && nFort == 1 )
        {
            effect eParalyze = EffectParalyze( );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eParalyze, oVictim, RoundsToSeconds( d6(1) + 2 ) );
            SetLocalInt( oCritter, "GemSlamUsed", 1 );
            DelayCommand( 6.0, SetLocalInt( oCritter, "GemSlamUsed", 0 ) );
        }
    }
    else if( nRandom == 3 )
    {
        //Contagion
        int nDiseaseType;
        nFort = FortitudeSave( oVictim, 35, SAVING_THROW_TYPE_DISEASE, oCritter );
        int nDiseaseNumber = Random( 7 ) + 1;
        switch( nDiseaseNumber )
        {
            case 1:     nDiseaseType = 0;       break;
            case 2:     nDiseaseType = 1;       break;
            case 3:     nDiseaseType = 4;       break;
            case 4:     nDiseaseType = 5;       break;
            case 5:     nDiseaseType = 7;       break;
            case 6:     nDiseaseType = 8;       break;
            case 7:     nDiseaseType = 9;       break;
            default:    break;
        }
        if( nSR <= nCasterCheck && nFort == 1 )
        {
            effect eDisease = EffectDisease( nDiseaseType );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDisease, oVictim );
            SetLocalInt( oCritter, "GemSlamUsed", 1 );
            DelayCommand( 6.0, SetLocalInt( oCritter, "GemSlamUsed", 0 ) );
        }
    }
    else if( nRandom == 4 )
    {
        //Bestow Curse
        nWill = WillSave( oVictim, 35, SAVING_THROW_TYPE_NEGATIVE, oCritter );
        if( nSR <= nCasterCheck && nWill == 1 )
        {
            effect eCurse = EffectCurse( 2, 2, 2, 2, 2, 2 );
                   eCurse = SupernaturalEffect( eCurse );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCurse, oVictim );
            SetLocalInt( oCritter, "GemSlamUsed", 1 );
            DelayCommand( 6.0, SetLocalInt( oCritter, "GemSlamUsed", 0 ) );
        }
    }
    else if( nRandom == 5 )
    {
        //Energy Drain
        nFort = FortitudeSave( oVictim, 40, SAVING_THROW_TYPE_DISEASE, oCritter );
        if( nSR <= nCasterCheck && nFort == 1 )
        {
            effect eDrain = EffectNegativeLevel( d4(2) );
                   eDrain = SupernaturalEffect( eDrain );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eDrain, oVictim );
            SetLocalInt( oCritter, "GemSlamUsed", 1 );
            DelayCommand( 24.0, SetLocalInt( oCritter, "GemSlamUsed", 0 ) );
        }
    }

}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ONHITCAST:
            GemSlam( );
            break;
    }
}
