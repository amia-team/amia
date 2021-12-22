// Nekhkbet's Pie Creator :: Creates an Apple Pie
void main( ){

    // Variables
    object oPC              = GetPCSpeaker( );
    int nPC_Gold            = GetGold( oPC );
    string sCategory        = GetLocalString(oPC,"killyourteethwith");
    string szPie_ResRef     = "nb_"+sCategory+"1";
    int nGP                 = 20;

    // Verify the player has sufficient gold
    if( nPC_Gold < nGP ){
        FloatingTextStringOnCreature( "- You have insufficient gold to create this item. -", oPC, FALSE );
        return;
    }


    // Retrieve gold
    TakeGoldFromCreature( nGP, oPC, TRUE );

    // Play a twinkling sound.
    AssignCommand( oPC, PlaySound( "sce_neutral" ) );

    // Create a natural effect on the player
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_MAGBLUE ), oPC, 0.0 );

    // Create the item
    object oItem = CreateItemOnObject( szPie_ResRef, oPC, 1 );
    if( GetIsObjectValid(oItem) ){
        FloatingTextStringOnCreature( "<cÌwþ>- Item created -</c>", oPC, FALSE );

        //strip category from name and rename
        string sName=GetName(oItem);
        sName=GetStringRight(sName,(GetStringLength(sName)-GetStringLength(sCategory)-2));
        SetName(oItem,sName);
    }
    else {
        FloatingTextStringOnCreature( "- Couldn't create this item -", oPC, FALSE );
    }

    return;

}
