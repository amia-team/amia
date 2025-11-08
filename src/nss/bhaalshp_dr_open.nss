// Fires when the nasty skull door to the Bhaal shop is given a drop of blood
void main()
{
    object oCharacter = GetPCSpeaker();
    object oBhaalDoor = OBJECT_SELF;

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1), oCharacter);
    AssignCommand(oBhaalDoor, ActionOpenDoor(oBhaalDoor));
}
