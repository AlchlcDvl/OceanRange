namespace OceanRange.Managers;

public static class Atlas
{
    private static ZoneData[] Zones;

#if DEBUG
    [TimeDiagnostic("Atlas Preload")]
#endif
    public static void PreloadMapData()
    {
        Zones = Inventory.GetJsonArray<ZoneData>("map");

        SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
    }

#if DEBUG
    [TimeDiagnostic("Contacts OnSavePreload")]
#endif
    private static void PreOnSaveLoad(SceneContext _)
    {
        foreach (var zone in Zones)
        {
            var zoneObj = GameObject.Find("zone" + zone.Zone);

            foreach (var cell in zone.Cells)
            {
                var cellObj = zoneObj.FindChild("cell" + cell.Name);

                var slimes = cellObj.FindChild("Sector/Slimes").transform;
                var slimeSpawnerPrefab = slimes.GetComponentInChildren<DirectedSlimeSpawner>();

                foreach (var slimeSpawner in cell.Slimes)
                {
                    var spawner = slimeSpawnerPrefab.Instantiate(slimes);
                    spawner.transform.localPosition = slimeSpawner.Orientation.Position;
                    spawner.transform.localEulerAngles = slimeSpawner.Orientation.Rotation;

                    var members = slimeSpawner.CommonMembers.Select(x => new SlimeSet.Member()
                    {
                        prefab = x.Id.GetPrefab(),
                        weight = x.Weight
                    });
                    var constraints = new List<DirectedActorSpawner.SpawnConstraint>();

                    foreach (var constraint in slimeSpawner.Constraints)
                    {
                        constraints.Add(new()
                        {
                            window = new()
                            {
                                timeMode = constraint.Window,
                                startHour = constraint.Start,
                                endHour = constraint.End,
                            },
                            feral = constraint.Feral,
                            slimeset = new()
                            {
                                members = [.. members, ..constraint.Members.Select(x => new SlimeSet.Member()
                                {
                                    prefab = x.Id.GetPrefab(),
                                    weight = x.Weight
                                })],
                            }
                        });
                    }

                    spawner.constraints = [.. constraints];
                }
            }
        }
    }
}