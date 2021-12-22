/*  Super Boss

    --------
    Verbatim
    --------
    This library script can randomize a creature's [boss] name and glow aura;
    and boosts it's HP.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    051206  Discosux    Initial release.
    051206  kfw         Library, syntax.
    062706  kfw         New feature: 100% loot.
    062906  kfw         Ability boost.
    ----------------------------------------------------------------------------

*/



/* External Prototypes */

// Randomizes creatures name and glow aura; and boosts it's HP and abilities, and drops consistent treasure.
void CreateSuperBoss( object oBoss, int nRandomizeName = TRUE, int nSuperCharge = TRUE, int nTreasure = TRUE );

// Generates a randomized name based on the racial type and level of the creature.
string GenerateRandomizedName( object oCreature );




/* Internal Prototypes */

//Generates a randomized name from the parameter-specified column in ds_namegen.2da.
string Get2daName( string szColumn );

//Generates a randomized name from a list of characters.
string GenerateName( int nSyllables );




/* Prototype Definitions */

// Generates a randomized name based on the racial type and level of the creature.
string GenerateRandomizedName( object oCreature ){

    // Variables.
    int nGender         = GetGender( oCreature );
    string szName       = nGender == GENDER_FEMALE ? RandomName( NAME_FIRST_HUMAN_FEMALE) : RandomName( );
    int nRace           = GetRacialType( oCreature );
    int nLevel          = GetHitDice( oCreature );

    // Seed the randomized name based on racial type.
    switch( nRace ){

        // Contructs : Prefix "Advanced " to it's name.
        case RACIAL_TYPE_CONSTRUCT:{    return( "Advanced " + GetName( oCreature ) );       }


        // Animals, Beasts, Magical Beasts, Invalids, Oozes : Prefix "Greater " to it's name.
        case RACIAL_TYPE_ANIMAL:
        case RACIAL_TYPE_BEAST:
        case RACIAL_TYPE_MAGICAL_BEAST:
        case RACIAL_TYPE_INVALID:
        case RACIAL_TYPE_OOZE:{         return( "Greater " + GetName( oCreature ) );        }


        // Dragonkin, Elementals, Fey : Generate a 4 syllable, randomized name.
        case RACIAL_TYPE_DRAGON:
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_FEY:{          szName = GenerateName( d4( ) + 1 );         break;  }


        // Reptiles and Vermin : Generate a randomized name from the Lizard column of ds_namegen.2da.
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
        case RACIAL_TYPE_VERMIN:{       szName = Get2daName( "Lizardkin" );         break;  }


        /* Goblins, Montrous Creatures, Orcs, Giants : Generate a randomized name
            from the Goblins column of ds_namegen.2da. */
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_HUMANOID_ORC:
        case RACIAL_TYPE_GIANT:{        szName = Get2daName( "Goblinoid" );         break;  }


        /* Outsiders and Aberrations : Generate a randomized name
            from the Daemon2 column of ds_namegen.2da. */
        case RACIAL_TYPE_OUTSIDER:
        case RACIAL_TYPE_ABERRATION:{   szName = Get2daName( "DaemonTrueName" );    break;  }


        /* Shapechangers and Undead : Generate a randomized name
            from the Daemon2 column of ds_namegen.2da. */
        case RACIAL_TYPE_SHAPECHANGER:
        case RACIAL_TYPE_UNDEAD:{       szName = Get2daName( "DaemonUseName" );     break;  }


        // Undefined race : Generate a randomized name.
        default:{                       szName = GenerateName( d2( ) + 1 );         break;  }


    }

    // Prefix a title to the randomized name if the creature is above level 19.
    if( nLevel > 19 ) szName += Get2daName( "Title" );

    //sometimes there doesn't seem to be a first capital
    string sCapital = GetStringUpperCase( GetSubString( szName, 0, 1 ) );
    string sRest    = GetSubString( szName, 1, ( GetStringLength( szName ) -1 ) );

    szName = sCapital + sRest;

    return( szName );
}

