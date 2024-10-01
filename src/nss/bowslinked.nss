#include "nw_inc_gff" // Include the necessary GFF functions

json GetLongbowModelParts(string sPrefix, int nResType = RESTYPE_NSS)
{
    json jResrefs = JsonArray();

    string sResref;
    int n = 1;
    // //BASE
    while ((sResref = ResManFindPrefix(sPrefix, nResType, n++, 1, "")) != ""){
        jResrefs = JsonArrayInsert(jResrefs, JsonString(sResref));
    }

    //CUSTOM
    n = 1;
    while ((sResref = ResManFindPrefix(sPrefix, nResType, n++, 0, "")) != ""){
        jResrefs = JsonArrayInsert(jResrefs, JsonString(sResref));
    }

    return JsonGetLength(jResrefs) == 0 ? JsonNull() : jResrefs;
}

int ExtractNumber(string modelPartString){
    string sNumber = GetStringRight(modelPartString, 3);
    return StringToInt(sNumber);
}

void CreateLongbowsForMerchant(object oMerchant)
{   
    int nItemCount = 0; // To keep track of items added to the merchant

    json jNwnPartsBottom = GetLongbowModelParts("wbwln_b_", RESTYPE_MDL);
    json jNwnPartsMiddle = GetLongbowModelParts("wbwln_m_", RESTYPE_MDL);
    json jNwnPartsTop = GetLongbowModelParts("wbwln_t_", RESTYPE_MDL);

    object oLongbow = CreateItemOnObject("nw_wbwln001", oMerchant);

    if (GetIsObjectValid(oLongbow))
    {
        int i = 0;
        for(i = 0; i < JsonGetLength(jNwnPartsBottom); i++){
            json jElbottom = JsonArrayGet(jNwnPartsBottom, i);
            int modelBottomPart = ExtractNumber(JsonGetString(jElbottom));


            // Convert the longbow object to JSON
            json jItem = ObjectToJson(oLongbow);

            // Replace the model part numbers in the JSON structure
            jItem = GffReplaceWord(jItem, "xModelPart1", modelBottomPart);  // Bottom part
            jItem = GffReplaceWord(jItem, "xModelPart2", modelBottomPart);  // Middle part
            jItem = GffReplaceWord(jItem, "xModelPart3", modelBottomPart);     // Top part
            jItem = GffReplaceLocString(jItem, "LocalizedName", "nw_wbwln001_b"+IntToString(modelBottomPart)+"_m"+ IntToString(modelBottomPart) +"_t"+ IntToString(modelBottomPart));     // Top part

            // Convert the modified JSON back into an item and place it in the merchant's inventory
            object oModifiedLongbow = JsonToObject(jItem, GetLocation(oMerchant), oMerchant, FALSE);

            // Destroy the original unmodified longbow
            DestroyObject(oLongbow);
            nItemCount++;

            if(nItemCount > 250){
                return;
            }
        }
    }
}

const string BLUE_PRINT_STORE = "generic_store";

void main()
{
    object oPC = OBJECT_SELF; //from nwscript console
    object oStore = CreateObject(OBJECT_TYPE_STORE, BLUE_PRINT_STORE, GetLocation(OBJECT_SELF), FALSE, "bow_store");

    CreateLongbowsForMerchant(oStore);

    OpenStore(oStore, oPC);
}