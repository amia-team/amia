//::///////////////////////////////////////////////
//:: glm_jellysplit
//:: Copyright (c) 2004 Bioware Corp.
//:://////////////////////////////////////////////
/*
    An include file for handling the "Split"
    functionality of the Ochre Jellies.

    Modified: Now handles splitting of all jelly
                 and pudding type creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith K2 Hayward
//:: Created On: July, 2004
//:: Modified On: January, 2006
//:: Modified: kfw Jun 28 '06, fixed up for Amia's drop system.
//:: Modified: Glim 03/20/13, functionality for all jellys & puddings.
//:://////////////////////////////////////////////

void SplitCreature(object oCritter, int nHP );

void SplitCreature(object oCritter, int nHP )
{
    location lSpawn = GetLocation( oCritter );

    effect eVFX = EffectVisualEffect( VFX_COM_CHUNK_YELLOW_SMALL );

    int nDamage = ( nHP / 2 );
    effect eDamage = EffectDamage( nDamage );

    effect eGhost = EffectCutsceneGhost();
           eGhost = SupernaturalEffect( eGhost );

    int nMax = GetLocalInt( oCritter, "DuplicateMax" );
    int nActual = GetLocalInt( oCritter, "ActualDuplicate" );
    int nSize = GetAppearanceType( oCritter );
    int nNewSize;

    // set scaling downsizing of critters as they split appart
    switch( nSize )
    {
        case 848:    nNewSize = 845;    break;    //200% to 170% (invisible_creature_S)
        case 845:    nNewSize = 842;    break;    //170% to 140% (invisible_creature_S)
        case 842:    nNewSize = 839;    break;    //140% to 110% (invisible_creature_S)
        case 839:    nNewSize = 836;    break;    //110% to 80%  (invisible_creature_S)
        case 836:    nNewSize = 833;    break;    //80% to 50%   (invisible_creature_S)
        case 833:    nNewSize = 830;    break;    //50% to 20%   (invisible_creature_S)

        case 828:    nNewSize = 825;    break;    //200% to 170% (invisible_human_male)
        case 825:    nNewSize = 822;    break;    //170% to 140% (invisible_human_male)
        case 822:    nNewSize = 819;    break;    //140% to 110% (invisible_human_male)
        case 819:    nNewSize = 816;    break;    //110% to 80%  (invisible_human_male)
        case 816:    nNewSize = 813;    break;    //80% to 50%   (invisible_human_male)
        case 813:    nNewSize = 810;    break;    //50% to 20%   (invisible_human_male)
        default:    break;
    }

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX, lSpawn );

    SetCreatureAppearanceType( oCritter, nNewSize );

    object oClone = CopyObject( oCritter, lSpawn, OBJECT_INVALID, "split_clone" );

    //prevent infinite looping and level out HP
    SetLocalInt( oCritter, "NoLoop", 1 );
    nActual = nActual + 1;
    SetLocalInt( oCritter, "ActualDuplicate", nActual );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oCritter );
    DelayCommand( 0.1, SetLocalInt( oCritter, "NoLoop", 0 ) );
    DelayCommand( 0.2, SetLocalInt( oClone, "NoLoop", 1 ) );
    DelayCommand( 0.3, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oClone ) );
    DelayCommand( 0.4, SetLocalInt( oClone, "NoLoop", 0 ) );
    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eGhost, oClone ) );

    if( nNewSize == 830 || nNewSize == 810 || nHP <= 10 || nActual >= nMax )
    {
        SetLocalInt( oCritter, "SplitLimit", 1 );
        SetLocalInt( oClone, "SplitLimit", 1 );
    }

    AssignCommand( oCritter, ClearAllActions( TRUE ) );
}
