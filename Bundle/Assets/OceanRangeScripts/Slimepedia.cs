using UnityEngine;
using System.IO;
using System;
using OceanRange.Unity.Json;

[CreateAssetMenu(menuName = "OceanRange/Holder/Slimepedia")]
public sealed class Slimepedia : ArrayHolder<SlimeData>
{
    public override string Name => "Slimepedia";
}