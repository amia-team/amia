/*
  Job System Converter Script - Converts the resources into different material

  - Maverick00053

  Edits:
  072722 Lord-Jyssev: new sPlaceableName naming method for placeables and ability to use PLC Spawners in recipes by sType Variable
  ??     Frozen: Tailor kit added
  16-april-2023 Frozen: Hair and tattoo kit added
  070523 Lord-Jyssev: Added epic loot crafting and ingredient retention option
  Feb 23 2024 Maverick: Added in new Raid crafting support, and added in functionality so you can have two identifical ingredients and it will work. Also added in proper tracking for job system material types and requires those items of certain materials for recipes. See the Epic/Legendary sections.
  March 8th 2023 Mav - Adding Epic Crafting support.
*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_td_itemprop"

const int RESOURCE_XP = 100;
const int REPEAT_LOOP_ON = TRUE; // Set to false if you want to turn off repeat crafting

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
void CraftProduct(object oPC, object oBench, string sProduct, string sType, string sMaterial, string sIngredient1, string sIngredient2, string sPlaceableName, int nCost, int nStack, int nProductStackSize, int nRetainItem, int nRepeat, string sIngredient1Type, string sIngredient2Type);

// Part of the loop system for the job system
void LoopCraftProduct(object oPC,object oBench,string sProduct,string sType,string sMaterial,string sIngredient1,string sIngredient2,string sPlaceableName,int nCost,int nStack,int nProductStackSize,int nRetainItem, string sIngredient1Type, string sIngredient2Type);

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
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nRetainItem; //Retains ingredients on failure for epic loot
    int nIngredient1Found;
    int nIngredient2Found;
    int nActionNode = GetLocalInt( oPC, "ds_actionnode");
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    if(nActionNode == 1)
    {
     switch(nNode)
     {

      case 1: sProduct = "js_arca_mytu"; sIngredient1 = "js_bla_miin"; sIngredient2 = "js_jew_crys"; nCost = 5000; break;
      case 2: sProduct = "js_arca_bdbg"; sIngredient1 = "js_bui_shpl"; sIngredient2 = "js_bla_miin"; nCost = 5000; break;
      case 3: sProduct = "js_arca_wdca"; sIngredient1 = "js_bla_siin"; sIngredient2 = "js_bui_shpl"; nCost = 5000; break;
      case 4: sProduct = "x2_it_cfm_bscrl"; sIngredient1 = "js_sch_pape"; sIngredient2 = "js_alch_pure"; nCost = 2000; break;
      case 5: sProduct = "x2_it_cfm_wand"; sIngredient1 = "js_gem_sivo"; sIngredient2 = "js_alch_coil"; nCost = 2000; break;
      case 6: sProduct = "js_arca_scbx"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bla_siin"; nCost = 5000; break;
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
      case 22: sProduct = "js_arca_gmpo"; sIngredient1 = "js_bla_miin"; sIngredient2 = "js_lea_leat"; nCost = 5000; break;
      case 23: sProduct = "raid_comp_frosty"; sIngredient1 = "raid_base_frosty"; sIngredient2 = "raid_base_frosty"; nCost = 5000; nRetainItem=1; break;
      case 24: sProduct = "raid_comp_lich"; sIngredient1 = "raid_base_lich"; sIngredient2 = "raid_base_lich"; nCost = 5000; nRetainItem=1; break;
      case 25: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_comp_frosty"; sIngredient2 = "js_jew_diam"; sType = "wdragonbossrewar"; sPlaceableName = "<cnÞÿ>Frostspear's Treasure</c>"; nCost = 10000; nRetainItem=1; break;
      case 26: sProduct = "epx_comp_wrc"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "epx_base_glyp"; nCost = 5000; nRetainItem=1; break;
      case 27: sProduct = "epx_comp_mwamc"; sIngredient1 = "epx_base_ston"; sIngredient2 = "epx_base_fabr"; nCost = 5000; nRetainItem=1; break;
      case 28: sProduct = "epx_comp_psbdc"; sIngredient1 = "epx_base_blod"; sIngredient2 = "epx_base_claw"; nCost = 5000; nRetainItem=1; break;
      case 29: sProduct = "epx_comp_gofbc"; sIngredient1 = "epx_base_bone"; sIngredient2 = "epx_base_obsd"; nCost = 5000; nRetainItem=1; break;
      case 30: sProduct = "epx_comp_wbc"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "epx_base_blod"; nCost = 5000; nRetainItem=1; break;
      case 31: sProduct = "epx_comp_drfc"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "epx_base_claw"; nCost = 5000; nRetainItem=1; break;
      case 32: sProduct = "epx_comp_safbc"; sIngredient1 = "epx_base_ston"; sIngredient2 = "epx_base_bone"; nCost = 5000; nRetainItem=1; break;
      case 33: sProduct = "epx_comp_goimc"; sIngredient1 = "epx_base_fabr"; sIngredient2 = "epx_base_obsd"; nCost = 5000; nRetainItem=1; break;

     }
    }
    if(nActionNode == 2)
    {
     switch(nNode)
     {
      case 1: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elea"; sType = "epx_ioun_chrys"; sPlaceableName = "<c¦ÿ©>Chrysoprase Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 2: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elef"; sType = "epx_ioun_iolit"; sPlaceableName = "<c¦ÿ©>Iolite Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 3: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elee"; sType = "epx_ioun_lavnd"; sPlaceableName = "<c¦ÿ©>Lavender Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 4: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elew"; sType = "epx_ioun_prple"; sPlaceableName = "<c¦ÿ©>Purple Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 5: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elea"; sType = "epx_ioun_white"; sPlaceableName = "<c¦ÿ©>White Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 6: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elew"; sType = "epx_ioun_blue1"; sPlaceableName = "<c¦ÿ©>Blue Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 7: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elee"; sType = "epx_ioun_dpred"; sPlaceableName = "<c¦ÿ©>Deep Red Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 8: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elef"; sType = "epx_ioun_drose"; sPlaceableName = "<c¦ÿ©>Dusty Rose Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 9: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elea"; sType = "epx_ioun_pblue"; sPlaceableName = "<c¦ÿ©>Pale Blue Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 10: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elew"; sType = "epx_ioun_pink1"; sPlaceableName = "<c¦ÿ©>Pink Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 11: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elef"; sType = "epx_ioun_pnkgn"; sPlaceableName = "<c¦ÿ©>Pink & Green Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 12: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ioun"; sIngredient2 = "js_alch_elee"; sType = "epx_ioun_sctbl"; sPlaceableName = "<c¦ÿ©>Scarlet & Blue Ioun</c>"; nCost = 10000; nRetainItem=1; break;
      case 13: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_gem_ivor"; sType = "epx_misc_wyrms"; sPlaceableName = "<c¦ÿ©>Wyrmshadow Reliquary</c>"; nCost = 10000; nRetainItem=1; break;
      case 14: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_bla_goin"; sType = "epx_misc_yowlr"; sPlaceableName = "<c¦ÿ©>Yowler's Eye</c>"; nCost = 10000; nRetainItem=1; break;
      case 15: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wbc"; sIngredient2 = "js_bla_siin"; sType = "epx_misc_hntrs"; sPlaceableName = "<c¦ÿ©>Hunter's Sense</c>"; nCost = 10000; nRetainItem=1; break;
      case 16: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_mwamc"; sIngredient2 = "js_sch_emto"; sType = "epx_misc_tmmys"; sPlaceableName = "<c¦ÿ©>Greater Tome of Mystra</c>"; nCost = 10000; nRetainItem=1; break;
      case 17: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_psbdc"; sIngredient2 = "js_bla_goin"; sType = "epx_misc_orbus"; sPlaceableName = "<c¦ÿ©>Orb of Unlocked Secrets</c>"; nCost = 10000; nRetainItem=1; break;
      case 18: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wrc"; sIngredient2 = "js_bla_plin"; sType = "epx_misc_hrald"; sPlaceableName = "<c¦ÿ©>Herald's Gift</c>"; nCost = 10000; nRetainItem=1; break;

     }
    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);

}


void ArchitectConverter(object oPC, object oBench, int nNode)
{


    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName = "Job System Placeable";
    int nRetainItem; //Retains ingredients on failure for epic loot
    int nIngredient1Found;
    int nIngredient2Found;
    int nActionNode = GetLocalInt( oPC, "ds_actionnode");
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
      case 8: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_farm_cott"; sType = "js_bui_comb"; sPlaceableName = "Combat Dummy"; sMaterial = "plc"; nCost = 2000; break;
      case 9: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "js_tai_bowo"; sType = "js_bui_bed"; sPlaceableName = "Bed"; sMaterial = "plc"; nCost = 2000; break;
      case 10: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "js_bla_irin"; sType = "js_bui_trsi"; sPlaceableName = "Transportable Sign Small"; sMaterial = "plc"; nCost = 2000; break;
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
      case 53: sProduct = "js_chest_kit";  sIngredient1 = "js_tree_shaw"; sIngredient2 = "js_herb_sils"; nCost = 5000; break;
      case 54: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_dupl"; sIngredient2 = "js_bla_irin"; sType = "js_bui_trsi2"; sPlaceableName = "Transportable Sign Large"; sMaterial = "plc"; nCost = 2000; break;
     }


    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);


}


void AlchemistConverter(object oPC, object oBench, int nNode)
{


    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nRetainItem; //Retains ingredients on failure for epic loot
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

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);


}


void ArtistConverter(object oPC, object oBench, int nNode)
{


    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName = "Job System Placeable";
    int nRetainItem; //Retains ingredients on failure for epic loot
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
          case 17: sProduct = "js_plcspawner"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "js_jew_crys"; sType = "js_art_lantern2"; sPlaceableName = "Lamp Post"; sMaterial = "plc"; nCost = 5000; break;

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
          case 12: sProduct = "js_plcspawner"; sIngredient1 = "js_tree_phaw"; sIngredient2 = "js_tai_bosi"; sType = "js_art_flgrav2"; sPlaceableName = "Pennant of Raven and Sword"; sMaterial = "plc"; nCost = 5000; break;
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
          case 9: sProduct = "js_tattoo_kit"; sIngredient1 = "jobsystemdye"; sIngredient2 = "js_bla_stin"; sType = "none"; sMaterial = "none"; nCost = 1000; break;
          case 10: sProduct = "js_hairdye_kit"; sIngredient1 = "jobsystemdye"; sIngredient2 = "js_alch_elew"; sType = "none"; sMaterial = "none"; nCost = 1000; break;

        }
    }


    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);


}


void BrewerConverter(object oPC, object oBench, int nNode)
{


    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nRetainItem; //Retains ingredients on failure for epic loot
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

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);


}


void ChefConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nRetainItem; //Retains ingredients on failure for epic loot
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

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);



}


void JewelerConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nRetainItem; //Retains ingredients on failure for epic loot
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
      case 15: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_base_frosty"; sIngredient2 = "js_jew_amul"; sType = "frostspear_neckl"; sPlaceableName = "<cnÞÿ>Frostchoker</c>"; nCost = 10000; nRetainItem=1; sIngredient2Type = "platinum"; break;
      case 16: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_base_lich"; sIngredient2 = "js_jew_ring"; sType = "shroudring"; sPlaceableName = "<cË z>Undeath's Eternal Servant</c>"; nCost = 10000; nRetainItem=1; sIngredient2Type = "platinum"; break;
      case 17: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_claw"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_immac"; sPlaceableName = "<c¦ÿ©>Ring of Elemental Acid Immunity</c>"; sIngredient2Type = "ivory"; nCost = 10000; nRetainItem=1; break;
      case 18: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_immco"; sPlaceableName = "<c¦ÿ©>Ring of Elemental Cold Immunity</c>"; sIngredient2Type = "silver"; nCost = 10000; nRetainItem=1; break;
      case 19: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_blod"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_immfi"; sPlaceableName = "<c¦ÿ©>Ring of Elemental Fire Immunity</c>"; sIngredient2Type = "gold"; nCost = 10000; nRetainItem=1; break;
      case 20: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_immlt"; sPlaceableName = "<c¦ÿ©>Ring of Elemental Lightning Immunity</c>"; sIngredient2Type = "platinum"; nCost = 10000; nRetainItem=1; break;
      case 21: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_prtpv"; sPlaceableName = "<c¦ÿ©>Ring of Protection and Prevention</c>"; sIngredient2Type = "silver"; nCost = 10000; nRetainItem=1; break;
      case 22: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_bone"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_bondu"; sPlaceableName = "<c¦ÿ©>A Bond Unbroken</c>"; sIngredient2Type = "platinum"; nCost = 10000; nRetainItem=1; break;
      case 23: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_crusd"; sPlaceableName = "<c¦ÿ©>Crusader's Band</c>"; sIngredient2Type = "gold"; nCost = 10000; nRetainItem=1; break;
      case 24: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_duskf"; sPlaceableName = "<c¦ÿ©>Duskfetter</c>"; sIngredient2Type = "silver"; nCost = 10000; nRetainItem=1; break;
      case 25: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_bone"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_heart"; sPlaceableName = "<c¦ÿ©>Heartwood Ring</c>"; sIngredient2Type = "platinum"; nCost = 10000; nRetainItem=1; break;
      case 26: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_nabna"; sPlaceableName = "<c¦ÿ©>Nabessan Nail</c>"; sIngredient2Type = "ivory"; nCost = 10000; nRetainItem=1; break;
      case 27: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_blod"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_troll"; sPlaceableName = "<c¦ÿ©>Troll Queen's Ring</c>"; sIngredient2Type = "gold"; nCost = 10000; nRetainItem=1; break;
      case 28: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_claw"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_evasn"; sPlaceableName = "<c¦ÿ©>Lesser Ring of Evasion</c>"; sIngredient2Type = "ivory"; nCost = 10000; nRetainItem=1; break;
      case 29: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "js_jew_amul"; sType = "epx_neck_scrbp"; sPlaceableName = "<c¦ÿ©>Scarab of Protection +6</c>"; sIngredient2Type = "ivory"; nCost = 10000; nRetainItem=1; break;
      case 30: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_bone"; sIngredient2 = "js_jew_amul"; sType = "epx_neck_scrbl"; sPlaceableName = "<c¦ÿ©>Scarab of Living</c>"; sIngredient2Type = "gold"; nCost = 10000; nRetainItem=1; break;
      case 31: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_jew_amul"; sType = "epx_neck_eledf"; sPlaceableName = "<c¦ÿ©>Elemental Defense Amulet</c>"; sIngredient2Type = "platinum"; nCost = 10000; nRetainItem=1; break;
      case 32: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_safbc"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_regen"; sPlaceableName = "<c¦ÿ©>Ring of Regeneration</c>"; sIngredient2Type = "ivory"; nCost = 10000; nRetainItem=1; break;
      case 33: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_drfc"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_power"; sPlaceableName = "<c¦ÿ©>Ring of Power</c>"; sIngredient2Type = "platinum"; nCost = 10000; nRetainItem=1; break;
      case 34: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_psbdc"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_clrth"; sPlaceableName = "<c¦ÿ©>Ring of Clear Thought +5</c>"; sIngredient2Type = "gold"; nCost = 10000; nRetainItem=1; break;
      case 35: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_mwamc"; sIngredient2 = "js_jew_amul"; sType = "epx_neck_pwisd"; sPlaceableName = "<c¦ÿ©>Periapt of Wisdom +6</c>"; sIngredient2Type = "platinum"; nCost = 10000; nRetainItem=1; break;
      case 36: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_bard"; sPlaceableName = "<c¦ÿ©>A Musician's Mind</c>"; sIngredient2Type = "ivory"; nCost = 10000; nRetainItem=1; break;
      case 37: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_blgd"; sPlaceableName = "<c¦ÿ©>Shadow's Glance</c>"; sIngredient2Type = "silver"; nCost = 10000; nRetainItem=1; break;
      case 38: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_blod"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_assn"; sPlaceableName = "<c¦ÿ©>Killer's Balance</c>"; sIngredient2Type = "gold"; nCost = 10000; nRetainItem=1; break;
      case 39: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_bone"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_empw"; sPlaceableName = "<c¦ÿ©>Warlock's Empowerment</c>"; sIngredient2Type = "ivory"; nCost = 10000; nRetainItem=1; break;
      case 40: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_focs"; sPlaceableName = "<c¦ÿ©>Warlock's Focus</c>"; sIngredient2Type = "silver"; nCost = 10000; nRetainItem=1; break;
      case 41: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_mwamc"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_drud"; sPlaceableName = "<c¦ÿ©>Nature's Devotion</c>"; sIngredient2Type = "gold"; nCost = 10000; nRetainItem=1; break;
      case 42: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wrc"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_wzrd"; sPlaceableName = "<c¦ÿ©>Band of Illumination</c>"; sIngredient2Type = "platinum"; nCost = 10000; nRetainItem=1; break;
      case 43: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_psbdc"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_sorc"; sPlaceableName = "<c¦ÿ©>Mysterious Band</c>"; sIngredient2Type = "gold"; nCost = 10000; nRetainItem=1; break;
      case 44: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wbc"; sIngredient2 = "js_jew_ring"; sType = "epx_ring_cler"; sPlaceableName = "<c¦ÿ©>Divine Touch</c>"; sIngredient2Type = "platinum"; nCost = 10000; nRetainItem=1; break;
      case 45: sProduct = "x2_it_lightgem01"; sIngredient1 = "js_gem_rsap"; sIngredient2 = "js_alch_elew"; nCost = 200; break;
      case 46: sProduct = "x2_it_lightgem02"; sIngredient1 = "js_gem_rcry"; sIngredient2 = "js_alch_elee"; nCost = 200; break;
      case 47: sProduct = "x2_it_lightgem03"; sIngredient1 = "js_gem_rrub"; sIngredient2 = "js_alch_elew"; nCost = 200; break;
      case 48: sProduct = "x2_it_lightgem04"; sIngredient1 = "js_gem_rrub"; sIngredient2 = "js_alch_elef"; nCost = 200; break;
      case 49: sProduct = "x2_it_lightgem05"; sIngredient1 = "js_gem_reme"; sIngredient2 = "js_alch_elee"; nCost = 200; break;
      case 50: sProduct = "x2_it_lightgem06"; sIngredient1 = "js_gem_rcry"; sIngredient2 = "js_alch_elef"; nCost = 200; break;
      case 51: sProduct = "x2_it_lightgem07"; sIngredient1 = "js_gem_rdia"; sIngredient2 = "js_alch_elea"; nCost = 200; break;
    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);



}


void RangedCraftsmanConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nRetainItem; //Retains ingredients on failure for epic loot
    int nActionNode = GetLocalInt( oPC, "ds_actionnode");
    int nIngredient1Found;
    int nIngredient2Found;
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;

    if(nActionNode == 1) //Base Items
    {

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
          case 36: sProduct = "js_arch_thax"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "throwaxe"; sMaterial = "iron"; nCost = 100; break;
          case 37: sProduct = "js_arch_thax"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "throwaxe"; sMaterial = "steel"; nCost = 100; break;
          case 38: sProduct = "js_arch_thax"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "throwaxe"; sMaterial = "ironwood"; nCost = 100; break;
          case 39: sProduct = "js_arch_thax"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "throwaxe"; sMaterial = "silver"; nCost = 100; break;
          case 40: sProduct = "js_arch_thax"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "throwaxe"; sMaterial = "adamantine"; nCost = 100; break;
          case 41: sProduct = "js_arch_thax"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "throwaxe"; sMaterial = "mithral"; nCost = 100; break;
          case 42: sProduct = "js_arch_dart"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "dart"; sMaterial = "iron"; nCost = 100; break;
          case 43: sProduct = "js_arch_dart"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "dart"; sMaterial = "steel"; nCost = 100; break;
          case 44: sProduct = "js_arch_dart"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "dart"; sMaterial = "ironwood"; nCost = 100; break;
          case 45: sProduct = "js_arch_dart"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "dart"; sMaterial = "silver"; nCost = 100; break;
          case 46: sProduct = "js_arch_dart"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "dart"; sMaterial = "adamantine"; nCost = 100; break;
          case 47: sProduct = "js_arch_dart"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "dart"; sMaterial = "mithral"; nCost = 100; break;
          case 48: sProduct = "js_arch_shrk"; sIngredient1 = "js_bla_irin"; sIngredient2 = "none"; sType = "shuriken"; sMaterial = "iron"; nCost = 100; break;
          case 49: sProduct = "js_arch_shrk"; sIngredient1 = "js_bla_stin"; sIngredient2 = "none"; sType = "shuriken"; sMaterial = "steel"; nCost = 100; break;
          case 50: sProduct = "js_arch_shrk"; sIngredient1 = "js_bui_irpl"; sIngredient2 = "none"; sType = "shuriken"; sMaterial = "ironwood"; nCost = 100; break;
          case 51: sProduct = "js_arch_shrk"; sIngredient1 = "js_bla_siin"; sIngredient2 = "none"; sType = "shuriken"; sMaterial = "silver"; nCost = 100; break;
          case 52: sProduct = "js_arch_shrk"; sIngredient1 = "js_bla_adin"; sIngredient2 = "none"; sType = "shuriken"; sMaterial = "adamantine"; nCost = 100; break;
          case 53: sProduct = "js_arch_shrk"; sIngredient1 = "js_bla_miin"; sIngredient2 = "none"; sType = "shuriken"; sMaterial = "mithral"; nCost = 100; break;

        }
    }
    else if(nActionNode == 2) // Epic Loot + Magical Wood Loot
    {

      switch(nNode)
      {

        case 1: sProduct = "isaac_hcbow"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 2: sProduct = "isaac_lcbow"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 3: sProduct = "seek_hcbow"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 4: sProduct = "seek_lcbow"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 5: sProduct = "seek_lbow"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 6: sProduct = "seek_sbow"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 7: sProduct = "seek_sling"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 8: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_psbdc"; sIngredient2 = "js_arch_bow"; sType = "epx_weap_bowtm"; sPlaceableName = "<c¦ÿ©>Bow of the Tempest</c>"; sIngredient2Type = "duskwood"; nCost = 10000; nRetainItem=1; break;
        case 9: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wrc"; sIngredient2 = "js_arch_dart"; sType = "epx_weap_earbl"; sPlaceableName = "<c¦ÿ©>Earblasters</c>"; sIngredient2Type = "duskwood"; nCost = 10000; nRetainItem=1; break;
        case 10: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_gofbc"; sIngredient2 = "js_arch_shrk"; sType = "epx_weap_frcut"; sPlaceableName = "<c¦ÿ©>Frozen Cutters</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
        case 11: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_goimc"; sIngredient2 = "js_arch_thax"; sType = "epx_weap_thstr"; sPlaceableName = "<c¦ÿ©>Thunderstrikers</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
        case 12: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_gofbc"; sIngredient2 = "js_arch_cbow"; sType = "epx_weap_esscr"; sPlaceableName = "<c¦ÿ©>Essence Crossbow</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
        case 13: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_drfc"; sIngredient2 = "js_arch_lbow"; sType = "epx_weap_hurrc"; sPlaceableName = "<c¦ÿ©>Hurricane</c>"; sIngredient2Type = "duskwood"; nCost = 10000; nRetainItem=1; break;
        case 14: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wbc"; sIngredient2 = "js_arch_sbow"; sType = "epx_weap_ebgal"; sPlaceableName = "<c¦ÿ©>Ebon Gale</c>"; sIngredient2Type = "shadowtop"; nCost = 10000; nRetainItem=1; break;
        case 15: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wrc"; sIngredient2 = "js_arch_sling"; sType = "epx_weap_dlstr"; sPlaceableName = "<c¦ÿ©>Dalestriker</c>"; sIngredient2Type = "silk"; nCost = 10000; nRetainItem=1; break;
      }
    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);


}


void ScoundrelConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nRetainItem; //Retains ingredients on failure for epic loot
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

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);



}


void ScholarConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nRetainItem; //Retains ingredients on failure for epic loot
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

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);



}


void SmithConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName;
    int nRetainItem; //Retains ingredients on failure for epic loot
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
    else if(nActionNode == 9) // Sure/True/Warforged
    {

      switch(nNode)
      {

        case 1: sProduct = "sure_dagger"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 2: sProduct = "sure_axe"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 3: sProduct = "sure_kama"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 4: sProduct = "sure_kukri"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 5: sProduct = "sure_hammer"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 6: sProduct = "sure_mace"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 7: sProduct = "true_rapier"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 8: sProduct = "true_scimitar"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 9: sProduct = "sure_sword"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 10: sProduct = "sure_sickle"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 11: sProduct = "sure_whip"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 12: sProduct = "true_bsword"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 13: sProduct = "true_baxe"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 14: sProduct = "true_club"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 15: sProduct = "true_daxe"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 16: sProduct = "true_katana"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 17: sProduct = "true_flail"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 18: sProduct = "true_lsword"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 19: sProduct = "true_mstar"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 20: sProduct = "true_trident"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 21: sProduct = "true_hammer"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 22: sProduct = "war_mace"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 23: sProduct = "war_daxe"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 24: sProduct = "war_gaxe"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 25: sProduct = "war_gsword"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 26: sProduct = "war_halberd"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 27: sProduct = "war_flail"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 28: sProduct = "war_staff"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 29: sProduct = "war_scythe"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 30: sProduct = "war_spear"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        case 31: sProduct = "war_dsword"; sIngredient1 = "epic_ore"; sIngredient2 = "none"; sType = "epic"; sMaterial = "none"; nCost = 50000; nRetainItem = 1; break;
        //case 32: sProduct = "warforged"; sIngredient1 = "js_bui_phpl"; sIngredient2 = "none"; sType = "weapon"; sMaterial = "training"; nCost = 1000; break;

      }
    }
    else if(nActionNode == 10) // Legendary Crafting
    {
      switch(nNode)
      {
        case 1: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_base_frosty"; sIngredient2 = "js_bla_shto"; sType = "frostspear_shiel"; sPlaceableName = "<cnÞÿ>Whitescale Aegis</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
        case 2: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_base_frosty"; sIngredient2 = "js_bla_wems"; sType = "frostspear_staff"; sPlaceableName = "<cnÞÿ>Wizard Staff of the Ice Queen</c>"; sIngredient2Type = "steel"; nCost = 10000; nRetainItem=1; break;
        case 3: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_base_frosty"; sIngredient2 = "js_bla_wems"; sType = "frostspear_staf2"; sPlaceableName = "<cnÞÿ>Sorcerer Staff of the Ice Queen</c>"; sIngredient2Type = "steel"; nCost = 10000; nRetainItem=1; break;
        case 4: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_base_frosty"; sIngredient2 = "js_bla_wems"; sType = "frostspear_staf3"; sPlaceableName = "<cnÞÿ>Cleric Staff of the Ice Queen</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
        case 5: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_base_frosty"; sIngredient2 = "js_bla_wems"; sType = "frostspear_staf4"; sPlaceableName = "<cnÞÿ>Druid Staff of the Ice Queen</c>"; sIngredient2Type = "ironwood"; nCost = 10000; nRetainItem=1; break;
        case 6: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_base_lich"; sIngredient2 = "js_bla_arfp"; sType = "shroudarmor"; sPlaceableName = "<cË z>Shroud of Eternal Damnation</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
        case 7: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_base_lich"; sIngredient2 = "js_bla_shto"; sType = "shroudshield"; sPlaceableName = "<cË z>Fallen Hero's Shield</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
        case 8: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_comp_frosty"; sIngredient2 = "js_bla_wega"; sType = "frostspear_gaxe"; sPlaceableName = "<cnÞÿ>Glacial Clever</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
        case 9: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_comp_lich"; sIngredient2 = "js_bla_helm"; sType = "shroudhelm"; sPlaceableName = "<cË z>Blazing Crown of Ages Past</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
      }
    }
    else if(nActionNode == 11) // Epic Crafting
    {
      switch(nNode)
      {
       case 1: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_blod"; sIngredient2 = "js_bla_grea"; sType = "epx_boot_stald"; sPlaceableName = "<c¦ÿ©>Greaves of the Stalwart Defender</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 2: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "js_bla_grea"; sType = "epx_boot_phalg"; sPlaceableName = "<c¦ÿ©>Phalanx Greaves</c>"; sIngredient2Type = "steel"; nCost = 10000; nRetainItem=1; break;
       case 3: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_claw"; sIngredient2 = "js_bla_helm"; sType = "epx_helm_myrta"; sPlaceableName = "<c¦ÿ©>Agility of the Myart</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 4: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_blod"; sIngredient2 = "js_bla_helm"; sType = "epx_helm_myrtb"; sPlaceableName = "<c¦ÿ©>Brilliance of the Myart</c>"; sIngredient2Type = "steel"; nCost = 10000; nRetainItem=1; break;
       case 5: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_bone"; sIngredient2 = "js_bla_helm"; sType = "epx_helm_myrti"; sPlaceableName = "<c¦ÿ©>Insight of the Myart</c>"; sIngredient2Type = "ironwood"; nCost = 10000; nRetainItem=1; break;
       case 6: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_claw"; sIngredient2 = "js_bla_helm"; sType = "epx_helm_myrtl"; sPlaceableName = "<c¦ÿ©>Leadership of the Myart</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 7: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_bla_helm"; sType = "epx_helm_myrtm"; sPlaceableName = "<c¦ÿ©>Might of the Myart</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 8: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_claw"; sIngredient2 = "js_bla_helm"; sType = "epx_helm_myrtv"; sPlaceableName = "<c¦ÿ©>Vitality of the Myart</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 9: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_bone"; sIngredient2 = "js_bla_brac"; sType = "epx_brac_gemgo"; sPlaceableName = "<c¦ÿ©>Bracers of the Gemstone Golem</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 10: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_bla_arfp"; sType = "epx_hevy_pltch"; sPlaceableName = "<c¦ÿ©>Dragon-Plate of Chaos</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 11: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_bla_arhp"; sType = "epx_hplt_chaos"; sPlaceableName = "<c¦ÿ©>Dragon-Half Plate of Chaos</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 12: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_bla_arsp"; sType = "epx_hspl_chaos"; sPlaceableName = "<c¦ÿ©>Dragon-Splint Mail of Chaos</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 13: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_bla_arbp"; sType = "epx_mbpt_chaos"; sPlaceableName = "<c¦ÿ©>Dragon-Breastplate of Chaos</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 14: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_bla_arcs"; sType = "epx_mchn_chaos"; sPlaceableName = "<c¦ÿ©>Dragon-Chain of Chaos</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 15: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_bla_arfp"; sType = "epx_hevy_pltty"; sPlaceableName = "<c¦ÿ©>Dragon-Plate of Tyranny</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 16: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_bla_arhp"; sType = "epx_hplt_tyrny"; sPlaceableName = "<c¦ÿ©>Dragon-Half Plate of Tyranny</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 17: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_bla_arsp"; sType = "epx_hspl_tyrny"; sPlaceableName = "<c¦ÿ©>Dragon-Splint Mail of Tyranny</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 18: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_bla_arbp"; sType = "epx_mbpt_tyrny"; sPlaceableName = "<c¦ÿ©>Dragon-Breastplate of Tyranny</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 19: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_bla_arcs"; sType = "epx_mchn_tyrny"; sPlaceableName = "<c¦ÿ©>Dragon-Chain of Tyranny</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 20: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_bla_arfp"; sType = "epx_hevy_arcdf"; sPlaceableName = "<c¦ÿ©>Arcane Defiance Plate</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 21: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_bla_arhp"; sType = "epx_hplt_arcdf"; sPlaceableName = "<c¦ÿ©>Arcane Defiance Half Plate</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 22: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_bla_arsp"; sType = "epx_hspl_arcdf"; sPlaceableName = "<c¦ÿ©>Arcane Defiance Splint Mail </c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 23: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_bla_arbp"; sType = "epx_mbpl_arcdf"; sPlaceableName = "<c¦ÿ©>Arcane Defiance Breastplate</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 24: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_bla_arcs"; sType = "epx_medm_arcdf"; sPlaceableName = "<c¦ÿ©>Arcane Defiance Chain</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 25: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_fabr"; sIngredient2 = "js_bla_shto"; sType = "epx_shdt_eledf"; sPlaceableName = "<c¦ÿ©>Elemental Defense Scutum</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 26: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_fabr"; sIngredient2 = "js_bla_shlg"; sType = "epx_shld_eledf"; sPlaceableName = "<c¦ÿ©>Elemental Defense Targe</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 27: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_fabr"; sIngredient2 = "js_bla_shsm"; sType = "epx_shdb_eledf"; sPlaceableName = "<c¦ÿ©>Elemental Defense Buckler</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 28: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "js_bla_shto"; sType = "epx_shdt_lasdf"; sPlaceableName = "<c¦ÿ©>The Last Defense Scutum</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 29: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "js_bla_shlg"; sType = "epx_shld_lasdf"; sPlaceableName = "<c¦ÿ©>The Last Defense Targe</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 30: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "js_bla_shsm"; sType = "epx_shdb_lasdf"; sPlaceableName = "<c¦ÿ©>The Last Defense Buckler</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 31: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_gofbc"; sIngredient2 = "js_bla_brac"; sType = "epx_brac_dext6"; sPlaceableName = "<c¦ÿ©>Bracers of Dexterity +6</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 32: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_psbdc"; sIngredient2 = "js_bla_wedw"; sType = "epx_weap_btbst"; sPlaceableName = "<c¦ÿ©>Battlerager Best</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 33: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_mwamc"; sIngredient2 = "js_bla_webs"; sType = "epx_weap_purft"; sPlaceableName = "<c¦ÿ©>Purified Filth</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 34: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_gofbc"; sIngredient2 = "js_bla_weda"; sType = "epx_weap_blakf"; sPlaceableName = "<c¦ÿ©>Fang of the Black Flag</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 35: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_drfc"; sIngredient2 = "js_bla_wegs"; sType = "epx_weap_scalr"; sPlaceableName = "<c¦ÿ©>Scalerot</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 36: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wbc"; sIngredient2 = "js_bla_wels"; sType = "epx_weap_myrkl"; sPlaceableName = "<c¦ÿ©>Myrk's Lament</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 37: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_goimc"; sIngredient2 = "js_bla_wera"; sType = "epx_weap_baled"; sPlaceableName = "<c¦ÿ©>Balanced Edge of Yin and Yang</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 38: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wrc"; sIngredient2 = "js_bla_wesc"; sType = "epx_weap_wailw"; sPlaceableName = "<c¦ÿ©>Wailing Wind</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 39: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_goimc"; sIngredient2 = "js_bla_wess"; sType = "epx_weap_harlq"; sPlaceableName = "<c¦ÿ©>Harlequin's Longsword</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 40: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_gofbc"; sIngredient2 = "js_bla_wewa"; sType = "epx_weap_dornt"; sPlaceableName = "<c¦ÿ©>Dornat Murr Guard Hammer</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 41: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_mwamc"; sIngredient2 = "js_bla_wema"; sType = "epx_weap_manor"; sPlaceableName = "<c¦ÿ©>The Manor House Door Knocker</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 42: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_drfc"; sIngredient2 = "js_bla_wekm"; sType = "epx_weap_irntr"; sPlaceableName = "<c¦ÿ©>Iron Tiger's Talons (Main)</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 43: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_drfc"; sIngredient2 = "js_bla_wekm"; sType = "epx_weap_irntl"; sPlaceableName = "<c¦ÿ©>Iron Tiger's Talons (Offhand)</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 44: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wbc"; sIngredient2 = "js_bla_weba"; sType = "epx_weap_mindr"; sPlaceableName = "<c¦ÿ©>Mindreaver</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 45: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_drfc"; sIngredient2 = "js_bla_wecl"; sType = "epx_weap_slbsh"; sPlaceableName = "<c¦ÿ©>Soulbasher</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 46: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_psbdc"; sIngredient2 = "js_bla_weha"; sType = "epx_weap_strmw"; sPlaceableName = "<c¦ÿ©>Stormweaver Axe</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 47: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_gofbc"; sIngredient2 = "js_bla_weka"; sType = "epx_weap_ethbl"; sPlaceableName = "<c¦ÿ©>Etherblade</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 48: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_mwamc"; sIngredient2 = "js_bla_weku"; sType = "epx_weap_vrtst"; sPlaceableName = "<c¦ÿ©>Vortex Stinger</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 49: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wrc"; sIngredient2 = "js_bla_welf"; sType = "epx_weap_sklsm"; sPlaceableName = "<c¦ÿ©>Skelly Smasher</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 50: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_drfc"; sIngredient2 = "js_bla_welh"; sType = "epx_weap_glcal"; sPlaceableName = "<c¦ÿ©>Galecaller</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 51: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_safbc"; sIngredient2 = "js_bla_wems"; sType = "epx_weap_beaur"; sPlaceableName = "<c¦ÿ©>Beauty's Redoubt</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 52: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_goimc"; sIngredient2 = "js_bla_wems"; sType = "epx_weap_sager"; sPlaceableName = "<c¦ÿ©>Sage's Redoubt</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 53: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_psbdc"; sIngredient2 = "js_bla_wems"; sType = "epx_weap_holyr"; sPlaceableName = "<c¦ÿ©>Holy Redoubt</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 54: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_mwamc"; sIngredient2 = "js_bla_wems"; sType = "epx_weap_eldrr"; sPlaceableName = "<c¦ÿ©>Eldritch Redoubt</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 55: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wbc"; sIngredient2 = "js_bla_wemo"; sType = "epx_weap_starf"; sPlaceableName = "<c¦ÿ©>Starfall</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 56: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_safbc"; sIngredient2 = "js_bla_wesi"; sType = "epx_weap_astcr"; sPlaceableName = "<c¦ÿ©>Astral Crescent</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 57: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wrc"; sIngredient2 = "js_bla_wetr"; sType = "epx_weap_runpg"; sPlaceableName = "<c¦ÿ©>Runic Pigsticker</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 58: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_safbc"; sIngredient2 = "js_bla_wewh"; sType = "epx_weap_drmwv"; sPlaceableName = "<c¦ÿ©>Dreamweaver</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 59: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_psbdc"; sIngredient2 = "js_bla_wequ"; sType = "epx_weap_crstw"; sPlaceableName = "<c¦ÿ©>Crystalwave Staff</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 60: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wbc"; sIngredient2 = "js_bla_wequ"; sType = "epx_weap_engmt"; sPlaceableName = "<c¦ÿ©>Enigma Totem</c>"; sIngredient2Type = "ironwood"; nCost = 10000; nRetainItem=1; break;
       case 61: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wrc"; sIngredient2 = "js_bla_wesp"; sType = "epx_weap_icesp"; sPlaceableName = "<c¦ÿ©>Icespire</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 62: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_safbc"; sIngredient2 = "js_bla_wega"; sType = "epx_weap_shdwm"; sPlaceableName = "<c¦ÿ©>Shadowmark</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 63: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_goimc"; sIngredient2 = "js_bla_wehb"; sType = "epx_weap_typhe"; sPlaceableName = "<c¦ÿ©>Typhoon Edge</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 64: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_drfc"; sIngredient2 = "js_bla_wehf"; sType = "epx_weap_ghstf"; sPlaceableName = "<c¦ÿ©>Ghostfire</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 65: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_gofbc"; sIngredient2 = "js_bla_wesy"; sType = "epx_weap_strfr"; sPlaceableName = "<c¦ÿ©>Starfrost</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;
       case 66: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_mwamc"; sIngredient2 = "js_bla_wedm"; sType = "epx_weap_shmir"; sPlaceableName = "<c¦ÿ©>Shadow Mirage</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 67: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_safbc"; sIngredient2 = "js_bla_wedb"; sType = "epx_weap_dbecl"; sPlaceableName = "<c¦ÿ©>Double Eclipse</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 68: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_goimc"; sIngredient2 = "js_bla_we2b"; sType = "epx_weap_frsfl"; sPlaceableName = "<c¦ÿ©>Frostfall</c>"; sIngredient2Type = "adamantine"; nCost = 10000; nRetainItem=1; break;
       case 69: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "js_bla_brac"; sType = "epx_brac_elego"; sPlaceableName = "<c¦ÿ©>Bracers of the Elemental Golem</c>"; sIngredient2Type = "mithral"; nCost = 10000; nRetainItem=1; break;


      }
    }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);

}


void TailorConverter(object oPC, object oBench, int nNode)
{

    string sProduct;
    string sIngredient1;
    string sIngredient2;
    string sIngredient1Type;
    string sIngredient2Type;
    string sType = "none";
    string sMaterial = "none";
    string sPlaceableName = "Job System Placeable";
    int nRetainItem; //Retains ingredients on failure for epic loot
    int nIngredient1Found;
    int nIngredient2Found;
    int nActionNode = GetLocalInt( oPC, "ds_actionnode");
    int nCost;
    int nStack = 0;
    int nProductStackSize = 1;


    if(nActionNode == 1)
    {
     switch(nNode)
     {

      case 1: sProduct = "js_lea_leat"; sIngredient1 = "js_hun_hide"; sIngredient2 = "none"; nCost = 200; break;
      case 2: sProduct = "js_tai_arle"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_tai_boco"; sType = "armor"; sMaterial = "leather"; nCost = 2000; break;
      case 3: sProduct = "js_tai_arha"; sIngredient1 = "js_hun_hide"; sIngredient2 = "js_tai_boco"; sType = "armor"; sMaterial = "hide"; nCost = 2000; break;
      case 4: sProduct = "js_tai_bpack1"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bla_irin"; nCost = 2000; break;
      case 5: sProduct = "js_tai_quiver1"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bui_phpl"; nCost = 2000; break;
      case 6: sProduct = "js_tai_scbrd1"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bla_siin"; nCost = 2000; break;
      case 7: sProduct = "js_tai_scbrd2"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bla_siin"; nCost = 2000; break;
      case 8: sProduct = "js_tai_scbrd3"; sIngredient1 = "js_lea_leat"; sIngredient2 = "js_bla_siin"; nCost = 2000; break;
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
      case 25: sProduct = "js_tai_boot"; sIngredient1 = "js_lea_leat"; sIngredient2 = "none"; sType = "boots"; sMaterial = "leather"; nCost = 2000; break;
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
      case 55: sProduct = "js_tailorkit"; sIngredient1 = "js_tai_bosi"; sIngredient2 = "js_bla_stin"; nCost = 10000; break;
      case 56: sProduct = "epiccraftingtmp"; sIngredient1 = "raid_base_lich"; sIngredient2 = "js_tai_cloa"; sType = "shroudcloak"; sPlaceableName = "<cË z>Mantle of Unlife</c>"; nCost = 10000; sIngredient2Type = "wool"; break;
      case 57: sProduct = "js_tai_glove"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "none"; sType = "gloves"; sMaterial = "wool"; nCost = 2000; break;
      case 58: sProduct = "js_tai_glove"; sIngredient1 = "js_tai_boco"; sIngredient2 = "none"; sType = "gloves"; sMaterial = "cotton"; nCost = 2000; break;
      case 59: sProduct = "js_tai_glove"; sIngredient1 = "js_tai_brwo"; sIngredient2 = "none"; sType = "gloves"; sMaterial = "rothewool"; nCost = 2000; break;
      case 60: sProduct = "js_tai_glove"; sIngredient1 = "js_hun_hide"; sIngredient2 = "none"; sType = "gloves"; sMaterial = "hide"; nCost = 2000; break;
      case 61: sProduct = "js_tai_glove"; sIngredient1 = "js_lea_leat"; sIngredient2 = "none"; sType = "gloves"; sMaterial = "leather"; nCost = 2000; break;
      case 62: sProduct = "js_tai_glove"; sIngredient1 = "js_tai_bosi"; sIngredient2 = "none"; sType = "gloves"; sMaterial = "silk"; nCost = 2000; break;
      case 63: sProduct = "js_tai_hood"; sIngredient1 = "js_tai_bosi"; sIngredient2 = "none"; sType = "hood"; sMaterial = "silk"; nCost = 2000; break;
      case 64: sProduct = "js_tai_hood"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "none"; sType = "hood"; sMaterial = "wool"; nCost = 2000; break;
      case 65: sProduct = "js_tai_hood"; sIngredient1 = "js_tai_boco"; sIngredient2 = "none"; sType = "hood"; sMaterial = "cotton"; nCost = 2000; break;
      case 66: sProduct = "js_tai_hood"; sIngredient1 = "js_tai_brwo"; sIngredient2 = "none"; sType = "hood"; sMaterial = "rothewool"; nCost = 2000; break;
      case 67: sProduct = "js_tai_boot"; sIngredient1 = "js_hun_hide"; sIngredient2 = "none"; sType = "boots"; sMaterial = "hide"; nCost = 2000; break;
      case 68: sProduct = "js_tai_hood"; sIngredient1 = "js_lea_leat"; sIngredient2 = "none"; sType = "hood"; sMaterial = "leather"; nCost = 2000; break;
      case 69: sProduct = "js_tai_boot"; sIngredient1 = "js_tai_bosi"; sIngredient2 = "none"; sType = "boots"; sMaterial = "silk"; nCost = 2000; break;
      case 70: sProduct = "js_tai_boot"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "none"; sType = "boots"; sMaterial = "wool"; nCost = 2000; break;
      case 71: sProduct = "js_tai_boot"; sIngredient1 = "js_tai_boco"; sIngredient2 = "none"; sType = "boots"; sMaterial = "cotton"; nCost = 2000; break;
      case 72: sProduct = "js_tai_boot"; sIngredient1 = "js_tai_brwo"; sIngredient2 = "none"; sType = "boots"; sMaterial = "rothewool"; nCost = 2000; break;
      case 73: sProduct = "js_tai_belt"; sIngredient1 = "js_hun_hide"; sIngredient2 = "none"; sType = "belt"; sMaterial = "hide"; nCost = 2000; break;
      case 74: sProduct = "js_tai_belt"; sIngredient1 = "js_tai_bosi"; sIngredient2 = "none"; sType = "belt"; sMaterial = "silk"; nCost = 2000; break;
      case 75: sProduct = "js_tai_belt"; sIngredient1 = "js_tai_bowo"; sIngredient2 = "none"; sType = "belt"; sMaterial = "wool"; nCost = 2000; break;
      case 76: sProduct = "js_tai_belt"; sIngredient1 = "js_tai_boco"; sIngredient2 = "none"; sType = "belt"; sMaterial = "cotton"; nCost = 2000; break;
      case 77: sProduct = "js_tai_belt"; sIngredient1 = "js_tai_brwo"; sIngredient2 = "none"; sType = "belt"; sMaterial = "rothewool"; nCost = 2000; break;

    }
   }
   if(nActionNode == 2) // Epics
   {
     switch(nNode)
     {
      case 1: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_tai_boot"; sType = "boots_broken5"; sPlaceableName = "<c¦ÿ©>Boots of the Broken Ones</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 2: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_fabr"; sIngredient2 = "js_tai_boot"; sType = "epx_boot_cushb"; sPlaceableName = "<c¦ÿ©>Cushioning Boots of the Archmage</c>"; sIngredient2Type = "silk"; nCost = 10000; nRetainItem=1; break;
      case 3: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_tai_boot"; sType = "epx_boot_shoin"; sPlaceableName = "<c¦ÿ©>Petite Shoes of Intuition</c>"; sIngredient2Type = "cotton"; nCost = 10000; nRetainItem=1; break;
      case 4: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_tai_boot"; sType = "epx_boot_fndtr"; sPlaceableName = "<c¦ÿ©>Finder of Trails</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 5: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_fabr"; sIngredient2 = "js_tai_hood"; sType = "epx_helm_archr"; sPlaceableName = "<c¦ÿ©>Hood of the Archer</c>"; sIngredient2Type = "wool"; nCost = 10000; nRetainItem=1; break;
      case 6: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_fabr"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_anmha"; sPlaceableName = "<c¦ÿ©>Epic Gloves of Animal Handling</c>"; sIngredient2Type = "wool"; nCost = 10000; nRetainItem=1; break;
      case 7: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_blod"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_concn"; sPlaceableName = "<c¦ÿ©>Epic Gloves of Concentration</c>"; sIngredient2Type = "cotton"; nCost = 10000; nRetainItem=1; break;
      case 8: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_discp"; sPlaceableName = "<c¦ÿ©>Epic Gloves of Discipline</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 9: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_bone"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_splcr"; sPlaceableName = "<c¦ÿ©>Epic Gloves of Spellcraft</c>"; sIngredient2Type = "silk"; nCost = 10000; nRetainItem=1; break;
      case 10: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_bone"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_mnstl"; sPlaceableName = "<c¦ÿ©>Epic Gloves of Minstrel</c>"; sIngredient2Type = "rothewool"; nCost = 10000; nRetainItem=1; break;
      case 11: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_claw"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_healg"; sPlaceableName = "<c¦ÿ©>Epic Healing Gloves</c>"; sIngredient2Type = "hide"; nCost = 10000; nRetainItem=1; break;
      case 12: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_blod"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_ringl"; sPlaceableName = "<c¦ÿ©>Ringleader's Gloves</c>"; sIngredient2Type = "cotton"; nCost = 10000; nRetainItem=1; break;
      case 13: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_fabr"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_mastg"; sPlaceableName = "<c¦ÿ©>The Master's Gift</c>"; sIngredient2Type = "silk"; nCost = 10000; nRetainItem=1; break;
      case 14: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_sword"; sPlaceableName = "<c¦ÿ©>Epic Gloves of Swordplay</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 15: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_fabr"; sIngredient2 = "js_tai_cloa"; sType = "epx_clok_hidth"; sPlaceableName = "<c¦ÿ©>Cloak of Hidden Things</c>"; sIngredient2Type = "wool"; nCost = 10000; nRetainItem=1; break;
      case 16: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_tai_arha"; sType = "epx_lhid_chaos"; sPlaceableName = "<c¦ÿ©>Dragon-Hide of Chaos</c>"; sIngredient2Type = "hide"; nCost = 10000; nRetainItem=1; break;
      case 17: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_tai_arle"; sType = "epx_llet_chaos"; sPlaceableName = "<c¦ÿ©>Dragon-Leather of Chaos</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 18: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_tai_arpa"; sType = "epx_lpad_chaos"; sPlaceableName = "<c¦ÿ©>Dragon-Padding of Chaos</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 19: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_tai_arcl"; sType = "epx_cloth_chaos"; sPlaceableName = "<c¦ÿ©>Dragon-Cloth of Chaos</c>"; sIngredient2Type = "rothewool"; nCost = 10000; nRetainItem=1; break;
      case 20: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_tai_arha"; sType = "epx_lhid_tyrny"; sPlaceableName = "<c¦ÿ©>Dragon-Hide of Tyranny</c>"; sIngredient2Type = "hide"; nCost = 10000; nRetainItem=1; break;
      case 21: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_tai_arle"; sType = "epx_llet_tyrny"; sPlaceableName = "<c¦ÿ©>Dragon-Leather of Tyranny</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 22: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_tai_arpa"; sType = "epx_lpad_tyrny"; sPlaceableName = "<c¦ÿ©>Dragon-Padding of Tyranny</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 23: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_tai_arcl"; sType = "epx_cloth_tyrny"; sPlaceableName = "<c¦ÿ©>Dragon-Cloth of Tyranny</c>"; sIngredient2Type = "cotton"; nCost = 10000; nRetainItem=1; break;
      case 24: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_tai_arha"; sType = "epx_lhid_arcdf"; sPlaceableName = "<c¦ÿ©>Arcane Defiance Hide</c>"; sIngredient2Type = "hide"; nCost = 10000; nRetainItem=1; break;
      case 25: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_tai_arle"; sType = "epx_ligt_arcdf"; sPlaceableName = "<c¦ÿ©>Arcane Defiance Leather</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 26: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_tai_arpa"; sType = "epx_lpad_arcdf"; sPlaceableName = "<c¦ÿ©>Arcane Defiance Padding</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 27: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_tai_arcl"; sType = "epx_clth_arcdf"; sPlaceableName = "<c¦ÿ©>Arcane Defiance Cloth</c>"; sIngredient2Type = "silk"; nCost = 10000; nRetainItem=1; break;
      case 28: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_claw"; sIngredient2 = "js_tai_arha"; sType = "epx_lhid_frtiv"; sPlaceableName = "<c¦ÿ©>Furtive Hide</c>"; sIngredient2Type = "hide"; nCost = 10000; nRetainItem=1; break;
      case 29: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_claw"; sIngredient2 = "js_tai_arle"; sType = "epx_llet_frtiv"; sPlaceableName = "<c¦ÿ©>Furtive Leather</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 30: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_claw"; sIngredient2 = "js_tai_arpa"; sType = "epx_lpad_frtiv"; sPlaceableName = "<c¦ÿ©>Furtive Padding</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 31: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_claw"; sIngredient2 = "js_tai_arcl"; sType = "epx_cloth_frtiv"; sPlaceableName = "<c¦ÿ©>Furtive Regalia</c>"; sIngredient2Type = "wool"; nCost = 10000; nRetainItem=1; break;
      case 32: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_eqip"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_hontg"; sPlaceableName = "<c¦ÿ©>Gloves of the Honeyed Tongue</c>"; sIngredient2Type = "silk"; nCost = 10000; nRetainItem=1; break;
      case 33: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_serpt"; sPlaceableName = "<c¦ÿ©>Gloves of the Serpent's Tongue</c>"; sIngredient2Type = "cotton"; nCost = 10000; nRetainItem=1; break;
      case 34: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_fabr"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_chalg"; sPlaceableName = "<c¦ÿ©>Gloves of the Challenger</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 35: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_blod"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_cnsth"; sPlaceableName = "<c¦ÿ©>Gloves of Conspicuous Threats</c>"; sIngredient2Type = "hide"; nCost = 10000; nRetainItem=1; break;
      case 36: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_obsd"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_eqest"; sPlaceableName = "<c¦ÿ©>Gloves of the Equestrian</c>"; sIngredient2Type = "wool"; nCost = 10000; nRetainItem=1; break;
      case 37: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_goimc"; sIngredient2 = "js_tai_boot"; sType = "epx_boot_strid"; sPlaceableName = "<c¦ÿ©>Boots of Striding</c>"; sIngredient2Type = "rothewool"; nCost = 10000; nRetainItem=1; break;
      case 38: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wbc"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_gldld"; sPlaceableName = "<c¦ÿ©>Gloves of the Golden Lady</c>"; sIngredient2Type = "silk"; nCost = 10000; nRetainItem=1; break;
      case 39: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wrc"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_artfc"; sPlaceableName = "<c¦ÿ©>Epic Gloves of the Artificer</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 40: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_mwamc"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_snqag"; sPlaceableName = "<c¦ÿ©>The Sanctuary's Quagmire</c>"; sIngredient2Type = "cotton"; nCost = 10000; nRetainItem=1; break;
      case 41: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_goimc"; sIngredient2 = "js_tai_cloa"; sType = "epx_clok_fort5"; sPlaceableName = "<c¦ÿ©>Cloak of Fortification +5</c>"; sIngredient2Type = "rothewool"; nCost = 10000; nRetainItem=1; break;
      case 42: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wbc"; sIngredient2 = "js_tai_cloa"; sType = "epx_clok_nmph6"; sPlaceableName = "<c¦ÿ©>Nymph Cloak +6</c>"; sIngredient2Type = "silk"; nCost = 10000; nRetainItem=1; break;
      case 43: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_gofbc"; sIngredient2 = "js_tai_cloa"; sType = "epx_clok_snclk"; sPlaceableName = "<c¦ÿ©>Sanctuary Cloak of Safety</c>"; sIngredient2Type = "cotton"; nCost = 10000; nRetainItem=1; break;
      case 44: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_gofbc"; sIngredient2 = "js_tai_belt"; sType = "epx_belt_aglty"; sPlaceableName = "<c¦ÿ©>Belt of Agility</c>"; sIngredient2Type = "hide"; nCost = 10000; nRetainItem=1; break;
      case 45: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_safbc"; sIngredient2 = "js_tai_belt"; sType = "epx_belt_stngi"; sPlaceableName = "<c¦ÿ©>Belt of Stone Giant Strength</c>"; sIngredient2Type = "silk"; nCost = 10000; nRetainItem=1; break;
      case 46: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_psbdc"; sIngredient2 = "js_tai_belt"; sType = "epx_belt_hrdrd"; sPlaceableName = "<c¦ÿ©>Belt of the Hard Road</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 47: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_safbc"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_silwh"; sPlaceableName = "<c¦ÿ©>Gloves of Silent Whispers</c>"; sIngredient2Type = "rothewool"; nCost = 10000; nRetainItem=1; break;
      case 48: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_drfc"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_ksens"; sPlaceableName = "<c¦ÿ©>Gloves of Keen Senses</c>"; sIngredient2Type = "cotton"; nCost = 10000; nRetainItem=1; break;
      case 49: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_wrc"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_hinfs"; sPlaceableName = "<c¦ÿ©>Gloves of the Hin Fist +6</c>"; sIngredient2Type = "hide"; nCost = 10000; nRetainItem=1; break;
      case 50: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_safbc"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_longd"; sPlaceableName = "<c¦ÿ©>Gloves of the Long Death +6</c>"; sIngredient2Type = "leather"; nCost = 10000; nRetainItem=1; break;
      case 51: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_comp_goimc"; sIngredient2 = "js_tai_glove"; sType = "epx_glov_yellr"; sPlaceableName = "<c¦ÿ©>Gloves of the Yellow Rose +6</c>"; sIngredient2Type = "hide"; nCost = 10000; nRetainItem=1; break;
      case 52: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_ston"; sIngredient2 = "js_tai_cloa"; sType = "epx_clok_stlt"; sPlaceableName = "<c¦ÿ©>Cape of the Panther</c>"; sIngredient2Type = "rothewool"; nCost = 10000; nRetainItem=1; break;
      case 53: sProduct = "epiccraftingtmp"; sIngredient1 = "epx_base_glyp"; sIngredient2 = "js_tai_cloa"; sType = "epx_clok_dtct"; sPlaceableName = "<c¦ÿ©>Cape of the Owl</c>"; sIngredient2Type = "rothewool"; nCost = 10000; nRetainItem=1; break;
     }

   }

    CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,0,sIngredient1Type,sIngredient2Type);



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
        SetLocalString(oCraftedItem,"stringMaterial","adamantine");

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
        SetLocalString(oCraftedItem,"stringMaterial","mithral");

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
        SetLocalString(oCraftedItem,"stringMaterial","steel");

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
        SetLocalString(oCraftedItem,"stringMaterial","iron");

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
        SetLocalString(oCraftedItem,"stringMaterial","ivory");
      }
      else if(sMaterial == "platinum")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Platinum</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(12);
        SetLocalString(oCraftedItem,"stringMaterial","platinum");
      }
      else if(sMaterial == "gold")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Gold</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(8);
        SetLocalString(oCraftedItem,"stringMaterial","gold");
      }
      else if(sMaterial == "silver")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Silver</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(13);
        SetLocalInt(oCraftedItem,"armormaterial",3);
        SetLocalInt(oCraftedItem,"material",3);
        SetLocalString(oCraftedItem,"stringMaterial","silver");

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
        SetLocalString(oCraftedItem,"stringMaterial","duskwood");

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
        SetLocalString(oCraftedItem,"stringMaterial","ironwood");

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
        SetLocalString(oCraftedItem,"stringMaterial","phandar");

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
        SetLocalString(oCraftedItem,"stringMaterial","shadowtop");

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
        SetLocalString(oCraftedItem,"stringMaterial","zurkwood");

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
        SetLocalString(oCraftedItem,"stringMaterial","cotton");

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
        SetLocalString(oCraftedItem,"stringMaterial","silk");

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
        SetLocalString(oCraftedItem,"stringMaterial","rothewool");

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
        SetLocalString(oCraftedItem,"stringMaterial","wool");

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
        SetLocalString(oCraftedItem,"stringMaterial","hide");

        if((sType == "armor"))
        {
          iProperty1 = ItemPropertyACBonus(1);
        }
      }
      else if(sMaterial == "leather")
      {
        SetName(oCraftedItem,"<c~Îë>Crafted Leather</c> " + GetName(oCraftedItem));
        iMaterial = ItemPropertyMaterial(31);
        SetLocalString(oCraftedItem,"stringMaterial","leather");

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
        SetLocalString(oCraftedItem,"stringMaterial","training");
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


void CraftProduct(object oPC, object oBench, string sProduct, string sType, string sMaterial, string sIngredient1, string sIngredient2, string sPlaceableName, int nCost, int nStack, int nProductStackSize, int nRetainItem, int nRepeat, string sIngredient1Type, string sIngredient2Type)
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
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }

      if(sIngredient2 == "jobsystemwood")
      {
        if((GetResRef(oItemInChest) == "js_tree_phaw") || (GetResRef(oItemInChest) == "js_tree_dusw") ||
        (GetResRef(oItemInChest) == "js_tree_shaw") || (GetResRef(oItemInChest) == "js_tree_irow") ||
        (GetResRef(oItemInChest) == "js_tree_zurw"))
        {
           nIngredient2Found = 1;
           oIngredient2 = oItemInChest;
        }
      }
      //

      // Catch all for any epic ore
      if(sIngredient1 == "epic_ore")
      {
        if((GetResRef(oItemInChest) == "nep_largemagical") || (GetResRef(oItemInChest) == "nep_mediummagic") ||
        (GetResRef(oItemInChest) == "nep_smallmagical") || (GetResRef(oItemInChest) == "nep_magicalhemp"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }
      if(sIngredient2 == "epic_ore")
      {
        if((GetResRef(oItemInChest) == "nep_largemagical") || (GetResRef(oItemInChest) == "nep_mediummagic") ||
        (GetResRef(oItemInChest) == "nep_smallmagical") || (GetResRef(oItemInChest) == "nep_magicalhemp"))
        {
           nIngredient2Found = 1;
           oIngredient2 = oItemInChest;
        }
      }

      // Catch all for meats so any work with jobs
      if(sIngredient1 == "jobsystemmeat")
      {
        if((GetResRef(oItemInChest) == "js_ran_chme") || (GetResRef(oItemInChest) == "js_ran_rome") ||
        (GetResRef(oItemInChest) == "js_ran_pork") || (GetResRef(oItemInChest) == "js_ran_beef") ||
        (GetResRef(oItemInChest) == "js_ran_mutt") || (GetResRef(oItemInChest) == "js_ran_peam")
        || (GetResRef(oItemInChest) == "js_hun_game"))
        {
           nIngredient1Found = 1;
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
           nIngredient2Found = 1;
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
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }

      if(sIngredient2 == "jobsystemmilk")
      {
        if((GetResRef(oItemInChest) == "js_ran_cami") || (GetResRef(oItemInChest) == "js_ran_romi") ||
        (GetResRef(oItemInChest) == "js_ran_shmi") || (GetResRef(oItemInChest) == "js_ran_mil"))
        {
           nIngredient2Found = 1;
           oIngredient2 = oItemInChest;
        }
      }
      //

      // Catch all for eggs so any work with jobs
      if(sIngredient1 == "jobsystemeggs")
      {
        if((GetResRef(oItemInChest) == "js_ran_cheg") || (GetResRef(oItemInChest) == "js_ran_peae"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }

      if(sIngredient2 == "jobsystemeggs")
      {
        if((GetResRef(oItemInChest) == "js_ran_cheg") || (GetResRef(oItemInChest) == "js_ran_peae"))
        {
           nIngredient2Found = 1;
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

           nIngredient1Found = 1;
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
           nIngredient2Found = 1;
           oIngredient2 = oItemInChest;
           nWeaponMaterial = GetLocalInt(oItemInChest, "material");
           sWeaponResRef = GetResRef(oItemInChest);
           nWeaponMaterialPresent = 1;
        }
      }
      //

            // Catch all for dye so any work with jobs
      if(sIngredient1 == "jobsystemdye")
      {
        if((GetResRef(oItemInChest) == "js_art_colblk") || (GetResRef(oItemInChest) == "js_art_colblu") ||
        (GetResRef(oItemInChest) == "js_art_colgrn") || (GetResRef(oItemInChest) == "js_art_colorn") ||
        (GetResRef(oItemInChest) == "js_art_colprp") || (GetResRef(oItemInChest) == "js_art_colred") ||
        (GetResRef(oItemInChest) == "js_art_colwht") || (GetResRef(oItemInChest) == "js_art_colyel"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }

      if(sIngredient2 == "jobsystemdye")
      {
        if((GetResRef(oItemInChest) == "js_art_colblk") || (GetResRef(oItemInChest) == "js_art_colblu") ||
        (GetResRef(oItemInChest) == "js_art_colgrn") || (GetResRef(oItemInChest) == "js_art_colorn") ||
        (GetResRef(oItemInChest) == "js_art_colprp") || (GetResRef(oItemInChest) == "js_art_colred") ||
        (GetResRef(oItemInChest) == "js_art_colwht") || (GetResRef(oItemInChest) == "js_art_colyel"))
        {
           nIngredient2Found = 1;
           oIngredient2 = oItemInChest;
        }
      }
      //

      // PLC Spawners as Ingredients using "plc" string variables

      // Scented Candle
      if(sIngredient1 == "jobplc_scntcandle")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_art_scca"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Exotic Candle
      if(sIngredient1 == "jobplc_exoticcandle")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_art_exca"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Table
      if(sIngredient1 == "jobplc_table")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_bui_tabl"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Pot
      if(sIngredient1 == "jobplc_pot")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_art_potclay1"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Big Tent, Dark
      if(sIngredient1 == "jobplc_bigtent")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_bui_tent3"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Big Tent, Red and White
      if(sIngredient1 == "jobplc_bigtentrdwht")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_bui_tent5"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Carpet
      if(sIngredient1 == "jobplc_carpet")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_tai_carp"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Rug, Fancy Base
      if(sIngredient1 == "jobplc_carpetfancy")
      {
        if((GetLocalString(oItemInChest, "plc") == "js_art_rugbase1"))
        {
           nIngredient1Found = 1;
           oIngredient1 = oItemInChest;
        }
      }
      //

      // Added support so it now works properly if you have two ingredients that are identical
      if((GetResRef(oItemInChest) == sIngredient1) && (nIngredient1Found != 1))
      {
         if((sIngredient1Type == GetLocalString(oItemInChest,"stringMaterial")) || (sIngredient1Type==""))
         {
          nIngredient1Found = 1;
          oIngredient1 = oItemInChest;
         }

      }
      else if((GetResRef(oItemInChest) == sIngredient2) && (nIngredient2Found != 1))  // If you find the second ingredient store it
      {
        if((sIngredient2Type == GetLocalString(oItemInChest,"stringMaterial")) || (sIngredient2Type==""))
        {
         nIngredient2Found = 1;
         oIngredient2 = oItemInChest;
        }

      }
     //

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
            SetIdentified(oCraftedItem, TRUE);
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

            if(nRetainItem == 1) //Don't destroy items if retain item is set to true
            {
                SendMessageToPC(oPC, "Your ingredient isn't destroyed.");
            }
            else // If there is a stack for ingredient1  we reduce the stack by 1
            {
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
            SetIdentified(oCraftedItem, TRUE);
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

            if(nRetainItem == 1) //Don't destroy items if retain item is set to true
            {
                SendMessageToPC(oPC, "Your ingredient isn't destroyed.");
            }
            else // If there is a stack for ingredient1  we reduce the stack by 1
            {
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
            SetIdentified(oCraftedItem, TRUE);
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
            if(nRetainItem == 1) //Don't destroy items if retain item is set to true
            {
                SendMessageToPC(oPC, "Your ingredient isn't destroyed.");
            }
            else
            {
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

      // If the type is listed as "epic", set the name to green. This is mainly used for Magical Ore / Magical Wood conversion.
      if(GetIsObjectValid(oCraftedItem) && (sType == "epic"))
      {
        string sItemName = GetName(oCraftedItem);
        if(GetSubString(sItemName, 0, 6) != "<c¦ÿ©>") //If the color code isn't found, set the color tags on the item
        {
            SetName(oCraftedItem, "<c¦ÿ©>" + sItemName +"</c>");
        }
      }

      // If the resref is set to epiccraftingtmp it is tied into the epic resource/component crafting system.
      if(GetIsObjectValid(oCraftedItem) && (sProduct == "epiccraftingtmp"))
      {
        SetName(oCraftedItem, "<cÿ×#>Unfinished</c> " + sPlaceableName);
        SetLocalString(oCraftedItem,"finalResRef",sType);
      }

      // Repeat loop script
      if((REPEAT_LOOP_ON==TRUE) && (nRetainItem==0))
      {
       DelayCommand(0.1,LoopCraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,sIngredient1Type,sIngredient2Type));
      }
    }
    else if(nRepeat==1) // This is a simple catch so that it doesnt always spam people with the message in else.
    {
      DS_CLEAR_ALL(oPC);
      return;
    }
    else
    {
      DS_CLEAR_ALL(oPC);
      SendMessageToPC(oPC,"*You do not have the proper ingredients*");
      return;
    }
      DS_CLEAR_ALL(oPC);
}

void LoopCraftProduct(object oPC,object oBench,string sProduct,string sType,string sMaterial,string sIngredient1,string sIngredient2,string sPlaceableName,int nCost,int nStack,int nProductStackSize,int nRetainItem,string sIngredient1Type,string sIngredient2Type)
{
  CraftProduct(oPC,oBench,sProduct,sType,sMaterial,sIngredient1,sIngredient2,sPlaceableName,nCost,nStack,nProductStackSize,nRetainItem,1,sIngredient1Type,sIngredient2Type);
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
