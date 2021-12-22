#include "NW_I0_GENERIC"
#include "amia_include"

int LightType(string sType);
int LightColour(string sColour);
string DyeName(int nIndex, string sType);
string StandardClothDyes(int nIndex);
string StandardMetalDyes(int nIndex);
string LushDyes(int nIndex);
string NaturalDyes(int nIndex);
string UrbanDyes(int nIndex);


void main()
{
    int iMatch = GetListenPatternNumber();
    int nMatch = GetMatchedSubstringsCount();
    int nSpace;
    int iMaterialToDye;
    int iColor;
    int nError=0;
    int iItemToDye;
    string sResult;
    string sRest;
    string sType;
    string sMaterial;
    string sOption;
    string sColour;
    object oShouter = GetLastSpeaker();
    object oPC=GetLocalObject(OBJECT_SELF, "oActivator");
    object oItem;
    object oDyedItem;
    int i=0;

    ClearAllActions(); //just to be sure

    //if the password matches, and is spoken by the right person then continue
    if(iMatch == 30440 && GetIsObjectValid(oShouter) && oShouter == oPC){

        //get the part AFTER the password
        while(i<nMatch){
            if(i==1){
                sResult=GetStringLowerCase(GetMatchedSubstring(i));
            }
            i++;
        }

        nSpace=FindSubString(sResult," ");
        if(nSpace==-1){
            sType=sResult;
        }
        else{
            sType=GetStringLeft(sResult, nSpace);
            sRest=GetSubString(sResult,(nSpace+1),GetStringLength(sResult));
            nSpace=FindSubString(sRest," ");
            if(nSpace==-1){
                sMaterial=sRest;
            }
            else{
                sMaterial=GetStringLeft(sRest, nSpace);
                sRest=GetSubString(sRest,(nSpace+1),GetStringLength(sRest));
                nSpace=FindSubString(sRest," ");
                if(nSpace==-1){
                    sOption=sRest;
                }
                else{
                    sOption=GetStringLeft(sRest, nSpace);
                    sRest=GetSubString(sRest,(nSpace+1),GetStringLength(sRest));
                    sColour=sRest;
                }
            }
        }

        if (sType=="close"){
             DestroyObject(OBJECT_SELF,1.0);       //Destroy if Bustier says 'Chester, close'
             return;
        }
        else if (sType=="begone"){
             DestroyObject(OBJECT_SELF,1.0);       //idem
             return;
        }
        else if (sType=="follow"){
             ActionForceFollowObject(oPC,1.0);       //to move the box
             return;
        }
        else if (sType=="come"){
             ActionForceFollowObject(oPC,1.0);       //to move the box
             return;
        }
        else if (sType=="stay"){
            ClearAllActions();                     //to pin the box
            return;
        }
        else if (sType=="helmet"){
            oItem=GetItemInSlot(INVENTORY_SLOT_HEAD, oPC); //armour = helmet
            iItemToDye=INVENTORY_SLOT_HEAD;
            effect eBeam=EffectBeam(VFX_BEAM_MIND ,OBJECT_SELF, BODY_NODE_CHEST);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oPC,0.7);
        }
        else if (sType=="armour"){
            oItem=GetItemInSlot(INVENTORY_SLOT_CHEST, oPC); //armour = suit
            iItemToDye=INVENTORY_SLOT_CHEST;
            effect eBeam=EffectBeam(VFX_BEAM_MIND ,OBJECT_SELF, BODY_NODE_CHEST);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oPC,0.7);
        }
        else if (sType=="create"){

            //create suit
            object oSuit=CreateItemOnObject("ds_realbustier",oPC);
            itemproperty iLight=ItemPropertyLight(LightType(sMaterial), LightColour(sOption));
            SetName(oSuit,"A Real Cassanova ("+sMaterial+" "+sOption+")");
            AddItemProperty(DURATION_TYPE_PERMANENT,iLight,oSuit);

            //take gold
            TakeGoldFromCreature(GetGoldPieceValue(oSuit),oPC);

            //creation beam effect
            effect eBeam=EffectBeam(VFX_BEAM_LIGHTNING ,OBJECT_SELF, BODY_NODE_CHEST);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oPC,1.5);

            return;
        }
        else{
            ActionForceFollowObject(oPC,1.0);
            return;
        }

        //sets the right kind of colour to apply
        if (sOption=="1"){
            if (sMaterial=="cloth"){
                iMaterialToDye=ITEM_APPR_ARMOR_COLOR_CLOTH1;
            }
            else if (sMaterial=="leather"){
                iMaterialToDye=ITEM_APPR_ARMOR_COLOR_LEATHER1;
            }
            else if (sMaterial=="metal"){
                iMaterialToDye=ITEM_APPR_ARMOR_COLOR_METAL1;
            }
            else{
                nError=1;    //not a valid material
            }
        }
        else if (sOption=="2"){
            if (sMaterial=="cloth"){
                iMaterialToDye=ITEM_APPR_ARMOR_COLOR_CLOTH2;
            }
            else if (sMaterial=="leather"){
                iMaterialToDye=ITEM_APPR_ARMOR_COLOR_LEATHER2;
            }
            else if (sMaterial=="metal"){
                iMaterialToDye=ITEM_APPR_ARMOR_COLOR_METAL2;
            }
            else{
                nError=1;
            }
        }
        else{
            nError=1;//not a valid option
        }

        //checks for a valid colour
        iColor=StringToInt(sColour);
        if(iColor<0 || iColor>175){
            nError=1;
        }

        //if there's no errors... the paintjob starts
        if (nError<1 && GetIsObjectValid(oItem)) {
            // Set armor to being edited
            SetLocalInt(oItem, "mil_EditingItem", TRUE);

           //copy and modify
            object oDyedItem = CopyItemAndModifyFixed(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iMaterialToDye, iColor, TRUE);

           // Equip the modified armor
           DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oDyedItem, iItemToDye)));

           //take 50 gold
           TakeGoldFromCreature(50,oPC,TRUE);

           //destroy the original item
           DestroyObject(oItem);

           // Set armor editable again
           DelayCommand(3.0f, DeleteLocalInt(oDyedItem, "mil_EditingItem"));

           //for feedback
           if (sMaterial=="metal"){
                sColour=DyeName(iColor,"metal");
           }
           else{
                sColour=DyeName(iColor,"fabric");
           }
           SpeakString("*beep* "+sColour+" dye applied! *beep*",TALKVOLUME_TALK);
        }
    }

    //no clue what this does
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT)){
        SignalEvent(OBJECT_SELF, EventUserDefined(1004));
    }
}

