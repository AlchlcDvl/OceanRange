using Newtonsoft.Json;
using System;
using OceanRange.Unity.Json;
using System.IO;

public abstract class SingleHolder<T> : Holder<T> where T : JsonData
{
    public sealed override void SerialiseTo(BinaryWriter writer) => Value.SerialiseTo(writer);
}