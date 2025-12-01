void main(){

    object oNPC = OBJECT_SELF;
    int head    = GetLocalInt(oNPC, "head");
    string sName;
    string sNameAdd;

    if(GetTag(oNPC) == "amia_npc_commoner"){
        if(GetRacialType(oNPC) == RACIAL_TYPE_HUMAN){
            if(GetGender(oNPC) == GENDER_MALE){
                sName = RandomName(NAME_FIRST_HUMAN_MALE);
                SetName(oNPC, sName);
            }
            else{
                sName = RandomName(NAME_FIRST_HUMAN_FEMALE);
                SetName(oNPC, sName);
            }
        }
        else if(GetRacialType(oNPC) == RACIAL_TYPE_ELF){
            if(GetGender(oNPC) == GENDER_MALE){
                sName = RandomName(NAME_FIRST_ELF_MALE);
                SetName(oNPC, sName);
            }
            else{
                sName = RandomName(NAME_FIRST_ELF_FEMALE);
                SetName(oNPC, sName);
            }
        }
        else if(GetRacialType(oNPC) == RACIAL_TYPE_DWARF){
            if(GetGender(oNPC) == GENDER_MALE){
                sName = RandomName(NAME_FIRST_DWARF_MALE);
                SetName(oNPC, sName);
            }
            else{
                sName = RandomName(NAME_FIRST_DWARF_FEMALE);
                SetName(oNPC, sName);
            }
        }
        else if(GetRacialType(oNPC) == RACIAL_TYPE_GNOME){
            if(GetGender(oNPC) == GENDER_MALE){
                sName = RandomName(NAME_FIRST_GNOME_MALE);
                SetName(oNPC, sName);
            }
            else{
                sName = RandomName(NAME_FIRST_GNOME_FEMALE);
                SetName(oNPC, sName);
            }
        }
        else if(GetRacialType(oNPC) == RACIAL_TYPE_HALFELF){
            if(GetGender(oNPC) == GENDER_MALE){
                sName = RandomName(NAME_FIRST_HALFELF_MALE);
                SetName(oNPC, sName);
            }
            else{
                sName = RandomName(NAME_FIRST_HALFELF_FEMALE);
                SetName(oNPC, sName);
            }
        }
        else if(GetRacialType(oNPC) == RACIAL_TYPE_HALFLING){
            if(GetGender(oNPC) == GENDER_MALE){
                sName = RandomName(NAME_FIRST_HALFLING_MALE);
                SetName(oNPC, sName);
            }
            else{
                sName = RandomName(NAME_FIRST_HALFLING_FEMALE);
                SetName(oNPC, sName);
            }
        }
        else if(GetRacialType(oNPC) == RACIAL_TYPE_HALFORC){
            if(GetGender(oNPC) == GENDER_MALE){
                sName = RandomName(NAME_FIRST_HALFORC_MALE);
                SetName(oNPC, sName);
            }
            else{
                sName = RandomName(NAME_FIRST_HALFORC_FEMALE);
                SetName(oNPC, sName);
            }
        }
        else
            return;
    }
    else{
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
        SetName( oNPC, sNameAdd );
    }

    if(head != 0){
        if(GetRacialType(oNPC) == 6 || GetRacialType(oNPC) == 4){
             if(GetGender(oNPC) == 0){
                int headNumber = d100();
                if(headNumber >= 47 && headNumber <= 81 ){
                    headNumber = 146;
                    SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
                }
                else{
                    SetCreatureBodyPart(20, headNumber, OBJECT_SELF);
                }
            }
            if(GetGender(oNPC) == 1){
                int headNumber = d100();
                if(headNumber == 39 || headNumber == 40 || headNumber == 41 || headNumber == 57 || headNumber == 58 || headNumber == 78 || headNumber == 94){
                    headNumber = 145;
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