int LightType(string sType){
    if(sType=="bright"){return IP_CONST_LIGHTBRIGHTNESS_BRIGHT;}
    if(sType=="dim"){return IP_CONST_LIGHTBRIGHTNESS_DIM;}
    if(sType=="low"){return IP_CONST_LIGHTBRIGHTNESS_LOW;}
    if(sType=="normal"){return IP_CONST_LIGHTBRIGHTNESS_NORMAL;}
    return IP_CONST_LIGHTBRIGHTNESS_NORMAL;
}

int LightColour(string sColour){
    if(sColour=="blue"){return IP_CONST_LIGHTCOLOR_BLUE;}
    if(sColour=="green"){return IP_CONST_LIGHTCOLOR_GREEN;}
    if(sColour=="orange"){return IP_CONST_LIGHTCOLOR_ORANGE;}
    if(sColour=="purple"){return IP_CONST_LIGHTCOLOR_PURPLE;}
    if(sColour=="red"){return IP_CONST_LIGHTCOLOR_RED;}
    if(sColour=="white"){return IP_CONST_LIGHTCOLOR_WHITE;}
    if(sColour=="yellow"){return IP_CONST_LIGHTCOLOR_YELLOW;}
    return IP_CONST_LIGHTCOLOR_WHITE;
}

//List of names for each dye
string DyeName(int nIndex, string sType){

    //get the indexed colour from the correct colour list
    if (nIndex > -1 && nIndex < 64 && sType == "fabric"){
        return StandardClothDyes(nIndex);
    }
    else if (nIndex > -1 && nIndex < 64 && sType == "metal"){
        return StandardMetalDyes(nIndex);
    }
    else if (nIndex > 63 && nIndex < 96){
        return LushDyes(nIndex);
    }
    else if (nIndex > 95 && nIndex <136){
        return NaturalDyes(nIndex);
    }
    else if (nIndex > 135 && nIndex <176){
        return UrbanDyes(nIndex);
    }
    return "Unknown Dye";
}

