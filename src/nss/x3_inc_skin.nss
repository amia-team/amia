//::///////////////////////////////////////////////
//:: Functions for using variables on a skin object
//:: x3_inc_string
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: Feb 3rd, 2008
//:: Modifications By: The Krit
//:: Last Update: April 16th, 2008
//:://////////////////////////////////////////////

#include "x3_inc_string"

//////////////////////////////////////
// PROTOTYPES
//////////////////////////////////////


// FILE: x3_inc_skin       FUNCTION: SetSkinInt()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void SetSkinInt(object oCreature,string sVariable,int nValue);


// FILE: x3_inc_skin       FUNCTION: SetSkinString()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void SetSkinString(object oCreature,string sVariable,string sValue);


// FILE: x3_inc_skin       FUNCTION: SetSkinFloat()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void SetSkinFloat(object oCreature,string sVariable,float fValue);


// FILE: x3_inc_skin       FUNCTION: GetSkinInt()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
int GetSkinInt(object oCreature,string sVariable);


// FILE: x3_inc_skin       FUNCTION: GetSkinString()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
string GetSkinString(object oCreature,string sVariable);


// FILE: x3_inc_skin       FUNCTION: GetSkinFloat()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
float GetSkinFloat(object oCreature,string sVariable);


// FILE: x3_inc_skin       FUNCTION: DeleteSkinInt()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void DeleteSkinInt(object oCreature,string sVariable);


// FILE: x3_inc_skin       FUNCTION: DeleteSkinString()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void DeleteSkinString(object oCreature,string sVariable);


// FILE: x3_inc_skin       FUNCTION: DeleteSkinFloat()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void DeleteSkinFloat(object oCreature,string sVariable);


///////////////////////////////////////
// FUNCTIONS
///////////////////////////////////////


void SKIN_SupportEquipSkin(object oSkin,int nCount=0)
{ // PURPOSE: Force equip skin
    return;
} // SKIN_SupportEquipSkin()

object SKIN_SupportGetSkin(object oCreature)
{ // PURPOSE: To return the skin object and if need be create it
    return OBJECT_INVALID;
} // SKIN_SupportGetSkin()



void SetSkinInt(object oCreature,string sVariable,int nValue)
{ // PURPOSE: SetSkinInt
    return;
} // SetSkinInt()


void SetSkinString(object oCreature,string sVariable,string sValue)
{ // PURPOSE: SetSkinString
    return;
} // SetSkinString()


void SetSkinFloat(object oCreature,string sVariable,float fValue)
{ // PURPOSE: SetSkinFloat
    return;
} // SetSkinFloat()


int GetSkinInt(object oCreature,string sVariable)
{ // PURPOSE: GetSkinInt
    return 1;
} // GetSkinInt()


string GetSkinString(object oCreature,string sVariable)
{ // PURPOSE: GetSkinString
    return "";
} // GetSkinString()


float GetSkinFloat(object oCreature,string sVariable)
{ // PURPOSE: GetSkinFloat
    return 0.0;
} // GetSkinFloat()


void DeleteSkinInt(object oCreature,string sVariable)
{ // PUPOSE: DeleteSkinInt
    return;
} // DeleteSkinInt()


void DeleteSkinString(object oCreature,string sVariable)
{ // PUPOSE: DeleteSkinString
    return;
} // DeleteSkinString()


void DeleteSkinFloat(object oCreature,string sVariable)
{ // PUPOSE: DeleteSkinFloat
    return;
} // DeleteSkinFloat()


//void main(){}
