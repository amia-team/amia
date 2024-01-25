//
// Unsummoning Trigger
// Lord-Jyssev
//
// 8/29/2023
//
// This script is placed on a trigger and will unsummon any summoned creature that steps into it.
// If the int "vfx" is set on the trigger, it will play an associated VFX
// If the string "message" is set on the trigger, it will send a message to the master of the unsummoned creature
// The delay on destroying the creature will increase to 3.0 if a VFX is set to allow it to play through
//

void DestroySummon(object oPC, object oCreature, float fDuration, int nVFX, string sMessage);

void main()
{
    object oCreature    = GetEnteringObject();
    object oPC          = GetMaster(oCreature);
    float fDuration     = 3.0;
    int nVFX            = GetLocalInt( OBJECT_SELF, "vfx" );
    string sMessage     = GetLocalString( OBJECT_SELF, "message" );

    if(GetIsObjectValid( oCreature ) && GetAssociateType( oCreature ) == ASSOCIATE_TYPE_SUMMONED)
    {
        DestroySummon(oPC, oCreature, fDuration, nVFX, sMessage);
    }
    else if(GetIsObjectValid( oCreature ) && GetLocalInt(oCreature, "Arena Summon") == 1)
    {
        DestroySummon(oPC, oCreature, fDuration, nVFX, sMessage);
    }

}

void DestroySummon(object oPC, object oCreature, float fDuration, int nVFX, string sMessage)
{
    if( nVFX != 0) { ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), oCreature ); }
    if( sMessage != "") { SendMessageToPC( oPC, sMessage); }
    DestroyObject( oCreature, fDuration);
}