//standard pre 1.67 cloth/leather colours
string StandardClothDyes(int nIndex){

    string sDyeName;

    if (nIndex == 00){ sDyeName = "Lightest Brown"; }
    if (nIndex == 01){ sDyeName = "Light Brown"; }
    if (nIndex == 02){ sDyeName = "Dark Brown"; }
    if (nIndex == 03){ sDyeName = "Darkest Brown"; }
    if (nIndex == 04){ sDyeName = "Lightest Tan"; }
    if (nIndex == 05){ sDyeName = "Light Tan"; }
    if (nIndex == 06){ sDyeName = "Dark Tan"; }
    if (nIndex == 07){ sDyeName = "Darkest Tan"; }
    if (nIndex == 08){ sDyeName = "Lightest Beige"; }
    if (nIndex == 09){ sDyeName = "Light Beige"; }
    if (nIndex == 10){ sDyeName = "Dark Beige"; }
    if (nIndex == 11){ sDyeName = "Darkest Beige"; }
    if (nIndex == 12){ sDyeName = "Lightest Taupe"; }
    if (nIndex == 13){ sDyeName = "Light Taupe"; }
    if (nIndex == 14){ sDyeName = "Dark Taupe"; }
    if (nIndex == 15){ sDyeName = "Darkest Taupe"; }
    if (nIndex == 16){ sDyeName = "Lightest Olive"; }
    if (nIndex == 17){ sDyeName = "Light Olive"; }
    if (nIndex == 18){ sDyeName = "Dark Olive"; }
    if (nIndex == 19){ sDyeName = "Darkest Olive"; }
    if (nIndex == 20){ sDyeName = "Lightest Grey"; }
    if (nIndex == 21){ sDyeName = "Light Grey"; }
    if (nIndex == 22){ sDyeName = "Grey"; }
    if (nIndex == 23){ sDyeName = "Dark Grey"; }
    if (nIndex == 24){ sDyeName = "Blue"; }
    if (nIndex == 25){ sDyeName = "Dark Blue"; }
    if (nIndex == 26){ sDyeName = "Lightest Blue"; }
    if (nIndex == 27){ sDyeName = "Light Blue"; }
    if (nIndex == 28){ sDyeName = "Turquoise"; }
    if (nIndex == 29){ sDyeName = "Teal"; }
    if (nIndex == 30){ sDyeName = "Light Green"; }
    if (nIndex == 31){ sDyeName = "Dark Green"; }
    if (nIndex == 32){ sDyeName = "Yellow"; }
    if (nIndex == 33){ sDyeName = "Dark Yellow"; }
    if (nIndex == 34){ sDyeName = "Orange"; }
    if (nIndex == 35){ sDyeName = "Dark Orange"; }
    if (nIndex == 36){ sDyeName = "Red"; }
    if (nIndex == 37){ sDyeName = "Light Red"; }
    if (nIndex == 38){ sDyeName = "Dark Red"; }
    if (nIndex == 39){ sDyeName = "Pink"; }
    if (nIndex == 40){ sDyeName = "Purple"; }
    if (nIndex == 41){ sDyeName = "Dark Purple"; }
    if (nIndex == 42){ sDyeName = "Lavender"; }
    if (nIndex == 43){ sDyeName = "Dark Lavender"; }
    if (nIndex == 44){ sDyeName = "White"; }
    if (nIndex == 45){ sDyeName = "Black"; }
    if (nIndex == 46){ sDyeName = "Shiny Dark Blue"; }
    if (nIndex == 47){ sDyeName = "Shiny Light Blue"; }
    if (nIndex == 48){ sDyeName = "Shiny Teal"; }
    if (nIndex == 49){ sDyeName = "Shiny Dark Green"; }
    if (nIndex == 50){ sDyeName = "Shiny Dark Yellow"; }
    if (nIndex == 51){ sDyeName = "Shiny Dark Orange"; }
    if (nIndex == 52){ sDyeName = "Shiny Red"; }
    if (nIndex == 53){ sDyeName = "Shiny Pink"; }
    if (nIndex == 54){ sDyeName = "Shiny Purple"; }
    if (nIndex == 55){ sDyeName = "Shiny Dark Lavender"; }
    if (nIndex == 56){ sDyeName = "Silver"; }
    if (nIndex == 57){ sDyeName = "Obsidian"; }
    if (nIndex == 58){ sDyeName = "Shiny Yellow"; }
    if (nIndex == 59){ sDyeName = "Pale Copper"; }
    if (nIndex == 60){ sDyeName = "Textured Grey"; }
    if (nIndex == 61){ sDyeName = "Reflective"; }
    if (nIndex == 62){ sDyeName = "Pure White"; }
    if (nIndex == 63){ sDyeName = "Pure Black"; }

    return sDyeName;
}

