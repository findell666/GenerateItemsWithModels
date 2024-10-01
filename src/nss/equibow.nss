#include "nw_inc_gff"

void EquipCustomLongbow(object oPC, int nPart1, int nPart2, int nPart3)
{
    // Check if the player or creature is valid
    if (!GetIsObjectValid(oPC))
    {
        return;
    }

    // Create a base longbow from the blueprint (e.g., "nw_wbwln001")
    object oLongbow = CreateItemOnObject("nw_wbwln001", oPC);

    // Check if the longbow was successfully created
    if (!GetIsObjectValid(oLongbow))
    {
        return;
    }

    // Convert the longbow object to JSON
    json jItem = ObjectToJson(oLongbow);

    // Custom part numbers for bottom, middle, and top (set these as needed)
    //int nPart1 = 493;  // Bottom part
    //int nPart2 = 493;  // Middle part
    //int nPart3 = 493;  // Top part

    // Replace the model part numbers in the JSON structure
    jItem = GffReplaceWord(jItem, "xModelPart1", nPart1);  // Bottom part
    jItem = GffReplaceWord(jItem, "xModelPart2", nPart2);  // Middle part
    jItem = GffReplaceWord(jItem, "xModelPart3", nPart3);  // Top part

    // Convert the modified JSON back into an item and create the modified object
    object oModifiedLongbow = JsonToObject(jItem, GetLocation(oPC), oPC, TRUE);

    // Equip the modified longbow to the player's right hand
    AssignCommand(oPC, ActionEquipItem(oModifiedLongbow, INVENTORY_SLOT_RIGHTHAND));

    // Optionally destroy the original longbow, since we now have a modified copy
    DestroyObject(oLongbow);
}

void main()
{
    object oPC = OBJECT_SELF;
    EquipCustomLongbow(oPC,493,493,493);

}