//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  td_dragonbook
//description: handles the dragonshape book
//used as: action script
//date:    08/16/08
//author:  Terra


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main()
{
    // Vars
    object  oPC     = OBJECT_SELF;
    int     nNode   = GetLocalInt( oPC , "ds_node" );

    //Switch
    switch(nNode)
    {
    // Do the polymorph
    case 1:

    // Remove a feat use from dragonshape
    //DecrementRemainingFeatUses( oPC, 873 );

    // Bling Bling
    //ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SUMMONDRAGON ), oPC );

    // Dragonshape
    //ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectPolymorph( GetLocalInt( oPC, "td_poly_type" ) ), oPC );

        // Override and use the feat instead; to catch merging stuff and that
        AssignCommand( oPC , ActionUseFeat( 873, oPC ) );

    break;

    // case 2+ sets which polymorph should be used

    // Red
    case 2:SetLocalInt( oPC, "td_poly_type" , 72 );
    SetLocalString( oPC, "td_drag_color", "red");break;

    // Blue
    case 3:SetLocalInt( oPC, "td_poly_type" , 71 );
    SetLocalString( oPC, "td_drag_color", "blue");break;

    // Green
    case 4:SetLocalInt( oPC, "td_poly_type" , 73 );
    SetLocalString( oPC, "td_drag_color", "green");break;

    // Silver
    case 5:SetLocalInt( oPC, "td_poly_type" , 117 );
    SetLocalString( oPC, "td_drag_color", "silver");break;

    // Gold
    case 6:SetLocalInt( oPC, "td_poly_type" , 116 );
    SetLocalString( oPC, "td_drag_color", "gold");break;

    // Brass
    case 7:SetLocalInt( oPC, "td_poly_type" , 118 );
    SetLocalString( oPC, "td_drag_color", "brass");break;

    // Black
    case 8:SetLocalInt( oPC, "td_poly_type" , 119 );
    SetLocalString( oPC, "td_drag_color", "black");break;

    // White
    case 9:SetLocalInt( oPC, "td_poly_type" , 120 );
    SetLocalString( oPC, "td_drag_color", "white");break;

    // Copper
    case 10:SetLocalInt( oPC, "td_poly_type" , 121 );
    SetLocalString( oPC, "td_drag_color", "copper");break;

    // Bronze
    case 11:SetLocalInt( oPC, "td_poly_type" , 122 );
    SetLocalString( oPC, "td_drag_color", "bronze");break;


    // Set override for the default dragonshape script
    case 20:SetLocalInt( oPC, "td_dragon_override_red" , GetLocalInt( oPC, "td_poly_type" ) );
    SetLocalString( oPC, "td_dragon_override_red_color" , GetLocalString( oPC, "td_drag_color" ) );
    SendMessageToPC( oPC, "Red dragon shape overriden with "+GetLocalString(oPC, "td_drag_color")+" dragon." );
    break;
    case 21:SetLocalInt( oPC, "td_dragon_override_blue" , GetLocalInt( oPC, "td_poly_type" ) );
    SetLocalString( oPC, "td_dragon_override_blue_color" , GetLocalString( oPC, "td_drag_color" ) );
    SendMessageToPC( oPC, "Blue dragon shape overriden with "+GetLocalString(oPC, "td_drag_color")+" dragon." );
    break;
    case 22:SetLocalInt( oPC, "td_dragon_override_green" , GetLocalInt( oPC, "td_poly_type" ) );
    SetLocalString( oPC, "td_dragon_override_green_color" , GetLocalString( oPC, "td_drag_color" ) );
    SendMessageToPC( oPC, "Green dragon shape overriden with "+GetLocalString(oPC, "td_drag_color")+" dragon." );
    break;

    default:break;
    }
}
