// Conversation action to have this creature leave using the Superman
// animation.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/14/2004 jpavelch         Initial Release.
//

void main( )
{
    object oSelf = OBJECT_SELF;
    DelayCommand(
        1.0,
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectDisappear(),
            oSelf
        )
    );
}
