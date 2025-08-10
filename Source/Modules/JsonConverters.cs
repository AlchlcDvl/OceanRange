using System.Diagnostics.CodeAnalysis;
using System.Globalization;

namespace OceanRange.Modules;

// Parsing validation delegate for byte, float etc
public delegate bool TryParseDelegate<TValue, TComponent>(string value, NumberStyles style, CultureInfo culture, out TComponent component)
    where TValue : struct
    where TComponent : struct;

// Unity's try parse methods for html strings, much faster and simpler using a delegate pointing to native code than doing it myself
public delegate bool TryParseHtml<TColor>(string valString, out TColor color)
    where TColor : struct;

/// <summary>
/// Main base class for all json converters for all json serialised values. Provides wrappers for the read and write methods because the additional params are never used.
/// </summary>
public abstract class OceanJsonConverter : JsonConverter
{
    /// <inheritdoc/>
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

    /// <inheritdoc/>
    public sealed override void WriteJson(JsonWriter writer, [AllowNull] object value, JsonSerializer _)
    {
        if (value == null)
            writer.WriteNull();
        else
            writer.WriteValue(ToValueString(value));
    }

    /// <summary>
    /// A converter's implementation of reading from json.
    /// </summary>
    /// <param name="reader">The json reader.</param>
    /// <param name="objectType">The type of the object (used for non generics).</param>
    /// <returns>The deserialised value.</returns>
    protected abstract object ParseFromJson(JsonReader reader, Type objectType);

    /// <summary>
    /// Converts the value to a string representation to be entered into the json.
    /// </summary>
    /// <param name="value">The value to convert.</param>
    /// <returns>A string representation of the passed value.</returns>
    protected virtual string ToValueString(object value) => value.ToString();
}

/// <summary>
/// Generic base class for type safety and a simplified CanConvert check.
/// </summary>
/// <typeparam name="T">The type of the value being handled.</typeparam>
public abstract class OceanJsonConverter<T> : OceanJsonConverter
{
    /// <inheritdoc/>
    public sealed override bool CanConvert(Type objectType) => typeof(T).IsAssignableFrom(objectType) || objectType.IsNullableOf<T>();

    /// <inheritdoc/>
    protected sealed override string ToValueString(object value)
    {
        if (value is T tValue)
            return ToValueString(tValue);

        throw new JsonSerializationException("Received unknown value: " + value);
    }

    /// <inheritdoc/>
    protected sealed override object ParseFromJson(JsonReader reader, Type _) => ParseFromJson(reader);

    /// <summary>
    /// Wrapper method without the type parameter.
    /// </summary>
    /// <inheritdoc cref="ParseFromJson(JsonReader, Type)"/>
    protected abstract object ParseFromJson(JsonReader reader);

    /// <summary>
    /// Type safe wrapper.
    /// </summary>
    /// <inheritdoc cref="ToValueString(object)"/>
    protected abstract string ToValueString(T value);
}

