using System.Globalization;

namespace OceanRange.Modules;

public delegate bool TryParseDelegate<TValue, TComponent>(string value, NumberStyles style, CultureInfo culture, out TComponent component);

// public delegate bool TryParseHtml<TColor>(string valString, out TColor color);

public abstract class MultiComponentConverter<TValue, TComponent>(string format, NumberStyles style, TryParseDelegate<TValue, TComponent> tryParse, int maxLength, int minLength, TComponent defaultValue = default, char separator = ',')
    : JsonConverter<TValue>()
    where TValue : struct // The value being read/written
    where TComponent : struct // The type that make up the value's components
{
    protected static readonly CultureInfo InvariantCulture = CultureInfo.InvariantCulture;

    private readonly TryParseDelegate<TValue, TComponent> TryParse = tryParse;
    private readonly TComponent[] ToFill = new TComponent[maxLength];
    private readonly int MaxLength = maxLength;
    private readonly int MinLength = minLength;
    private readonly char Separator = separator;
    private readonly TComponent Default = defaultValue;
    private readonly NumberStyles Style = style;
    private readonly string Format = format;

    protected void BaseCheckJson(JsonReader reader, out string valString)
    {
        valString = reader.Value?.ToString() ?? "null";

        if (reader.TokenType != JsonToken.String)
            throw new InvalidDataException($"Cannot convert value '{valString}' to {typeof(TValue).Name}. Expected string format {Format}.");
    }

    protected abstract TValue FillFromArray(TComponent[] array);

    // protected virtual bool ParseOtherFormat(string valString, out TValue result)
    // {
    //     result = default;
    //     return false;
    // }

    public sealed override TValue ReadJson(JsonReader reader, Type _, TValue __, bool ___, JsonSerializer ____)
    {
        try
        {
            BaseCheckJson(reader, out var valString);

            // if (ParseOtherFormat(valString, out var result))
            //     return result;

            ParseComponents(valString, this);
            return FillFromArray(ToFill);
        }
        catch (Exception ex)
        {
            throw new JsonSerializationException("Encountered an error while deserialising:", ex);
        }
    }

    protected static void ParseComponents(string value, MultiComponentConverter<TValue, TComponent> converter)
    {
        var components = value.TrueSplit(converter.Separator);

        if (components.Length < converter.MinLength)
            throw new InvalidDataException($"'{value}' has too less values!");

        if (components.Length > converter.MaxLength)
            throw new InvalidDataException($"'{value}' has too many values!");

        for (var i = 0; i < components.Length; i++)
        {
            var component = components[i];

            if (converter.TryParse(component, converter.Style, InvariantCulture, out var valueComponent))
                converter.ToFill[i] = valueComponent;
            else
                throw new InvalidDataException($"Invalid {typeof(TComponent).Name} string '{component}'!");
        }

        for (var i = components.Length; i < converter.MaxLength; i++)
            converter.ToFill[i] = converter.Default;
    }
}

public sealed class Vector3Converter() : MultiComponentConverter<Vector3, float>("'x,y,z' or 'x,y'", NumberStyles.Float | NumberStyles.AllowThousands, float.TryParse, 3, 2)
{
    protected override Vector3 FillFromArray(float[] array) => new(array[0], array[1], array[2]);

    public override void WriteJson(JsonWriter writer, Vector3 value, JsonSerializer _) => writer.WriteValue(ToVectorString(value));

    public static string ToVectorString(Vector3 value) => $"{value.x.ToString(InvariantCulture)},{value.y.ToString(InvariantCulture)},{value.z.ToString(InvariantCulture)}";
}

public sealed class OrientationConverter() : MultiComponentConverter<Orientation, Vector3>("of a pair of 'x,y,z' or 'x,y' separated by a ;", NumberStyles.Float | NumberStyles.AllowThousands, Helpers.TryParseVector, 2, 2, default, ';')
{
    protected override Orientation FillFromArray(Vector3[] array) => new(array[0], array[1]);

    public override void WriteJson(JsonWriter writer, Orientation value, JsonSerializer _) =>
        writer.WriteValue($"{Vector3Converter.ToVectorString(value.Position)};{Vector3Converter.ToVectorString(value.Rotation)}");
}

// public abstract class BaseColorConverter<TColor, TComponent>(NumberStyles style, TryParseDelegate<TColor, TComponent> tryParse, TComponent defaultValue, TryParseHtml<TColor> htmlParser)
//     : MultiComponentConverter<TColor, TComponent>("'r,g,b', 'r,g,b,a' or #hex", style, tryParse, 4, 3, defaultValue)
//     where TColor : struct // Color or Color32 but I don't know how to limit to only those two types
//     where TComponent : struct // float or byte, same as above
// {
//     protected readonly TryParseHtml<TColor> TryParseHtmlColor = htmlParser;

//     protected sealed override bool ParseOtherFormat(string valString, out TColor result)
//     {
//         if (valString.StartsWith("#"))
//             return TryParseHtmlColor(valString, out result);

//         result = default;
//         return false;
//     }
// }

// public sealed class ColorConverter() : BaseColorConverter<Color, float>(NumberStyles.Float, float.TryParse, 1f, ColorUtility.TryParseHtmlString)
// {
//     protected override Color FillFromArray(float[] array) => new(array[0], array[1], array[2], array[3]);

//     public override void WriteJson(JsonWriter writer, Color value, JsonSerializer _) =>
//         writer.WriteValue($"{value.r.ToString(InvariantCulture)},{value.g.ToString(InvariantCulture)},{value.b.ToString(InvariantCulture)},{value.a.ToString(InvariantCulture)}");
// }

// public sealed class Color32Converter() : BaseColorConverter<Color32, byte>(NumberStyles.Integer, byte.TryParse, 255, ColorUtility.DoTryParseHtmlColor)
// {
//     protected override Color32 FillFromArray(byte[] array) => new(array[0], array[1], array[2], array[3]);

//     public override void WriteJson(JsonWriter writer, Color32 value, JsonSerializer _) => writer.WriteValue(value.ToHexRGBA());
// }

/// <summary>
/// A JsonConverter class that handles the serialisation of enum values.
/// </summary>
/// <remarks>Made because srml's enum patching is causing errors with patched enums being read by newtonsoft, will be removed if and when a fix is administered.</remarks>
public sealed class EnumConverter : JsonConverter
{
    public override void WriteJson(JsonWriter writer, object value, JsonSerializer _) => writer.WriteValue(value.ToString());

    public override object ReadJson(JsonReader reader, Type objectType, object _, JsonSerializer __)
    {
        var enumString = reader.Value?.ToString() ?? "null";
        return reader.TokenType switch
        {
            JsonToken.String when Helpers.TryParse(objectType, enumString, true, out var result) => result,
            JsonToken.Integer => Enum.ToObject(objectType, reader.Value),
            _ => throw new JsonSerializationException($"Cannot convert value '{enumString}' ({reader.TokenType}) to {objectType.Name}. Expected a defined string or an integer."),
        };
    }

    public override bool CanConvert(Type objectType) => objectType.IsEnum;
}