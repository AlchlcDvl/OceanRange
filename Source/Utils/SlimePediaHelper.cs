// using RichPresence;

namespace OceanRange.Utils;

// Obtained this code from SimpleSrModLibrary, just been optimised to avoid excessive ToString and ToLower overhead
public static class SlimePediaCreation
{
    public static void CreatePediaForSlime(PediaId slimePediaId, string name, string intro, string diet, string favorite, string slimeology, string risks, string plortonomics)
    {
        var id = slimePediaId.ToString().ToLower();
        TranslationPatcher.AddActorTranslation("l." + id, name);
        TranslationPatcher.AddPediaTranslation("t." + id, name);
        TranslationPatcher.AddPediaTranslation("m.intro." + id, intro);
        TranslationPatcher.AddPediaTranslation("m.diet." + id, diet);
        TranslationPatcher.AddPediaTranslation("m.favorite." + id, favorite);
        TranslationPatcher.AddPediaTranslation("m.slimeology." + id, slimeology);
        TranslationPatcher.AddPediaTranslation("m.risks." + id, risks);
        TranslationPatcher.AddPediaTranslation("m.plortonomics." + id, plortonomics);
    }

    public static void CreatePediaForFood(PediaId pediaId, string name, string intro, string type, string favored, string about, string ranch)
    {
        var id = pediaId.ToString().ToLower();
        TranslationPatcher.AddActorTranslation("l." + id.Replace("_entry", ""), name);
        TranslationPatcher.AddPediaTranslation("t." + id, name);
        TranslationPatcher.AddPediaTranslation("m.intro." + id, intro);
        TranslationPatcher.AddPediaTranslation("m.resource_type." + id, type);
        TranslationPatcher.AddPediaTranslation("m.favored_by." + id, favored);
        TranslationPatcher.AddPediaTranslation("m.desc." + id, about);
        TranslationPatcher.AddPediaTranslation("m.how_to_use." + id, ranch);
    }

    // public static void CreateZoneSlimePedia(PediaId slimePediaId, Zone lNameId, string name, string presence, string fullName, string intro, string description)
    // {
    //     var id = slimePediaId.ToString().ToLower();
    //     Director.RICH_PRESENCE_ZONE_LOOKUP.Add(lNameId, name);
    //     TranslationPatcher.AddTranslationKey("global", "l.presence." + lNameId.ToString().ToLower(), presence);
    //     TranslationPatcher.AddPediaTranslation("t." + id, fullName);
    //     TranslationPatcher.AddPediaTranslation("m.intro." + id, intro);
    //     TranslationPatcher.AddPediaTranslation("m.desc." + id, description);
    // }

    public static void PreLoadSlimePediaConnection(PediaId pediaId, IdentifiableId pediaOfId, PediaCategory pediaCategory)
    {
        PediaRegistry.RegisterIdentifiableMapping(pediaId, pediaOfId);
        PediaRegistry.SetPediaCategory(pediaId, pediaCategory);
    }
}