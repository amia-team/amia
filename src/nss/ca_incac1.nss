// Conversation action to increase AC by one.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/24/2004 jpavelch         Initial release.
//


// Removes the current AC bonus effect on a creature
void RemoveACEffects( object oCreature )
{
    effect eEffect = GetFirstEffect( oCreature );
    while ( GetIsEffectValid(eEffect) ) {
        if ( GetEffectType(eEffect) == EFFECT_TYPE_AC_INCREASE
            || GetEffectType(eEffect) == EFFECT_TYPE_AC_DECREASE ) {

            RemoveEffect( oCreature, eEffect );
        }
        eEffect = GetNextEffect( oCreature );
    }
}


void ReportAC( )
{
    object oSelf = OBJECT_SELF;

    int nAC = GetAC( oSelf );
    SpeakString( "AC is " + IntToString(nAC) );
}


void main( )
{
    object oSelf = OBJECT_SELF;

    RemoveACEffects( oSelf );
    int nAdjustment = GetLocalInt( oSelf, "AR_Adjust" ) + 1;
    SetLocalInt( oSelf, "AR_Adjust", nAdjustment );

    effect eAdjust;
    if ( nAdjustment < 0 ) {
        eAdjust = EffectACDecrease( -nAdjustment );
    } else {
        eAdjust = EffectACIncrease( nAdjustment );
    }
    eAdjust = SupernaturalEffect( eAdjust );

    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        eAdjust,
        oSelf
    );

    DelayCommand( 0.1, ReportAC() );
}
