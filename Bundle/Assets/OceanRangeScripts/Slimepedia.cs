using UnityEngine;
using System.IO;
using System;

[CreateAssetMenu(menuName = "OceanRange/Holder/Slimepedia")]
public sealed class Slimepedia : JsonData
{
    public SlimeData[] Slimes;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}