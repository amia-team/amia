//void main( ){}

//Set spell ID on eEffect and return new effect
effect SetEffectSpellID( effect eEffect, int nSpellID );

//Set a script that is to be fired when eEffect expires
//Use GetLastEffect( ) inside the effect script to get the effect
//Object_self is the effect owner
effect SetEffectScript( effect eEffect, string sEffectScript );

//Set the CL for eEffect


//Get the unique effect ID
//this has two parts, index 0 and index 1 since its a 64bit unsigned intiger
int GetEffectID( effect eEffect, int nIndex=0 );

//Set eEffect's creator to o Creator


//Get the casterlevel of the effect
int GetLegacyEffectCasterLevel( effect eEffect );

//Get the last effect
//Used in SetEffectScript scripts
effect GetLastEffect( );

//Clears all the effects on others
void ClearEffectsOnOthers( object oCreator );

effect GetLastEffect( ){

    SetLocalString( OBJECT_SELF, "NWNX!EFFECTS!GetLastEffect", "0" );
    DeleteLocalString( OBJECT_SELF, "NWNX!EFFECTS!GetLastEffect" );
    int nID = GetEffectDurationType( EffectSleep( ) );

    effect eEffect = GetFirstEffect( OBJECT_SELF );
    while( GetIsEffectValid( eEffect ) ){

        if( nID = GetEffectID( eEffect ) )
            break;

        eEffect = GetNextEffect( OBJECT_SELF );
    }

    return eEffect;
}

int GetLegacyEffectCasterLevel( effect eEffect ){

    SetLocalString( OBJECT_SELF, "NWNX!EFFECTS!GetLegacyEffectCasterLevel", "0" );
    DeleteLocalString( OBJECT_SELF, "NWNX!EFFECTS!GetLegacyEffectCasterLevel" );
    return GetEffectDurationType( eEffect );
}


int GetEffectID( effect eEffect, int nIndex ){

    SetLocalString( OBJECT_SELF, "NWNX!EFFECTS!GetEffectID", IntToString( nIndex ) );
    DeleteLocalString( OBJECT_SELF, "NWNX!EFFECTS!GetEffectID" );
    return GetEffectDurationType( eEffect );
}


effect SetEffectScript( effect eEffect, string sEffectScript ){

    SetLocalString( OBJECT_SELF, "NWNX!EFFECTS!SetEffectScript", sEffectScript );
    DeleteLocalString( OBJECT_SELF, "NWNX!EFFECTS!SetEffectScript" );
    return MagicalEffect( eEffect );
}

effect SetEffectSpellID( effect eEffect, int nSpellID ){

    SetLocalString( OBJECT_SELF, "NWNX!EFFECTS!SetEffectSpellID", IntToString( nSpellID ) );
    DeleteLocalString( OBJECT_SELF, "NWNX!EFFECTS!SetEffectSpellID" );
    return MagicalEffect( eEffect );
}

void ClearEffectsOnOthers( object oCreator ){

    SetLocalString( oCreator, "NWNX!EFFECTS!ClearEff", "......................" );
    DeleteLocalString( oCreator, "NWNX!EFFECTS!ClearEff" );
}
