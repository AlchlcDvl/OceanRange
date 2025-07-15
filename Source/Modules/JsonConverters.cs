using System.Globalization;

namespace TheOceanRange.Modules;

public sealed class Vector3Converter : JsonConverter<Vector3>
{
    private static readonly CultureInfo InvariantCulture = CultureInfo.InvariantCulture;

    public override Vector3 ReadJson(JsonReader reader, Type objectType, Vector3 existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        if (reader.TokenType == JsonToken.Null)
            return default;

        if (reader.TokenType != JsonToken.String)
            throw new JsonSerializationException($"Cannot convert value '{reader.Value}' to Vector3. Expected format 'x,y,z' or 'x,y'.");

        var components = reader.Value.ToString().TrueSplit(',');

        if (components.Length < 2)
            throw new JsonSerializationException($"'{reader.Value}' has too less values!");

        if (components.Length > 3)
            throw new JsonSerializationException($"'{reader.Value}' has too many values!");

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

    public override void WriteJson(JsonWriter writer, Vector3 value, JsonSerializer serializer) =>
        writer.WriteValue($"{value.x.ToString(InvariantCulture)},{value.y.ToString(InvariantCulture)},{value.z.ToString(InvariantCulture)}");
}

public abstract class EnumConverter<T> : JsonConverter<T> where T : struct, Enum
{
    public override void WriteJson(JsonWriter writer, T value, JsonSerializer serializer) => writer.WriteValue(value.ToString());

    public override T ReadJson(JsonReader reader, Type objectType, T existingValue, bool hasExistingValue, JsonSerializer serializer)
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