// Ostland Madness Script (OnEnter Trigger)
//
// When a PC enters the trigger, they must pass a will save or lose 1 point of
// either INT or WIS, randomly.  Every 2-4 minutes, the save fires again.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/13/2012 Mathias          Initial Release.
//
#include "amia_include"

// Prototypes
void MadnessSave( object oPC, int nDC, string sTrigger, int nMinTime, int nMaxTime, string sSoundTag, int bDebug );


// Main
void main() {

    // Major variables
    string  sSoundTag   = "MadnessSound";           // The tag of the sound object that plays when failing the save.
    int     nDC         = 23;                       // The DC for the will save.
    int     nMinTime    = 30;                      // The minimum wait in seconds before rolling the save.
    int     nMaxTime    = 60;                      // The maximum wait in seconds before rolling the save.
    int     bDebug      = FALSE;                    // Set to TRUE to see debug messages
    object  oPC         = GetEnteringObject();
    float   fDelay;
    string  sTriggerTag = GetTag( OBJECT_SELF );

    // Make sure its a PC.
    if (GetIsPC(oPC))
    {
        // Make sure there isn't already a check scheduled
        if ( GetLocalInt( oPC, "ost_madness_delay" ) < 1 )
        {
            // Create a random wait for this PC.
            fDelay = IntToFloat( Random( nMaxTime - nMinTime ) + 1 + nMinTime );

            // !!DEBUG!!
            if ( bDebug ) { SendMessageToPC( oPC, "Madness check on trigger " + sTriggerTag + " in " + FloatToString(fDelay) + " seconds."); }

            // Signal that a check is incoming, so don't schedule a new one.
            SetLocalInt( oPC, "ost_madness_delay", 1 );

            // Set the save to roll after the delay above.
            DelayCommand( fDelay, MadnessSave( oPC, nDC, sTriggerTag, nMinTime, nMaxTime, sSoundTag, bDebug ) );

        } else {

            // !!DEBUG!!
            if ( bDebug ) { SendMessageToPC( oPC, "You already has a madness check coming."); }

        }
    }
}

void MadnessSave( object oPC, int nDC, string sTrigger, int nMinTime, int nMaxTime, string sSoundTag, int bDebug) {

    // Check if PC is still in the trigger
    if ( GetIsInsideTrigger( oPC, sTrigger ) ) {

        // Make it affect INT instead of WIS on random.
        int nAbility = ABILITY_WISDOM;
        if ( d2( ) == 2) {
            nAbility = ABILITY_INTELLIGENCE;
        }

        // Play the sound
        object oSound = GetObjectByTag( sSoundTag );
        SoundObjectPlay ( oSound );
        FloatingTextStringOnCreature( "Wild bird calls reverberate all around with a maddening echo", oPC );


        // Roll the save
        if ( WillSave( oPC, nDC, SAVING_THROW_TYPE_MIND_SPELLS ) == 0 ) {

            // !!DEBUG!!
            if ( bDebug ) { SendMessageToPC( oPC, "PC failed will check, and gets -1 to ablity #" + IntToString(nAbility) + "."); }

            // Drain the ability
            effect eDrain = EffectAbilityDecrease( nAbility, 1);
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eDrain, oPC );


        } else {

            // !!DEBUG!!
            if ( bDebug ) { SendMessageToPC( oPC, "PC passed will save and takes no damage to ability #" + IntToString(nAbility) + "."); }
        }

        // Create a new random wait for this PC.
        float fDelay = IntToFloat( Random( nMaxTime - nMinTime ) + 1 + nMinTime );

        // !!DEBUG!!
        if ( bDebug ) { SendMessageToPC( oPC, "Madness check in " + FloatToString(fDelay) + " seconds."); }

        // Set the save to roll after the delay above.
        DelayCommand( fDelay, MadnessSave( oPC, nDC, sTrigger, nMinTime, nMaxTime, sSoundTag, bDebug ) );

    } else {

        // Allow a new check to be scheduled
        SetLocalInt( oPC, "ost_madness_delay", 0 );

        // !!DEBUG!!
        if ( bDebug ) { SendMessageToPC( oPC, "PC is no longer in the trigger."); }
    }

}
