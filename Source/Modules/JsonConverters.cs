using System.Diagnostics.CodeAnalysis;
using System.Globalization;

namespace OceanRange.Modules;

public delegate bool TryParseDelegate<TValue, TComponent>(string value, NumberStyles style, CultureInfo culture, out TComponent component)
    where TValue : struct
    where TComponent : struct;

public delegate bool TryParseHtml<TColor>(string valString, out TColor color)
    where TColor : struct;

public abstract class OceanJsonConverter : JsonConverter
{
    public sealed override object ReadJson(JsonReader reader, Type objectType, [AllowNull] object _1, JsonSerializer _2)
    {
        if (reader.TokenType == JsonToken.Null)
            return default;

        try
        {
            return ParseFromJson(reader, objectType);
        }
        catch (Exception ex)
        {
            throw new JsonSerializationException("Encountered an error while deserialising:", ex);
        }
    }

    public sealed override void WriteJson(JsonWriter writer, [AllowNull] object value, JsonSerializer _)
    {
        if (value == null)
            writer.WriteNull();
        else
            writer.WriteValue(ToValueString(value));
    }

    protected abstract object ParseFromJson(JsonReader reader, Type objectType);

    protected virtual string ToValueString(object value) => value.ToString();
}

public abstract class OceanJsonConverter<T> : OceanJsonConverter
{
    public sealed override bool CanConvert(Type objectType) => typeof(T).IsAssignableFrom(objectType) || objectType.IsNullableOf<T>();

    protected sealed override string ToValueString(object value)
    {
        if (value is T tValue)
            return ToValueString(tValue);

        throw new JsonSerializationException("Received unknown value: " + value);
    }

    protected abstract string ToValueString(T value);
}

public abstract class MultiComponentConverter<TValue, TComponent>(string format, NumberStyles style, TryParseDelegate<TValue, TComponent> tryParse, int maxLength, int minLength, TComponent defaultValue = default, char separator = ',')
    : OceanJsonConverter<TValue>()
    where TValue : struct // The value being read/written
    where TComponent : struct // The type that make up the value's components
{
    private readonly TryParseDelegate<TValue, TComponent> TryParse = tryParse;
    private readonly int MaxLength = maxLength;
    private readonly int MinLength = minLength;
    private readonly char Separator = separator;
    private readonly TComponent Default = defaultValue;
    private readonly NumberStyles Style = style;
    private readonly string Format = format;

    private void BaseCheckJson(JsonReader reader, out string valString)
    {
        valString = reader.Value?.ToString() ?? "null";

        if (reader.TokenType != JsonToken.String)
            throw new InvalidDataException($"Cannot convert value '{valString}' to {typeof(TValue).Name}. Expected string format {Format}.");
    }

    protected abstract TValue FillFromArray(TComponent[] array);

    public TValue Parse(string valString) => ParseOtherFormat(valString, out var result) ? result : FillFromArray(ParseComponents(valString, this));

    protected virtual bool ParseOtherFormat(string valString, out TValue result)
    {
        result = default;
        return false;
    }

    protected override object ParseFromJson(JsonReader reader, Type objectType)
    {
        BaseCheckJson(reader, out var valString);
        return Parse(valString);
    }

    protected static TComponent[] ParseComponents(string value, MultiComponentConverter<TValue, TComponent> converter)
    {
        var components = value.TrueSplit(converter.Separator);

        if (components.Length < converter.MinLength)
            throw new InvalidDataException($"'{value}' has too less values!");

        if (components.Length > converter.MaxLength)
            throw new InvalidDataException($"'{value}' has too many values!");

        var array = new TComponent[converter.MaxLength];

        for (var i = 0; i < components.Length; i++)
        {
            var component = components[i];

            if (converter.TryParse(component, converter.Style, CultureInfo.InvariantCulture, out var valueComponent))
                array[i] = valueComponent;
            else
                throw new InvalidDataException($"Invalid {typeof(TComponent).Name} string '{component}'!");
        }

        for (var i = components.Length; i < converter.MaxLength; i++)
            array[i] = converter.Default;

        return array;
    }
}

public sealed class Vector3Converter : MultiComponentConverter<Vector3, float>
{
    public static Vector3Converter Instance;

    public Vector3Converter() : base("'x,y,z' or 'x,y'", NumberStyles.Float | NumberStyles.AllowThousands, float.TryParse, 3, 2) => Instance = this;

    protected override Vector3 FillFromArray(float[] array) => new(array[0], array[1], array[2]);

    protected override string ToValueString(Vector3 value) => value.ToVectorString();
}

public sealed class OrientationConverter() : MultiComponentConverter<Orientation, Vector3>("of a pair of 'x,y,z' or 'x,y' separated by a ;", NumberStyles.Float | NumberStyles.AllowThousands,
    Helpers.TryParseVector, 2, 2, default, ';')
{
    protected override Orientation FillFromArray(Vector3[] array) => new(array[0], array[1]);

    protected override string ToValueString(Orientation value)  => $"{value.Position.ToVectorString()};{value.Rotation.ToVectorString()}";
}

public abstract class BaseColorConverter<TColor, TComponent>(NumberStyles style, TryParseDelegate<TColor, TComponent> tryParse, TComponent defaultValue, TryParseHtml<TColor> htmlParser)
    : MultiComponentConverter<TColor, TComponent>("'r,g,b', 'r,g,b,a' or #hex", style, tryParse, 4, 3, defaultValue)
    where TColor : struct // Color or Color32 but I don't know how to limit to only those two types
    where TComponent : struct // float or byte, same as above
{
    protected readonly TryParseHtml<TColor> TryParseHtmlColor = htmlParser;

    protected sealed override bool ParseOtherFormat(string valString, out TColor result)
    {
        if (valString.StartsWith("#"))
            return TryParseHtmlColor(valString, out result);

        result = default;
        return false;
    }
}

public sealed class ColorConverter() : BaseColorConverter<Color, float>(NumberStyles.Float, float.TryParse, 1f, ColorUtility.TryParseHtmlString)
{
    protected override Color FillFromArray(float[] array) => new(array[0], array[1], array[2], array[3]);

    protected override string ToValueString(Color value) => value.ToColorString();
}

// public sealed class Color32Converter() : BaseColorConverter<Color32, byte>(NumberStyles.Integer, byte.TryParse, 255, ColorUtility.DoTryParseHtmlColor)
// {
//     protected override Color32 FillFromArray(byte[] array) => new(array[0], array[1], array[2], array[3]);

//     protected override string ToValueString(Color32 value) => value.ToHexRGBA();
// }

/// <summary>
/// A JsonConverter class that handles the serialisation of enum values.
/// </summary>
/// <remarks>Made because srml's enum patching is causing errors with patched enums being read by newtonsoft, will be removed if and when a fix is administered.</remarks>
public sealed class EnumConverter : OceanJsonConverter
{
    public override bool CanConvert(Type objectType) => objectType.IsEnum;

    protected override object ParseFromJson(JsonReader reader, Type objectType)
    {
        var enumString = reader.Value?.ToString() ?? "null";
        return reader.TokenType switch
        {
            JsonToken.String when Helpers.TryParse(objectType, enumString, true, out var result) => result,
            JsonToken.Integer => Enum.ToObject(objectType, reader.Value),
            _ => throw new JsonSerializationException($"Cannot convert value '{enumString}' ({reader.TokenType}) to {objectType.Name}. Expected a defined string or an integer."),
        };
    }

    protected override string ToValueString(object value) => value.ToString();
}