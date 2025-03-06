using System.Reflection;
using SRML;
using SRML.SR.Translation;

namespace TheOceanRange;

public class Main : ModEntryPoint
{
    public static AssetBundle AssetsBundle = AssetBundle.LoadFromStream(Assembly.GetExecutingAssembly().GetManifestResourceStream("TheOceanRange.Assets.bundle"));
    public static Main Instance { get; private set; }

    public override void PreLoad()
    {
        Instance = this;
        HarmonyInstance.PatchAll();
        PediaRegistry.RegisterIdentifiableMapping(PediaId.PLORTS, Ids.ROSA_PLORT);
        PediaRegistry.RegisterIdentifiableMapping(Ids.ROSA_SLIME_ENTRY, Ids.ROSA_SLIME);
        PediaRegistry.SetPediaCategory(Ids.ROSA_SLIME_ENTRY, PediaCategory.SLIMES);
        new SlimePediaEntryTranslation(Ids.ROSA_SLIME_ENTRY)
            .SetTitleTranslation("Rosa Slime")
            .SetIntroTranslation("The pink pearl of the sea. Believed to the cousin of the pink slime.")
            .SetDietTranslation("Everything")
            .SetFavoriteTranslation("No favorite food. The Rosa slime loves everything equally.")
            .SetSlimeologyTranslation("The Rosa Slime is the most common slime found in The Great Reef. They are often seen as cheerful, friendly, and mischievous, often pranking other slimes" +
                " and even humans. Rosa Slimes have a deep bond with one another and are very rarely seen alone, As long as they have a partner to play with, they will be happy forever, rarely" +
                " showing any sadness. And when they are sad it's often at the expense of others. Trying their best to cheer the slime or human back to their happy selves.")
            .SetRisksTranslation("There is not much to worry about the Rosa Slime. They are very easy to Ranch, only needing food and companionship. A lonely Rosa Slime is a sad Rosa Slime. " +
                "So it's recommended for ranchers to have more than one if they want a healthy production of Pearls.")
            .SetPlortonomicsTranslation("Rosa Pearls are often called \"The Aphrodite Pearl\" for their rejuvenating properties on human skin. Beauty companies frequently market their products "
                + "as the key to a youthful glow, claiming that Rosa Pearls help rewind aging skin by 20-50 years. This wouldn't be a problem if their Feather Gills were also believed to have " +
                "abilities to cure internal organs, even rare cancers when consumed. While their Feather Gills can slowly regenerate constant tearing causes smaller gills to grow. However, " +
                "new research shows that these healing properties are temporary. The resulting constant consumption and usage of the Pearl cause rapid aging, making Rosa Pearls an unreliable " +
                "anti-aging solution.");
    }

    public override void Load() => Slimes.Slimes.CreateRosaSlime();
}