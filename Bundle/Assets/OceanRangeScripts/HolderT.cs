using Newtonsoft.Json;
using System;
using OceanRange.Unity.Json;

public abstract class Holder<T> : Holder
{
    public sealed override Type DataType => typeof(T);
    public sealed override object BoxedValue => Value;

    public T Value;

    public sealed override void ReadJson(object values) => Value = (T)values;
}