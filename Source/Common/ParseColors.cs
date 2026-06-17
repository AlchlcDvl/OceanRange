#if !UNITY
namespace OceanRange.Data;

// Unity's try parse methods for HTML strings, much faster and simpler using a delegate pointing to native code than doing it myself
public delegate bool TryParseHtml<T>(string valString, out T color) where T : struct;
#endif