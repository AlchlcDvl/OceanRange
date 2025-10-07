using UnityEngine;
using System.IO;
using System.Collections.Generic;
using OceanRange.Unity.Json;

[CreateAssetMenu(menuName = "OceanRange/Holder/World")]
public sealed class WorldUnity : SingleHolder<World>
{
    public override string Name => "World";
}