//Generates a name from the parameter-specified column in ds_namegen.2da.
string Get2daName( string szColumn ){

    // Variables.
    string szName           = "Joop";
    int nRows               = 0;

    // Lizardkin
    if(         szColumn == "Lizardkin" ){
        // Hints: Part + part + part.
        nRows = StringToInt( Get2DAString( "ds_namegen", "Count", 0) );
        szName = Get2DAString( "ds_namegen", "Lizard", Random( nRows ) );
        szName = szName + GetStringLowerCase( Get2DAString( "ds_namegen", "Lizard", Random( nRows ) ) );
        szName = szName + GetStringLowerCase( Get2DAString( "ds_namegen", "Lizard", Random( nRows ) ) );
    }

    // Goblins and their ilk.
    else if(    szColumn == "Goblinoid" ){
        // Hints: Part1 + part2.
        nRows = StringToInt( Get2DAString( "ds_namegen", "Count", 1 ) );
        szName = Get2DAString( "ds_namegen", "Goblin1", Random( nRows ) );
        nRows = StringToInt( Get2DAString( "ds_namegen", "Count", 2 ) );
        szName = szName + GetStringLowerCase( Get2DAString( "ds_namegen", "Goblin2", Random( nRows ) ) );
    }

    // Outsiders and their ilk.
    else if(    szColumn == "DaemonTrueName" ){
        // Hints: Part + part + part + part + part.
        nRows = StringToInt( Get2DAString( "ds_namegen", "Count", 3 ) );
        szName = Get2DAString( "ds_namegen", "Daemon1", Random( nRows ) );
        szName = szName + GetStringLowerCase( Get2DAString( "ds_namegen", "Daemon1", Random( nRows ) ) );
        szName = szName + GetStringLowerCase( Get2DAString( "ds_namegen", "Daemon1", Random( nRows ) ) );
        szName = szName + GetStringLowerCase( Get2DAString( "ds_namegen", "Daemon1", Random( nRows ) ) );
        szName = szName + GetStringLowerCase( Get2DAString( "ds_namegen", "Daemon1", Random( nRows ) ) );
    }

    // Shapechangers and Undead.
    else if(    szColumn == "DaemonUseName" ){
        // Hints: Part + part.
        nRows = StringToInt( Get2DAString( "ds_namegen", "Count", 4 ) );
        szName = Get2DAString( "ds_namegen", "Daemon2", Random( nRows ) );
        szName = szName + GetStringLowerCase( Get2DAString( "ds_namegen", "Daemon2", Random( nRows ) ) );
    }

    // Prefix a title to creatures above level 19.
    else if(    szColumn == "Title" ){
        //Hints: " the " + part.
        nRows = StringToInt( Get2DAString( "ds_namegen", "Count", 5 ) );
        szName = " the " + Get2DAString( "ds_namegen", "Titles", Random( nRows ) );
    }

    return( szName );

}

//Generates a randomized name from a list of characters.
string GenerateName( int nSyllables ){

    // Variables - Substrates.
    string szVowels                     = "aeiouy";
    string szStartConsonants            = "bcdfghklmnprstvwxz";
    string szComplementingConsonants    = "lhrjhrlhnjrhhrrrlj";
    string szEndConsonants              = "bdfghklmnpqrstz";
    string szSpecials                   = "' ";

    // Variables.
    string szVowel                      = "";
    string szStartConsonant             = "";
    string szEndConsonant               = "";
    string szName                       = "";
    int nCounter                        = 0;
    int nDie                            = 0;
    int nCapital                        = 1;

    // A syllable has on average three characters.
    nSyllables = nSyllables * 3;

    // Create nCounter number of syllables.
    while( nCounter < nSyllables ){

        if(         szStartConsonant == "" ){

            // Seed.
            nDie = Random( 18 );

            // Block this part and open vowel and end consonant.
            szStartConsonant = GetSubString( szStartConsonants, nDie, 1);
            szVowel = "";
            szEndConsonant = "";

            // Add to the name.
            if( nCapital == 1 ){
                szStartConsonant = GetStringUpperCase( szStartConsonant );
                nCapital = 0;
            }

            szName += szStartConsonant;

            if( Random( 3 ) == 1 )
                szName += GetSubString( szComplementingConsonants, nDie, 1 );

        }
        else if(    szVowel == "" ){

            // Seed.
            nDie = Random( 6 );

            // Block this part and open start consonant or continue to end consonant.
            szVowel = GetSubString( szVowels, nDie, 1 );

            // Opens start consonant.
            if( d3( ) != 1 )    szStartConsonant = "";

            // Add to the name.
            if( nCapital == 1 ){
                szVowel = GetStringUpperCase( szVowel );
                nCapital = 0;
            }

            szName = szName + szVowel;

        }
        else if(    szEndConsonant == "" ){

            // Seed.
            nDie = Random( 15 );

            // Restart the loop.
            szEndConsonant = GetSubString( szEndConsonants, nDie, 1 );
            szStartConsonant = "";
            szVowel = "";

            // Add to the name.
            if( nCapital == 1 ){
                szEndConsonants = GetStringUpperCase( szEndConsonants );
                nCapital = 0;
            }

            szName = szName + szEndConsonant;

        }

        if(         Random( 10 ) == 1 && nCounter > 3 && nCounter < nSyllables - 2 ){

            // Seed.
            nDie = Random( 2 );

            // Get a space or quote.
            szName = szName + GetSubString( szSpecials, nDie, 1 );
            nCapital = 1;

        }

        // Get the next syllable.
        nCounter++;

    }

    return( szName );
}