//standard pre 1.67 metal colours
string StandardMetalDyes(int nIndex){

    string sDyeName;

    if (nIndex == 00){ sDyeName = "Silver"; }
    if (nIndex == 01){ sDyeName = "Steel"; }
    if (nIndex == 02){ sDyeName = "Dark Steel"; }
    if (nIndex == 03){ sDyeName = "Obsidian"; }
    if (nIndex == 04){ sDyeName = "Bright Grey"; }
    if (nIndex == 05){ sDyeName = "Light Grey"; }
    if (nIndex == 06){ sDyeName = "Dark Grey"; }
    if (nIndex == 07){ sDyeName = "Darkest Grey"; }
    if (nIndex == 08){ sDyeName = "Bright Yellow"; }
    if (nIndex == 09){ sDyeName = "Light Yellow"; }
    if (nIndex == 10){ sDyeName = "Muted  Yellow"; }
    if (nIndex == 11){ sDyeName = "Dark Yellow"; }
    if (nIndex == 12){ sDyeName = "Bright Gold"; }
    if (nIndex == 13){ sDyeName = "Light Gold"; }
    if (nIndex == 14){ sDyeName = "Muted Gold"; }
    if (nIndex == 15){ sDyeName = "Dark Gold"; }
    if (nIndex == 16){ sDyeName = "Bright Orange"; }
    if (nIndex == 17){ sDyeName = "Light Orange"; }
    if (nIndex == 18){ sDyeName = "Muted Orange"; }
    if (nIndex == 19){ sDyeName = "Dark Orange"; }
    if (nIndex == 20){ sDyeName = "Bright Copper"; }
    if (nIndex == 21){ sDyeName = "Light Copper"; }
    if (nIndex == 22){ sDyeName = "Muted Copper"; }
    if (nIndex == 23){ sDyeName = "Dark Copper"; }
    if (nIndex == 24){ sDyeName = "Bright Red"; }
    if (nIndex == 25){ sDyeName = "Maroon"; }
    if (nIndex == 26){ sDyeName = "Muted Bright Red"; }
    if (nIndex == 27){ sDyeName = "Muted Maroon"; }
    if (nIndex == 28){ sDyeName = "Bright Purple"; }
    if (nIndex == 29){ sDyeName = "Dark Purple"; }
    if (nIndex == 30){ sDyeName = "Bright Lavender"; }
    if (nIndex == 31){ sDyeName = "Muted Lavender"; }
    if (nIndex == 32){ sDyeName = "Bright Blue"; }
    if (nIndex == 33){ sDyeName = "Dark Blue"; }
    if (nIndex == 34){ sDyeName = "Muted Bright Blue"; }
    if (nIndex == 35){ sDyeName = "Muted Dark Blue"; }
    if (nIndex == 36){ sDyeName = "Bright Turquoise"; }
    if (nIndex == 37){ sDyeName = "Bright Teal"; }
    if (nIndex == 38){ sDyeName = "Muted Turquoise"; }
    if (nIndex == 39){ sDyeName = "Muted Teal"; }
    if (nIndex == 40){ sDyeName = "Bright Green"; }
    if (nIndex == 41){ sDyeName = "Dark Green"; }
    if (nIndex == 42){ sDyeName = "Muted Bright Green"; }
    if (nIndex == 43){ sDyeName = "Muted Dark Green"; }
    if (nIndex == 44){ sDyeName = "Bright Olive"; }
    if (nIndex == 45){ sDyeName = "Dark Olive"; }
    if (nIndex == 46){ sDyeName = "Muted Bright Olive"; }
    if (nIndex == 47){ sDyeName = "Muted Dark Olive"; }
    if (nIndex == 48){ sDyeName = "Rainbow"; }
    if (nIndex == 49){ sDyeName = "Muted Rainbow"; }
    if (nIndex == 50){ sDyeName = "Light Rust"; }
    if (nIndex == 51){ sDyeName = "Full  Rust"; }
    if (nIndex == 52){ sDyeName = "Dark Rust"; }
    if (nIndex == 53){ sDyeName = "Dark Full Rust"; }
    if (nIndex == 54){ sDyeName = "Textured Grey"; }
    if (nIndex == 55){ sDyeName = "Fully Textured Grey"; }
    if (nIndex == 56){ sDyeName = "Silver"; }
    if (nIndex == 57){ sDyeName = "Obsidian"; }
    if (nIndex == 58){ sDyeName = "Bright Yellow"; }
    if (nIndex == 59){ sDyeName = "Bright Copper"; }
    if (nIndex == 60){ sDyeName = "Shiny Black"; }
    if (nIndex == 61){ sDyeName = "Reflective"; }
    if (nIndex == 62){ sDyeName = "Pure White"; }
    if (nIndex == 63){ sDyeName = "Pure Black"; }

    return sDyeName;
}

