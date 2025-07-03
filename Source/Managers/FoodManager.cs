using Newtonsoft.Json;
using SimpleSRmodLibrary.Creation;

namespace TheOceanRange.Managers;

public static class FoodManager
{
    public static readonly Dictionary<IdentifiableId, CustomFoodData> FoodsMap = [];

    public static void PreLoadFoods()
    {
        PreLoadChimkens();
    }

    private static void PreLoadChimkens()
    {
        BasePreLoadChimkens(Ids.SANDY_CHICKEN, Ids.SANDY_CHICK, [Zone.REEF], 1f);
    }

    private static void BasePreLoadChimkens(IdentifiableId henId, IdentifiableId chickId, Zone[] spawnZones, float spawnWeight)
    {
        Identifiable.CHICK_CLASS.Add(chickId);
        Identifiable.NON_SLIMES_CLASS.Add(chickId);

        SRCallbacks.PreSaveGameLoad += _ =>
        {
            foreach (var directedAnimalSpawner2 in UObject.FindObjectsOfType<DirectedAnimalSpawner>().Where(spawner =>
            {
                var zoneId = spawner.GetComponentInParent<Region>(true).GetZoneId();
                return zoneId == Zone.NONE || spawnZones.Contains(zoneId);
            }))
            {
                foreach (var constraint in directedAnimalSpawner2.constraints)
                {
                    constraint.slimeset.members =
                    [
                        .. constraint.slimeset.members,
                        new()
                        {
                            prefab = GameInstance.Instance.LookupDirector.GetPrefab(henId),
                            weight = spawnWeight / 2
                        },
                        new()
                        {
                            prefab = GameInstance.Instance.LookupDirector.GetPrefab(chickId),
                            weight = spawnWeight / 2
                        }
                    ];
                }
            }
        };
    }

    public static void LoadFoods()
    {
        var json = JsonConvert.DeserializeObject<Dictionary<string, FoodPediaEntry>>(AssetManager.GetJson("Foodpedia"));
        CreateChimkens(json);
        CreatePlants(json);
    }

    private const string CommonHenRanchPedia = "%type% hens in close proximity to roostros will periodically lay eggs that produce %type% chickadoos. However, keeping too many hens or roostros in close proximity makes them anxious and egg production will come to a halt. Savvy ranchers with an understanding of the complex nature of chicken romance always keep their coops from exceeding 12 grown chickens.";
    private const string CommonChickAboutPedia = "%type% chickadoos are baby chickens that will eventually grow into a %type% hen or more rarely, a roostro.\n\nChickadoos of all varieties will never be eaten by slimes. Some believe this is because slimes are too kind-hearted to do such a thing. Others believe it's because chickadoos don't yet have enough meat on their bones.";
    private const string CommonChickRanchPedia = "Keep %type% Chickadoos in a safe place and they'll eventually grow into a %type% Hen or Roostro.";

    private static void CreateChimkens(Dictionary<string, FoodPediaEntry> json)
    {
        BaseCreateChimken("Sandy", Ids.SANDY_CHICKEN, Ids.SANDY_CHICKEN_ENTRY, json["SANDY_HEN"], Ids.SANDY_CHICK, Ids.SANDY_CHICK_ENTRY, "#C2B280", json["SANDY_CHICK"], [Ids.COCO_SLIME]);
    }