// Randomizes creatures name and glow aura; and boosts it's HP and abilities, and drops consistent treasure.
void CreateSuperBoss( object oBoss, int nRandomizeName = TRUE, int nSuperCharge = TRUE, int nTreasure = TRUE ){

    //Don't change bosses!
    if ( GetLocalInt( oBoss, "is_boss" ) == 1 ){

        return;
    }


    // Variables.
    int nMod                = GetHitDice( oBoss ) / 5;
    if( nMod < 1 )
        nMod = 1;

    int nResistanceVisual   = 0;
    int nResistanceType     = 0;

    effect eHP_Boost        = EffectTemporaryHitpoints( GetHitDice( oBoss ) * 3 );

    effect eStr             = SupernaturalEffect( EffectAbilityIncrease( ABILITY_STRENGTH, nMod ) );
    effect eDex             = SupernaturalEffect( EffectAbilityIncrease( ABILITY_DEXTERITY, nMod ) );
    effect eCon             = SupernaturalEffect( EffectAbilityIncrease( ABILITY_CONSTITUTION, nMod ) );
    effect eWis             = SupernaturalEffect( EffectAbilityIncrease( ABILITY_WISDOM, nMod ) );
    effect eCha             = SupernaturalEffect( EffectAbilityIncrease( ABILITY_CHARISMA, nMod ) );
    effect eInt             = SupernaturalEffect( EffectAbilityIncrease( ABILITY_INTELLIGENCE, nMod ) );

    // Generate a randomized name for this boss.
    if( nRandomizeName ){

        SetName( oBoss, GenerateRandomizedName( oBoss ) );
    }

    // Seed randomized Elemental Immunity.
    switch( d4( ) ){

        case 1:     nResistanceVisual = VFX_DUR_GLOW_BLUE;  nResistanceType = DAMAGE_TYPE_COLD; break;
        case 2:     nResistanceVisual = VFX_DUR_GLOW_RED;   nResistanceType = DAMAGE_TYPE_FIRE; break;
        case 3:     nResistanceVisual = VFX_DUR_GLOW_GREEN; nResistanceType = DAMAGE_TYPE_ACID; break;
        default:    nResistanceVisual = VFX_DUR_GLOW_WHITE; nResistanceType = DAMAGE_TYPE_SONIC; break;

    }

    // Create an Aura Glow and Elemental Immunity.
    effect eEleImmVisual    = EffectVisualEffect( nResistanceVisual );
    effect eEleImm          = EffectDamageImmunityIncrease( nResistanceType, 25 );

    // Apply Aura Glow, Elemental Immunity; and HP Boost and Abilities.
    if( nSuperCharge ){
        // Glow.
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEleImmVisual, oBoss );
        // Elemental Immunity.
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEleImm, oBoss );
        // HP Boost.
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eHP_Boost, oBoss );
        // Abilities.
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eStr, oBoss );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eDex, oBoss );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCon, oBoss );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eWis, oBoss );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCha, oBoss );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eInt, oBoss );
    }

    // Consistent treasure drop.
    if ( nTreasure ) {

        SetLocalInt( oBoss, "CustDropPercent", 100 );
    }

    return;

}
