#include "nwnx_creature"
#include "nwnx_item"

void main(){

    object oNPC = OBJECT_SELF;
    int head    = GetLocalInt(oNPC, "no_headchange");
    string sName;
    string sNameAdd;
    int sit = GetLocalInt(oNPC, "sit");

    if(sit == 1){
        ExecuteScript("spawn_sit", oNPC);
    }

    if(GetTag(oNPC) == "amia_npc_commoner"){
        int randomGender = Random(2);
        int randomRace   = Random(7);
        int randomRobe   = Random(10);
        int randomHair   = Random(5);
        int randomSkin   = Random(5);
        int randomColor  = Random(7);
        int randomColor2 = 0;
        object npcArmor  = GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC);

        SetSoundset(oNPC, 9999);

        switch(randomGender){
            case 0: SetGender(oNPC, GENDER_MALE); SetPortraitResRef(oNPC, "po_clsrogue_"); break;
            case 1: SetGender(oNPC, GENDER_FEMALE); SetPortraitResRef(oNPC, "po_clsroguef_"); break;
        }

        switch(randomRace){
            case 0: NWNX_Creature_SetRacialType(oNPC, RACIAL_TYPE_DWARF); SetCreatureAppearanceType(oNPC, 0); break;
            case 1: NWNX_Creature_SetRacialType(oNPC, RACIAL_TYPE_ELF); SetCreatureAppearanceType(oNPC, 1); break;
            case 2: NWNX_Creature_SetRacialType(oNPC, RACIAL_TYPE_GNOME); SetCreatureAppearanceType(oNPC, 2); break;
            case 3: NWNX_Creature_SetRacialType(oNPC, RACIAL_TYPE_HALFLING); SetCreatureAppearanceType(oNPC, 3); break;
            case 4: NWNX_Creature_SetRacialType(oNPC, RACIAL_TYPE_HALFELF); SetCreatureAppearanceType(oNPC, 4); break;
            case 5: NWNX_Creature_SetRacialType(oNPC, RACIAL_TYPE_HALFORC); SetCreatureAppearanceType(oNPC, 5); break;
            case 6: NWNX_Creature_SetRacialType(oNPC, RACIAL_TYPE_HUMAN); SetCreatureAppearanceType(oNPC, 6); break;
        }

        switch(randomHair){
            case 0: SetColor(oNPC, COLOR_CHANNEL_HAIR, 15); break; //Brown
            case 1: SetColor(oNPC, COLOR_CHANNEL_HAIR, 23); break; //Black
            case 2: SetColor(oNPC, COLOR_CHANNEL_HAIR, 17); break; //White
            case 3: SetColor(oNPC, COLOR_CHANNEL_HAIR, 10); break; //Blonde
            case 4: SetColor(oNPC, COLOR_CHANNEL_HAIR, 7); break; //Red
        }

        switch(randomSkin){
            case 0: SetColor(oNPC, COLOR_CHANNEL_SKIN, 0); break;
            case 1: SetColor(oNPC, COLOR_CHANNEL_SKIN, 2); break;
            case 2: SetColor(oNPC, COLOR_CHANNEL_SKIN, 4); break;
            case 3: SetColor(oNPC, COLOR_CHANNEL_SKIN, 7); break;
            case 4: SetColor(oNPC, COLOR_CHANNEL_SKIN, 12); break;
        }

        switch(randomRobe){
            case 0: randomRobe = 3; break;
            case 1: randomRobe = 4; break;
            case 2: randomRobe = 20; break;
            case 3: randomRobe = 55 ; break;
            case 4: randomRobe = 114; break;
            case 5: randomRobe = 186; break;
            case 6: randomRobe = 202; break;
            case 7: randomRobe = 221; break;
            case 8: randomRobe = 235; break;
            case 9: randomRobe = 247; break;
        }

        switch(randomColor){
            case 0: randomColor = 22; randomColor2 = 132; break;
            case 1: randomColor = 126; randomColor2 = 124; break;
            case 2: randomColor = 21; randomColor2 = 83; break;
            case 3: randomColor = 22; randomColor2 = 77; break;
            case 4: randomColor = 125; randomColor2 = 64; break;
            case 5: randomColor = 81; randomColor2 = 77; break;
            case 6: randomColor = 65; randomColor2 = 74; break;
        }

        NWNX_Item_SetItemAppearance(npcArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE, randomRobe, TRUE);
        NWNX_Item_SetItemAppearance(npcArmor, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, randomColor, TRUE);
        NWNX_Item_SetItemAppearance(npcArmor, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, randomColor, TRUE);
        NWNX_Item_SetItemAppearance(npcArmor, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, randomColor2, TRUE);
        NWNX_Item_SetItemAppearance(npcArmor, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, randomColor2, TRUE);

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

    if(head != 1){
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