    private static void BaseCreateChimken
    (
        string name,
        IdentifiableId henId,
        PediaId henEntry,
        FoodPediaEntry henJson,
        IdentifiableId chickId,
        PediaId chickEntry,
        string ammoColor,
        FoodPediaEntry chickJson,
        IdentifiableId[] favouredBy
    )
    {
        var skin = AssetManager.GetTexture2D($"{name}SkinRamp");
        var dark = AssetManager.GetTexture2D($"{name}SkinRampDarker");
        var ammo = ammoColor.HexToColor();

        var chickPrefab = GameInstance.Instance.LookupDirector.GetPrefab(IdentifiableId.CHICK).CreatePrefab();
        chickPrefab.name = $"{name} Chick";
        var component = chickPrefab.transform.Find("Chickadoo/mesh_body1").gameObject.GetComponent<SkinnedMeshRenderer>();
        var material = UObject.Instantiate(component.sharedMaterial);
        material.SetTexture("_RampRed", dark);
        material.SetTexture("_RampGreen", skin);
        material.SetTexture("_RampBlue", skin);
        material.SetTexture("_RampBlack", skin);
        component.sharedMaterial = material;
        chickPrefab.GetComponent<Identifiable>().id = chickId;
        LookupRegistry.RegisterIdentifiablePrefab(chickPrefab);
        CropCreation.LoadCrop(chickId, chickPrefab, true, false, false);
        var chickIcon = AssetManager.GetSprite($"{name}Chick");
        VacItemCreation.NewVacItem(0, chickPrefab, chickId, $"{name} Chick", chickIcon, ammo);
        SlimePediaCreation.PreLoadSlimePediaConnection(chickEntry, chickId, PediaCategory.RESOURCES);
        SlimePediaCreation.CreateSlimePediaForItemWithName(chickEntry, chickId, chickJson.Title, chickJson.Intro, "Future Meat", "None", chickJson?.About ??
            CommonChickAboutPedia.Replace("%type%", name), chickJson.Ranch ?? CommonChickRanchPedia.Replace("%type%", name));
        SlimePediaCreation.LoadSlimePediaIcon(chickEntry, chickIcon);

        var henPrefab = GameInstance.Instance.LookupDirector.GetPrefab(IdentifiableId.HEN).CreatePrefab();
        henPrefab.name = $"{name} Chicken";
        var component2 = henPrefab.transform.Find("Hen Hen/mesh_body1").gameObject.GetComponent<SkinnedMeshRenderer>();
        var material2 = UObject.Instantiate(component2.sharedMaterial);
        material2.SetTexture("_RampRed", dark);
        material2.SetTexture("_RampGreen", skin);
        material2.SetTexture("_RampBlue", skin);
        material2.SetTexture("_RampBlack", skin);
        component2.sharedMaterial = material2;
        henPrefab.GetComponent<Identifiable>().id = henId;
        henPrefab.GetComponent<Reproduce>().childPrefab = chickPrefab;
        var transformChance = henPrefab.GetComponent<TransformChanceOnReproduce>();
        transformChance.targetPrefab = GameInstance.Instance.LookupDirector.GetPrefab(IdentifiableId.ELDER_HEN);
        transformChance.transformChance = 2.5f;
        LookupRegistry.RegisterIdentifiablePrefab(henPrefab);
        CropCreation.LoadCrop(henId, henPrefab, false, false, false, true);
        var henIcon = AssetManager.GetSprite($"{name}Hen");
        VacItemCreation.NewVacItem(0, henPrefab, henId, $"{name} Hen", henIcon, ammo);
        SlimePediaCreation.PreLoadSlimePediaConnection(henEntry, henId, PediaCategory.RESOURCES);
        SlimePediaCreation.CreateSlimePediaForItemWithName(henEntry, henId, henJson.Title, henJson.Intro, "Meat", henJson.FavouredBy, henJson.About, henJson.Ranch ??
            CommonHenRanchPedia.Replace("%type%", name));
        SlimePediaCreation.LoadSlimePediaIcon(henEntry, henIcon);

        chickPrefab.GetComponent<TransformAfterTime>().options =
        [
            new()
            {
                targetPrefab = henPrefab,
                weight = 4.5f
            },
            new()
            {
                targetPrefab = GameInstance.Instance.LookupDirector.GetPrefab(IdentifiableId.ROOSTER),
                weight = 3.5f
            }
        ];

        FoodsMap[henId] = new()
        {
            FavouredBy = favouredBy,
            Group = FoodGroup.MEAT
        };
    }

    private const string CommonPlantPedia = "Deposit a %type% into a garden's depositor and you'll have a large %type% %food% of your very own.";

    private static void CreatePlants(Dictionary<string, FoodPediaEntry> json)
    {

    }
}