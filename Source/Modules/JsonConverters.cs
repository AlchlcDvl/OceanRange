using System.Globalization;

namespace OceanRange.Modules;

public abstract class MultiComponentConverter<TValue, TComponent> : JsonConverter<TValue>
    where TValue : struct // The value being read/written
    where TComponent : struct // The type that make up the value's components
{
    protected static readonly CultureInfo InvariantCulture = CultureInfo.InvariantCulture;

    protected delegate bool TryParseDelegate(string value, NumberStyles style, CultureInfo culture, out TComponent component);

    protected abstract string Format { get; }

    protected void BaseCheckJson(JsonReader reader, out string valString)
    {
        valString = reader.Value?.ToString() ?? "null";

        if (reader.TokenType != JsonToken.String)
            throw new InvalidDataException($"Cannot convert value '{valString}' to {typeof(TValue).Name}. Expected string format {Format}.");
    }

    protected abstract TValue ReadJson(string valString);

    public sealed override TValue ReadJson(JsonReader reader, Type _, TValue __, bool ___, JsonSerializer ____)
    {
        try
        {
            BaseCheckJson(reader, out var valString);
            return ReadJson(valString);
        }
        catch (Exception ex)
        {
            throw new JsonSerializationException("Encountered an error while deserialising:", ex);
        }
    }

    protected static void ParseComponents(string value, ParseOptions options)
    {
        var components = value.TrueSplit(options.Separator);

        if (components.Length < options.MinLength)
            throw new InvalidDataException($"'{value}' has too less values!");

        if (components.Length > options.MaxLength)
            throw new InvalidDataException($"'{value}' has too many values!");

        for (var i = 0; i < components.Length; i++)
        {
            var component = components[i];

            if (options.TryParse(component, options.Style, InvariantCulture, out var valueComponent))
                options.ToFill[i] = valueComponent;
            else
                throw new InvalidDataException($"Invalid {typeof(TComponent).Name} string '{component}'!");
        }

        for (var i = components.Length; i < options.MaxLength; i++)
            options.ToFill[i] = options.Default;
    }

    protected sealed class ParseOptions(NumberStyles style, TryParseDelegate tryParse, TComponent defaultValue, int maxLength, int minLength, char separator)
    {
        public readonly TryParseDelegate TryParse = tryParse;
        public readonly TComponent[] ToFill = new TComponent[maxLength];
        public readonly int MaxLength = maxLength;
        public readonly int MinLength = minLength;
        public readonly char Separator = separator;
        public readonly TComponent Default = defaultValue;
        public readonly NumberStyles Style = style;
    }
}

public sealed class Vector3Converter : MultiComponentConverter<Vector3, float>
{
    protected override string Format => "'x,y,z' or 'x,y'";

    private static readonly ParseOptions Options = new(NumberStyles.Float | NumberStyles.AllowThousands, float.TryParse, 0f, 3, 2, ',');

    protected override Vector3 ReadJson(string valString)
    {
        ParseComponents(valString, Options);
        return new(Options.ToFill[0], Options.ToFill[1], Options.ToFill[2]);
    }

    public override void WriteJson(JsonWriter writer, Vector3 value, JsonSerializer _) => writer.WriteValue(ToVectorString(value));

    public static string ToVectorString(Vector3 value) => $"{value.x.ToString(InvariantCulture)},{value.y.ToString(InvariantCulture)},{value.z.ToString(InvariantCulture)}";
}

public sealed class OrientationConverter : MultiComponentConverter<Orientation, Vector3>
{
    protected override string Format => "of a pair of 'x,y,z' or 'x,y' separated by a ;";

    private static readonly ParseOptions Options = new(NumberStyles.Float | NumberStyles.AllowThousands, Helpers.TryParseVector, default, 2, 2, ';');

    protected override Orientation ReadJson(string valString)
    {
        ParseComponents(valString, Options);
        return new(Options.ToFill[0], Options.ToFill[1]);
    }

    public override void WriteJson(JsonWriter writer, Orientation value, JsonSerializer _) =>
        writer.WriteValue($"{Vector3Converter.ToVectorString(value.Position)};{Vector3Converter.ToVectorString(value.Rotation)}");
}

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

// public sealed class ColorConverter : MultiComponentConverter<Color, float>
// {
//     protected override string Format => "'r,g,b', 'r,g,b,a' or hex code";

//    private static readonly ParseOptions Options = new(NumberStyles.Float, float.TryParse, 1f, 4, 3, ',');

//     protected override Color ReadJson(string valString)
//     {
//         if (valString.StartsWith("#"))
//         {
//             if (ColorUtility.TryParseHtmlString(valString, out var color))
//                 return color;

//             throw new JsonSerializationException($"'{valString}' was not correctly formatted as a hex code!");
//         }

//         ParseComponents(valString, Options);
//         return new(Options.ToFill[0], Options.ToFill[1], Options.ToFill[2], Options.ToFill[3]);
//     }

//     public override void WriteJson(JsonWriter writer, Color value, JsonSerializer _) =>
//         writer.WriteValue($"{value.r.ToString(InvariantCulture)},{value.g.ToString(InvariantCulture)},{value.b.ToString(InvariantCulture)},{value.a.ToString(InvariantCulture)}");
// }

// public sealed class Color32Converter : MultiComponentConverter<Color32, byte>
// {
//     protected override string Format => "'r,g,b', 'r,g,b,a' or hex code";

//    private static readonly ParseOptions Options = new(NumberStyles.Integer, byte.TryParse, 255, 4, 3, ',');

//     protected override Color32 ReadJson(string valString)
//     {
//         if (valString.StartsWith("#"))
//         {
//             if (ColorUtility.DoTryParseHtmlColor(valString, out var color))
//                 return color;

//             throw new JsonSerializationException($"'{valString}' was not correctly formatted as a hex code!");
//         }

//         ParseComponents(valString, Options);
//         return new(Options.ToFill[0], Options.ToFill[1], Options.ToFill[2], Options.ToFill[3]);
//     }

//     public override void WriteJson(JsonWriter writer, Color32 value, JsonSerializer _) => writer.WriteValue(value.ToHexRGBA());
// }