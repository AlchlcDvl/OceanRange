using System.IO;
using UnityEngine;
using OceanRange.Unity.Json;

[CreateAssetMenu(menuName = "OceanRange/Holder/Contacts")]
public sealed class Contacts : ArrayHolder<RancherData>
{
    public override string Name => "Contacts";
}