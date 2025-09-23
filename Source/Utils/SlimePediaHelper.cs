using RichPresence;

namespace OceanRange.Utils;

// Obtained this code from SimpleSrModLibrary, just been optimised to avoid excessive ToString and ToLower overhead
public static class SlimepediaCreation
{
    public static void CreatePediaForSlime(PediaId slimePediaId, IdentifiableId id, string name, string intro, string diet, string favorite, string slimeology, string risks, string plortonomics)
    {
        TranslationPatcher.AddActorTranslation("l." + id.ToString().ToLowerInvariant(), name);

        var pediaTranslateId = slimePediaId.ToString().ToLowerInvariant();
        TranslationPatcher.AddPediaTranslation("t." + pediaTranslateId, name);
        TranslationPatcher.AddPediaTranslation("m.intro." + pediaTranslateId, intro);
        TranslationPatcher.AddPediaTranslation("m.diet." + pediaTranslateId, diet);
        TranslationPatcher.AddPediaTranslation("m.favorite." + pediaTranslateId, favorite);
        TranslationPatcher.AddPediaTranslation("m.slimeology." + pediaTranslateId, slimeology);
        TranslationPatcher.AddPediaTranslation("m.risks." + pediaTranslateId, risks);
        TranslationPatcher.AddPediaTranslation("m.plortonomics." + pediaTranslateId, plortonomics);
    }

    public static void CreatePediaForFood(PediaId pediaId, IdentifiableId id, string name, string intro, string type, string favored, string about, string ranch)
    {
        TranslationPatcher.AddActorTranslation("l." + id.ToString().ToLowerInvariant(), name);

        var pediaTranslateId = pediaId.ToString().ToLowerInvariant();
        TranslationPatcher.AddPediaTranslation("t." + pediaTranslateId, name);
        TranslationPatcher.AddPediaTranslation("m.intro." + pediaTranslateId, intro);
        TranslationPatcher.AddPediaTranslation("m.resource_type." + pediaTranslateId, type);
        TranslationPatcher.AddPediaTranslation("m.favored_by." + pediaTranslateId, favored);
        TranslationPatcher.AddPediaTranslation("m.desc." + pediaTranslateId, about);
        TranslationPatcher.AddPediaTranslation("m.how_to_use." + pediaTranslateId, ranch);
    }

    public static void CreateZoneSlimePedia(PediaId slimePediaId, Zone lNameId, string name, string presence, string fullName, string intro, string description)
    {
        PediaRegistry.RegisterIdEntry(slimePediaId, null);

        PediaUI.WORLD_ENTRIES = PediaUI.WORLD_ENTRIES.AddToArray(slimePediaId);

        var id = slimePediaId.ToString().ToLowerInvariant();
        Director.RICH_PRESENCE_ZONE_LOOKUP.Add(lNameId, name);
        TranslationPatcher.AddGlobalTranslation("l.presence." + lNameId.ToString().ToLowerInvariant(), presence);
        TranslationPatcher.AddPediaTranslation("t." + id, fullName);
        TranslationPatcher.AddPediaTranslation("m.intro." + id, intro);
        TranslationPatcher.AddPediaTranslation("m.desc." + id, description);
    }

    public static void PreloadSlimePediaConnection(PediaId pediaId, IdentifiableId pediaOfId, PediaCategory pediaCategory)
    {
        PediaRegistry.RegisterIdentifiableMapping(pediaId, pediaOfId);
        PediaRegistry.SetPediaCategory(pediaId, pediaCategory);
    }
}