/// <summary>
/// Powerful converter class that handles values that have components (eg, Vector3 has 3 float components, Orientation has 2 Vector3 components)
/// </summary>
/// <typeparam name="TValue">The type of the value being handled.</typeparam>
/// <typeparam name="TComponent">The type of the values that make up <typeparamref name="TValue"/>.</typeparam>
/// <param name="format">The expected format.</param>
/// <param name="style">The accepted number style.</param>
/// <param name="tryParse">The number parser and validator.</param>
/// <param name="maxLength">Maximum accepted component values.</param>
/// <param name="minLength">Minimum accepted component values.</param>
/// <param name="defaultValue">The default value for missing components between min and max counts.</param>
/// <param name="separator">The separator used for splitting the string into component parts.</param>
public abstract class MultiComponentConverter<TValue, TComponent>(string format, NumberStyles style, TryParseDelegate<TValue, TComponent> tryParse, int maxLength, int minLength, TComponent defaultValue = default, char separator = ',')
    : OceanJsonConverter<TValue>()
    where TValue : struct // The value being read/written
    where TComponent : struct // The type that make up the value's components
{
    private readonly TryParseDelegate<TValue, TComponent> TryParse = tryParse; // The delegate that handles converting strings to the component values
    private readonly int MaxLength = maxLength; // Maximum possible values needed
    private readonly int MinLength = minLength; // Minimum possible values needed
    private readonly char Separator = separator; // Separator for complex formats
    private readonly TComponent Default = defaultValue; // The default values for component indices between min and max counts
    private readonly NumberStyles Style = style; // The supported styles of the numbers
    private readonly string Format = format; // The expected format in case of parsing error

    /// <summary>
    /// Creates the instance of the type handled by the converter using the parse array of components.
    /// </summary>
    /// <param name="array">The component array.</param>
    /// <returns>An instance employing the values deserialised from a string.</returns>
    protected abstract TValue FillFromArray(TComponent[] array);

    /// <summary>
    /// Parses a string into <typeparamref name="TValue"/>.
    /// </summary>
    /// <param name="valString">The string to parse.</param>
    /// <returns>The parse <typeparamref name="TValue"/>.</returns>
    public TValue Parse(string valString) => ParseOtherFormat(valString, out var result) ? result : FillFromArray(ParseComponents(valString, this));

    /// <summary>
    /// An alternative parsing format that doesn't involve splitting the string to get the values.
    /// </summary>
    /// <param name="valString">The string to parse.</param>
    /// <param name="result">The parse result</param>
    /// <returns>true if the parsing was successful.</returns>
    protected virtual bool ParseOtherFormat(string valString, out TValue result)
    {
        result = default;
        return false;
    }

    /// <inheritdoc/>
    protected sealed override object ParseFromJson(JsonReader reader)
    {
        var valString = reader.Value?.ToString() ?? "null";

        if (reader.TokenType != JsonToken.String)
            throw new InvalidDataException($"Cannot convert value '{valString}' to {typeof(TValue).Name}. Expected string format {Format}.");

        return Parse(valString);
    }

    /// <summary>
    /// Breaks down a value string and returns an array of <typeparamref name="TComponent"/>.
    /// </summary>
    /// <param name="value">The value to parse.</param>
    /// <param name="converter">The converter that's doing the parsing.</param>
    /// <returns>An array of parsed components from the provided string.</returns>
    /// <exception cref="InvalidDataException">Thrown if a component string was not of the correct number format.</exception>
    protected static TComponent[] ParseComponents(string value, MultiComponentConverter<TValue, TComponent> converter)
    {
        var components = value.TrueSplit(converter.Separator); // Split into would be components

        // Ensure that the correct number of components are there

        if (components.Length < converter.MinLength)
            throw new InvalidDataException($"'{value}' has too less values!");

        if (components.Length > converter.MaxLength)
            throw new InvalidDataException($"'{value}' has too many values!");

        var array = new TComponent[converter.MaxLength]; // Create temp array (I wish the game used System.Memory so I could use ArrayPool)

        for (var i = 0; i < components.Length; i++) // For each string component
        {
            var component = components[i];

            if (converter.TryParse(component, converter.Style, CultureInfo.InvariantCulture, out var valueComponent)) // Attempt to parse
                array[i] = valueComponent; // Assign to index of array if parsing successful
            else
                throw new InvalidDataException($"Invalid {typeof(TComponent).Name} string '{component}'!"); // Throw error otherwise
        }

        // Filling in the missing values with the converter default
        for (var i = components.Length; i < converter.MaxLength; i++)
            array[i] = converter.Default;

        return array;
    }
}

/// <summary>
/// Vector3 converter.
/// </summary>
public sealed class Vector3Converter : MultiComponentConverter<Vector3, float>
{
    public static Vector3Converter Instance; // Used for Orientation conversion

    public Vector3Converter() : base("'x,y,z' or 'x,y'", NumberStyles.Float | NumberStyles.AllowThousands, float.TryParse, 3, 2) => Instance = this;

    /// <inheritdoc/>
    protected override Vector3 FillFromArray(float[] array) => new(array[0], array[1], array[2]); // 0 = x, 1 = y, 2 = z

    /// <inheritdoc/>
    protected override string ToValueString(Vector3 value) => value.ToVectorString();
}

/// <summary>
/// Orientation converter.
/// </summary>
public sealed class OrientationConverter() : MultiComponentConverter<Orientation, Vector3>("of a pair of 'x,y,z' or 'x,y' separated by a ;", NumberStyles.Float | NumberStyles.AllowThousands,
    Helpers.TryParseVector, 2, 2, default, ';') // Uses Vector3Converter under the hood
{
    /// <inheritdoc/>
    protected override Orientation FillFromArray(Vector3[] array) => new(array[0], array[1]); // 0 = position, 1 = rotation

    /// <inheritdoc/>
    protected override string ToValueString(Orientation value) => $"{value.Position.ToVectorString()};{value.Rotation.ToVectorString()}";
}

