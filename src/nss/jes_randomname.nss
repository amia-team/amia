void main(){

    object oNPC = OBJECT_SELF;
    int head    = GetLocalInt(oNPC, "head");
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
    if(head != 0){
        if(GetRacialType(oNPC) == 6 || GetRacialType(oNPC) == 4){
             if(GetGender(oNPC) == 0){
                int headNumber = d100();
                if(headNumber == 47 || headNumber == 48 || headNumber == 49){
                    headNumber == 146;
                    SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
                }
                else{
                    SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
                }
            }
            if(GetGender(oNPC) == 1){
                int headNumber = d100();
                if(headNumber == 39 || headNumber == 40 || headNumber == 41 || headNumber == 57){
                    headNumber == 145;
                    SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
                }
                else{
                    SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
                }
            }
        }
        if(GetRacialType(oNPC) == 5){
             if(GetGender(oNPC) == 0){
                int headNumber = d12();

                SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
            }
            if(GetGender(oNPC) == 1){
                int headNumber = 2 + d20();

                if(headNumber == 13){
                    headNumber = 154;
                    SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
                }
                else{
                    SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
                }
            }
        }
        if(GetRacialType(oNPC) == 2 || GetRacialType(oNPC) == 3){
             if(GetGender(oNPC) == 0){
                int headNumber = 7 + d20();

                SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
            }
            if(GetGender(oNPC) == 1){
                int headNumber = 4 + d20();

                SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
            }
        }
        if(GetRacialType(oNPC) == 1){
             if(GetGender(oNPC) == 0){
                int headNumber = 37 + d12();

                SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
            }
            if(GetGender(oNPC) == 1){
                int headNumber = 126 + d12();

                SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
            }
        }
        if(GetRacialType(oNPC) == 0){
             if(GetGender(oNPC) == 0){
                int headNumber = 11 + d20();

                SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
            }
            if(GetGender(oNPC) == 1){
                int headNumber = 7 + d20();

                SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
            }
        }
    }
}
