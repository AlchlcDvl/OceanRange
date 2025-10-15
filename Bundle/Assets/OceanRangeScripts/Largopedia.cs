using System.IO;
using UnityEngine;
using OceanRange.Unity;
using OceanRange.Unity.Json;

[CreateAssetMenu(menuName = "OceanRange/Holder/Largopedia")]
public sealed class Largopedia : ArrayHolder<LargoData>
{
    public override string Name => "Largopedia";
}