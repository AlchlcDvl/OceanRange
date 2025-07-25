using System.Globalization;

namespace OceanRange.Modules;

public abstract class OceanRangeJsonConverter<T> : JsonConverter<T>
{
    protected static readonly CultureInfo InvariantCulture = CultureInfo.InvariantCulture;
}

public sealed class Vector3Converter : OceanRangeJsonConverter<Vector3>
{
    public override Vector3 ReadJson(JsonReader reader, Type _, Vector3 __, bool ___, JsonSerializer ____)
    {
        if (reader.TokenType == JsonToken.Null)
            return default;

        var valString = reader.Value?.ToString() ?? "null";

        if (reader.TokenType != JsonToken.String)
            throw new JsonSerializationException($"Cannot convert value '{valString}' to Vector3. Expected string format 'x,y,z' or 'x,y'.");

        var components = valString.TrueSplit(',', ' ');

        switch (components.Length)
        {
            case < 2:
                throw new JsonSerializationException($"'{valString}' has too less values!");
            case > 3:
                throw new JsonSerializationException($"'{valString}' has too many values!");
        }

        if (!float.TryParse(components[0], NumberStyles.Float, InvariantCulture, out var x))
            throw new JsonSerializationException($"Invalid float string '{components[0]}'!");

        if (!float.TryParse(components[1], NumberStyles.Float, InvariantCulture, out var y))
            throw new JsonSerializationException($"Invalid float string '{components[1]}'!");

        float z;

        if (components.Length == 2)
            z = 0f;
        else if (!float.TryParse(components[2], NumberStyles.Float, InvariantCulture, out z))
            throw new JsonSerializationException($"Invalid float string '{components[2]}'!");

        return new(x, y, z);
    }

    public override void WriteJson(JsonWriter writer, Vector3 value, JsonSerializer _) =>
        writer.WriteValue($"{value.x.ToString(InvariantCulture)},{value.y.ToString(InvariantCulture)},{value.z.ToString(InvariantCulture)}");
}

// Made because srml's enum patching is causing errors with patched enums being read by newtonsoft, will be removed if and when a fix is administered
public abstract class EnumConverter<T> : OceanRangeJsonConverter<T> where T : struct, Enum
{
    public override void WriteJson(JsonWriter writer, T value, JsonSerializer _) => writer.WriteValue(value.ToString());

    public override T ReadJson(JsonReader reader, Type _, T __, bool ___, JsonSerializer ____)
    {
        var enumString = reader.Value?.ToString() ?? "null";
        return reader.TokenType switch
        {
            JsonToken.String when Enum.TryParse<T>(enumString, true, out var result) => result,
            JsonToken.Integer => Helpers.ToEnum<T>(reader.Value),
            JsonToken.Null => default,
            _ => throw new JsonSerializationException($"Cannot convert value '{enumString}' ({reader.TokenType}) to {typeof(T).Name}. Expected a defined string, an integer or null."),
        };
    }
}

public sealed class ZoneConverter : EnumConverter<Zone>;

public sealed class PediaIdConverter : EnumConverter<PediaId>;

public sealed class FoodGroupConverter : EnumConverter<FoodGroup>;

public sealed class ProgressTypeConverter : EnumConverter<ProgressType>;

public sealed class IdentifiableIdConverter : EnumConverter<IdentifiableId>;

