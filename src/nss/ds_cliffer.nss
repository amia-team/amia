void main()
{
object oPC = GetEnteringObject();

 effect eStoneskin = EffectVisualEffect(VFX_DUR_PETRIFY);

 object oCliff = GetNearestObjectByTag("ForestCliff", oPC );

 int i = 1;

 while ( GetIsObjectValid( oCliff ) ){


    ++i;
     ApplyEffectToObject(DURATION_TYPE_PERMANENT,eStoneskin,oCliff);
    oCliff = GetNearestObjectByTag("ForestCliff", oPC, i );
 }

 DestroyObject( OBJECT_SELF );

}