//List of lush dyes. Cloth and metal are the same.
string LushDyes(int nIndex){

    string sDyeName;

    if (nIndex == 64){ sDyeName = "Dark Rose"; }
    if (nIndex == 65){ sDyeName = "Mauve"; }
    if (nIndex == 66){ sDyeName = "Dark Gold"; }
    if (nIndex == 67){ sDyeName = "Dull Olive"; }
    if (nIndex == 68){ sDyeName = "Leaf"; }
    if (nIndex == 69){ sDyeName = "Bluegrass"; }
    if (nIndex == 70){ sDyeName = "Dark Plum"; }
    if (nIndex == 71){ sDyeName = "Stone"; }
    if (nIndex == 72){ sDyeName = "Plum"; }
    if (nIndex == 73){ sDyeName = "Faded Plum"; }
    if (nIndex == 74){ sDyeName = "Peachy Tan"; }
    if (nIndex == 75){ sDyeName = "Mouse"; }
    if (nIndex == 76){ sDyeName = "Jade Green"; }
    if (nIndex == 77){ sDyeName = "Dark Jade"; }
    if (nIndex == 78){ sDyeName = "Blue Steel"; }
    if (nIndex == 79){ sDyeName = "Medium Blue Steel"; }
    if (nIndex == 80){ sDyeName = "Medium Olive"; }
    if (nIndex == 81){ sDyeName = "Taupe"; }
    if (nIndex == 82){ sDyeName = "Sky Blue"; }
    if (nIndex == 83){ sDyeName = "Light Blue Steel"; }
    if (nIndex == 84){ sDyeName = "Mould"; }
    if (nIndex == 85){ sDyeName = "Smoke"; }
    if (nIndex == 86){ sDyeName = "Dust"; }
    if (nIndex == 87){ sDyeName = "Dirty Olive"; }
    if (nIndex == 88){ sDyeName = "Light Red"; }
    if (nIndex == 89){ sDyeName = "Red"; }
    if (nIndex == 90){ sDyeName = "Brick Red"; }
    if (nIndex == 91){ sDyeName = "Cherry"; }
    if (nIndex == 92){ sDyeName = "Honey"; }
    if (nIndex == 93){ sDyeName = "Dark Honey"; }
    if (nIndex == 94){ sDyeName = "Mustard"; }
    if (nIndex == 95){ sDyeName = "Dark Mustard"; }

    return sDyeName;
}

//List of natural dyes. Cloth and metal are the same.
string NaturalDyes(int nIndex){

    string sDyeName;

    if (nIndex == 96){ sDyeName = "Lightest Burgundy"; }
    if (nIndex == 97){ sDyeName = "Light Burgundy"; }
    if (nIndex == 98){ sDyeName = "Burgundy"; }
    if (nIndex == 99){ sDyeName = "Dark Burgundy"; }
    if (nIndex == 100){ sDyeName = "Lightest Rouge"; }
    if (nIndex == 101){ sDyeName = "Light Rouge"; }
    if (nIndex == 102){ sDyeName = "Rouge"; }
    if (nIndex == 103){ sDyeName = "Dark Rouge"; }
    if (nIndex == 104){ sDyeName = "Lightest Pine"; }
    if (nIndex == 105){ sDyeName = "Light Pine"; }
    if (nIndex == 106){ sDyeName = "Pine"; }
    if (nIndex == 107){ sDyeName = "Dark Pine"; }
    if (nIndex == 108){ sDyeName = "Lightest Olive"; }
    if (nIndex == 109){ sDyeName = "Light Olive"; }
    if (nIndex == 110){ sDyeName = "Olive"; }
    if (nIndex == 111){ sDyeName = "Dark Olive"; }
    if (nIndex == 112){ sDyeName = "Lightest Taupe"; }
    if (nIndex == 113){ sDyeName = "Light Taupe"; }
    if (nIndex == 114){ sDyeName = "Taupe"; }
    if (nIndex == 115){ sDyeName = "Dark Taupe"; }
    if (nIndex == 116){ sDyeName = "Lighest Caramel"; }
    if (nIndex == 117){ sDyeName = "Light Caramel"; }
    if (nIndex == 118){ sDyeName = "Caramel"; }
    if (nIndex == 119){ sDyeName = "Dark Caramel"; }
    if (nIndex == 120){ sDyeName = "Lightest Champagne"; }
    if (nIndex == 121){ sDyeName = "Light Champagne"; }
    if (nIndex == 122){ sDyeName = "Champagne"; }
    if (nIndex == 123){ sDyeName = "Dark Champagne"; }
    if (nIndex == 124){ sDyeName = "Lightest Chocolate"; }
    if (nIndex == 125){ sDyeName = "Light Chocolate"; }
    if (nIndex == 126){ sDyeName = "Chocolate"; }
    if (nIndex == 127){ sDyeName = "Dark Chocolate"; }
    if (nIndex == 128){ sDyeName = "Lighest Amber"; }
    if (nIndex == 129){ sDyeName = "Light Amber"; }
    if (nIndex == 130){ sDyeName = "Amber"; }
    if (nIndex == 131){ sDyeName = "Dark Amber"; }
    if (nIndex == 132){ sDyeName = "Lightest Shadow"; }
    if (nIndex == 133){ sDyeName = "Light Shadow"; }
    if (nIndex == 134){ sDyeName = "Shadow"; }
    if (nIndex == 135){ sDyeName = "Dark Shadow"; }
    return sDyeName;
}

