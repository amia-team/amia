void main()
{

    object oPC = GetItemActivator();
    object oItem = GetItemActivated();
    object oArea = GetArea( oPC );
    string sItemName = GetName( oItem );
    int bBlock = GetLocalInt( oItem, "blocked" );
    if ( bBlock ){

        // If we're in the entry area and the widget is blocked, allow this use
        // to clear the widget.
        if ( GetTag( oArea ) == "amia_entry" ){

            DeleteLocalInt( oItem, "blocked" );
            SendMessageToPC( oPC, "Light is green, widget is clean." );

        }
        else{

            SendMessageToPC( oPC, "You can't use " + sItemName + " yet." );
            return;
        }
    }

    float fDuration;
    effect eEffect, eLink, eVis;

    //Mahir's Battle Paint
    if ( GetName( oItem ) == "Mahir's Battle Paint" ){

        //Check that conditions are met
        int nColor = GetColor( oPC, COLOR_CHANNEL_SKIN );
        if ( nColor != 103 ){

            SendMessageToPC( oPC, "You're not wearing your battle paint!" );
            return;

        }

        //Set a block for this item
        SetLocalInt( oItem, "blocked", 1 );
        fDuration = TurnsToSeconds(5);
        //Delayed block removal
        DelayCommand( fDuration , DeleteLocalInt( oItem, "blocked" ) );
        //Set effects for this widget
        eEffect = EffectSkillIncrease( SKILL_TAUNT, 5 );
        eVis = EffectVisualEffect( VFX_IMP_IMPROVE_ABILITY_SCORE );
        //Apply effects for this widget
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPC, fDuration );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
        SendMessageToPC( oPC, "Applying effects for " + sItemName + " widget." );

    }

}
