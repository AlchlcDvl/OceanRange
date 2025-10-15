using UnityEngine;
using System.IO;
using System.Collections.Generic;
using OceanRange.Unity.Json;

[CreateAssetMenu(menuName = "OceanRange/Holder/Ingredients")]
public sealed class IngredientsUnity : SingleHolder<Ingredients>
{
    public override string Name => "Ingredients";
}