//List of urban dyes. Cloth and metal are the same.
string UrbanDyes(int nIndex){

    string sDyeName;

    if (nIndex == 136){ sDyeName = "Lightest Indigo"; }
    if (nIndex == 137){ sDyeName = "Light Indigo"; }
    if (nIndex == 138){ sDyeName = "Indigo"; }
    if (nIndex == 139){ sDyeName = "Dark Indigo"; }
    if (nIndex == 140){ sDyeName = "Lightest Turquoise"; }
    if (nIndex == 141){ sDyeName = "Light Turquoise"; }
    if (nIndex == 142){ sDyeName = "Turquoise"; }
    if (nIndex == 143){ sDyeName = "Dark Turquoise"; }
    if (nIndex == 144){ sDyeName = "Lightest Magenta"; }
    if (nIndex == 145){ sDyeName = "Light Magenta"; }
    if (nIndex == 146){ sDyeName = "Magenta"; }
    if (nIndex == 147){ sDyeName = "Dark Magenta"; }
    if (nIndex == 148){ sDyeName = "Light Sky"; }
    if (nIndex == 149){ sDyeName = "Sky"; }
    if (nIndex == 150){ sDyeName = "Light Aquamarine"; }
    if (nIndex == 151){ sDyeName = "Aquamarine"; }
    if (nIndex == 152){ sDyeName = "Light Lime"; }
    if (nIndex == 153){ sDyeName = "Lime"; }
    if (nIndex == 154){ sDyeName = "Light Hobo"; }
    if (nIndex == 155){ sDyeName = "Hobo"; }
    if (nIndex == 156){ sDyeName = "Light Potatoesack"; }
    if (nIndex == 157){ sDyeName = "Potatoesack"; }
    if (nIndex == 158){ sDyeName = "Light Peach"; }
    if (nIndex == 159){ sDyeName = "Peach"; }
    if (nIndex == 160){ sDyeName = "Light Grape"; }
    if (nIndex == 161){ sDyeName = "Grape"; }
    if (nIndex == 162){ sDyeName = "Candy"; }
    if (nIndex == 163){ sDyeName = "Petunia"; }
    if (nIndex == 164){ sDyeName = "Ice"; }
    if (nIndex == 165){ sDyeName = "Dark Frost"; }
    if (nIndex == 166){ sDyeName = "Snow"; }
    if (nIndex == 167){ sDyeName = "Oil"; }
    if (nIndex == 168){ sDyeName = "Bone"; }
    if (nIndex == 169){ sDyeName = "Scale"; }
    if (nIndex == 170){ sDyeName = "Twilight"; }
    if (nIndex == 171){ sDyeName = "Charcoal"; }
    if (nIndex == 172){ sDyeName = "Swampgator"; }
    if (nIndex == 173){ sDyeName = "Dark Mocha"; }
    if (nIndex == 174){ sDyeName = "Light Mocha"; }
    if (nIndex == 175){ sDyeName = "Tarnished Gold"; }
    return sDyeName;
}