/// <summary>
/// Base color converter class that handles the usage of the unity method delegate that's passed along with the other converter specific values.
/// </summary>
/// <typeparam name="TColor">The type of the color being handled (Color/Color32).</typeparam>
/// <typeparam name="TComponent">The type of the values that make up <typeparamref name="TColor"/>.</typeparam>
/// <param name="style">The accepted number style.</param>
/// <param name="tryParse">The number parsing delegate.</param>
/// <param name="defaultValue">The default value for missing values.</param>
/// <param name="htmlParser">The delegate for the unity html parsing method.</param>
public abstract class BaseColorConverter<TColor, TComponent>(NumberStyles style, TryParseDelegate<TColor, TComponent> tryParse, TComponent defaultValue, TryParseHtml<TColor> htmlParser)
    : MultiComponentConverter<TColor, TComponent>("'r,g,b', 'r,g,b,a' or #hex", style, tryParse, 4, 3, defaultValue)
    where TColor : struct // Color or Color32 but I don't know how to limit to only those two types
    where TComponent : struct // float or byte, same as above
{
    protected readonly TryParseHtml<TColor> TryParseHtmlColor = htmlParser; // Unity parsing delegate

    /// <inheritdoc/>
    protected sealed override bool ParseOtherFormat(string valString, out TColor result)
    {
        if (valString.StartsWith("#"))
            return TryParseHtmlColor(valString, out result);

        result = default;
        return false;
    }
}

/// <summary>
/// Color converter.
/// </summary>
public sealed class ColorConverter() : BaseColorConverter<Color, float>(NumberStyles.Float, float.TryParse, 1f, ColorUtility.TryParseHtmlString)
{
    /// <inheritdoc/>
    protected override Color FillFromArray(float[] array) => new(array[0], array[1], array[2], array[3]); // 0 = r, 1 = g, 2 = b, 3 = a

    /// <inheritdoc/>
    protected override string ToValueString(Color value) => value.ToColorString();
}

// /// <summary>
// /// Color32 converter.
// /// </summary>
// public sealed class Color32Converter() : BaseColorConverter<Color32, byte>(NumberStyles.Integer, byte.TryParse, 255, ColorUtility.DoTryParseHtmlColor)
// {
//     /// <inheritdoc/>
//     protected override Color32 FillFromArray(byte[] array) => new(array[0], array[1], array[2], array[3]); // 0 = r, 1 = g, 2 = b, 3 = a

//     /// <inheritdoc/>
//     protected override string ToValueString(Color32 value) => value.ToHexRGBA(); // Using hex code here because it's a simpler representation
// }

/// <summary>
/// Enum converter.
/// </summary>
/// <remarks>Made because srml's enum patching is causing errors with patched enum types being read by newtonsoft, will be removed if and when a fix is administered.</remarks>
public sealed class EnumConverter : OceanJsonConverter
{
    /// <inheritdoc/>
    public override bool CanConvert(Type objectType) => objectType.IsEnum || objectType.IsNullableEnum();

    /// <inheritdoc/>
    protected override object ParseFromJson(JsonReader reader, Type objectType)
    {
        var underlyingType = Nullable.GetUnderlyingType(objectType);

        if (underlyingType?.IsEnum == true)
            objectType = underlyingType;

        var enumString = reader.Value?.ToString() ?? "null"; // Get string version
        return reader.TokenType switch
        {
            JsonToken.String when Helpers.TryParse(objectType, enumString, true, out var result) => result, // Attempt the parse the string, make sure to use this arm
            JsonToken.Integer => Enum.ToObject(objectType, reader.Value), // Mainly there for completion's sake as integers are unreadable in json, the string call is wasted here
            _ => throw new JsonSerializationException($"Cannot convert value '{enumString}' ({reader.TokenType}) to {objectType.Name}. Expected a defined string or an integer."), // Throw an error because it was nothing else
        };
    }
}

/// <summary>
/// Type converter.
/// </summary>
public sealed class TypeConverter : OceanJsonConverter<Type>
{
    /// <inheritdoc/>
    protected override object ParseFromJson(JsonReader reader)
    {
        if (reader.TokenType != JsonToken.String)
            throw new InvalidDataException("Expected a string of the format as 'Namespace.TypeName, Assembly'"); // Throw if invalid

        var name = reader.Value as string; // Convert to string
        return Type.GetType(name) ?? throw new ArgumentException($"Cannot find type {name}!"); // Find type or throw if not found
    }

    /// <inheritdoc/>
    protected override string ToValueString(Type value) => value.FullName + ", " + value.Assembly.GetName().Name;
}