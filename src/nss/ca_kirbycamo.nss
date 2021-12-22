// Kirby's Urban Camouflage - Action script
//
// Accepts the choice from the conversation script, and changes the caster
// into the selected object, or unshifts, according to selection.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/15/2012  Mathias          Initial Release.
//

void CamoFollow( object oCamoObject, object oPC, location lPCPosition, float fSink, float fDelay ) {

    string      sTemplate   = GetResRef( oCamoObject );
    string      sCamoTag    = GetTag( oCamoObject );
    vector      vPosition   = GetPosition( oPC );
    location    lPosition;
    int         bDebug      = FALSE;  // set to TRUE to see debug messages

    // Make sure the object is still there.
    if( GetIsObjectValid( oCamoObject ) ) {

        // if PC has moved, move the object too.
        if ( lPCPosition != GetLocation( oPC ) ) {

            // DEBUG
            if( bDebug ) { SendMessageToPC( oPC, "Tag is " + sCamoTag ); }

            // Update the PC's location
            lPCPosition = GetLocation( oPC );

            // Destroy the object
            DestroyObject( oCamoObject );

            // Alter the location to be a bit lower
            vPosition = Vector( vPosition.x, vPosition.y, (vPosition.z - fSink) );
            lPosition = Location( GetArea( oPC ), vPosition, GetFacing( oPC ) );

            // Create the object in the new place
            oCamoObject = CreateObject( OBJECT_TYPE_PLACEABLE, sTemplate, lPosition, FALSE, sCamoTag );

            // Make it unuseable
            SetUseableFlag( oCamoObject, TRUE );

            // Make it check again every round.
            DelayCommand( fDelay, CamoFollow( oCamoObject, oPC, lPCPosition, fSink, fDelay ) );

        // If PC hasnt moved, just pass on the cycle.
        } else {

            // Make it check again every round.
            DelayCommand( fDelay, CamoFollow( oCamoObject, oPC, lPCPosition, fSink, fDelay ) );
        }
    }
}

void KirbyCamo( string sTemplate ) {

    // Variables
    float       fDelay          = 2.0;                  // How often, in seconds, the object moves to the PC
    float       fSink           = 0.11;                 // Negative z-axis modification
    object      oPC             = GetItemActivator( );
    int         nCasterLevel    = GetLevelByClass( CLASS_TYPE_SORCERER, oPC );
    float       fDuration       = IntToFloat( nCasterLevel ) * 600.0;
    string      sCamoTag        = "CAMO_OBJECT";
    effect      eInv            = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    effect      eAntiMagic      = EffectSpellFailure(100);
    effect      eSmoke          = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);
    effect      eLink           = EffectLinkEffects( eAntiMagic, eInv );
    object      oCamoObject;
    vector      vPosition       = GetPosition( oPC );
    location    lPCPosition     = GetLocation( oPC );
    location    lPosition;
    int         bDebug          = FALSE;                 // set to TRUE to see debug messages

    // Make the caster cutscene invis.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);

    // Alter the location to be a bit lower
    vPosition = Vector( vPosition.x, vPosition.y, (vPosition.z - fSink) );
    lPosition = Location( GetArea( oPC ), vPosition, GetFacing( oPC ) );

    // Create the object.
    oCamoObject = CreateObject( OBJECT_TYPE_PLACEABLE, sTemplate, lPosition, FALSE, sCamoTag );

    // Trigger the smoke effect.
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eSmoke, lPCPosition);

    // Set the object to start following the PC around.
    CamoFollow( oCamoObject, oPC, lPCPosition, fSink, fDelay );

    // Indicate that the effect is active.
    SetLocalInt( oPC, "CAMO_ACTIVE", TRUE );

    // Decrement uses of custom spell (self) level 3.
    DecrementRemainingSpellUses( oPC, 878 );

    // Destroy the PLC when the spell duration has expired.
    DelayCommand( fDuration, DestroyObject( GetObjectByTag( sCamoTag ) ) );
    DelayCommand( fDuration, SetLocalInt( oPC, "CAMO_ACTIVE", FALSE ) );

    // DEBUG
    if( bDebug ) { SendMessageToPC( oPC, "Spell is active for " + FloatToString( fDuration)  + " from " + IntToString( nCasterLevel ) + " caster levels times 10 minutes." + " seconds." ); }
}

void main( ) {
    object  oPC         = OBJECT_SELF;
    int     iNode       = GetLocalInt( oPC , "ds_node" );
    string  sPLCString;

    // Find which form was chosen from the conversation.
    switch( iNode ) {
        case 1:
            sPLCString  = "x2_easy_barrel";
        break;

        case 2:
            sPLCString  = "plc_chair";
        break;

        case 3:
            sPLCString  = "plc_box1";
        break;

        case 4:
            sPLCString  = "nw_plc_rock1";
        break;

        case 5:
            sPLCString  = "plc_shrub";
        break;

        case 6:
            sPLCString  = "plc_woodpile";
        break;
    }

    // Call the main function.
    KirbyCamo( sPLCString );
}


