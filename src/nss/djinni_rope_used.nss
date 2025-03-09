/*
  Hemp Rope Bridge Puzzle Generation Script  - On Use Script for Puzzle PLC
- Maverick00053

*/

void LaunchConvoActivate( object oPC, object oPLC);
void LaunchConvoActivated( object oPC, object oPLC);
void SetQuestion(object oPLC);

void main()
{
   object oPC = GetLastUsedBy();
   object oPLC = OBJECT_SELF;
   int nActivated = GetLocalInt(oPLC,"activated");
   int nBlock = GetLocalInt(oPLC,"block");

   if(nBlock==1)
   {
    AssignCommand(oPLC,ActionSpeakString("<c ¿ >**The device appears unusable at this time**</c>"));
    return;
   }

   if(nActivated != 1)
   {
    LaunchConvoActivate(oPC,oPLC);
   }
   else
   {
    LaunchConvoActivated(oPC,oPLC);
   }

}

void LaunchConvoActivate( object oPC, object oPLC)
{
    SetQuestion(oPLC);
    AssignCommand(oPC, ActionStartConversation(oPLC, "c_djinni_rope", TRUE, FALSE));
}

void LaunchConvoActivated( object oPC, object oPLC)
{
    AssignCommand(oPC, ActionStartConversation(oPLC, "c_djinni_rope", TRUE, FALSE));
}

void SetQuestion(object oPLC)
{
  string sQuestion;
  int nAnswer;

  switch(Random(30)+1)
  {
    case 1: sQuestion = "A dungeon has 6 doors. If 3 of them are trapped, what is the percentage probability of picking a safe door? ((Just state the number))"; nAnswer = 50; break;
    case 2: sQuestion = "A group of 4 adventurers finds a treasure chest with 120 gold coins. How many coins will each adventurer receive if the coins are divided equally?"; nAnswer = 30; break;
    case 3: sQuestion = "A dragon’s hoard contains 3000 gold coins and 500 platinum coins. If each platinum coin is worth 10 gold coins, how much is the hoard worth in total?"; nAnswer = 8000; break;
    case 4: sQuestion = "The adventurers are traveling at a speed of 4 miles per hour. If they need to travel 24 miles to reach a village, how long will it take them in hours?"; nAnswer = 6; break;
    case 5: sQuestion = "A ranger has 30 arrows. If they use 3 arrows per day during their journey, how many days will it take before they run out of arrows?"; nAnswer = 10; break;
    case 6: sQuestion = "A Beholder has 10 eye stalks, and each eye can shoot a ray. How many total rays can the Beholder shoot at once?"; nAnswer = 10; break;
    case 7: sQuestion = "A miner finds 10 gems in a cave. He decides to keep 4 and sell the rest. How many gems will he sell?"; nAnswer = 6; break;
    case 8: sQuestion = "A group of 5 adventurers finds 10000 gold coins. If they divide the coins equally, how many coins will each adventurer get?"; nAnswer = 2000; break;
    case 9: sQuestion = "There are 8 legendary swords in Waterdeep. If two adventurers wish to each receive a sword, one adventurer wishes for 2, and another wishes for 3. How many swords will be left over?"; nAnswer = 1; break;
    case 11: sQuestion = "A rogue has a 70% chance to disarm a trap. What is the percent probability that the rogue will fail to disarm the trap on a single attempt? ((Just state the number))"; nAnswer = 30; break;
    case 12: sQuestion = "A treasure chest contains 500 gold coins and 300 silver coins. If each gold coin is worth 2 silver coins, how many silver coins is the total worth?"; nAnswer = 1300; break;
    case 13: sQuestion = "A party finds 5 treasure chests. One chest contains 100 gold coins, another contains 123 gold coins, and the remaining contain 175 each. How many total gold coins does the party find?"; nAnswer = 748; break;
    case 14: sQuestion = "A magic sword costs 200 gold pieces, and a shield costs 1.5 times as much gold pieces as the magic sword. How much would it cost to buy both items?"; nAnswer = 500; break;
    case 15: sQuestion = "A group of adventurers explores a dungeon for 5 hours per day. How many hours will it take them to explore a dungeon that is 30 miles long if they travel 3 miles per hour? "; nAnswer = 10; break;
    case 16: sQuestion = "A party finds 6 magic items, and each item is worth 100 gold pieces. How much are the items worth in total?"; nAnswer = 600; break;
    case 17: sQuestion = "A mimic weighs 200 pounds in chest form. If it transforms and increases its weight by 50%, how much does it weigh in its monster form?"; nAnswer = 300; break;
    case 18: sQuestion = "A wizard teleports the party of 4 adventurers. The chance of a successful teleportation is 90%. What is the percent probability that all adventurers will successfully teleport? ((Just state the number rounded to the nearest whole number))"; nAnswer = 66; break;
    case 19: sQuestion = "A treasure hoard contains 3 types of coins: gold, silver, and platinum. If there are 500 gold coins, 1000 silver coins, and 200 platinum coins, how many coins are there in total?"; nAnswer = 1700; break;
    case 20: sQuestion = "It takes the party 6 hours to travel 18 miles through the Underdark. How many hours will it take to travel 54 miles?"; nAnswer = 18; break;
    case 21: sQuestion = "A dwarf crafts a shield that takes 8 hours to make. How many hours will it take to make 5 shields?"; nAnswer = 40; break;
    case 22: sQuestion = "The party is exploring the Tomb of Horrors and they encounter 3 traps, each with a 30% chance of being triggered. What is the percent probability that none of the traps will trigger? ((Just state the number rounded to the nearest whole number))"; nAnswer = 34; break;
    case 23: sQuestion = "A party travels through 21 miles of dungeon in 3 hours. How many miles can they travel per hour?"; nAnswer = 7; break;
    case 24: sQuestion = "A treasure hoard contains 198 gems. If there are 3 adventurers, how many gems can each adventurer receive if the gems are divided equally?"; nAnswer = 66; break;
    case 25: sQuestion = " A mimic weighs 350 pounds in chest form. If it transforms and increases its weight by 50%, how much does it weigh in its monster form?"; nAnswer = 525; break;
    case 26: sQuestion = "The party finds a chest with 300 gold, 400 silver, and 200 copper coins. How many coins are there in total?"; nAnswer = 900; break;
    case 27: sQuestion = "The adventurers are traveling at a speed of 7 miles per hour. If they need to travel 77 miles to reach a town, how many hours will it take them?"; nAnswer = 11; break;
    case 28: sQuestion = "A red dragon can consume 4 adventurers per hour. If the amount of adventurers visiting its lair are unlimited. How many adventurers can it consume in 4 and a half hours?"; nAnswer = 18; break;
    case 29: sQuestion = "An ogre, a giant, and a yeti are all arguing about who is heavier. The giant weights 2000 pounds, the ogre 600 pounds, and the yeti 750 pounds. How much is their total weight?"; nAnswer = 3350; break;
    case 30: sQuestion = "An arcane archer can fire 6 arrows in six seconds. How many seconds does it take to fire 41 arrows?"; nAnswer = 41; break;
  }

  SetCustomToken(72333330,sQuestion);
  SetLocalInt(oPLC,"answer",nAnswer);
  SetLocalInt(oPLC,"activated",1);
}

