using MonomiPark.SlimeRancher.Regions;

namespace TheOceanRange.Slimes;

public static class Spawners
{
    public static void CreateSpawner(CustomSlimeData data)
    {
        SRCallbacks.PreSaveGameLoad += _ =>
        {
            foreach (var item in UObject.FindObjectsOfType<DirectedSlimeSpawner>().Where(x => data.Zones.Contains(x.GetComponentInParent<Region>(true).GetZoneId())))
            {
                foreach (var val in item.constraints)
                {
                    val.slimeset.members = [.. val.slimeset.members.AddItem(new()
                    {
                        prefab = GameInstance.Instance.LookupDirector.GetPrefab(data.Id),
                        weight = data.Weight
                    })];
                }
            }
        };
    }
}