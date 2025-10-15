using Newtonsoft.Json;
using System;
using OceanRange.Unity.Json;
using System.IO;

public abstract class ArrayHolder<T> : Holder<T[]> where T : JsonData
{
    public sealed override void SerialiseTo(BinaryWriter writer) => writer.WriteArray(Value, Helpers.WriteJsonData);
}