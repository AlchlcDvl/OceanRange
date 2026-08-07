// #if !UNITY
// namespace OceanRange.Data;

// public enum RequirementType : byte
// {
//     CorporateLevel,
//     ExchangeProgress,
//     DevCommand,
// }

// public sealed partial class ZoneRequirementData
// {
//     public override void ReadFrom(DataReader reader)
//     {
//         base.ReadFrom(reader);
//         CorporateLevelMin = (int)reader.ReadPackedUInt();
//         CorporateLevelMax = (int)reader.ReadPackedUInt();
//         ExchangeProgress = (int)reader.ReadPackedUInt();
//         PathToGameObject = reader.ReadString()!;
//     }
// }

// public sealed partial class ZoneData
// {
//     [JsonRequired] public RegionId Region;
//     public Dictionary<RequirementType, ZoneRequirementData>? Requirements;

//     [JsonIgnore] public Zone Zone;
//     [JsonIgnore] public PediaId PediaId;
//     [JsonIgnore] public Ambiance Ambiance;
//     [JsonIgnore] public bool PrefabsPrepped;
//     [JsonIgnore] public GameObject Prefab;
//     [JsonIgnore] public AmbianceDirectorZoneSetting AmbianceSetting;

//     public override void ReadFrom(DataReader reader)
//     {
//         base.ReadFrom(reader);
//         Region = reader.ReadEnum<RegionId>();
//         TeleporterOrientation = reader.ReadOrientation();
//         TeleporterLocation = reader.ReadString()!;
//         AssetName = reader.ReadString()!;

//         Requirements = reader.ReadDictionary(
//             r => r.ReadEnum<RequirementType>(),
//             r => { var z = new ZoneRequirementData(); z.ReadFrom(r); return z; }
//         );
//     }

//     public override void OnDeserialise()
//     {
//         if (Requirements != null)
//         {
//             foreach (var req in Requirements.Values)
//                 req.OnDeserialise();
//         }

//         var upper = Name!.ToUpperInvariant();

//         Zone = Helpers.AddEnumValue<Zone>(upper);
//         PediaId = Helpers.AddEnumValue<PediaId>(upper + "_ENTRY");
//         Ambiance = Helpers.AddEnumValue<Ambiance>(upper + "_AMBIANCE");
//     }
// }

// public sealed partial class RegionData
// {
//     [JsonIgnore] public RegionId Region;

//     public override void ReadFrom(DataReader reader)
//     {
//         base.ReadFrom(reader);
//         MinNodeSize = reader.ReadPackedFloat();
//         LoosenessVal = reader.ReadPackedFloat();
//         InitialWorldSize = reader.ReadPackedFloat();
//         InitialWorldPos = reader.ReadVector3();
//         Region = Helpers.AddEnumValue<RegionId>(Name!.ToUpperInvariant());
//     }
// }

// public sealed partial class World
// {
//     public override void ReadFrom(DataReader reader)
//     {
//         base.ReadFrom(reader);
//         Regions = reader.ReadArray(r => { var d = new RegionData(); d.ReadFrom(r); return d; })!;
//         Zones = reader.ReadArray(r => { var d = new ZoneData(); d.ReadFrom(r); return d; })!;
//     }

//     public override void OnDeserialise()
//     {
//         base.OnDeserialise();
//         Array.ForEach(Regions, r => r.OnDeserialise());
//         Array.ForEach(Zones, z => z.OnDeserialise());
//     }
// }
// #endif
