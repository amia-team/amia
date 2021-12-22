// Creates a combust effect on the braziers.
//
void main()
{

    object oBrazier = GetNearestObjectByTag("Brazier", OBJECT_SELF, 1);
    object oPC = GetEnteringObject( );

    if ( GetIsPC(oPC) ) {


        AssignCommand(
           oBrazier,
           PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));

        DelayCommand(
           30.0,
           AssignCommand(
              oBrazier,
              PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));

    }
}
