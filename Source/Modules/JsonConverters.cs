using System.Globalization;

namespace OceanRange.Modules;

public abstract class MultiComponentConverter<TValue, TComponent> : JsonConverter<TValue>
    where TValue : struct // The value being read/written
    where TComponent : struct // The type that make up the value's components
{
    protected static readonly CultureInfo InvariantCulture = CultureInfo.InvariantCulture;

    protected delegate bool TryParseDelegate(string value, NumberStyles style, CultureInfo culture, out TComponent component);

    protected abstract string Format { get; }
    protected abstract TryParseDelegate TryParse { get; }
    protected abstract int MinLength { get; }
    protected abstract int MaxLength { get; }
    protected abstract NumberStyles Style { get; }

    protected virtual char Separator => ',';
    protected virtual TComponent Default => default;

    private readonly ParseOptions Options;

    protected MultiComponentConverter() => Options = new(Style, TryParse, Default, MaxLength, MinLength, Separator);

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

            ParseComponents(valString, Options);
            return FillFromArray(Options.ToFill);
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
    protected override int MinLength => 2;
    protected override int MaxLength => 3;
    protected override string Format => "'x,y,z' or 'x,y'";
    protected override TryParseDelegate TryParse { get; } = float.TryParse;
    protected override NumberStyles Style => NumberStyles.Float | NumberStyles.AllowThousands;

    protected override Vector3 FillFromArray(float[] array) => new(array[0], array[1], array[2]);

    public override void WriteJson(JsonWriter writer, Vector3 value, JsonSerializer _) => writer.WriteValue(ToVectorString(value));

    public static string ToVectorString(Vector3 value) => $"{value.x.ToString(InvariantCulture)},{value.y.ToString(InvariantCulture)},{value.z.ToString(InvariantCulture)}";
}

public sealed class OrientationConverter : MultiComponentConverter<Orientation, Vector3>
{
    protected override int MinLength => 2;
    protected override int MaxLength => 2;
    protected override char Separator => ';';
    protected override TryParseDelegate TryParse { get; } = Helpers.TryParseVector;
    protected override string Format => "of a pair of 'x,y,z' or 'x,y' separated by a ;";
    protected override NumberStyles Style => NumberStyles.Float | NumberStyles.AllowThousands;

    protected override Orientation FillFromArray(Vector3[] array) => new(array[0], array[1]);

    public override void WriteJson(JsonWriter writer, Orientation value, JsonSerializer _) =>
        writer.WriteValue($"{Vector3Converter.ToVectorString(value.Position)};{Vector3Converter.ToVectorString(value.Rotation)}");
}

// public abstract class BaseColorConverter<TColor, TComponent> : MultiComponentConverter<TColor, TComponent>
//     where TColor : struct // Color or Color32 but I don't know how to limit to only those two types
//     where TComponent : struct // float or byte, same as above
// {
//     protected delegate bool TryParseHtml(string valString, out TColor color);

//     protected sealed override int MinLength => 3;
//     protected sealed override int MaxLength => 4;
//     protected sealed override string Format => "'r,g,b', 'r,g,b,a' or hex code";

//     protected abstract TryParseHtml TryParseHtmlColor { get; }

//     protected sealed override bool ParseOtherFormat(string valString, out TColor result)
//     {
//         if (valString.StartsWith("#"))
//             return TryParseHtmlColor(valString, out result);

//         result = default;
//         return false;
//     }
// }

// public sealed class ColorConverter : BaseColorConverter<Color, float>
// {
//     protected override float Default => 1f;
//     protected override NumberStyles Style => NumberStyles.Float;
//     protected override TryParseDelegate TryParse { get; } = float.TryParse;
//     protected override TryParseHtml TryParseHtmlColor { get; } = ColorUtility.TryParseHtmlString;

//     protected override Color FillFromArray(float[] array) => new(array[0], array[1], array[2], array[3]);

//     public override void WriteJson(JsonWriter writer, Color value, JsonSerializer _) =>
//         writer.WriteValue($"{value.r.ToString(InvariantCulture)},{value.g.ToString(InvariantCulture)},{value.b.ToString(InvariantCulture)},{value.a.ToString(InvariantCulture)}");
// }

// public sealed class Color32Converter : BaseColorConverter<Color32, byte>
// {
//     protected override byte Default => 255;
//     protected override NumberStyles Style => NumberStyles.Integer;
//     protected override TryParseDelegate TryParse { get; } = byte.TryParse;
//     protected override TryParseHtml TryParseHtmlColor { get; } = ColorUtility.DoTryParseHtmlColor;

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