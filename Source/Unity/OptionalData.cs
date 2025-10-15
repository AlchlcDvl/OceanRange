#if UNITY
using System;
using UnityEngine;

namespace OceanRange.Unity;

public abstract class OptionalData<T> where T : struct
{
    public bool HasValue;
    public T Value;
}

[Serializable]
public sealed class OptionalInt : OptionalData<int> { }

[Serializable]
public sealed class OptionalColor : OptionalData<Color> { }

[Serializable]
public sealed class OptionalFloat : OptionalData<float> { }

[Serializable]
public sealed class OptionalDouble : OptionalData<double> { }
#endif