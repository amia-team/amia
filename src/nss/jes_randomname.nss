void main(){

    object oNPC = OBJECT_SELF;
    string sName;
    string sNameAdd;

    if ( GetRacialType(oNPC) == RACIAL_TYPE_HUMAN ){

        sName = RandomName( NAME_LAST_HUMAN );
}
    else if ( GetRacialType(oNPC) == RACIAL_TYPE_ELF ){

        sName = RandomName( NAME_LAST_ELF );
}
    else if ( GetRacialType(oNPC) == RACIAL_TYPE_DWARF ){

        sName = RandomName( NAME_LAST_DWARF );
}
    else if ( GetRacialType(oNPC) == RACIAL_TYPE_GNOME ){

        sName = RandomName( NAME_LAST_GNOME );
}
    else if ( GetRacialType(oNPC) == RACIAL_TYPE_HALFELF ){

        sName = RandomName( NAME_LAST_HALFELF );
}
    else if ( GetRacialType(oNPC) == RACIAL_TYPE_HALFLING ){

        sName = RandomName( NAME_LAST_HALFLING );
}
    else if ( GetRacialType(oNPC) == RACIAL_TYPE_HALFORC ){

        sName = RandomName( NAME_LAST_HALFORC );
}
    else
        return;

    sNameAdd = GetName(oNPC) + " " + sName ;

    //SetName
    SetName( oNPC, sNameAdd );

}