// public sealed class ColorConverter : OceanRangeJsonConverter<Color>
// {
//     public override Color ReadJson(JsonReader reader, Type _, Color __, bool ___, JsonSerializer ____)
//     {
//         if (reader.TokenType == JsonToken.Null)
//             return default;
//
//         var valString = reader.Value?.ToString() ?? "null";
//
//         if (reader.TokenType != JsonToken.String)
//             throw new JsonSerializationException($"Cannot convert value '{valString}' to Color. Expected string format 'r,g,b', 'r,g,b,a' or hex code.");
//
//         if (valString.Contains("#"))
//         {
//             if (ColorUtility.TryParseHtmlString(valString, out var color))
//                 return color;
//
//             throw new JsonSerializationException($"'{valString}' was not correctly formatted as a hex code!");
//         }
//
//         var components = valString.TrueSplit(',', ' ');
//
//         switch (components.Length)
//         {
//             case < 3:
//                 throw new JsonSerializationException($"'{valString}' has too less values!");
//             case > 4:
//                 throw new JsonSerializationException($"'{valString}' has too many values!");
//         }
//
//         if (!float.TryParse(components[0], NumberStyles.Float, InvariantCulture, out var r))
//             throw new JsonSerializationException($"Invalid float string '{components[0]}'!");
//
//         if (!float.TryParse(components[1], NumberStyles.Float, InvariantCulture, out var g))
//             throw new JsonSerializationException($"Invalid float string '{components[1]}'!");
//
//         if (!float.TryParse(components[2], NumberStyles.Float, InvariantCulture, out var b))
//             throw new JsonSerializationException($"Invalid float string '{components[2]}'!");
//
//         float a;
//
//         if (components.Length == 3)
//             a = 1f;
//         else if (!float.TryParse(components[3], NumberStyles.Float, InvariantCulture, out a))
//             throw new JsonSerializationException($"Invalid float string '{components[3]}'!");
//
//         return new(r, g, b, a);
//     }
//
//     public override void WriteJson(JsonWriter writer, Color value, JsonSerializer _) =>
//         writer.WriteValue($"{value.r.ToString(InvariantCulture)},{value.g.ToString(InvariantCulture)},{value.b.ToString(InvariantCulture)},{value.a.ToString(InvariantCulture)}");
// }
//
// public sealed class Color32Converter : OceanRangeJsonConverter<Color32>
// {
//     public override Color32 ReadJson(JsonReader reader, Type _, Color32 __, bool ___, JsonSerializer ____)
//     {
//         if (reader.TokenType == JsonToken.Null)
//             return default;
//
//         var valString = reader.Value?.ToString() ?? "null";
//
//         if (reader.TokenType != JsonToken.String)
//             throw new JsonSerializationException($"Cannot convert value '{valString}' to Color. Expected string format 'r,g,b', 'r,g,b,a' or hex code.");
//
//         if (valString.Contains("#"))
//         {
//             if (ColorUtility.DoTryParseHtmlColor(valString, out var color))
//                 return color;
//
//             throw new JsonSerializationException($"'{valString}' was not correctly formatted as a hex code!");
//         }
//
//         var components = valString.TrueSplit(',', ' ');
//
//         switch (components.Length)
//         {
//             case < 3:
//                 throw new JsonSerializationException($"'{valString}' has too less values!");
//             case > 4:
//                 throw new JsonSerializationException($"'{valString}' has too many values!");
//         }
//
//         if (!byte.TryParse(components[0], NumberStyles.Integer, InvariantCulture, out var r))
//             throw new JsonSerializationException($"Invalid byte string '{components[0]}'!");
//
//         if (!byte.TryParse(components[1], NumberStyles.Integer, InvariantCulture, out var g))
//             throw new JsonSerializationException($"Invalid byte string '{components[1]}'!");
//
//         if (!byte.TryParse(components[2], NumberStyles.Integer, InvariantCulture, out var b))
//             throw new JsonSerializationException($"Invalid byte string '{components[2]}'!");
//
//         byte a;
//
//         if (components.Length == 3)
//             a = 255;
//         else if (!byte.TryParse(components[3], NumberStyles.Integer, InvariantCulture, out a))
//             throw new JsonSerializationException($"Invalid byte string '{components[3]}'!");
//
//         return new(r, g, b, a);
//     }
//
//     public override void WriteJson(JsonWriter writer, Color32 value, JsonSerializer _) => writer.WriteValue(value.ToHexRGBA());
// }