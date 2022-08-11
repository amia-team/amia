/*
  Job System Converter Script - Converts the resources into different material

  - Maverick00053

  Edits:
  072722 Lord-Jyssev: new sPlaceableName naming method for placeables and ability to use PLC Spawners in recipes by sType Variable


*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_td_itemprop"

const int RESOURCE_XP = 100;

// Launches the Convo Script
void LaunchConvo( object oBench, object oPC);


// Launches the LaunchJobConverter Function
void LaunchJobConverter(object oPC, object oBench, int nNode);


//Checks their level and sets what they can access
void DS_CHECK_SET(object oPC);


// Launches the AlchemistConverter Function
void AlchemistConverter(object oPC, object oBench, int nNode);


// Launches the ArchitechConverter Function
void ArchitectConverter(object oPC, object oBench, int nNode);


// Launches the ArtificerConverter Function
void ArtificerConverter(object oPC, object oBench, int nNode);


// Launches the ArtistConverter Function
void ArtistConverter(object oPC, object oBench, int nNode);


// Launches the BrewerConverter Function
void BrewerConverter(object oPC, object oBench, int nNode);


// Launches the ChefConverter Function
void ChefConverter(object oPC, object oBench, int nNode);


// Launches the JewelerConverter Function
void JewelerConverter(object oPC, object oBench, int nNode);


// Launches the RangedCraftsmanConverter Function
void RangedCraftsmanConverter(object oPC, object oBench, int nNode);


// Launches the ScoundrelConverter Function
void ScoundrelConverter(object oPC, object oBench, int nNode);


// Launches the ScholarConverter Function
void ScholarConverter(object oPC, object oBench, int nNode);


// Launches the SmithConverter Function
void SmithConverter(object oPC, object oBench, int nNode);


// Launches the TailorConverter Function
void TailorConverter(object oPC, object oBench, int nNode);


//Launches the function to add properties to armor/weapons
void CraftProperties(object oPC, object oCraftedItem, string sType, string sMaterial, string sPlaceableName);


//Launches the function to take the ingredients and produce the product
void CraftProduct(object oPC, object oBench, string sProduct, string sType, string sMaterial, string sIngredient1, string sIngredient2, string sPlaceableName, int nCost, int nStack, int nProductStackSize);

//Sets the material local variables
void SetMaterialType(object oCraftedItem, string sWeaponResRef, int nArmorMaterialPresent, int nArmorMaterial, int nWeaponMaterialPresent, int nWeaponMaterial);

// Clears all the ds_action and ds_check variables
void DS_CLEAR_ALL(object oPC);

// Clears all the ds_check variables
void DS_CLEAR_CHECK(object oPC);


// Finds your job and if it is primary/secondary
int FindJobJournalRank(object oPC, object oBench);


void main()
{
    object oPC          = GetLastClosedBy();
    object oBench       = OBJECT_SELF;
    object oDoor;


    DS_CHECK_SET(oPC);


    // Second run through the code makes sure the PC is set
    if(!GetIsObjectValid(oPC))
    {
      oPC = OBJECT_SELF;
    }


    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");

    if(!GetIsObjectValid(GetFirstItemInInventory(oBench)))
    {
      DeleteLocalInt( oPC, "ds_node");
      DeleteLocalString( oPC, "ds_action");
      DeleteLocalString( oPC, "ds_actionnode");
      return;
    }
    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "js_converter")
    {
       DeleteLocalInt( oPC, "ds_node");
       DeleteLocalString( oPC, "ds_action");
       DeleteLocalString( oPC, "ds_actionnode");
       LaunchConvo(oBench,oPC);
    }
    else if(nNode > 0)
    {

      if( 99 >= nNode >= 1)
      {
         // Since the script is going to be launched a second time and moved from the Bench to the PC you need to make sure the NPC is set
         // properly on the second run.
         oBench = GetNearestObjectByTag("jobconverter",oPC);
         LaunchJobConverter(oPC,oBench,nNode);
         DeleteLocalInt( oPC, "ds_node");
         DeleteLocalString( oPC, "ds_action");
         DeleteLocalString( oPC, "ds_actionnode");
         return;
      }




    }
    else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
    {
      DeleteLocalInt( oPC, "ds_node");
      DeleteLocalString( oPC, "ds_action");
      DeleteLocalString( oPC, "ds_actionnode");
      LaunchConvo(oBench,oPC);
    }


}

void LaunchConvo( object oBench, object oPC){
    string sJob = GetLocalString(oBench,"job");
    SetLocalString(oPC,"ds_action","js_converter");
    AssignCommand(oBench, ActionStartConversation(oPC, "c_js_"+GetStringLowerCase(sJob), TRUE, FALSE));
}

void LaunchJobConverter(object oPC, object oBench, int nNode)
{
    string sJob = GetLocalString(oBench,"job");


    if(sJob == "Alchemist")
    {
      AlchemistConverter(oPC,oBench,nNode);
    }
    else if(sJob == "Artificer")
    {
      ArtificerConverter(oPC,oBench,nNode);
    }
    else if(sJob == "Artist")
    {
      ArtistConverter(oPC,oBench,nNode);
    }
    else if(sJob == "Brewer")
    {
      BrewerConverter(oPC,oBench,nNode);
    }
    else if(sJob == "Chef")
    {
      ChefConverter(oPC,oBench,nNode);
    }
    else if(sJob == "RCraftsman")
    {
      RangedCraftsmanConverter(oPC,oBench,nNode);
    }
    else if(sJob == "Architect")
    {
      ArchitectConverter(oPC,oBench,nNode);
    }
    else if(sJob == "Jeweler")
    {
      JewelerConverter(oPC,oBench,nNode);
    }
    else if(sJob == "Smith")
    {
      SmithConverter(oPC,oBench,nNode);
    }
    else if(sJob == "Scholar")
    {
      ScholarConverter(oPC,oBench,nNode);
    }
    else if(sJob == "Tailor")
    {
      TailorConverter(oPC,oBench,nNode);
    }
    else if(sJob == "Scoundrel")
    {
      ScoundrelConverter(oPC,oBench,nNode);
    }

}

void DS_CHECK_SET(object oPC)
{
  int nPCLevel = GetHitDice(oPC);

  DS_CLEAR_CHECK(oPC);

  if(nPCLevel >= 5)
  {
    SetLocalInt(oPC,"ds_check_1",1);
  }

  if(nPCLevel >= 10)
  {
    SetLocalInt(oPC,"ds_check_2",1);
  }

  if(nPCLevel >= 15)
  {
    SetLocalInt(oPC,"ds_check_3",1);
  }

  if(nPCLevel >= 20)
  {
    SetLocalInt(oPC,"ds_check_4",1);
  }

}


void ArtificerConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    switch(nNode)
    {

      case 1: sProduct = "ds_j_mythalbox"; sIngredient1 = "js_bla_miin"; sIngredient2 = "js_jew_crys"; nCost = 5000; break;
      case 2: sProduct = "ds_j_bandagebag"; sIngredient1 = "js_bui_shpl"; sIngredient2 = "js_bla_miin"; nCost = 5000; break;
      case 3: sProduct = "ds_j_wandcase"; sIngredient1 = "js_bla_siin"; sIngredient2 = "js_bui_shpl"; nCost = 5000; break;
      case 4: sProduct = "x2_it_cfm_bscrl"; sIngredient1 = "js_sch_pape"; sIngredient2 = "js_alch_pure"; nCost = 2000; break;
      case 5: sProduct = "x2_it_cfm_wand"; sIngredient1 = "js_gem_sivo"; sIngredient2 = "js_alch_coil"; nCost = 2000; break;
      case 6: sProduct = "ds_j_scrollbox"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bla_siin"; nCost = 5000; break;
      case 7: sProduct = "js_arca_trca"; sIngredient1 = "js_bui_shpl"; sIngredient2 = "js_tai_bowo"; nCost = 5000; break;
      case 8: sProduct = "js_arca_ncry"; sIngredient1 = "js_jew_crys"; sIngredient2 = "none"; nCost = 2000; nStack = 1; break;
      case 9: sProduct = "js_arca_egc"; sIngredient1 = "js_bla_arfp"; sIngredient2 = "js_scho_anc"; nCost = 2000; break;
      case 10: sProduct = "js_arca_pbait"; sIngredient1 = "js_corpse"; sIngredient2 = "js_jew_crys"; nCost = 2000; break;
      case 11: sProduct = "js_arca_zom"; sIngredient1 = "js_corpse"; sIngredient2 = "js_arca_ncry"; nCost = 2000; nStack = 1; break;
      case 12: sProduct = "js_arca_gol"; sIngredient1 = "js_arca_egc"; sIngredient2 = "js_alch_elee"; nCost = 2000; break;
      case 13: sProduct = "js_arca_dem"; sIngredient1 = "js_arca_pbait"; sIngredient2 = "js_scho_anc"; nCost = 2000; break;
      case 14: sProduct = "js_arca_necore"; sIngredient1 = "js_jew_diam"; sIngredient2 = "js_jew_ruby"; nCost = 2000; nStack = 1; break;
      case 15: sProduct = "js_arca_ecore"; sIngredient1 = "js_jew_sapp"; sIngredient2 = "js_jew_emer"; nCost = 2000; nStack = 1; break;
      case 16: sProduct = "js_arca_zom_w"; sIngredient1 = "js_arca_zom"; sIngredient2 = "jobsystemweapon"; nCost = 2000; break;
      case 17: sProduct = "js_arca_zom_e"; sIngredient1 = "js_arca_zom_w"; sIngredient2 = "js_arca_necore"; nCost = 2000; nStack = 1; break;
      case 18: sProduct = "js_arca_zom_f"; sIngredient1 = "js_arca_zom_e"; sIngredient2 = "js_alch_pofi"; nCost = 5000; break;
      case 19: sProduct = "js_arca_gol_g"; sIngredient1 = "js_arca_gol"; sIngredient2 = "jobsystemweapon"; nCost = 2000; break;
      case 20: sProduct = "js_arca_gol_c"; sIngredient1 = "js_arca_gol_g"; sIngredient2 = "js_arca_ecore"; nCost = 2000; nStack = 1; break;
      case 21: sProduct = "js_arca_gol_h"; sIngredient1 = "js_arca_gol_c"; sIngredient2 = "js_alch_elea"; nCost = 5000; nStack = 1; break;
      case 22: sProduct = "ds_j_gempouch"; sIngredient1 = "js_bla_miin"; sIngredient2 = "js_lea_leat"; nCost = 5000; break;

    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);

}


void ArchitectConverter(object oPC, object oBench, int nNode)
{


    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName = "Job System Placeable";
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    switch(nNode)
    {

      case 1: sProduct = "js_bui_bric"; sIngredient1 = "js_rock_gran"; sIngredient2 = "none"; nCost = 100; break;
      case 2: sProduct = "js_bui_mort"; sIngredient1 = "js_rock_gran"; sIngredient2 = "js_bui_quic"; nCost = 100; break;
      case 3: sProduct = "js_bui_quic"; sIngredient1 = "js_rock_sand"; sIngredient2 = "none"; nCost = 100; break;
      case 4: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "js_bui_dupl"; sType = "js_bui_tabl"; sPlaceableName = "Table"; sMaterial = "plc"; nCost = 2000; break;
      case 5: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_zupl"; sIngredient2 = "js_bla_stin"; sType = "js_bui_drta"; sPlaceableName = "Drow Table"; sMaterial = "plc"; nCost = 2000; break;
      case 6: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "js_tai_boco"; sType = "js_bui_couc"; sPlaceableName = "Couch"; sMaterial = "plc"; nCost = 2000; break;
      case 7: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_zupl"; sIngredient2 = "js_bla_siin"; sType = "js_bui_dral"; sPlaceableName = "Drow Altar"; sMaterial = "plc"; nCost = 2000; break;
      case 8: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "js_farm_cott"; sType = "js_bui_comb"; sPlaceableName = "Combat Dummy"; sMaterial = "plc"; nCost = 2000; break;
      case 9: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "js_tai_bowo"; sType = "js_bui_bed"; sPlaceableName = "Bed"; sMaterial = "plc"; nCost = 2000; break;
      case 10: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "js_bla_irin"; sType = "js_bui_trsi"; sPlaceableName = "Transportable Sign"; sMaterial = "plc"; nCost = 2000; break;
      case 11: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "js_bui_chai"; sPlaceableName = "Chair"; sMaterial = "plc"; nCost = 2000; break;
      case 12: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "js_bla_goin"; sType = "js_bui_thro"; sPlaceableName = "Throne"; sMaterial = "plc"; nCost = 2000; break;
      case 13: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "none"; sType = "js_bui_stoo"; sPlaceableName = "Stool"; sMaterial = "plc"; nCost = 2000; break;
      case 14: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "js_bla_siin"; sType = "js_bui_mirr"; sPlaceableName = "Mirror"; sMaterial = "plc"; nCost = 2000; break;
      case 15: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "js_bui_benc"; sPlaceableName = "Bench"; sMaterial = "plc"; nCost = 2000; break;
      case 16: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_zupl"; sIngredient2 = "js_bla_irin"; sType = "js_bui_drch"; sPlaceableName = "Drow Bench"; sMaterial = "plc"; nCost = 2000; break;
      case 17: sProduct = "js_bui_shpl"; sIngredient1 = "js_tree_shaw"; sIngredient2 = "none"; nCost = 100; break;
      case 18: sProduct = "js_bui_zupl"; sIngredient1 = "js_tree_zurw"; sIngredient2 = "none"; nCost = 100; break;
      case 19: sProduct = "js_bui_phpl"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "none"; nCost = 100; break;
      case 20: sProduct = "js_bui_irpl"; sIngredient1 = "js_tree_irow"; sIngredient2 = "none"; nCost = 100; break;
      case 21: sProduct = "js_bui_dupl"; sIngredient1 = "js_tree_dusw"; sIngredient2 = "none"; nCost = 100; break;
      case 22: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_shpl"; sIngredient2 = "js_bla_siin"; sType = "js_conv_alc"; sPlaceableName = "Alchemist Station"; sMaterial = "plc"; nCost = 5000; break;
      case 23: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_shpl"; sIngredient2 = "js_jew_crys"; sType = "js_conv_arc"; sPlaceableName = "Artificer Station"; sMaterial = "plc"; nCost = 5000; break;
      case 24: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "js_bla_miin"; sType = "js_conv_arh"; sPlaceableName = "Ranged Craftsman Station"; sMaterial = "plc"; nCost = 5000; break;
      case 25: sProduct = "js_plcspawner"; sIngredient1 = "js_bla_miin"; sIngredient2 = "js_jew_crys"; sType = "js_conv_art"; sPlaceableName = "Artist Station"; sMaterial = "plc"; nCost = 5000; break;
      case 26: sProduct = "js_plcspawner"; sIngredient1 = "js_bla_adin"; sIngredient2 = "js_herb_firw"; sType = "js_conv_smi"; sPlaceableName = "Smith Station"; sMaterial = "plc"; nCost = 5000; break;
      case 27: sProduct = "js_plcspawner"; sIngredient1 = "js_bla_miin"; sIngredient2 = "js_herb_firw"; sType = "js_conv_bre"; sPlaceableName = "Brewer Station"; sMaterial = "plc"; nCost = 5000; break;
      case 28: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "js_bla_miin"; sType = "js_conv_bui"; sPlaceableName = "Architect Station"; sMaterial = "plc"; nCost = 5000; break;
      case 29: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "js_bla_miin"; sType = "js_conv_che"; sPlaceableName = "Chef Station"; sMaterial = "plc"; nCost = 5000; break;
      case 30: sProduct = "js_plcspawner"; sIngredient1 = "js_bla_plin"; sIngredient2 = "js_bui_phpl"; sType = "js_conv_jew"; sPlaceableName = "Jeweler Station"; sMaterial = "plc"; nCost = 5000; break;
      case 31: break;
      case 32: sProduct = "js_plcspawner"; sIngredient1 = "js_bla_miin"; sIngredient2 = "js_bui_shpl"; sType = "js_conv_sch"; sPlaceableName = "Scholar Station"; sMaterial = "plc"; nCost = 5000; break;
      case 33: sProduct = "js_plcspawner"; sIngredient1 = "js_tai_boco"; sIngredient2 = "js_bla_miin"; sType = "js_conv_tai"; sPlaceableName = "Tailor Station"; sMaterial = "plc"; nCost = 5000; break;
      case 34: sProduct = "js_plcspawner"; sIngredient1 = "js_bla_stin"; sIngredient2 = "js_bui_shpl"; sType = "js_conv_sco"; sPlaceableName = "Scoundrel Station"; sMaterial = "plc"; nCost = 5000; break;
      case 35: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hide"; sIngredient2 = "js_hun_sbone"; sType = "js_bui_trophy1"; sPlaceableName = "Deer Trophy 1"; sMaterial = "plc"; nCost = 5000; break;
      case 36: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hqhide"; sIngredient2 = "js_hun_mbone"; sType = "js_bui_trophy2"; sPlaceableName = "Bison Trophy"; sMaterial = "plc"; nCost = 5000; break;
      case 37: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_bas"; sIngredient2 = "none"; sType = "js_bui_trophy3"; sPlaceableName = "Fish Trophy"; sMaterial = "plc"; nCost = 5000; break;
      case 38: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_sal"; sIngredient2 = "none"; sType = "js_bui_trophy3"; sPlaceableName = "Fish Trophy"; sMaterial = "plc"; nCost = 5000; break;
      case 39: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_tro"; sIngredient2 = "none"; sType = "js_bui_trophy3"; sPlaceableName = "Fish Trophy"; sMaterial = "plc"; nCost = 5000; break;
      case 40: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hqhide"; sIngredient2 = "js_hun_sbone"; sType = "js_bui_trophy4"; sPlaceableName = "Boar Trophy"; sMaterial = "plc"; nCost = 5000; break;
      case 41: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hqhide"; sIngredient2 = "js_hun_lbone"; sType = "js_bui_wallbear"; sPlaceableName = "Bear Trophy"; sMaterial = "plc"; nCost = 7000; break;
      case 42: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_lhide"; sIngredient2 = "js_hun_mbone"; sType = "js_bui_wallcat"; sPlaceableName = "Cat Trophy"; sMaterial = "plc"; nCost = 10000; break;
      case 43: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hide"; sIngredient2 = "js_hun_mbone"; sType = "js_bui_walldeer1"; sPlaceableName = "Deer Trophy 2"; sMaterial = "plc"; nCost = 5000; break;
      case 44: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hide"; sIngredient2 = "js_hun_mbone"; sType = "js_bui_walldeer2"; sPlaceableName = "Deer Trophy 3"; sMaterial = "plc"; nCost = 5000; break;
      case 45: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hide"; sIngredient2 = "js_hun_mbone"; sType = "js_bui_walldeer3"; sPlaceableName = "Deer Trophy 4"; sMaterial = "plc"; nCost = 5000; break;
      case 46: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hqhide"; sIngredient2 = "js_tree_irow"; sType = "js_bui_drum1"; sPlaceableName = "Drum"; sMaterial = "plc"; nCost = 5000; break;
      case 47: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_lhide"; sIngredient2 = "js_tree_shaw"; sType = "js_bui_drum2"; sPlaceableName = "Massive Drum"; sMaterial = "plc"; nCost = 10000; break;
      case 48: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hippogrif"; sIngredient2 = "js_hun_lbone"; sType = "js_bui_barbhorn"; sPlaceableName = "Massive Leather and Bone Bound Horn"; sMaterial = "plc"; nCost = 10000; break;
      case 49: sProduct = "js_plcspawner"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "js_hun_mbone"; sType = "js_bui_fflag"; sPlaceableName = "Feather Flag"; sMaterial = "plc"; nCost = 5000; break;
      case 50: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_treant"; sIngredient2 = "js_tree_shaw"; sType = "js_bui_totem"; sPlaceableName = "Massive Tribal Totem"; sMaterial = "plc"; nCost = 10000; break;
      case 51: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_sbone"; sIngredient2 = "js_tai_boco"; sType = "js_bui_dreamcat"; sPlaceableName = "Dream Catcher"; sMaterial = "plc"; nCost = 5000; break;
      case 52: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_sbone"; sIngredient2 = "js_hun_mbone"; sType = "js_bui_bonecage"; sPlaceableName = "Bone Cage"; sMaterial = "plc"; nCost = 5000; break;

    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);


}


void AlchemistConverter(object oPC, object oBench, int nNode)
{


    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    switch(nNode)
    {

      case 1: sProduct = "js_alch_coil"; sIngredient1 = "js_farm_coco"; sIngredient2 = "none"; nCost = 100; break;
      case 2: sProduct = "js_alch_ince"; sIngredient1 = "js_herb_rosl"; sIngredient2 = "none"; nCost = 100; break;
      case 3: sProduct = "js_alch_medi"; sIngredient1 = "js_farm_grap"; sIngredient2 = "js_art_tall"; nCost = 100; break;
      case 4: sProduct = "js_alch_poai"; sIngredient1 = "js_alch_elea"; sIngredient2 = "js_alch_pure"; nCost = 100; break;
      case 5: sProduct = "js_alch_poea"; sIngredient1 = "js_alch_elee"; sIngredient2 = "js_alch_pure"; nCost = 100; break;
      case 6: sProduct = "js_alch_pofi"; sIngredient1 = "js_alch_elef"; sIngredient2 = "js_alch_pure"; nCost = 100; break;
      case 7: sProduct = "js_alch_powa"; sIngredient1 = "js_alch_elew"; sIngredient2 = "js_alch_pure"; nCost = 100; break;
      case 8: sProduct = "js_alch_pure"; sIngredient1 = "js_farm_appl"; sIngredient2 = "none"; nCost = 1000; break;
      case 9: sProduct = "js_alch_pure"; sIngredient1 = "js_farm_blac"; sIngredient2 = "none"; nCost = 1000; break;
      case 10: sProduct = "js_alch_scen"; sIngredient1 = "js_art_tall"; sIngredient2 = "js_herb_rosl"; nCost = 100; break;
      case 11: sProduct = "js_alch_loca"; sIngredient1 = "js_alch_coil"; sIngredient2 = "js_herb_felb"; nCost = 100; break;
      case 12: sProduct = "it_medkit005"; sIngredient1 = "js_herb_turs"; sIngredient2 = "js_farm_cott"; nCost = 1000; nProductStackSize = 10; break;
      case 13: sProduct = "js_alch_pohe"; sIngredient1 = "js_alch_midw"; sIngredient2 = "js_alch_medi"; nCost = 2000; nProductStackSize = 10; break;
      case 14: sProduct = "js_alch_midw"; sIngredient1 = "js_herb_turs"; sIngredient2 = "js_alch_loca"; nCost = 100; break;
      case 15: sProduct = "js_alch_poba"; sIngredient1 = "js_herb_felb"; sIngredient2 = "js_alch_elee"; nCost = 100; break;
      case 16: sProduct = "js_alch_pore"; sIngredient1 = "js_herb_turs"; sIngredient2 = "js_herb_rosl"; nCost = 100; break;
      case 17: sProduct = "it_medkit003"; sIngredient1 = "js_herb_rosl"; sIngredient2 = "js_farm_cott"; nCost = 400; nProductStackSize = 10; break;
      case 18: sProduct = "js_alch_slee"; sIngredient1 = "js_farm_hops"; sIngredient2 = "js_herb_rosl"; nCost = 100; break;
      case 19: sProduct = "it_medkit004"; sIngredient1 = "js_herb_felb"; sIngredient2 = "js_farm_cott"; nCost = 600; nProductStackSize = 10; break;
      case 20: sProduct = "js_alch_nebrew"; sIngredient1 = "js_arca_ncry"; sIngredient2 = "js_alch_pure"; nCost = 1000;  nStack = 1; nProductStackSize = 10; break;
      case 21: sProduct = "js_alch_underw"; sIngredient1 = "js_alch_powa"; sIngredient2 = "js_alch_pure"; nCost = 1000; break;
      case 22: sProduct = "js_dryaddom"; sIngredient1 = "js_hun_dryad"; sIngredient2 = "js_alch_pure"; nCost = 3000; nProductStackSize = 10; break;
      case 23: sProduct = "js_grickcompound"; sIngredient1 = "js_hun_grick"; sIngredient2 = "js_alch_pure"; nCost = 3000;  nStack = 1; nProductStackSize = 10; break;
      case 24: sProduct = "js_hydracompound"; sIngredient1 = "js_hun_hydra"; sIngredient2 = "js_alch_pure"; nCost = 3000; break;


     }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);


}


void ArtistConverter(object oPC, object oBench, int nNode)
{


    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName = "Job System Placeable";
    int nActionNode = GetLocalInt( oPC, "ds_actionnode");
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    if(nActionNode == 1)//Candles and Lanterns
    {
        switch(nNode)
        {

          case 1: sProduct = "js_plcspawner"; sIngredient1 = "js_art_cand"; sIngredient2 = "js_herb_rosl"; sType = "js_art_scca"; sPlaceableName = "Scented Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 2: sProduct = "js_plcspawner"; sIngredient1 = "js_art_cand"; sIngredient2 = "js_alch_coil"; sType = "js_art_exca"; sPlaceableName = "Exotic Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 3: sProduct = "js_art_cand"; sIngredient1 = "js_art_tall"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 1000; break;
          case 4: sProduct = "js_plcspawner"; sIngredient1 = "js_art_cand"; sIngredient2 = "js_hun_sbone"; sType = "js_art_skca"; sPlaceableName = "Skull Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 5: sProduct = "js_plcspawner"; sIngredient1 = "js_art_cand"; sIngredient2 = "js_art_colred"; sType = "js_art_candred1"; sPlaceableName = "Red Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 6: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_scntcandle"; sIngredient2 = "js_art_colred"; sType = "js_art_candred2"; sPlaceableName = "Red Scented Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 7: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_exoticcandle"; sIngredient2 = "js_art_colred"; sType = "js_art_candred3"; sPlaceableName = "Red Exotic Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 8: sProduct = "js_plcspawner"; sIngredient1 = "js_art_cand"; sIngredient2 = "js_art_colyel"; sType = "js_art_candyel1"; sPlaceableName = "Yellow Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 9: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_scntcandle"; sIngredient2 = "js_art_colyel"; sType = "js_art_candyel2"; sPlaceableName = "Yellow Scented Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 10: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_exoticcandle"; sIngredient2 = "js_art_colyel"; sType = "js_art_candyel3"; sPlaceableName = "Yellow Exotic Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 11: sProduct = "js_plcspawner"; sIngredient1 = "js_art_cand"; sIngredient2 = "js_art_colprp"; sType = "js_art_candprp1"; sPlaceableName = "Purple Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 12: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_scntcandle"; sIngredient2 = "js_art_colprp"; sType = "js_art_candprp2"; sPlaceableName = "Purple Scented Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 13: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_exoticcandle"; sIngredient2 = "js_art_colprp"; sType = "js_art_candprp3"; sPlaceableName = "Purple Exotic Candle"; sMaterial = "plc"; nCost = 1000; break;
          case 14: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_irow"; sIngredient2 = "js_bla_irin"; sType = "js_art_torch1"; sPlaceableName = "Torch Bracket"; sMaterial = "plc"; nCost = 5000; break;
          case 15: sProduct = "js_plcspawner"; sIngredient1 = "js_bla_stin"; sIngredient2 = "js_tree_phaw"; sType = "js_art_brazier1"; sPlaceableName = "Brazier"; sMaterial = "plc"; nCost = 5000; break;
          case 16: sProduct = "js_plcspawner"; sIngredient1 = "js_bla_stin"; sIngredient2 = "js_jew_crys"; sType = "js_art_lantern1"; sPlaceableName = "Hanging Lantern"; sMaterial = "plc"; nCost = 5000; break;
          case 17: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_jew_crys"; sType = "js_art_lantern2"; sPlaceableName = "Lamp Post"; sMaterial = "plc"; nCost = 5000; break;

        }
    }
    if(nActionNode == 2)//Statues, Sculptures, Designs
    {
        switch(nNode)
        {

          case 1: sProduct = "js_plcspawner"; sIngredient1 = "js_art_colred"; sIngredient2 = "none"; sType = "js_art_runecirc1"; sPlaceableName = "Rune Circle"; sMaterial = "plc"; nCost = 15000; break;
          case 2: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_gran"; sIngredient2 = "none"; sType = "js_art_obelisk1"; sPlaceableName = "Obelisk"; sMaterial = "plc"; nCost = 15000; break;
          case 3: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_gran"; sIngredient2 = "jobsystemweapon"; sType = "js_art_pdsword1"; sPlaceableName = "Pedestal Sword"; sMaterial = "plc"; nCost = 15000; break;
          case 4: sProduct = "js_plcspawner"; sIngredient1 = "js_jew_sapp"; sIngredient2 = "js_arca_ecore"; sType = "js_art_sclblult1"; sPlaceableName = "Blue Light Sculpture"; sMaterial = "plc"; nCost = 20000; break;
          case 5: sProduct = "js_plcspawner"; sIngredient1 = "js_jew_emer"; sIngredient2 = "js_jew_ruby"; sType = "js_art_flrmos1"; sPlaceableName = "Floor Mosaic"; sMaterial = "plc"; nCost = 20000; break;
          case 6: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_gran"; sIngredient2 = "none"; sType = "js_art_stggoyl1"; sPlaceableName = "Statue, Gargoyle"; sMaterial = "plc"; nCost = 15000; break;
          case 7: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_marb"; sIngredient2 = "js_jew_ruby"; sType = "js_art_stmage1"; sPlaceableName = "Statue, Mage"; sMaterial = "plc"; nCost = 15000; break;
          case 8: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_gran"; sIngredient2 = "js_bla_goin"; sType = "js_art_stshld1"; sPlaceableName = "Statue with Shield, Whole"; sMaterial = "plc"; nCost = 15000; break;
          case 9: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_gran"; sIngredient2 = "js_bla_goin"; sType = "js_art_stshld2"; sPlaceableName = "Statue with Shield, Defaced"; sMaterial = "plc"; nCost = 15000; break;
          case 10: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_marb"; sIngredient2 = "none"; sType = "js_art_stfem1"; sPlaceableName = "Statue, Female"; sMaterial = "plc"; nCost = 15000; break;
          case 11: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_gran"; sIngredient2 = "js_alch_elef"; sType = "js_art_stflame1"; sPlaceableName = "Statue, Flaming"; sMaterial = "plc"; nCost = 15000; break;
          case 12: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_gran"; sIngredient2 = "none"; sType = "js_art_sarcoph1"; sPlaceableName = "Sarcophagus"; sMaterial = "plc"; nCost = 20000; break;
          case 13: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_marb"; sIngredient2 = "js_rock_gran"; sType = "js_art_stbust1"; sPlaceableName = "Marble Bust"; sMaterial = "plc"; nCost = 20000; break;
          case 14: sProduct = "js_plcspawner"; sIngredient1 = "js_art_colred"; sIngredient2 = "none"; sType = "js_art_flrpnta1"; sPlaceableName = "Deviant Art: Pentagram"; sMaterial = "plc"; nCost = 10000; break;
          case 15: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_hun_mbone"; sType = "js_art_skulpol1"; sPlaceableName = "Deviant Art: Skull Pole"; sMaterial = "plc"; nCost = 10000; break;
          case 16: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_dusw"; sIngredient2 = "js_hun_lbone"; sType = "js_art_skulpos1"; sPlaceableName = "Deviant Art: Skull Post"; sMaterial = "plc"; nCost = 10000; break;
          case 17: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_hun_mbone"; sType = "js_art_skelhng1"; sPlaceableName = "Deviant Art: Hanging Skeleton"; sMaterial = "plc"; nCost = 10000; break;
          case 18: sProduct = "js_plcspawner"; sIngredient1 = "js_art_colred"; sIngredient2 = "none"; sType = "js_art_flrskl1"; sPlaceableName = "Deviant Art: Floor Skull"; sMaterial = "plc"; nCost = 10000; break;
          case 19: sProduct = "js_plcspawner"; sIngredient1 = "js_jew_emer"; sIngredient2 = "js_bla_goin"; sType = "js_art_stpyrmd1"; sPlaceableName = "Pyramid Sculpture"; sMaterial = "plc"; nCost = 20000; break;

        }
    }
    if(nActionNode == 3)//Decorations
    {
        switch(nNode)
        {

          case 1: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_sand"; sIngredient2 = "none"; sType = "js_art_jars1"; sPlaceableName = "Jars"; sMaterial = "plc"; nCost = 10000; break;
          case 2: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_sand"; sIngredient2 = "none"; sType = "js_art_potclay1"; sPlaceableName = "Plain Pot"; sMaterial = "plc"; nCost = 10000; break;
          case 3: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_pot"; sIngredient2 = "js_art_colyel"; sType = "js_art_potclay2"; sPlaceableName = "Decorated Pot"; sMaterial = "plc"; nCost = 10000; break;
          case 4: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_sand"; sIngredient2 = "js_art_colblu"; sType = "js_art_potclay3"; sPlaceableName = "Blue Pot"; sMaterial = "plc"; nCost = 10000; break;
          case 5: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_sand"; sIngredient2 = "none"; sType = "js_art_urn1"; sPlaceableName = "Urn"; sMaterial = "plc"; nCost = 10000; break;
          case 6: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_dusw"; sIngredient2 = "js_bla_stin"; sType = "js_art_shldrack"; sPlaceableName = "Shield Rack"; sMaterial = "plc"; nCost = 10000; break;
          case 7: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_irow"; sIngredient2 = "js_farm_cott"; sType = "js_art_hangdec1"; sPlaceableName = "Decorative Hanging"; sMaterial = "plc"; nCost = 5000; break;
          case 8: sProduct = "js_plcspawner"; sIngredient1 = "js_jew_crys"; sIngredient2 = "js_bui_shpl"; sType = "js_art_cryball1"; sPlaceableName = "Crystal Ball"; sMaterial = "plc"; nCost = 10000; break;
          case 9: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_irow"; sIngredient2 = "js_bla_stin"; sType = "js_art_globe1"; sPlaceableName = "Globe"; sMaterial = "plc"; nCost = 5000; break;
          case 10: sProduct = "js_plcspawner"; sIngredient1 = "js_rock_marb"; sIngredient2 = "js_jew_crys"; sType = "js_art_divpool1"; sPlaceableName = "Divining Pool"; sMaterial = "plc"; nCost = 10000; break;
          case 11: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_table"; sIngredient2 = "js_bui_shpl"; sType = "js_art_table1"; sPlaceableName = "Table, Fancy"; sMaterial = "plc"; nCost = 10000; break;
          case 12: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_shpl"; sIngredient2 = "js_tail_rsil"; sType = "js_art_wndchim1"; sPlaceableName = "Wind Chimes"; sMaterial = "plc"; nCost = 5000; break;
          case 13: sProduct = "js_plcspawner"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "js_art_anchor1"; sPlaceableName = "Anchor"; sMaterial = "plc"; nCost =5000; break;
          case 14: sProduct = "js_plcspawner"; sIngredient1 = "js_tai_bosi"; sIngredient2 = "js_bui_irpl"; sType = "js_art_lilship1"; sPlaceableName = "Model Ship: Galley"; sMaterial = "plc"; nCost = 5000; break;
          case 15: sProduct = "js_plcspawner"; sIngredient1 = "js_tai_boco"; sIngredient2 = "js_bui_irpl"; sType = "js_art_lilship2"; sPlaceableName = "Model Ship: Sailboat"; sMaterial = "plc"; nCost = 5000; break;
          case 16: sProduct = "js_plcspawner"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "js_bui_irpl"; sType = "js_art_lilship3"; sPlaceableName = "Model Ship: Scooner"; sMaterial = "plc"; nCost = 5000; break;
          case 17: sProduct = "js_plcspawner"; sIngredient1 = "js_tai_bosi"; sIngredient2 = "js_bui_irpl"; sType = "js_art_lilship4"; sPlaceableName = "Model Ship: Galley, Hanging"; sMaterial = "plc"; nCost = 5000; break;

        }
    }
    if(nActionNode == 4)//Rugs
    {
        switch(nNode)
        {

          case 1: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpet"; sIngredient2 = "js_art_colred"; sType = "js_art_rugred1"; sPlaceableName = "Rug, Red"; sMaterial = "plc"; nCost = 5000; break;
          case 2: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpet"; sIngredient2 = "js_art_colorn"; sType = "js_art_rugorg1"; sPlaceableName = "Rug, Orange"; sMaterial = "plc"; nCost = 5000; break;
          case 3: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpet"; sIngredient2 = "js_art_colyel"; sType = "js_art_rugyel1"; sPlaceableName = "Rug, Yellow"; sMaterial = "plc"; nCost = 5000; break;
          case 4: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpet"; sIngredient2 = "js_art_colgrn"; sType = "js_art_ruggrn1"; sPlaceableName = "Rug, Green"; sMaterial = "plc"; nCost = 5000; break;
          case 5: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpet"; sIngredient2 = "js_art_colblu"; sType = "js_art_rugblu1"; sPlaceableName = "Rug, Blue"; sMaterial = "plc"; nCost = 5000; break;
          case 6: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpet"; sIngredient2 = "js_art_colprp"; sType = "js_art_rugprp1"; sPlaceableName = "Rug, Purple"; sMaterial = "plc"; nCost = 5000; break;
          case 7: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpet"; sIngredient2 = "js_art_colblk"; sType = "js_art_rugblk1"; sPlaceableName = "Rug, Black"; sMaterial = "plc"; nCost = 5000; break;
          case 8: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpet"; sIngredient2 = "js_art_colwht"; sType = "js_art_rugwht1"; sPlaceableName = "Rug, White"; sMaterial = "plc"; nCost = 5000; break;
          case 9: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpet"; sIngredient2 = "js_tai_bosi"; sType = "js_art_rugbase1"; sPlaceableName = "Rug, Fancy Base"; sMaterial = "plc"; nCost = 5000; break;
          case 10: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpetfancy"; sIngredient2 = "js_art_colred"; sType = "js_art_rugred2"; sPlaceableName = "Rug, Round"; sMaterial = "plc"; nCost = 7000; break;
          case 11: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpetfancy"; sIngredient2 = "js_art_colorn"; sType = "js_art_rugorg2"; sPlaceableName = "Rug, Large Orange"; sMaterial = "plc"; nCost = 10000; break;
          case 12: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpetfancy"; sIngredient2 = "js_art_colgrn"; sType = "js_art_ruggrn2"; sPlaceableName = "Rug, Large Green 1"; sMaterial = "plc"; nCost = 10000; break;
          case 13: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpetfancy"; sIngredient2 = "js_art_colgrn"; sType = "js_art_ruggrn3"; sPlaceableName = "Rug, Large Green 2"; sMaterial = "plc"; nCost = 10000; break;
          case 14: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_carpetfancy"; sIngredient2 = "js_art_colred"; sType = "js_art_rugred3"; sPlaceableName = "Rug, Large Red"; sMaterial = "plc"; nCost = 10000; break;

        }
    }
    if(nActionNode == 5)//Hangings
    {
        switch(nNode)
        {

          case 1: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgbane1"; sPlaceableName = "Pennant of Bane"; sMaterial = "plc"; nCost = 5000; break;
          case 2: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgcyrc1"; sPlaceableName = "Pennant of Cyric"; sMaterial = "plc"; nCost = 5000; break;
          case 3: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgeili1"; sPlaceableName = "Pennant of Eilistraee"; sMaterial = "plc"; nCost = 5000; break;
          case 4: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgstag1"; sPlaceableName = "Pennant of Green Stag 1"; sMaterial = "plc"; nCost = 5000; break;
          case 5: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgstag2"; sPlaceableName = "Pennant of Green Stag 2"; sMaterial = "plc"; nCost = 5000; break;
          case 6: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flghelm1"; sPlaceableName = "Pennant of Helm"; sMaterial = "plc"; nCost = 5000; break;
          case 7: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgilm1"; sPlaceableName = "Pennant of Ilmater"; sMaterial = "plc"; nCost = 5000; break;
          case 8: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flglath1"; sPlaceableName = "Pennant of Lathander"; sMaterial = "plc"; nCost = 5000; break;
          case 9: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flglolt1"; sPlaceableName = "Pennant of Lolth"; sMaterial = "plc"; nCost = 5000; break;
          case 10: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgmask1"; sPlaceableName = "Pennant of Mask"; sMaterial = "plc"; nCost = 5000; break;
          case 11: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgrav1"; sPlaceableName = "Pennant of Raven and Shield"; sMaterial = "plc"; nCost = 5000; break;
          case 12: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgrav2"; sPlaceableName = "Pennant of Raven and SWord"; sMaterial = "plc"; nCost = 5000; break;
          case 13: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgsune1"; sPlaceableName = "Pennant of Sune"; sMaterial = "plc"; nCost = 5000; break;
          case 14: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgtemp1"; sPlaceableName = "Pennant of Tempus"; sMaterial = "plc"; nCost = 5000; break;
          case 15: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgtorm1"; sPlaceableName = "Pennant of Torm"; sMaterial = "plc"; nCost = 5000; break;
          case 16: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgwauk1"; sPlaceableName = "Pennant of Waukeen"; sMaterial = "plc"; nCost = 5000; break;

        }
    }
    if(nActionNode == 6)//Paintings
    {
        switch(nNode)
        {

          case 1: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_dusw"; sIngredient2 = "js_farm_papy"; sType = "js_art_pain"; sPlaceableName = "Painting"; sMaterial = "plc"; nCost = 2000; break;

        }
    }
    if(nActionNode == 7)//Paints/Dyes
    {
        switch(nNode)
        {

          case 1: sProduct = "js_art_colblk"; sIngredient1 = "js_bla_carb"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 500; break;
          case 2: sProduct = "js_art_colblu"; sIngredient1 = "js_farm_grap"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 500; break;
          case 3: sProduct = "js_art_colgrn"; sIngredient1 = "js_farm_grap"; sIngredient2 = "js_farm_carr"; sType = "none"; sMaterial = "none"; nCost = 500; break;
          case 4: sProduct = "js_art_colorn"; sIngredient1 = "js_farm_carr"; sIngredient2 = "js_farm_cher"; sType = "none"; sMaterial = "none"; nCost = 500; break;
          case 5: sProduct = "js_art_colprp"; sIngredient1 = "js_farm_grap"; sIngredient2 = "js_farm_cher"; sType = "none"; sMaterial = "none"; nCost = 500; break;
          case 6: sProduct = "js_art_colred"; sIngredient1 = "js_farm_cher"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 500; break;
          case 7: sProduct = "js_art_colwht"; sIngredient1 = "js_alch_elea"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 500; break;
          case 8: sProduct = "js_art_colyel"; sIngredient1 = "js_farm_carr"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 500; break;

        }
    }


    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);


}


void BrewerConverter(object oPC, object oBench, int nNode)
{


    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    switch(nNode)
    {

      case 1: sProduct = "js_bre_fili"; sIngredient1 = "js_herb_firw"; sIngredient2 = "js_farm_hops"; nCost = 200; break;
      case 2: sProduct = "js_bre_wine"; sIngredient1 = "js_farm_grap"; sIngredient2 = "none"; nCost = 200; break;
      case 3: sProduct = "js_bre_cide"; sIngredient1 = "js_farm_appl"; sIngredient2 = "none"; nCost = 200; break;
      case 4: sProduct = "js_bre_ale"; sIngredient1 = "js_che_suga"; sIngredient2 = "js_farm_hops"; nCost = 200; break;
      case 5: sProduct = "js_bre_mead"; sIngredient1 = "js_farm_hon"; sIngredient2 = "js_farm_hops"; nCost = 200; break;
      case 6: sProduct = "js_bre_tual"; sIngredient1 = "js_farm_tunn"; sIngredient2 = "none"; nCost = 200; break;
      case 7: sProduct = "js_bre_firl"; sIngredient1 = "js_farm_fire"; sIngredient2 = "none"; nCost = 200; break;
      case 8: sProduct = "js_bre_puru"; sIngredient1 = "js_farm_zurk"; sIngredient2 = "js_farm_fire"; nCost = 200; break;
      case 9: sProduct = "js_bre_velv"; sIngredient1 = "js_farm_deep"; sIngredient2 = "none"; nCost = 200; break;
      case 10: sProduct = "js_bre_babe"; sIngredient1 = "js_farm_barr"; sIngredient2 = "js_farm_tunn"; nCost = 200; break;
      case 11: sProduct = "js_bre_chju"; sIngredient1 = "js_farm_cher"; sIngredient2 = "none"; nCost = 200; break;
      case 12: sProduct = "js_bre_comi"; sIngredient1 = "js_farm_coco"; sIngredient2 = "none"; nCost = 200; break;
      case 13: sProduct = "js_bre_grju"; sIngredient1 = "js_farm_grap"; sIngredient2 = "none"; nCost = 200; break;
      case 14: sProduct = "js_bre_apju"; sIngredient1 = "js_farm_appl"; sIngredient2 = "none"; nCost = 200; break;

    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);


}


void ChefConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    switch(nNode)
    {

      case 1: sProduct = "js_che_coco"; sIngredient1 = "js_farm_coco"; sIngredient2 = "js_che_flou"; nCost = 200; break;
      case 2: sProduct = "js_che_mepi"; sIngredient1 = "js_che_flou"; sIngredient2 = "jobsystemmeat"; nCost = 200; break;
      case 3: sProduct = "js_che_smsa"; sIngredient1 = "js_hun_sal"; sIngredient2 = "js_tree_phaw"; nCost = 200; break;
      case 4: sProduct = "js_che_appi"; sIngredient1 = "js_che_flou"; sIngredient2 = "js_farm_appl"; nCost = 200; break;
      case 5: sProduct = "js_che_chpi"; sIngredient1 = "js_che_flou"; sIngredient2 = "js_farm_cher"; nCost = 200; break;
      case 6: sProduct = "js_che_brea"; sIngredient1 = "js_che_flou"; sIngredient2 = "jobsystemmilk"; nCost = 200; break;
      case 7: sProduct = "js_che_quic"; sIngredient1 = "jobsystemeggs"; sIngredient2 = "js_ran_pork"; nCost = 200; break;
      case 8: sProduct = "js_che_capi"; sIngredient1 = "js_che_flou"; sIngredient2 = "js_farm_carr"; nCost = 200; break;
      case 9: sProduct = "js_che_cake"; sIngredient1 = "js_che_flou"; sIngredient2 = "jobsystemeggs"; nCost = 200; break;
      case 10: sProduct = "js_che_poso"; sIngredient1 = "js_farm_pota"; sIngredient2 = "jobsystemmilk"; nCost = 200; break;
      case 11: sProduct = "js_che_smst"; sIngredient1 = "jobsystemmeat"; sIngredient2 = "js_farm_mush"; nCost = 200; break;
      case 12: sProduct = "js_che_frba"; sIngredient1 = "js_hun_bas"; sIngredient2 = "js_che_butt"; nCost = 200; break;
      case 13: sProduct = "js_che_baom"; sIngredient1 = "jobsystemeggs"; sIngredient2 = "js_ran_pork"; nCost = 200; break;
      case 14: sProduct = "js_che_cheg"; sIngredient1 = "jobsystemeggs"; sIngredient2 = "js_che_chee"; nCost = 200; break;
      case 15: sProduct = "js_che_swca"; sIngredient1 = "js_farm_carr"; sIngredient2 = "js_farm_hon"; nCost = 200; break;
      case 16: sProduct = "js_che_meba"; sIngredient1 = "js_che_brea"; sIngredient2 = "jobsystemmeat"; nCost = 200; break;
      case 17: sProduct = "js_che_batr"; sIngredient1 = "js_hun_tro"; sIngredient2 = "js_che_flou"; nCost = 200; break;
      case 18: sProduct = "js_che_porr"; sIngredient1 = "js_farm_oats"; sIngredient2 = "js_farm_hon"; nCost = 200; break;
      case 19: sProduct = "js_che_caso"; sIngredient1 = "js_farm_carr"; sIngredient2 = "jobsystemmilk"; nCost = 200; break;
      case 20: sProduct = "js_che_hcwi"; sIngredient1 = "js_ran_chme"; sIngredient2 = "js_herb_firw"; nCost = 200; break;
      case 21: sProduct = "js_che_bans"; sIngredient1 = "js_che_saus"; sIngredient2 = "js_farm_mush"; nCost = 200; break;
      case 22: sProduct = "js_che_frap"; sIngredient1 = "js_che_suga"; sIngredient2 = "js_farm_appl"; nCost = 200; break;
      case 23: sProduct = "js_che_frto"; sIngredient1 = "jobsystemeggs"; sIngredient2 = "js_che_brea"; nCost = 200; break;
      case 24: sProduct = "js_che_sapa"; sIngredient1 = "js_hun_sal"; sIngredient2 = "js_che_brea"; nCost = 200; break;
      case 25: sProduct = "js_che_hgha"; sIngredient1 = "js_ran_pork"; sIngredient2 = "js_farm_hon"; nCost = 200; break;
      case 26: sProduct = "js_che_sufr"; sIngredient1 = "js_che_suga"; sIngredient2 = "js_farm_cher"; nCost = 200; break;
      case 27: sProduct = "js_che_bocr"; sIngredient1 = "js_hun_cru"; sIngredient2 = "none"; nCost = 200; break;
      case 28: sProduct = "js_che_rolo"; sIngredient1 = "js_hun_cru"; sIngredient2 = "js_che_butt"; nCost = 200; break;
      case 29: sProduct = "js_che_clch"; sIngredient1 = "js_hun_mus"; sIngredient2 = "jobsystemmilk"; nCost = 200; break;
      case 30: sProduct = "js_che_flou"; sIngredient1 = "js_farm_zurk"; sIngredient2 = "none"; nCost = 200; break;
      case 31: sProduct = "js_che_flou"; sIngredient1 = "js_farm_oats"; sIngredient2 = "none"; nCost = 200; break;
      case 32: sProduct = "js_che_suga"; sIngredient1 = "js_farm_suga"; sIngredient2 = "none"; nCost = 200; break;
      case 33: sProduct = "js_che_fisa"; sIngredient1 = "js_farm_fire"; sIngredient2 = "none"; nCost = 200; break;
      case 34: sProduct = "js_che_roro"; sIngredient1 = "js_ran_rome"; sIngredient2 = "none"; nCost = 200; break;
      case 35: sProduct = "js_che_dtpl"; sIngredient1 = "js_farm_deep"; sIngredient2 = "none"; nCost = 200; break;
      case 36: sProduct = "js_che_romo"; sIngredient1 = "js_ran_rome"; sIngredient2 = "js_farm_tunn"; nCost = 200; break;
      case 37: sProduct = "js_che_spmu"; sIngredient1 = "js_farm_blac"; sIngredient2 = "js_che_fisa"; nCost = 200; break;
      case 38: sProduct = "js_che_baho"; sIngredient1 = "js_farm_barr"; sIngredient2 = "js_che_fisa"; nCost = 200; break;
      case 39: sProduct = "js_che_zuje"; sIngredient1 = "js_farm_zurk"; sIngredient2 = "none"; nCost = 200; break;
      case 40: sProduct = "js_che_butt"; sIngredient1 = "jobsystemmilk"; sIngredient2 = "none"; nCost = 200; break;
      case 41: sProduct = "js_che_chee"; sIngredient1 = "jobsystemmilk"; sIngredient2 = "none"; nCost = 200; break;
      case 42: sProduct = "js_che_saus"; sIngredient1 = "jobsystemmeat"; sIngredient2 = "none"; nCost = 200; break;

    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);



}


void JewelerConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    switch(nNode)
    {

      case 1: sProduct = "js_jew_diam"; sIngredient1 = "js_gem_rdia"; sIngredient2 = "none"; nCost = 1000; nStack = 1; break;
      case 2: sProduct = "js_jew_emer"; sIngredient1 = "js_gem_reme"; sIngredient2 = "none"; nCost = 1000; nStack = 1; break;
      case 3: sProduct = "js_jew_crys"; sIngredient1 = "js_gem_rcry"; sIngredient2 = "none"; nCost = 1000; nStack = 1; break;
      case 4: sProduct = "js_jew_ruby"; sIngredient1 = "js_gem_rrub"; sIngredient2 = "none"; nCost = 1000; nStack = 1; break;
      case 5: sProduct = "js_jew_sapp"; sIngredient1 = "js_gem_rsap"; sIngredient2 = "none"; nCost = 1000; nStack = 1; break;
      case 6: sProduct = "js_jew_amul"; sIngredient1 = "js_gem_ivor"; sIngredient2 = "none"; sType = "amulet"; sMaterial = "ivory"; nCost = 1000; break;
      case 7: sProduct = "js_jew_amul"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "amulet"; sMaterial = "silver"; nCost = 1000; break;
      case 8: sProduct = "js_jew_amul"; sIngredient1 = "js_bla_goin"; sIngredient2 = "none"; sType = "amulet"; sMaterial = "gold"; nCost = 1000; break;
      case 9: sProduct = "js_jew_amul"; sIngredient1 = "js_bla_plin"; sIngredient2 = "none"; sType = "amulet"; sMaterial = "platinum"; nCost = 1000; break;
      case 10: sProduct = "js_jew_ring"; sIngredient1 = "js_gem_ivor"; sIngredient2 = "none"; sType = "ring"; sMaterial = "ivory"; nCost = 1000; break;
      case 11: sProduct = "js_jew_ring"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "ring"; sMaterial = "silver"; nCost = 1000; break;
      case 12: sProduct = "js_jew_ring"; sIngredient1 = "js_bla_goin"; sIngredient2 = "none"; sType = "ring"; sMaterial = "gold"; nCost = 1000; break;
      case 13: sProduct = "js_jew_ring"; sIngredient1 = "js_bla_plin"; sIngredient2 = "none"; sType = "ring"; sMaterial = "platinum"; nCost = 1000; break;
      case 14: sProduct = "js_gem_sivo"; sIngredient1 = "js_gem_ivor"; sIngredient2 = "none"; nCost = 2000; break;

    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);



}


void RangedCraftsmanConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    switch(nNode)
    {

      case 1: sProduct = "js_arch_sling"; sIngredient1 = "js_tai_boco"; sIngredient2 = "none"; sType = "sling"; sMaterial = "cotton"; nCost = 2000; break;
      case 2: sProduct = "js_arch_bow"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "none"; sType = "bow"; sMaterial = "duskwood"; nCost = 4400; break;
      case 3: sProduct = "js_arch_bow"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "bow"; sMaterial = "ironwood"; nCost = 1000; break;
      case 4: sProduct = "js_arch_bow"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "bow"; sMaterial = "phandar"; nCost = 200; break;
      case 5: sProduct = "js_arch_sling"; sIngredient1 = "js_tai_bosi"; sIngredient2 = "none"; sType = "sling"; sMaterial = "silk"; nCost = 2000; break;
      case 6: sProduct = "js_arch_bow"; sIngredient1 = "js_bui_shpl"; sIngredient2 = "none"; sType = "bow"; sMaterial = "shadowtop"; nCost = 8500; break;
      case 7: sProduct = "js_arch_sling"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "none"; sType = "sling"; sMaterial = "wool"; nCost = 2000; break;
      case 8: sProduct = "js_arch_bow"; sIngredient1 = "js_bui_zupl"; sIngredient2 = "none"; sType = "bow"; sMaterial = "zurkwood"; nCost = 2000; break;
      case 9: sProduct = "js_arch_irbu"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "bullet"; sMaterial = "iron"; nCost = 100; break;
      case 10: sProduct = "js_arch_adbu"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "bullet"; sMaterial = "adamantine"; nCost = 100; break;
      case 11: sProduct = "js_arch_sibu"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "bullet"; sMaterial = "silver"; nCost = 100; break;
      case 12: sProduct = "js_arch_stbu"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "bullet"; sMaterial = "steel"; nCost = 100; break;
      case 13: sProduct = "js_arch_siar"; sIngredient1 = "js_bla_siin"; sIngredient2 = "js_bui_phpl"; sType = "arrow"; sMaterial = "silver"; nCost = 100; break;
      case 14: sProduct = "js_arch_sibt"; sIngredient1 = "js_bla_siin"; sIngredient2 = "js_bui_phpl"; sType = "bolt"; sMaterial = "silver"; nCost = 100; break;
      case 15: sProduct = "js_arch_adar"; sIngredient1 = "js_bla_adin"; sIngredient2 = "js_bui_phpl"; sType = "arrow"; sMaterial = "adamantine"; nCost = 100; break;
      case 16: sProduct = "js_arch_adbt"; sIngredient1 = "js_bla_adin"; sIngredient2 = "js_bui_phpl"; sType = "bolt"; sMaterial = "adamantine"; nCost = 100; break;
      case 17: sProduct = "js_arch_star"; sIngredient1 = "js_bla_stin"; sIngredient2 = "js_bui_phpl"; sType = "arrow"; sMaterial = "steel"; nCost = 100; break;
      case 18: sProduct = "js_arch_stbt"; sIngredient1 = "js_bla_stin"; sIngredient2 = "js_bui_phpl"; sType = "bolt"; sMaterial = "steel"; nCost = 100; break;
      case 19: sProduct = "js_arch_irar"; sIngredient1 = "js_bla_irin"; sIngredient2 = "js_bui_phpl"; sType = "arrow"; sMaterial = "iron"; nCost = 100; break;
      case 20: sProduct = "js_arch_irbt"; sIngredient1 = "js_bla_irin"; sIngredient2 = "js_bui_phpl"; sType = "bolt"; sMaterial = "iron"; nCost = 100; break;
      case 21: sProduct = "js_arch_cbow"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "none"; sType = "crossbow"; sMaterial = "duskwood"; nCost = 4400; break;
      case 22: sProduct = "js_arch_cbow"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "crossbow"; sMaterial = "ironwood"; nCost = 1000; break;
      case 23: sProduct = "js_arch_cbow"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "crossbow"; sMaterial = "phandar"; nCost = 200; break;
      case 24: sProduct = "js_arch_cbow"; sIngredient1 = "js_bui_shpl"; sIngredient2 = "none"; sType = "crossbow"; sMaterial = "shadowtop"; nCost = 8500; break;
      case 25: sProduct = "js_arch_cbow"; sIngredient1 = "js_bui_zupl"; sIngredient2 = "none"; sType = "crossbow"; sMaterial = "zurkwood"; nCost = 2000; break;
      case 26: sProduct = "js_arch_lbow"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "none"; sType = "lightcrossbow"; sMaterial = "duskwood"; nCost = 4400; break;
      case 27: sProduct = "js_arch_lbow"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "lightcrossbow"; sMaterial = "ironwood"; nCost = 1000; break;
      case 28: sProduct = "js_arch_lbow"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "lightcrossbow"; sMaterial = "phandar"; nCost = 200; break;
      case 29: sProduct = "js_arch_lbow"; sIngredient1 = "js_bui_shpl"; sIngredient2 = "none"; sType = "lightcrossbow"; sMaterial = "shadowtop"; nCost = 8500; break;
      case 30: sProduct = "js_arch_lbow"; sIngredient1 = "js_bui_zupl"; sIngredient2 = "none"; sType = "lightcrossbow"; sMaterial = "zurkwood"; nCost = 2000; break;
      case 31: sProduct = "js_arch_sbow"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "none"; sType = "shortbow"; sMaterial = "duskwood"; nCost = 4400; break;
      case 32: sProduct = "js_arch_sbow"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "shortbow"; sMaterial = "ironwood"; nCost = 1000; break;
      case 33: sProduct = "js_arch_sbow"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "shortbow"; sMaterial = "phandar"; nCost = 200; break;
      case 34: sProduct = "js_arch_sbow"; sIngredient1 = "js_bui_shpl"; sIngredient2 = "none"; sType = "shortbow"; sMaterial = "shadowtop"; nCost = 8500; break;
      case 35: sProduct = "js_arch_sbow"; sIngredient1 = "js_bui_zupl"; sIngredient2 = "none"; sType = "shortbow"; sMaterial = "zurkwood"; nCost = 2000; break;

    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);


}


void ScoundrelConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    switch(nNode)
    {
      case 1: sProduct = "js_sco_druw"; sIngredient1 = "js_herb_moow"; sIngredient2 = "js_herb_firw"; nCost = 100; break;
      case 2: sProduct = "js_sco_drus"; sIngredient1 = "js_farm_fire"; sIngredient2 = "js_herb_sils"; nCost = 100; break;
      case 3: sProduct = "js_sco_drum"; sIngredient1 = "js_farm_blac"; sIngredient2 = "js_farm_mush"; nCost = 100; break;
      case 4: sProduct = "js_poison"; sIngredient1 = "js_farm_mush"; sIngredient2 = "none"; nCost = 100; break;
      case 5: sProduct = "js_bindingrope"; sIngredient1 = "js_hun_hide"; sIngredient2 = "js_alch_slee"; nCost = 1000; break;
      case 6: sProduct = "js_venomgland"; sIngredient1 = "js_hun_vgland"; sIngredient2 = "none"; nCost = 1000; break;
      case 7: sProduct = "js_hqvenomgland"; sIngredient1 = "js_hun_hqvgland"; sIngredient2 = "none"; nCost = 1300; break;
      case 8: sProduct = "js_lvenomgland"; sIngredient1 = "js_hun_lvgland"; sIngredient2 = "none"; nCost = 1600; break;
      case 9: sProduct = "js_wyverngland"; sIngredient1 = "js_hun_wyvern"; sIngredient2 = "none"; nCost = 2000; break;
      case 10: sProduct = "js_arca_spiderl"; sIngredient1 = "js_hun_cspider"; sIngredient2 = "js_alch_slee"; nCost = 2000; break;
    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);



}


void ScholarConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    switch(nNode)
    {

      case 1: sProduct = "js_sch_embo"; sIngredient1 = "js_sch_pape"; sIngredient2 = "js_tai_boco"; nCost = 2000; break;
      case 2: sProduct = "js_sch_emto"; sIngredient1 = "js_sch_pape"; sIngredient2 = "js_lea_leat"; nCost = 2000; break;
      case 3: sProduct = "js_sch_pape"; sIngredient1 = "js_farm_papy"; sIngredient2 = "none"; nCost = 1000; break;
      case 4: sProduct = "js_sch_pape"; sIngredient1 = "js_farm_barr"; sIngredient2 = "none"; nCost = 1000; break;
      case 5: sProduct = "js_sch_pape"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "none"; nCost = 1000; break;
      case 6: sProduct = "js_sch_pape"; sIngredient1 = "js_tree_zurw"; sIngredient2 = "none"; nCost = 1000; break;

    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);



}


void SmithConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nActionNode = GetLocalInt( oPC, "ds_actionnode");
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    if(nActionNode == 1)
    {

      switch(nNode)
      {

        case 1: sProduct = "js_bla_miin"; sIngredient1 = "js_met_mito"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 5000; break;
        case 2: sProduct = "js_bla_goin"; sIngredient1 = "js_met_golo"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 1000; break;
        case 3: sProduct = "js_bla_carb"; sIngredient1 = "jobsystemwood"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 1000; break;
        case 4: sProduct = "js_bla_adin"; sIngredient1 = "js_met_adao"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 7000; break;
        case 5: sProduct = "js_bla_plin"; sIngredient1 = "js_met_plao"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 1000; break;
        case 6: sProduct = "js_bla_irin"; sIngredient1 = "js_met_iroo"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 1000; break;
        case 7: sProduct = "js_bla_stin"; sIngredient1 = "js_met_iroo"; sIngredient2 = "js_bla_carb"; sType = "none"; sMaterial = "none"; nCost = 1000; break;
        case 8: sProduct = "js_bla_siin"; sIngredient1 = "js_met_silo"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 3000; break;
        case 9: sProduct = "js_bla_goin"; sIngredient1 = "js_scou_exp"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 1000; break;
        case 10: sProduct = "js_bla_siin"; sIngredient1 = "js_scou_sil"; sIngredient2 = "none"; sType = "none"; sMaterial = "none"; nCost = 3000; break;

      }
    }
    else if(nActionNode == 2) // Mithral
    {

      switch(nNode)
      {

        case 1: sProduct = "js_bla_wega"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 2: sProduct = "js_bla_wedw"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 3: sProduct = "js_bla_weha"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 4: sProduct = "js_bla_weba"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 5: sProduct = "js_bla_webs"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 6: sProduct = "js_bla_weda"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 7: sProduct = "js_bla_wegs"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 8: sProduct = "js_bla_wels"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 9: sProduct = "js_bla_weka"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 10: sProduct = "js_bla_wera"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 11: sProduct = "js_bla_wesc"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 12: sProduct = "js_bla_wess"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 13: sProduct = "js_bla_wecl"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 14: sProduct = "js_bla_wehf"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 15: sProduct = "js_bla_welf"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 16: sProduct = "js_bla_welh"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 17: sProduct = "js_bla_wewa"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 18: sProduct = "js_bla_wema"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 19: sProduct = "js_bla_wemo"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 20: sProduct = "js_bla_wedm"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 21: sProduct = "js_bla_wedb"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 22: sProduct = "js_bla_wequ"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 23: sProduct = "js_bla_we2b"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 24: sProduct = "js_bla_wekm"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 25: sProduct = "js_bla_weku"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 26: sProduct = "js_bla_wesi"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 27: sProduct = "js_bla_wewh"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 28: sProduct = "js_bla_wems"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 29: sProduct = "js_bla_wehb"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 30: sProduct = "js_bla_wesy"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 31: sProduct = "js_bla_wesp"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 32: sProduct = "js_bla_wetr"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "mithral"; nCost = 3000; break;
        case 33: sProduct = "js_bla_arcs"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "mithral"; nCost = 15000; break;
        case 34: sProduct = "js_bla_arbp"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "mithral"; nCost = 15000; break;
        case 35: sProduct = "js_bla_arch"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "mithral"; nCost = 15000; break;
        case 36: sProduct = "js_bla_arsc"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "mithral"; nCost = 15000; break;
        case 37: sProduct = "js_bla_arbm"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "mithral"; nCost = 15000; break;
        case 38: sProduct = "js_bla_arfp"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "mithral"; nCost = 15000; break;
        case 39: sProduct = "js_bla_arhp"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "mithral"; nCost = 15000; break;
        case 40: sProduct = "js_bla_arsp"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "mithral"; nCost = 15000; break;
        case 41: sProduct = "js_bla_shsm"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "mithral"; nCost = 15000; break;
        case 42: sProduct = "js_bla_shlg"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "mithral"; nCost = 15000; break;
        case 43: sProduct = "js_bla_shto"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "mithral"; nCost = 15000; break;
        case 44: sProduct = "js_bla_helm"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "helmet"; sMaterial = "mithral"; nCost = 15000; break;
        case 45: sProduct = "js_bla_grea"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "greaves"; sMaterial = "mithral"; nCost = 15000; break;
        case 46: sProduct = "js_bla_brac"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "bracers"; sMaterial = "mithral"; nCost = 15000; break;

      }
    }
    else if(nActionNode == 3) // Adamantine
    {

      switch(nNode)
      {

        case 1: sProduct = "js_bla_wega"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 2: sProduct = "js_bla_wedw"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 3: sProduct = "js_bla_weha"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 4: sProduct = "js_bla_weba"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 5: sProduct = "js_bla_webs"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 6: sProduct = "js_bla_weda"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 7: sProduct = "js_bla_wegs"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 8: sProduct = "js_bla_wels"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 9: sProduct = "js_bla_weka"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 10: sProduct = "js_bla_wera"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 11: sProduct = "js_bla_wesc"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 12: sProduct = "js_bla_wess"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 13: sProduct = "js_bla_wecl"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 14: sProduct = "js_bla_wehf"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 15: sProduct = "js_bla_welf"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 16: sProduct = "js_bla_welh"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 17: sProduct = "js_bla_wewa"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 18: sProduct = "js_bla_wema"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 19: sProduct = "js_bla_wemo"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 20: sProduct = "js_bla_wedm"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 21: sProduct = "js_bla_wedb"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 22: sProduct = "js_bla_wequ"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 23: sProduct = "js_bla_we2b"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 24: sProduct = "js_bla_wekm"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 25: sProduct = "js_bla_weku"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 26: sProduct = "js_bla_wesi"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 27: sProduct = "js_bla_wewh"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 28: sProduct = "js_bla_wems"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 29: sProduct = "js_bla_wehb"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 30: sProduct = "js_bla_wesy"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 31: sProduct = "js_bla_wesp"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 32: sProduct = "js_bla_wetr"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "adamantine"; nCost = 5400; break;
        case 33: sProduct = "js_bla_arcs"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "adamantine"; nCost = 15000; break;
        case 34: sProduct = "js_bla_arbp"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "adamantine"; nCost = 15000; break;
        case 35: sProduct = "js_bla_arch"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "adamantine"; nCost = 15000; break;
        case 36: sProduct = "js_bla_arsc"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "adamantine"; nCost = 15000; break;
        case 37: sProduct = "js_bla_arbm"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "adamantine"; nCost = 15000; break;
        case 38: sProduct = "js_bla_arfp"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "adamantine"; nCost = 15000; break;
        case 39: sProduct = "js_bla_arhp"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "adamantine"; nCost = 15000; break;
        case 40: sProduct = "js_bla_arsp"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "adamantine"; nCost = 15000; break;
        case 41: sProduct = "js_bla_shsm"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "adamantine"; nCost = 15000; break;
        case 42: sProduct = "js_bla_shlg"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "adamantine"; nCost = 15000; break;
        case 43: sProduct = "js_bla_shto"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "adamantine"; nCost = 15000; break;
        case 44: sProduct = "js_bla_helm"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "helmet"; sMaterial = "adamantine"; nCost = 15000; break;
        case 45: sProduct = "js_bla_grea"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "greaves"; sMaterial = "adamantine"; nCost = 15000; break;
        case 46: sProduct = "js_bla_brac"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "bracers"; sMaterial = "adamantine"; nCost = 15000; break;

      }
    }
    else if(nActionNode == 4) // Silver
    {

      switch(nNode)
      {

        case 1: sProduct = "js_bla_wega"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 2: sProduct = "js_bla_wedw"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 3: sProduct = "js_bla_weha"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 4: sProduct = "js_bla_weba"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 5: sProduct = "js_bla_webs"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 6: sProduct = "js_bla_weda"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 7: sProduct = "js_bla_wegs"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 8: sProduct = "js_bla_wels"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 9: sProduct = "js_bla_weka"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 10: sProduct = "js_bla_wera"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 11: sProduct = "js_bla_wesc"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 12: sProduct = "js_bla_wess"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 13: sProduct = "js_bla_wecl"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 14: sProduct = "js_bla_wehf"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 15: sProduct = "js_bla_welf"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 16: sProduct = "js_bla_welh"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 17: sProduct = "js_bla_wewa"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 18: sProduct = "js_bla_wema"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 19: sProduct = "js_bla_wemo"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 20: sProduct = "js_bla_wedm"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 21: sProduct = "js_bla_wedb"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 22: sProduct = "js_bla_wequ"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 23: sProduct = "js_bla_we2b"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 24: sProduct = "js_bla_wekm"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 25: sProduct = "js_bla_weku"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 26: sProduct = "js_bla_wesi"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 27: sProduct = "js_bla_wewh"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 28: sProduct = "js_bla_wems"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 29: sProduct = "js_bla_wehb"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 30: sProduct = "js_bla_wesy"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 31: sProduct = "js_bla_wesp"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "silver"; nCost = 2000; break;
        case 32: sProduct = "js_bla_wetr"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "silver"; nCost = 2000; break;
        case 33: sProduct = "js_bla_arcs"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "silver"; nCost = 10000; break;
        case 34: sProduct = "js_bla_arbp"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "silver"; nCost = 10000; break;
        case 35: sProduct = "js_bla_arch"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "silver"; nCost = 10000; break;
        case 36: sProduct = "js_bla_arsc"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "silver"; nCost = 10000; break;
        case 37: sProduct = "js_bla_arbm"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "silver"; nCost = 10000; break;
        case 38: sProduct = "js_bla_arfp"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "silver"; nCost = 10000; break;
        case 39: sProduct = "js_bla_arhp"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "silver"; nCost = 10000; break;
        case 40: sProduct = "js_bla_arsp"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "silver"; nCost = 10000; break;
        case 41: sProduct = "js_bla_shsm"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "silver"; nCost = 10000; break;
        case 42: sProduct = "js_bla_shlg"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "silver"; nCost = 10000; break;
        case 43: sProduct = "js_bla_shto"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "silver"; nCost = 10000; break;
        case 44: sProduct = "js_bla_helm"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "helmet"; sMaterial = "silver"; nCost = 10000; break;
        case 45: sProduct = "js_bla_grea"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "greaves"; sMaterial = "silver"; nCost = 10000; break;
        case 46: sProduct = "js_bla_brac"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "bracers"; sMaterial = "silver"; nCost = 10000; break;

      }
    }
    else if(nActionNode == 5) // Ironwood
    {

      switch(nNode)
      {

        case 1: sProduct = "js_bla_wega"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 2: sProduct = "js_bla_wedw"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 3: sProduct = "js_bla_weha"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 4: sProduct = "js_bla_weba"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 5: sProduct = "js_bla_webs"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 6: sProduct = "js_bla_weda"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 7: sProduct = "js_bla_wegs"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 8: sProduct = "js_bla_wels"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 9: sProduct = "js_bla_weka"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 10: sProduct = "js_bla_wera"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 11: sProduct = "js_bla_wesc"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 12: sProduct = "js_bla_wess"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 13: sProduct = "js_bla_wecl"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 14: sProduct = "js_bla_wehf"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 15: sProduct = "js_bla_welf"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 16: sProduct = "js_bla_welh"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 17: sProduct = "js_bla_wewa"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 18: sProduct = "js_bla_wema"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 19: sProduct = "js_bla_wemo"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 20: sProduct = "js_bla_wedm"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 21: sProduct = "js_bla_wedb"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 22: sProduct = "js_bla_wequ"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 23: sProduct = "js_bla_we2b"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 24: sProduct = "js_bla_wekm"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 25: sProduct = "js_bla_weku"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 26: sProduct = "js_bla_wesi"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 27: sProduct = "js_bla_wewh"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 28: sProduct = "js_bla_wems"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 29: sProduct = "js_bla_wehb"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 30: sProduct = "js_bla_wesy"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 31: sProduct = "js_bla_wesp"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 32: sProduct = "js_bla_wetr"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "ironwood"; nCost = 1000; break;
        case 33: sProduct = "js_bla_arcs"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "armor"; sMaterial = "ironwood"; nCost = 1000; break;
        case 34: sProduct = "js_bla_arbp"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "armor"; sMaterial = "ironwood"; nCost = 1000; break;
        case 35: sProduct = "js_bla_arch"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "armor"; sMaterial = "ironwood"; nCost = 1000; break;
        case 36: sProduct = "js_bla_arsc"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "armor"; sMaterial = "ironwood"; nCost = 1000; break;
        case 37: sProduct = "js_bla_arbm"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "armor"; sMaterial = "ironwood"; nCost = 1000; break;
        case 38: sProduct = "js_bla_arfp"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "armor"; sMaterial = "ironwood"; nCost = 1000; break;
        case 39: sProduct = "js_bla_arhp"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "armor"; sMaterial = "ironwood"; nCost = 1000; break;
        case 40: sProduct = "js_bla_arsp"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "armor"; sMaterial = "ironwood"; nCost = 1000; break;
        case 41: sProduct = "js_bla_shsm"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "shield"; sMaterial = "ironwood"; nCost = 1000; break;
        case 42: sProduct = "js_bla_shlg"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "shield"; sMaterial = "ironwood"; nCost = 1000; break;
        case 43: sProduct = "js_bla_shto"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "shield"; sMaterial = "ironwood"; nCost = 1000; break;
        case 44: sProduct = "js_bla_helm"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "helmet"; sMaterial = "ironwood"; nCost = 1000; break;
        case 45: sProduct = "js_bla_grea"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "greaves"; sMaterial = "ironwood"; nCost = 1000; break;
        case 46: sProduct = "js_bla_brac"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "bracers"; sMaterial = "ironwood"; nCost = 1000; break;

      }
    }
    else if(nActionNode == 6) // Steel
    {

      switch(nNode)
      {

        case 1: sProduct = "js_bla_wega"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 2: sProduct = "js_bla_wedw"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 3: sProduct = "js_bla_weha"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 4: sProduct = "js_bla_weba"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 5: sProduct = "js_bla_webs"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 6: sProduct = "js_bla_weda"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 7: sProduct = "js_bla_wegs"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 8: sProduct = "js_bla_wels"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 9: sProduct = "js_bla_weka"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 10: sProduct = "js_bla_wera"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 11: sProduct = "js_bla_wesc"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 12: sProduct = "js_bla_wess"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 13: sProduct = "js_bla_wecl"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 14: sProduct = "js_bla_wehf"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 15: sProduct = "js_bla_welf"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 16: sProduct = "js_bla_welh"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 17: sProduct = "js_bla_wewa"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 18: sProduct = "js_bla_wema"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 19: sProduct = "js_bla_wemo"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 20: sProduct = "js_bla_wedm"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 21: sProduct = "js_bla_wedb"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 22: sProduct = "js_bla_wequ"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 23: sProduct = "js_bla_we2b"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 24: sProduct = "js_bla_wekm"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 25: sProduct = "js_bla_weku"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 26: sProduct = "js_bla_wesi"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 27: sProduct = "js_bla_wewh"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 28: sProduct = "js_bla_wems"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 29: sProduct = "js_bla_wehb"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 30: sProduct = "js_bla_wesy"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 31: sProduct = "js_bla_wesp"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "steel"; nCost = 1000; break;
        case 32: sProduct = "js_bla_wetr"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "steel"; nCost = 1000; break;
        case 33: sProduct = "js_bla_arcs"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "steel"; nCost = 1000; break;
        case 34: sProduct = "js_bla_arbp"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "steel"; nCost = 1000; break;
        case 35: sProduct = "js_bla_arch"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "steel"; nCost = 1000; break;
        case 36: sProduct = "js_bla_arsc"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "steel"; nCost = 1000; break;
        case 37: sProduct = "js_bla_arbm"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "steel"; nCost = 1000; break;
        case 38: sProduct = "js_bla_arfp"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "steel"; nCost = 1000; break;
        case 39: sProduct = "js_bla_arhp"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "steel"; nCost = 1000; break;
        case 40: sProduct = "js_bla_arsp"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "steel"; nCost = 1000; break;
        case 41: sProduct = "js_bla_shsm"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "steel"; nCost = 1000; break;
        case 42: sProduct = "js_bla_shlg"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "steel"; nCost = 1000; break;
        case 43: sProduct = "js_bla_shto"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "steel"; nCost = 1000; break;
        case 44: sProduct = "js_bla_helm"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "helmet"; sMaterial = "steel"; nCost = 1000; break;
        case 45: sProduct = "js_bla_grea"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "greaves"; sMaterial = "steel"; nCost = 1000; break;
        case 46: sProduct = "js_bla_brac"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "bracers"; sMaterial = "steel"; nCost = 1000; break;

      }
    }
    else if(nActionNode == 7) // Iron
    {

      switch(nNode)
      {

        case 1: sProduct = "js_bla_wega"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 2: sProduct = "js_bla_wedw"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 3: sProduct = "js_bla_weha"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 4: sProduct = "js_bla_weba"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 5: sProduct = "js_bla_webs"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 6: sProduct = "js_bla_weda"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 7: sProduct = "js_bla_wegs"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 8: sProduct = "js_bla_wels"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 9: sProduct = "js_bla_weka"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 10: sProduct = "js_bla_wera"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 11: sProduct = "js_bla_wesc"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 12: sProduct = "js_bla_wess"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 13: sProduct = "js_bla_wecl"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 14: sProduct = "js_bla_wehf"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 15: sProduct = "js_bla_welf"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 16: sProduct = "js_bla_welh"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 17: sProduct = "js_bla_wewa"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 18: sProduct = "js_bla_wema"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 19: sProduct = "js_bla_wemo"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 20: sProduct = "js_bla_wedm"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 21: sProduct = "js_bla_wedb"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 22: sProduct = "js_bla_wequ"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 23: sProduct = "js_bla_we2b"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 24: sProduct = "js_bla_wekm"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 25: sProduct = "js_bla_weku"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 26: sProduct = "js_bla_wesi"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 27: sProduct = "js_bla_wewh"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 28: sProduct = "js_bla_wems"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 29: sProduct = "js_bla_wehb"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 30: sProduct = "js_bla_wesy"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 31: sProduct = "js_bla_wesp"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "iron"; nCost = 1000; break;
        case 32: sProduct = "js_bla_wetr"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "iron"; nCost = 1000; break;
        case 33: sProduct = "js_bla_arcs"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "iron"; nCost = 1000; break;
        case 34: sProduct = "js_bla_arbp"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "iron"; nCost = 1000; break;
        case 35: sProduct = "js_bla_arch"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "iron"; nCost = 1000; break;
        case 36: sProduct = "js_bla_arsc"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "iron"; nCost = 1000; break;
        case 37: sProduct = "js_bla_arbm"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "iron"; nCost = 1000; break;
        case 38: sProduct = "js_bla_arfp"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "iron"; nCost = 1000; break;
        case 39: sProduct = "js_bla_arhp"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "iron"; nCost = 1000; break;
        case 40: sProduct = "js_bla_arsp"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "armor"; sMaterial = "iron"; nCost = 1000; break;
        case 41: sProduct = "js_bla_shsm"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "iron"; nCost = 1000; break;
        case 42: sProduct = "js_bla_shlg"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "iron"; nCost = 1000; break;
        case 43: sProduct = "js_bla_shto"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "shield"; sMaterial = "iron"; nCost = 1000; break;
        case 44: sProduct = "js_bla_helm"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "helmet"; sMaterial = "iron"; nCost = 1000; break;
        case 45: sProduct = "js_bla_grea"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "greaves"; sMaterial = "iron"; nCost = 1000; break;
        case 46: sProduct = "js_bla_brac"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "bracers"; sMaterial = "iron"; nCost = 1000; break;

      }
    }
    else if(nActionNode == 8) // Training
    {

      switch(nNode)
      {

        case 1: sProduct = "js_bla_wega"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "training"; nCost = 1000; break;
        case 2: sProduct = "js_bla_wedw"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 3: sProduct = "js_bla_weha"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 4: sProduct = "js_bla_weba"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 5: sProduct = "js_bla_webs"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 6: sProduct = "js_bla_weda"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 7: sProduct = "js_bla_wegs"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "training"; nCost = 1000; break;
        case 8: sProduct = "js_bla_wels"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 9: sProduct = "js_bla_weka"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 10: sProduct = "js_bla_wera"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 11: sProduct = "js_bla_wesc"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 12: sProduct = "js_bla_wess"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 13: sProduct = "js_bla_wecl"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 14: sProduct = "js_bla_wehf"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "training"; nCost = 1000; break;
        case 15: sProduct = "js_bla_welf"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 16: sProduct = "js_bla_welh"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 17: sProduct = "js_bla_wewa"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 18: sProduct = "js_bla_wema"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 19: sProduct = "js_bla_wemo"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 20: sProduct = "js_bla_wedm"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "training"; nCost = 1000; break;
        case 21: sProduct = "js_bla_wedb"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "training"; nCost = 1000; break;
        case 22: sProduct = "js_bla_wequ"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "training"; nCost = 1000; break;
        case 23: sProduct = "js_bla_we2b"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "dweapon"; sMaterial = "training"; nCost = 1000; break;
        case 24: sProduct = "js_bla_wekm"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 25: sProduct = "js_bla_weku"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 26: sProduct = "js_bla_wesi"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 27: sProduct = "js_bla_wewh"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;
        case 28: sProduct = "js_bla_wems"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "training"; nCost = 1000; break;
        case 29: sProduct = "js_bla_wehb"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "training"; nCost = 1000; break;
        case 30: sProduct = "js_bla_wesy"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "training"; nCost = 1000; break;
        case 31: sProduct = "js_bla_wesp"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "gweapon"; sMaterial = "training"; nCost = 1000; break;
        case 32: sProduct = "js_bla_wetr"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;

      }
    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);

}


void TailorConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName = "Job System Placeable";
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    switch(nNode)
    {

      case 1: sProduct = "js_lea_leat"; sIngredient1 = "js_hun_hide"; sIngredient2 = "none"; nCost = 200; break;
      case 2: sProduct = "js_tai_arle"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_tai_boco"; sType = "armor"; sMaterial = "leather"; nCost = 2000; break;
      case 3: sProduct = "js_tai_arha"; sIngredient1 = "js_hun_hide"; sIngredient2 = "js_tai_boco"; sType = "armor"; sMaterial = "hide"; nCost = 2000; break;
      case 4: sProduct = "ds_j_backpack"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bla_irin"; nCost = 2000; break;
      case 5: sProduct = "ds_j_quiver"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bui_phpl"; nCost = 2000; break;
      case 6: sProduct = "ds_j_scabbard"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bla_siin"; nCost = 2000; break;
      case 7: sProduct = "ds_j_scabbard_a"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bla_siin"; nCost = 2000; break;
      case 8: sProduct = "ds_j_scabbard_b"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bla_siin"; nCost = 2000; break;
      case 9: sProduct = "js_tai_arcl"; sIngredient1 = "js_tai_brwo"; sIngredient2 = "none"; nCost = 2000; sType = "armor"; sMaterial = "rothewool"; break;
      case 10: sProduct = "js_tai_arcl"; sIngredient1 = "js_tai_boco"; sIngredient2 = "none"; nCost = 2000; sType = "armor"; sMaterial = "cotton"; break;
      case 11: sProduct = "js_tai_arcl"; sIngredient1 = "js_tai_bosi"; sIngredient2 = "none"; nCost = 2000; sType = "armor"; sMaterial = "silk"; break;
      case 12: sProduct = "js_tai_arcl"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "none"; nCost = 2000; sType = "armor"; sMaterial = "wool"; break;
      case 13: sProduct = "js_tai_arpa"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_tai_boco"; nCost = 2000; sType = "armor"; sMaterial = "leather"; break;
      case 14: sProduct = "js_tai_arst"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_tai_boco"; nCost = 2000; sType = "armor"; sMaterial = "leather"; break;
      case 15: sProduct = "js_plcspawner"; sIngredient1 = "js_ran_wool"; sIngredient2 = "none"; sType = "js_tai_carp"; sPlaceableName = "Carpet"; sMaterial = "plc"; nCost = 5000; break;
      case 16: sProduct = "js_tai_bosi"; sIngredient1 = "js_tail_rsil"; sIngredient2 = "none"; nCost = 1000; break;
      case 17: sProduct = "js_tai_bowo"; sIngredient1 = "js_ran_wool"; sIngredient2 = "none"; nCost = 1000; break;
      case 18: sProduct = "js_tai_boco"; sIngredient1 = "js_farm_cott"; sIngredient2 = "none"; nCost = 1000; break;
      case 19: sProduct = "js_plcspawner"; sIngredient1 = "js_ran_rowo"; sIngredient2 = "none"; sType = "js_tai_carp"; sPlaceableName = "Carpet"; sMaterial = "plc"; nCost = 5000; break;
      case 20: sProduct = "js_tai_brwo"; sIngredient1 = "js_ran_rowo"; sIngredient2 = "none"; nCost = 1000; break;
      case 21: sProduct = "js_tai_cloa"; sIngredient1 = "js_tai_brwo"; sIngredient2 = "none"; sType = "cloak"; sMaterial = "rothewool"; nCost = 2000; break;
      case 22: sProduct = "js_tai_cloa"; sIngredient1 = "js_tai_boco"; sIngredient2 = "none"; sType = "cloak"; sMaterial = "cotton"; nCost = 2000; break;
      case 23: sProduct = "js_tai_cloa"; sIngredient1 = "js_tai_bosi"; sIngredient2 = "none"; sType = "cloak"; sMaterial = "silk"; nCost = 2000; break;
      case 24: sProduct = "js_tai_cloa"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "none"; sType = "cloak"; sMaterial = "wool"; nCost = 2000; break;
      case 25: sProduct = "js_tai_boot"; sIngredient1 = "js_lea_leat"; sIngredient2 = "none"; sType = "boot"; sMaterial = "leather"; nCost = 2000; break;
      case 26: sProduct = "js_tai_belt"; sIngredient1 = "js_lea_leat"; sIngredient2 = "none"; sType = "belt"; sMaterial = "leather"; nCost = 2000; break;
      case 27: sProduct = "ds_j_masked"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "none"; sType = "cloak"; sMaterial = "wool"; nCost = 2000; break;
      case 28: sProduct = "ds_j_hooded"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "none"; sType = "cloak"; sMaterial = "wool"; nCost = 2000; break;
      case 29: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_fur"; sIngredient2 = "none"; sType = "js_tai_hangfur"; sPlaceableName = "Hanging Furs"; sMaterial = "plc"; nCost = 5000; break;
      case 30: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hide"; sIngredient2 = "none"; sType = "js_tai_velmap"; sPlaceableName = "Vellum Map"; sMaterial = "plc"; nCost = 5000; break;
      case 31: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hqhide"; sIngredient2 = "none"; sType = "js_tai_satchel"; sPlaceableName = "Satchel"; sMaterial = "plc"; nCost = 5000; break;
      case 32: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hqfur"; sIngredient2 = "js_tree_phaw"; sType = "js_bui_bfurrack"; sPlaceableName = "Bear Fur on Rack"; sMaterial = "plc"; nCost = 5000; break;
      case 33: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hqhide"; sIngredient2 = "js_tree_phaw"; sType = "js_bui_stfbat"; sPlaceableName = "Stuffed Bat"; sMaterial = "plc"; nCost = 5000; break;
      case 34: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_lfur"; sIngredient2 = "none"; sType = "js_bui_tigerfur"; sPlaceableName = "Tiger Fur, Ground"; sMaterial = "plc"; nCost = 10000; break;
      case 35: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hide"; sIngredient2 = "js_hun_sbone"; sType = "js_bui_tent1"; sPlaceableName = "Tent 1, Dark"; sMaterial = "plc"; nCost = 5000; break;
      case 36: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hide"; sIngredient2 = "js_hun_sbone"; sType = "js_bui_tent2"; sPlaceableName = "Tent 2, Dark"; sMaterial = "plc"; nCost = 5000; break;
      case 37: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_lhide"; sIngredient2 = "js_hun_lbone"; sType = "js_bui_tent3"; sPlaceableName = "Big Tent, Dark"; sMaterial = "plc"; nCost = 10000; break;
      case 38: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hqhide"; sIngredient2 = "js_hun_mbone"; sType = "js_bui_teepee1"; sPlaceableName = "Teepee 1"; sMaterial = "plc"; nCost = 5000; break;
      case 39: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hqhide"; sIngredient2 = "js_hun_mbone"; sType = "js_bui_teepee2"; sPlaceableName = "Teepee 2"; sMaterial = "plc"; nCost = 5000; break;
      case 40: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_shaw"; sIngredient2 = "js_hun_gryphon"; sType = "js_bui_marketsta"; sPlaceableName = "Massive Market Stall"; sMaterial = "plc"; nCost = 10000; break;
      case 41: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hide"; sIngredient2 = "none"; sType = "js_bui_skins"; sPlaceableName = "Skins Ground"; sMaterial = "plc"; nCost = 5000; break;
      case 42: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_fur"; sIngredient2 = "none"; sType = "js_bui_skins"; sPlaceableName = "Skins, Ground"; sMaterial = "plc"; nCost = 5000; break;
      case 43: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hqhide"; sIngredient2 = "none"; sType = "js_bui_bbrug"; sPlaceableName = "Brown Bear Rug"; sMaterial = "plc"; nCost = 5000; break;
      case 44: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_hide"; sIngredient2 = "js_hun_sbone"; sType = "js_bui_sparrot"; sPlaceableName = "Stuffed Parrot"; sMaterial = "plc"; nCost = 5000; break;
      case 45: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_csnake"; sIngredient2 = "js_hun_lhide"; sType = "js_bui_marketcan"; sPlaceableName = "Massive Market Canopy"; sMaterial = "plc"; nCost = 10000; break;
      case 46: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_wyvernhid"; sIngredient2 = "none"; sType = "js_bui_wyvernhid"; sPlaceableName = "Wyvern Hide, Ground"; sMaterial = "plc"; nCost = 5000; break;
      case 47: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_whitedrag"; sIngredient2 = "none"; sType = "js_bui_whitedhid"; sPlaceableName = "White Dragon Hide, Hung"; sMaterial = "plc"; nCost = 5000; break;
      case 48: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_game"; sIngredient2 = "js_hun_hide"; sType = "js_bui_boarplat"; sPlaceableName = "Boar Platter"; sMaterial = "plc"; nCost = 5000; break;
      case 49: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_fur"; sIngredient2 = "none"; sType = "js_bui_blackbrug"; sPlaceableName = "Black Bear Rug"; sMaterial = "plc"; nCost = 5000; break;
      case 50: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_lfur"; sIngredient2 = "js_hun_lbone"; sType = "js_bui_stuffgriz"; sPlaceableName = "Stuffed Grizzly Bear"; sMaterial = "plc"; nCost = 10000; break;
      case 51: sProduct = "js_plcspawner"; sIngredient1 = "js_hun_game"; sIngredient2 = "js_hun_hide"; sType = "js_bui_basilisk"; sPlaceableName = "Basilisk on a Stick"; sMaterial = "plc"; nCost = 5000; break;
      case 52: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_bigtent"; sIngredient2 = "js_art_colblu"; sType = "js_bui_tent4"; sPlaceableName = "Big Blue and White Tent"; sMaterial = "plc"; nCost = 10000; break;
      case 53: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_bigtent"; sIngredient2 = "js_art_colred"; sType = "js_bui_tent5"; sPlaceableName = "Big Red and White Tent"; sMaterial = "plc"; nCost = 10000; break;
      case 54: sProduct = "js_plcspawner"; sIngredient1 = "jobplc_bigtentrdwht"; sIngredient2 = "js_art_colblk"; sType = "js_bui_tent6"; sPlaceableName = "Big Red and Black Tent"; sMaterial = "plc"; nCost = 10000; break;


    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize);



}


void CraftProperties(object oPC, object oCraftedItem, string sType, string sMaterial, string sPlaceableName)
{
      itemproperty iMaterial;
      itemproperty iProperty1;
      itemproperty iProperty2;
      itemproperty iProperty3;

      //
      if(sMaterial == "adamantine")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Adamantine</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(1);
        SetLocalInt(oCraftedItem,"armormaterial",6);
        SetLocalInt(oCraftedItem,"material",6);

        if((sType == "weapon") || (sType == "gweapon") || (sType == "dweapon"))
        {
          iProperty1 = ItemPropertyEnhancementBonus(4);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d8);
        }
        else if((sType == "armor") || (sType == "shield") || (sType == "helmet")
        || (sType == "greaves") || (sType == "bracers"))
        {
          iProperty1 = ItemPropertyACBonus(4);
          iProperty2 = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_4,IP_CONST_DAMAGESOAK_5_HP);
        }
        else if((sType == "bullet") || (sType == "arrow") || (sType == "bolt"))
        {
          iProperty1 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_1d10);
        }

      }
      else if(sMaterial == "mithral")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Mithral</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(11);
        SetLocalInt(oCraftedItem,"armormaterial",4);
        SetLocalInt(oCraftedItem,"material",4);

        if((sType == "weapon") || (sType == "gweapon") || (sType == "dweapon"))
        {
          iProperty1 = ItemPropertyEnhancementBonus(3);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d6);
          iProperty3 = ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_60_PERCENT);
        }
        else if((sType == "armor") || (sType == "shield") || (sType == "helmet")
        || (sType == "greaves") || (sType == "bracers"))
        {
          iProperty1 = ItemPropertyACBonus(3);
          iProperty2 = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_3,IP_CONST_DAMAGESOAK_5_HP);
          iProperty3 = ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_60_PERCENT);
        }

      }
      else if(sMaterial == "steel")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Steel</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(15);
        SetLocalInt(oCraftedItem,"armormaterial",2);
        SetLocalInt(oCraftedItem,"material",2);

        if((sType == "weapon") || (sType == "gweapon") || (sType == "dweapon"))
        {
          iProperty1 = ItemPropertyEnhancementBonus(2);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d6);
        }
        else if((sType == "armor") || (sType == "shield") || (sType == "helmet")
        || (sType == "greaves") || (sType == "bracers"))
        {
          iProperty1 = ItemPropertyACBonus(2);
        }
        else if((sType == "bullet") || (sType == "arrow") || (sType == "bolt"))
        {
          iProperty1 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_1d6);
        }

      }
      else if(sMaterial == "iron")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Iron</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(9);
        SetLocalInt(oCraftedItem,"armormaterial",0);
        SetLocalInt(oCraftedItem,"material",0);

        if((sType == "weapon") || (sType == "gweapon") || (sType == "dweapon"))
        {
          iProperty1 = ItemPropertyEnhancementBonus(1);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d4);
        }
        else if((sType == "armor") || (sType == "shield") || (sType == "helmet")
        || (sType == "greaves") || (sType == "bracers"))
        {
          iProperty1 = ItemPropertyACBonus(1);
        }
        else if((sType == "bullet") || (sType == "arrow") || (sType == "bolt"))
        {
          iProperty1 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_1d4);
        }

      }
      else if(sMaterial == "ivory")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Ivory</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(16);
      }
      else if(sMaterial == "platinum")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Platinum</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(12);
      }
      else if(sMaterial == "gold")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Gold</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(8);
      }
      else if(sMaterial == "silver")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Silver</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(13);
        SetLocalInt(oCraftedItem,"armormaterial",3);
        SetLocalInt(oCraftedItem,"material",3);

        if((sType == "weapon") || (sType == "gweapon") || (sType == "dweapon"))
        {
          iProperty1 = ItemPropertyEnhancementBonus(2);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d6);
          iProperty3 = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER,IP_CONST_DAMAGETYPE_MAGICAL,IP_CONST_DAMAGEBONUS_1d6);
        }
        else if((sType == "armor") || (sType == "shield") || (sType == "helmet")
        || (sType == "greaves") || (sType == "bracers"))
        {
          iProperty1 = ItemPropertyACBonus(2);
          iProperty2 = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_2,IP_CONST_DAMAGESOAK_5_HP);
        }
        else if((sType == "bullet") || (sType == "arrow") || (sType == "bolt"))
        {
          iProperty1 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_1d8);
        }

      }
      else if(sMaterial == "duskwood")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Duskwood</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(37);

        if((sType == "bow") || (sType == "crossbow") || (sType == "lightcrossbow") || (sType == "shortbow"))
        {
          iProperty1 = ItemPropertyAttackBonus(3);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6);
          iProperty3 = ItemPropertyMaxRangeStrengthMod(4);
        }

      }
      else if(sMaterial == "ironwood")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Ironwood</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(37);

        if((sType == "weapon") || (sType == "gweapon"))
        {
          iProperty1 = ItemPropertyEnhancementBonus(1);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d4);
        }
        else if((sType == "armor") || (sType == "shield") || (sType == "helmet")
        || (sType == "greaves") || (sType == "bracers"))
        {
          iProperty1 = ItemPropertyACBonus(1);
        }
        else if((sType == "bow") || (sType == "crossbow") || (sType == "lightcrossbow") || (sType == "shortbow"))
        {
          iProperty1 = ItemPropertyAttackBonus(2);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d6);
          iProperty3 = ItemPropertyMaxRangeStrengthMod(3);
        }


      }
      else if(sMaterial == "phandar")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Phandar</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(37);

        if((sType == "bow") || (sType == "crossbow") || (sType == "lightcrossbow") || (sType == "shortbow"))
        {
          iProperty1 = ItemPropertyAttackBonus(1);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d4);
          iProperty3 = ItemPropertyMaxRangeStrengthMod(1);
        }

      }
      else if(sMaterial == "shadowtop")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Shadowtop</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(37);

        if((sType == "bow") || (sType == "crossbow") || (sType == "lightcrossbow") || (sType == "shortbow"))
        {
          iProperty1 = ItemPropertyAttackBonus(4);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6);
          iProperty3 = ItemPropertyMaxRangeStrengthMod(5);
        }

      }
      else if(sMaterial == "zurkwood")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Zurkwood</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(37);

        if((sType == "bow") || (sType == "crossbow") || (sType == "lightcrossbow") || (sType == "shortbow"))
        {
          iProperty1 = ItemPropertyAttackBonus(1);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d4);
          iProperty3 = ItemPropertyMaxRangeStrengthMod(1);
        }

      }
      else if(sMaterial == "cotton")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Cotton</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(34);

        if((sType == "armor"))
        {
          iProperty1 = ItemPropertyACBonus(1);
        }
        else if((sType == "cloak"))
        {
          iProperty1 = ItemPropertyACBonus(1);
        }
        else if((sType == "sling"))
        {
          iProperty1 = ItemPropertyAttackBonus(1);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d4);
          iProperty3 = ItemPropertyMaxRangeStrengthMod(1);
        }

      }
      else if(sMaterial == "silk")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Silk</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(35);

        if((sType == "armor"))
        {
          iProperty1 = ItemPropertyACBonus(3);
        }
        else if((sType == "cloak"))
        {
          iProperty1 = ItemPropertyACBonus(3);
        }
        else if((sType == "sling"))
        {
          iProperty1 = ItemPropertyAttackBonus(3);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d6);
          iProperty3 = ItemPropertyMaxRangeStrengthMod(2);
        }

      }
      else if(sMaterial == "rothewool")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Rothe Wool</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(36);

        if((sType == "armor"))
        {
          iProperty1 = ItemPropertyACBonus(2);
          iProperty1 = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGERESIST_5);
        }
        else if((sType == "cloak"))
        {
          iProperty1 = ItemPropertyACBonus(2);
          iProperty1 = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGERESIST_5);
        }
      }
      else if(sMaterial == "wool")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Wool</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(36);

        if((sType == "armor"))
        {
          iProperty1 = ItemPropertyACBonus(2);
        }
        else if((sType == "cloak"))
        {
          iProperty1 = ItemPropertyACBonus(2);
        }
        else if((sType == "sling"))
        {
          iProperty1 = ItemPropertyAttackBonus(2);
          iProperty2 = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d4);
          iProperty3 = ItemPropertyMaxRangeStrengthMod(2);
        }
      }
      else if(sMaterial == "hide")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Hide</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(17);

        if((sType == "armor"))
        {
          iProperty1 = ItemPropertyACBonus(1);
        }
      }
      else if(sMaterial == "leather")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Leather</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(31);

        if((sType == "armor"))
        {
          iProperty1 = ItemPropertyACBonus(3);
        }
        else if((sType == "boot") || (sType == "belt"))
        {
          iProperty1 = ItemPropertyACBonus(1);
        }
      }
      else if(sMaterial == "training")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Training</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(37);
        iProperty1 = ItemPropertyNoDamage();
      }
      else if(sMaterial == "plc")// For PLC items we set the resref on the PLC spawner and set the name
      {
        SetName(oCraftedItem, "<c~Îë>"+sPlaceableName+"</c> ");
        SetLocalString(oCraftedItem,"plc",sType);
      }

      AddItemProperty(DURATION_TYPE_PERMANENT,iMaterial,oCraftedItem);
      AddItemProperty(DURATION_TYPE_PERMANENT,iProperty1,oCraftedItem);
      AddItemProperty(DURATION_TYPE_PERMANENT,iProperty2,oCraftedItem);
      AddItemProperty(DURATION_TYPE_PERMANENT,iProperty3,oCraftedItem);
      DS_CLEAR_ALL(oPC);
}


void CraftProduct(object oPC, object oBench, string sProduct, string sType, string sMaterial, string sIngredient1, string sIngredient2, string sPlaceableName, int nCost, int nStack, int nProductStackSize)
{

    object oItemInChest = GetFirstItemInInventory(oBench);
    object oIngredient1;
    object oIngredient2;
    object oCraftedItem;
    string sSuccessOrFailure;
    string sWeaponResRef;
    int nWeaponMaterial;
    int nArmorMaterial;
    int nWeaponMaterialPresent;  // True or false
    int nArmorMaterialPresent;   // True or false
    int nIngredient1Found;
    int nIngredient2Found;
    int nSingleIngredient;
    int nRank = FindJobJournalRank(oPC,oBench);
    int nRandom = Random(100)+1;
    int nPCLevel = GetHitDice(oPC);
    int nXP = RESOURCE_XP;

    // Level 30 XP blocker
    if(nPCLevel == 30)
    {
      nXP = 1;
    }

    // Gold check to make sure they got enough
    if(GetGold(oPC) < nCost)
    {
       DS_CLEAR_ALL(oPC);
       AssignCommand(oBench, ActionSpeakString("*You need more gold*"));
       return;
    }
    //

    // If there is no second ingredient, mark it as found
    if(sIngredient2 == "none")
    {
      nSingleIngredient = 1;
    }
    //

    while(GetIsObjectValid(oItemInChest))
    {

      // Catch all for woods so any work with jobs
      if(sIngredient1 == "jobsystemwood")
      {
        if((GetResRef(oItemInChest) == "js_tree_phaw") || (GetResRef(oItemInChest) == "js_tree_dusw") ||
        (GetResRef(oItemInChest) == "js_tree_shaw") || (GetResRef(oItemInChest) == "js_tree_irow") ||
        (GetResRef(oItemInChest) == "js_tree_zurw"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }

      if(sIngredient2 == "jobsystemwood")
      {
        if((GetResRef(oItemInChest) == "js_tree_phaw") || (GetResRef(oItemInChest) == "js_tree_dusw") ||
        (GetResRef(oItemInChest) == "js_tree_shaw") || (GetResRef(oItemInChest) == "js_tree_irow") ||
        (GetResRef(oItemInChest) == "js_tree_zurw"))
        {
           nIngredient2Found == 1;
           oIngredient2 = oItemInChest;
        }
      }
      //


      // Catch all for meats so any work with jobs
      if(sIngredient1 == "jobsystemmeat")
      {
        if((GetResRef(oItemInChest) == "js_ran_chme") || (GetResRef(oItemInChest) == "js_ran_rome") ||
        (GetResRef(oItemInChest) == "js_ran_pork") || (GetResRef(oItemInChest) == "js_ran_beef") ||
        (GetResRef(oItemInChest) == "js_ran_mutt") || (GetResRef(oItemInChest) == "js_ran_peam")
        || (GetResRef(oItemInChest) == "js_hun_game"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }

      if(sIngredient2 == "jobsystemmeat")
      {
        if((GetResRef(oItemInChest) == "js_ran_chme") || (GetResRef(oItemInChest) == "js_ran_rome") ||
        (GetResRef(oItemInChest) == "js_ran_pork") || (GetResRef(oItemInChest) == "js_ran_beef") ||
        (GetResRef(oItemInChest) == "js_ran_mutt") || (GetResRef(oItemInChest) == "js_ran_peam")
        || (GetResRef(oItemInChest) == "js_hun_game"))
        {
           nIngredient2Found == 1;
           oIngredient2 = oItemInChest;
        }
      }
      //

      // Catch all for milk so any work with jobs
      if(sIngredient1 == "jobsystemmilk")
      {
        if((GetResRef(oItemInChest) == "js_ran_cami") || (GetResRef(oItemInChest) == "js_ran_romi") ||
        (GetResRef(oItemInChest) == "js_ran_shmi") || (GetResRef(oItemInChest) == "js_ran_mil"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }

      if(sIngredient2 == "jobsystemmilk")
      {
        if((GetResRef(oItemInChest) == "js_ran_cami") || (GetResRef(oItemInChest) == "js_ran_romi") ||
        (GetResRef(oItemInChest) == "js_ran_shmi") || (GetResRef(oItemInChest) == "js_ran_mil"))
        {
           nIngredient2Found == 1;
           oIngredient2 = oItemInChest;
        }
      }
      //

      // Catch all for eggs so any work with jobs
      if(sIngredient1 == "jobsystemeggs")
      {
        if((GetResRef(oItemInChest) == "js_ran_cheg") || (GetResRef(oItemInChest) == "js_ran_peae"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }

      if(sIngredient2 == "jobsystemeggs")
      {
        if((GetResRef(oItemInChest) == "js_ran_cheg") || (GetResRef(oItemInChest) == "js_ran_peae"))
        {
           nIngredient2Found == 1;
           oIngredient2 = oItemInChest;
        }
      }
      //

      // Catch all for weapons so any work with golems/zombies
      if(sIngredient1 == "jobsystemweapon")
      {
        if((GetResRef(oItemInChest) == "js_bla_wega") || (GetResRef(oItemInChest) == "js_bla_wedw")  || (GetResRef(oItemInChest) == "js_bla_weha")
        || (GetResRef(oItemInChest) == "js_bla_weba")  || (GetResRef(oItemInChest) == "js_bla_webs")  || (GetResRef(oItemInChest) == "js_bla_weda")
        || (GetResRef(oItemInChest) == "js_bla_wegs")  || (GetResRef(oItemInChest) == "js_bla_wels")  || (GetResRef(oItemInChest) == "js_bla_weka")
        || (GetResRef(oItemInChest) == "js_bla_wera")  || (GetResRef(oItemInChest) == "js_bla_wesc")  || (GetResRef(oItemInChest) == "js_bla_wess")
        || (GetResRef(oItemInChest) == "js_bla_wecl")  || (GetResRef(oItemInChest) == "js_bla_wehf")  || (GetResRef(oItemInChest) == "js_bla_welf")
        || (GetResRef(oItemInChest) == "js_bla_welh")  || (GetResRef(oItemInChest) == "js_bla_wewa")  || (GetResRef(oItemInChest) == "js_bla_wema")
        || (GetResRef(oItemInChest) == "js_bla_wemo")  || (GetResRef(oItemInChest) == "js_bla_wedm")  || (GetResRef(oItemInChest) == "js_bla_wedb")
        || (GetResRef(oItemInChest) == "js_bla_wequ")  || (GetResRef(oItemInChest) == "js_bla_we2b")  || (GetResRef(oItemInChest) == "js_bla_wekm")
        || (GetResRef(oItemInChest) == "js_bla_weku")  || (GetResRef(oItemInChest) == "js_bla_wesi")  || (GetResRef(oItemInChest) == "js_bla_wewh")
        || (GetResRef(oItemInChest) == "js_bla_wems")  || (GetResRef(oItemInChest) == "js_bla_wehb")  || (GetResRef(oItemInChest) == "js_bla_wesy")
        || (GetResRef(oItemInChest) == "js_bla_wesp")  || (GetResRef(oItemInChest) == "js_bla_wetr"))
        {

           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
           nWeaponMaterial = GetLocalInt(oItemInChest, "material");
           sWeaponResRef = GetResRef(oItemInChest);
           nWeaponMaterialPresent = 1;
        }
      }

      if(sIngredient2 == "jobsystemweapon")
      {
        if((GetResRef(oItemInChest) == "js_bla_wega") || (GetResRef(oItemInChest) == "js_bla_wedw")  || (GetResRef(oItemInChest) == "js_bla_weha")
        || (GetResRef(oItemInChest) == "js_bla_weba")  || (GetResRef(oItemInChest) == "js_bla_webs")  || (GetResRef(oItemInChest) == "js_bla_weda")
        || (GetResRef(oItemInChest) == "js_bla_wegs")  || (GetResRef(oItemInChest) == "js_bla_wels")  || (GetResRef(oItemInChest) == "js_bla_weka")
        || (GetResRef(oItemInChest) == "js_bla_wera")  || (GetResRef(oItemInChest) == "js_bla_wesc")  || (GetResRef(oItemInChest) == "js_bla_wess")
        || (GetResRef(oItemInChest) == "js_bla_wecl")  || (GetResRef(oItemInChest) == "js_bla_wehf")  || (GetResRef(oItemInChest) == "js_bla_welf")
        || (GetResRef(oItemInChest) == "js_bla_welh")  || (GetResRef(oItemInChest) == "js_bla_wewa")  || (GetResRef(oItemInChest) == "js_bla_wema")
        || (GetResRef(oItemInChest) == "js_bla_wemo")  || (GetResRef(oItemInChest) == "js_bla_wedm")  || (GetResRef(oItemInChest) == "js_bla_wedb")
        || (GetResRef(oItemInChest) == "js_bla_wequ")  || (GetResRef(oItemInChest) == "js_bla_we2b")  || (GetResRef(oItemInChest) == "js_bla_wekm")
        || (GetResRef(oItemInChest) == "js_bla_weku")  || (GetResRef(oItemInChest) == "js_bla_wesi")  || (GetResRef(oItemInChest) == "js_bla_wewh")
        || (GetResRef(oItemInChest) == "js_bla_wems")  || (GetResRef(oItemInChest) == "js_bla_wehb")  || (GetResRef(oItemInChest) == "js_bla_wesy")
        || (GetResRef(oItemInChest) == "js_bla_wesp")  || (GetResRef(oItemInChest) == "js_bla_wetr"))
        {
           nIngredient2Found == 1;
           oIngredient2 = oItemInChest;
           nWeaponMaterial = GetLocalInt(oItemInChest, "material");
           sWeaponResRef = GetResRef(oItemInChest);
           nWeaponMaterialPresent = 1;
        }
      }
      //

      // PLC Spawners as Ingredients using "plc" string variables

      // Scented Candle
      if(sIngredient1 == "jobplc_scntcandle")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_art_scca"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Exotic Candle
      if(sIngredient1 == "jobplc_exoticcandle")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_art_exca"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Table
      if(sIngredient1 == "jobplc_table")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_bui_tabl"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Pot
      if(sIngredient1 == "jobplc_pot")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_art_potclay1"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Big Tent, Dark
      if(sIngredient1 == "jobplc_bigtent")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_bui_tent3"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Big Tent, Red and White
      if(sIngredient1 == "jobplc_bigtentrdwht")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_bui_tent5"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Carpet
      if(sIngredient1 == "jobplc_carpet")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_tai_carp"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Rug, Fancy Base
      if(sIngredient1 == "jobplc_carpetfancy")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_art_rugbase1"))
        {
           nIngredient1Found == 1;
           oIngredient1 = oItemInChest;
        }
      }
      //


      // If you find the first ingredient store it
      if(GetResRef(oItemInChest) == sIngredient1)
      {
         nIngredient1Found == 1;
         oIngredient1 = oItemInChest;
      }

      // If you find the second ingredient store it
      if(GetResRef(oItemInChest) == sIngredient2)
      {
         nIngredient2Found == 1;
         oIngredient2 = oItemInChest;
      }

      // Once both ingredients are found or just the first ingredient if its a single ingredient receipe stop the loop
      if(((nIngredient1Found == 1) && (nIngredient2Found == 1)) || ((nIngredient1Found == 1) && (nSingleIngredient == 1)))
      {
        break;
      }

      oItemInChest = GetNextItemInInventory(oBench);
    }


      // Catch for elementary golems so we can carry over armor material type from the plate
      if((sIngredient1 == "js_arca_gol") || (sIngredient1 == "js_arca_egc") || (sIngredient1 == "js_bla_arfp"))
      {
        nArmorMaterial = GetLocalInt(oIngredient1, "armormaterial");
        nArmorMaterialPresent = 1;
      }
      else if((sIngredient2 == "js_arca_gol") || (sIngredient1 == "js_arca_egc") || (sIngredient1 == "js_bla_arfp"))
      {
        nArmorMaterial = GetLocalInt(oIngredient2, "armormaterial");
        nArmorMaterialPresent = 1;
      }
      //

      // Catch for the golems/zombies to carry over their material types
      if((sIngredient1 == "js_arca_zom_w") || (sIngredient1 == "js_arca_zom_e") || (sIngredient1 == "js_arca_zom_f")  || (sIngredient1 == "js_arca_gol_g") || (sIngredient1 == "js_arca_gol_c")  || (sIngredient1 == "js_arca_gol_h"))
      {
        nArmorMaterial = GetLocalInt(oIngredient1, "armormaterial");
        nWeaponMaterial = GetLocalInt(oIngredient1, "material");
        sWeaponResRef = GetLocalString(oIngredient1, "weapon");
        nWeaponMaterialPresent = 1;
        nArmorMaterialPresent = 1;
      }
      else if((sIngredient2 == "js_arca_zom_w") || (sIngredient2 == "js_arca_zom_e") || (sIngredient2 == "js_arca_zom_f")  || (sIngredient2 == "js_arca_gol_g") || (sIngredient2 == "js_arca_gol_c")  || (sIngredient2 == "js_arca_gol_h"))
      {
        nArmorMaterial = GetLocalInt(oIngredient2, "armormaterial");
        nWeaponMaterial = GetLocalInt(oIngredient2, "material");
        sWeaponResRef = GetLocalString(oIngredient2, "weapon");
        nWeaponMaterialPresent = 1;
        nArmorMaterialPresent = 1;
      }
      //



    // This will launch if either of the ingredients is valid, or if the first ingriedient is valid while there is only a single ingredient
    if((GetIsObjectValid(oIngredient1) && GetIsObjectValid(oIngredient2)) || (GetIsObjectValid(oIngredient1) && (nSingleIngredient == 1)))
    {

      // Based on the roll and rank see if they succeed or fail at crafting
      if(nRank == 2)
      {

          if(nRandom <= 100)
          {
            sSuccessOrFailure = "SUCCESS";
            GiveExactXP(oPC,nXP);
            oCraftedItem = CreateItemOnObject(sProduct,oBench,nProductStackSize);
            SetMaterialType(oCraftedItem,sWeaponResRef,nArmorMaterialPresent,nArmorMaterial,nWeaponMaterialPresent,nWeaponMaterial);
            TakeGoldFromCreature(nCost,oPC,TRUE);
            // If there is a stack for ingredient1  we reduce the stack by 1
            if(GetItemStackSize(oIngredient1) == 1)
              {
                DestroyObject(oIngredient1);
              }
              else
              {
                SetItemStackSize(oIngredient1,GetItemStackSize(oIngredient1)-1);
              }
            // If there is a stack for ingredient2 we reduce the stack by 1
            if(GetItemStackSize(oIngredient2) == 1)
              {
                DestroyObject(oIngredient2);
              }
              else
              {
                SetItemStackSize(oIngredient2,GetItemStackSize(oIngredient2)-1);
              }
            //
          }
          else
          {
            sSuccessOrFailure = "FAILURE";
            GiveExactXP(oPC,nXP/2);
            TakeGoldFromCreature(nCost,oPC,TRUE);
            // If there is a stack for ingredient1  we reduce the stack by 1
            if(GetItemStackSize(oIngredient1) == 1)
              {
                DestroyObject(oIngredient1);
              }
              else
              {
                SetItemStackSize(oIngredient1,GetItemStackSize(oIngredient1)-1);
              }
            // If there is a stack for ingredient2 we reduce the stack by 1
            if(GetItemStackSize(oIngredient2) == 1)
              {
                DestroyObject(oIngredient2);
              }
              else
              {
                SetItemStackSize(oIngredient2,GetItemStackSize(oIngredient2)-1);
              }
            //
          }
          SendMessageToPC(oPC,"Rolled "+IntToString(nRandom)+" vs 100 or less. "+sSuccessOrFailure);


      }
      else if(nRank == 1)
      {

          if(nRandom <= 80)
          {
            sSuccessOrFailure = "SUCCESS";
            GiveExactXP(oPC,nXP);
            oCraftedItem = CreateItemOnObject(sProduct,oBench,nProductStackSize);
            SetMaterialType(oCraftedItem,sWeaponResRef,nArmorMaterialPresent,nArmorMaterial,nWeaponMaterialPresent,nWeaponMaterial);
            TakeGoldFromCreature(nCost,oPC,TRUE);
            // If there is a stack for ingredient1  we reduce the stack by 1
            if(GetItemStackSize(oIngredient1) == 1)
              {
                DestroyObject(oIngredient1);
              }
              else
              {
                SetItemStackSize(oIngredient1,GetItemStackSize(oIngredient1)-1);
              }
            // If there is a stack for ingredient2 we reduce the stack by 1
            if(GetItemStackSize(oIngredient2) == 1)
              {
                DestroyObject(oIngredient2);
              }
              else
              {
                SetItemStackSize(oIngredient2,GetItemStackSize(oIngredient2)-1);
              }
            //
          }
          else
          {
            sSuccessOrFailure = "FAILURE";
            GiveExactXP(oPC,nXP/2);
            TakeGoldFromCreature(nCost,oPC,TRUE);
            // If there is a stack for ingredient1  we reduce the stack by 1
            if(GetItemStackSize(oIngredient1) == 1)
              {
                DestroyObject(oIngredient1);
              }
              else
              {
                SetItemStackSize(oIngredient1,GetItemStackSize(oIngredient1)-1);
              }
            // If there is a stack for ingredient2 we reduce the stack by 1
            if(GetItemStackSize(oIngredient2) == 1)
              {
                DestroyObject(oIngredient2);
              }
              else
              {
                SetItemStackSize(oIngredient2,GetItemStackSize(oIngredient2)-1);
              }
            //
          }
          SendMessageToPC(oPC,"Rolled "+IntToString(nRandom)+" vs 80 or less. "+sSuccessOrFailure);



      }
      else if(nRank == 0)
      {

          if(nRandom <= 60)
          {
            sSuccessOrFailure = "SUCCESS";
            oCraftedItem = CreateItemOnObject(sProduct,oBench,nProductStackSize);
            SetMaterialType(oCraftedItem,sWeaponResRef,nArmorMaterialPresent,nArmorMaterial,nWeaponMaterialPresent,nWeaponMaterial);
            TakeGoldFromCreature(nCost,oPC,TRUE);
            // If there is a stack for ingredient1  we reduce the stack by 1
            if(GetItemStackSize(oIngredient1) == 1)
              {
                DestroyObject(oIngredient1);
              }
              else
              {
                SetItemStackSize(oIngredient1,GetItemStackSize(oIngredient1)-1);
              }
            // If there is a stack for ingredient2 we reduce the stack by 1
            if(GetItemStackSize(oIngredient2) == 1)
              {
                DestroyObject(oIngredient2);
              }
              else
              {
                SetItemStackSize(oIngredient2,GetItemStackSize(oIngredient2)-1);
              }
            //
          }
          else
          {
            sSuccessOrFailure = "FAILURE";
            TakeGoldFromCreature(nCost,oPC,TRUE);
            // If there is a stack for ingredient1  we reduce the stack by 1
            if(GetItemStackSize(oIngredient1) == 1)
              {
                DestroyObject(oIngredient1);
              }
              else
              {
                SetItemStackSize(oIngredient1,GetItemStackSize(oIngredient1)-1);
              }
            // If there is a stack for ingredient2 we reduce the stack by 1
            if(GetItemStackSize(oIngredient2) == 1)
              {
                DestroyObject(oIngredient2);
              }
              else
              {
                SetItemStackSize(oIngredient2,GetItemStackSize(oIngredient2)-1);
              }
            //
          }
          SendMessageToPC(oPC,"Rolled "+IntToString(nRandom)+" vs 60 or less. "+sSuccessOrFailure);

      }

      // If there is a type and material set then set the properties for the item. This is mostly used for weapons/armor.
      if(GetIsObjectValid(oCraftedItem) && (sType != "none") && (sMaterial != "none"))
      {
        CraftProperties(oPC,oCraftedItem,sType,sMaterial,sPlaceableName);
      }

    }
    else
    {
      DS_CLEAR_ALL(oPC);
      SendMessageToPC(oPC,"*You do not have the proper ingredients*");
      return;
    }
      DS_CLEAR_ALL(oPC);
}


void SetMaterialType(object oCraftedItem, string sWeaponResRef, int nArmorMaterialPresent, int nArmorMaterial, int nWeaponMaterialPresent, int nWeaponMaterial)
{

  if(nArmorMaterialPresent == 1)
  {
    SetLocalInt(oCraftedItem,"armormaterial",nArmorMaterial);
  }
  if(nWeaponMaterialPresent == 1)
  {
    SetLocalString(oCraftedItem,"weapon",sWeaponResRef);
    SetLocalInt(oCraftedItem,"material",nWeaponMaterial);
  }

}


void DS_CLEAR_ALL(object oPC)
{
   SetLocalInt( oPC, "ds_node", 0 );
   SetLocalString( oPC, "ds_action", "" );
   SetLocalInt( oPC, "ds_actionnode", 0 );
   SetLocalInt( oPC, "ds_check_1", 0 );
   SetLocalInt( oPC, "ds_check_2", 0 );
   SetLocalInt( oPC, "ds_check_3", 0 );
   SetLocalInt( oPC, "ds_check_4", 0 );
}

void DS_CLEAR_CHECK(object oPC)
{
   SetLocalInt( oPC, "ds_check_1", 0 );
   SetLocalInt( oPC, "ds_check_2", 0 );
   SetLocalInt( oPC, "ds_check_3", 0 );
   SetLocalInt( oPC, "ds_check_4", 0 );
}


int FindJobJournalRank(object oPC, object oBench)
{
    object oInventoryItem = GetFirstItemInInventory(oPC);
    object oJobJournal;
    int nRank;
    string sPrimaryJob;
    string sSecondaryJob;
    string sJob = GetLocalString(oBench, "job");

    // We search for their journal
    while(GetIsObjectValid(oInventoryItem))
    {
        if(GetResRef(oInventoryItem) == "jobjournal")
        {
          oJobJournal = oInventoryItem;
          break;
        }
      oInventoryItem = GetNextItemInInventory(oPC);
    }

    // Getting a rank for the job. If its their primary they get a 2, secondary a 1, and not at all a 0
    if(!GetIsObjectValid(oJobJournal))
    {
      nRank = 0;
    }
    else
    {
      // Get their primary and secondary jobs
      sPrimaryJob = GetLocalString(oJobJournal,"primaryjob");
      sSecondaryJob = GetLocalString(oJobJournal,"secondaryjob");

      // Rank how good they are at the job
      if((GetSubString(sJob,0,GetStringLength(sPrimaryJob)) == sPrimaryJob) && (sPrimaryJob != ""))
      {
        nRank = 2;
      }
      else if((GetSubString(sJob,0,GetStringLength(sSecondaryJob)) == sSecondaryJob)  && (sSecondaryJob != ""))
      {
        nRank = 1;
      }
      else
      {
        nRank = 0;
      }

    }
    return nRank;
}
