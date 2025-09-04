using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Linq.Expressions;

namespace OceanRange.Modules;

// Parsing validation delegate for byte, float etc
public delegate bool TryParseDelegate<T>(string value, NumberStyles style, CultureInfo culture, out T component) where T : struct;

// Unity's try parse methods for html strings, much faster and simpler using a delegate pointing to native code than doing it myself
public delegate bool TryParseHtml<T>(string valString, out T color) where T : struct;

/// <summary>
/// Main base class for all json converters for all json serialised values. Provides wrappers for the read and write methods because the additional params are never used.
/// </summary>
public abstract class OceanJsonConverter : JsonConverter
{
    protected virtual bool CustomSerialisation => false;

    /// <inheritdoc/>
    public override sealed object ReadJson(JsonReader reader, Type objectType, [AllowNull] object _1, JsonSerializer _2)
    {
        if (reader.TokenType == JsonToken.Null)
            return null;

        try
        {
            return ParseFromJson(reader, objectType);
        }
        catch (Exception ex)
        {
            throw new JsonSerializationException($"Encountered an error while deserialising {objectType.Name} at path {reader.Path}:", ex);
        }
    }

    /// <inheritdoc/>
    public override sealed void WriteJson(JsonWriter writer, [AllowNull] object value, JsonSerializer _)
    {
        if (value == null)
            writer.WriteNull();
        else if (CustomSerialisation)
            WriteJson(writer, value);
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

    /// <summary>
    /// Writes the JSON representation of the object.
    /// </summary>
    /// <param name="writer">The JsonWriter to write to.</param>
    /// <param name="value">The value to write.</param>
    protected virtual void WriteJson(JsonWriter writer, [AllowNull] object value) { }
}

/// <summary>
/// Generic json converter for <typeparamref name="T"/> with a simplified CanConvert check.
/// </summary>
/// <typeparam name="T">The type of the value being handled.</typeparam>
public abstract class OceanJsonConverter<T> : OceanJsonConverter
{
    /// <inheritdoc/>
    public override sealed bool CanConvert(Type objectType) => typeof(T).IsAssignableFrom(objectType) || objectType.IsNullableOf<T>();

    /// <inheritdoc/>
    protected override sealed string ToValueString(object value)
    {
        if (value is T tValue)
            return ToValueString(tValue);

        throw new JsonSerializationException("Received unknown value: " + value);
    }

    /// <inheritdoc/>
    protected override sealed object ParseFromJson(JsonReader reader, Type _) => ParseFromJson(reader);

    /// <inheritdoc/>
    protected override sealed void WriteJson(JsonWriter writer, [AllowNull] object value)
    {
        if (value is T tValue)
            WriteJson(writer, tValue);
        else
            throw new JsonSerializationException("Received unknown value: " + value);
    }

    /// <summary>
    /// Wrapper method without the type parameter.
    /// </summary>
    /// <inheritdoc cref="ParseFromJson(JsonReader, Type)"/>
    protected abstract T ParseFromJson(JsonReader reader);

    /// <summary>
    /// Type safe wrapper.
    /// </summary>
    /// <inheritdoc cref="ToValueString(object)"/>
    protected virtual string ToValueString(T value) => value.ToString();

    /// <summary>
    /// Type safe wrapper.
    /// </summary>
    /// <inheritdoc cref="WriteJson(JsonWriter, object)"/>
    protected virtual void WriteJson(JsonWriter writer, [AllowNull] T value) { }
}

/// <summary>
/// Converter class that handles values types that have components (eg, Vector3 has 3 float components, Orientation has 2 Vector3 components)
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
public abstract class MultiComponentConverter<TValue, TComponent>(string format, NumberStyles style, TryParseDelegate<TComponent> tryParse, int maxLength, int minLength, TComponent defaultValue = default, char separator = ',')
    : OceanJsonConverter<TValue>
    where TValue : struct // The value being read/written
    where TComponent : struct // The type that make up the value's components
{
    private readonly TryParseDelegate<TComponent> TryParse = tryParse; // The delegate that handles converting strings to the component values
    private readonly int MaxLength = maxLength; // Maximum possible values needed
    private readonly int MinLength = minLength; // Minimum possible values needed
    private readonly char Separator = separator; // Separator for complex formats
    private readonly TComponent Default = defaultValue; // The default values for component indices between min and max counts
    protected readonly NumberStyles Style = style; // The supported styles of the numbers
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
    public TValue Parse(string valString) => ParseOtherFormat(valString, out var result) ? result : FillFromArray(ParseComponents(valString));

    /// <summary>
    /// An alternative parsing format that doesn't involve splitting the string to get the values.
    /// </summary>
    /// <param name="valString">The string to parse.</param>
    /// <param name="result">The parsed result.</param>
    /// <returns>true if the parsing was successful.</returns>
    protected virtual bool ParseOtherFormat(string valString, out TValue result)
    {
        result = default;
        return false;
    }

    /// <inheritdoc/>
    protected override sealed TValue ParseFromJson(JsonReader reader)
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
    /// <returns>An array of parsed components from the provided string.</returns>
    /// <exception cref="InvalidDataException">Thrown if a component string was not of the correct number format.</exception>
    private TComponent[] ParseComponents(string value)
    {
        var components = value.TrueSplit(Separator); // Split into would be components

        // Ensure that the correct number of components are there

        if (components.Count < MinLength)
            throw new InvalidDataException($"'{value}' has too less values!");

        if (components.Count > MaxLength)
            throw new InvalidDataException($"'{value}' has too many values!");

        var array = new TComponent[MaxLength]; // Create temp array (I wish the game used System.Memory so I could use ArrayPool)

        for (var i = 0; i < components.Count; i++) // For each string component
        {
            var component = components[i];

            if (TryParse(component, Style, CultureInfo.InvariantCulture, out var valueComponent)) // Attempt to parse
                array[i] = valueComponent; // Assign to index of array if parsing successful
            else
                throw new InvalidDataException($"Invalid {typeof(TComponent).Name} string '{component}' at index {i}!"); // Throw error otherwise
        }

        // Filling in the missing values with the converter default
        for (var i = components.Count; i < MaxLength; i++)
            array[i] = Default;

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
/// <remarks>Uses Vector3Converter under the hood.</remarks>
public sealed class OrientationConverter() : MultiComponentConverter<Orientation, Vector3>("of a pair of 'x,y,z' separated by a ; or 'f xPos,yPos,zPos,xRot,yRot,zRot", NumberStyles.Float | NumberStyles.AllowThousands, Helpers.TryParseVector, 2,
    2, default, ';')
{
    /// <inheritdoc/>
    protected override Orientation FillFromArray(Vector3[] array) => new(array[0], array[1]); // 0 = position, 1 = rotation

    /// <inheritdoc/>
    protected override string ToValueString(Orientation value) => $"{value.Position.ToVectorString()};{value.Rotation.ToVectorString()}";

    /// <inheritdoc/>
    protected override bool ParseOtherFormat(string valString, out Orientation result)
    {
        if (!valString.StartsWith('f')) // f = float
            return base.ParseOtherFormat(valString, out result);

        // I don't like the copy pasted bit here, but it's a necessary evil
        var components = valString.TrueSplit(',', 'f');

        switch (components.Count)
        {
            case < 6:
                throw new InvalidDataException($"'{valString}' has too less values!");
            case > 6:
                throw new InvalidDataException($"'{valString}' has too many values!");
        }

        var array = new float[6];

        for (var i = 0; i < 6; i++)
        {
            var component = components[i];

            if (float.TryParse(component, Style, CultureInfo.InvariantCulture, out var valueComponent))
                array[i] = valueComponent;
            else
                throw new InvalidDataException($"Invalid float string '{component}' at index {i}!");
        }

        result = new(array[0], array[1], array[2], array[3], array[4], array[5]); // 0 = position x, 1 = position y, 2 = position z, 3 = rotation x, 4 = rotation y, 5 = rotation z
        return true;
    }
}

/// <summary>
/// Base color converter class that handles the usage of the unity method delegate that's passed along with the other converter specific values.
/// </summary>
/// <typeparam name="TColor">The type of the color being handled (Color/Color32).</typeparam>
/// <typeparam name="TComponent">The type of the values that make up <typeparamref name="TColor"/>.</typeparam>
public abstract class BaseColorConverter<TColor, TComponent> : MultiComponentConverter<TColor, TComponent>
    where TColor : struct // Color or Color32, but I don't know how to limit to only those two types
    where TComponent : struct // float or byte, same as above
{
    private readonly TryParseHtml<TColor> TryParseHtmlColor; // Unity parsing delegate

    /// <summary>
    /// Base color converter class that handles the usage of the unity method delegate that's passed along with the other converter specific values.
    /// </summary>
    /// <param name="style">The accepted number style.</param>
    /// <param name="tryParse">The number parsing delegate.</param>
    /// <param name="defaultValue">The default value for missing values.</param>
    /// <param name="htmlParser">The delegate for the unity html parsing method.</param>
    protected BaseColorConverter(NumberStyles style, TryParseDelegate<TComponent> tryParse, TComponent defaultValue, TryParseHtml<TColor> htmlParser) : base("'r,g,b', 'r,g,b,a' or #hex", style, tryParse, 4, 3, defaultValue)
    {
        var tType = typeof(TColor);

        if (tType != typeof(Color) && tType != typeof(Color32))
            throw new InvalidOperationException($"Invalid color type: {tType.Name}. Only UnityEngine.Color or UnityEngine.Color32 are supported.");

        TryParseHtmlColor = htmlParser;
    }

    /// <inheritdoc/>
    protected override sealed bool ParseOtherFormat(string valString, out TColor result)
    {
        if (valString.StartsWith('#'))
            return TryParseHtmlColor(valString, out result);

        result = default;
        return false;
    }
}

/// <summary>
/// Color converter.
/// </summary>
public sealed class ColorConverter() : BaseColorConverter<Color, float>(NumberStyles.Float, float.TryParse, 1f, Helpers.TryHexToColor)
{
    /// <inheritdoc/>
    protected override Color FillFromArray(float[] array) => new(array[0], array[1], array[2], array[3]); // 0 = r, 1 = g, 2 = b, 3 = a

    /// <inheritdoc/>
    protected override string ToValueString(Color value) => value.ToColorString();
}

// /// <summary>
// /// Color32 converter.
// /// </summary>
// public sealed class Color32Converter() : BaseColorConverter<Color32, byte>(NumberStyles.Integer, byte.TryParse, 255, Helpers.TryHexToColor32)
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
    private sealed class EnumMetadata
    {
        public readonly bool IsFlags;
        public readonly (object, string)[] Values;
        public readonly string ZeroName;
        public readonly Func<object, ulong> ToUInt64;
        public readonly Func<ulong, object> FromUInt64;

        public EnumMetadata(Type enumType)
        {
            IsFlags = enumType.IsDefined(typeof(FlagsAttribute), false);
            Values = [.. Enum.GetValues(enumType).Cast<object>().Zip(Enum.GetNames(enumType))];
            ZeroName = Enum.ToObject(enumType, 0).ToString();

            var underlying = Enum.GetUnderlyingType(enumType);
            ToUInt64 = MakeToUInt64(underlying);
            FromUInt64 = MakeFromUInt64(enumType, underlying);
        }

        private static Func<object, ulong> MakeToUInt64(Type underlying)
        {
            var obj = Expression.Parameter(typeof(object), "value");
            var converted = Expression.ConvertChecked(Expression.Convert(obj, underlying), typeof(ulong));
            return Expression.Lambda<Func<object, ulong>>(converted, obj).Compile();
        }

        private static Func<ulong, object> MakeFromUInt64(Type enumType, Type underlying)
        {
            var value = Expression.Parameter(typeof(ulong), "value");
            var converted = Expression.ConvertChecked(value, underlying);
            var boxed = Expression.Convert(Expression.Convert(converted, enumType), typeof(object));
            return Expression.Lambda<Func<ulong, object>>(boxed, value).Compile();
        }
    }

    private static readonly Dictionary<Type, EnumMetadata> MetadataCache = [];

    protected override bool CustomSerialisation => true;

    public override bool CanConvert(Type objectType) => objectType.IsEnum || objectType.IsNullableEnum();

    private static EnumMetadata GetMetadata(Type enumType)
    {
        if (!MetadataCache.TryGetValue(enumType, out var value))
            MetadataCache[enumType] = value = new(enumType);

        return value;
    }

    protected override object ParseFromJson(JsonReader reader, Type objectType)
    {
        var targetType = Nullable.GetUnderlyingType(objectType) ?? objectType;
        var metadata = GetMetadata(targetType);
        return metadata.IsFlags ? ParseFlags(reader, targetType, metadata) : ParseSingle(reader, targetType, metadata, false);
    }

    private static object ParseSingle(JsonReader reader, Type enumType, EnumMetadata metadata, bool partOfArray) => reader.TokenType switch
    {
        JsonToken.Null when partOfArray => null, // Only check null when in an array, because normal null values are handled outside this method
        JsonToken.String when Helpers.TryParse(enumType, reader.Value?.ToString() ?? "null", true, out var parsed) => parsed, // Attempt the parse the string, make sure to use this arm
        JsonToken.Integer => metadata.FromUInt64(Convert.ToUInt64(reader.Value)), // Avoid adding numbers, they're hard to understand in JSON when you don't have access to the relevant enum
        _ => throw new InvalidDataException($"Cannot convert value '{reader.Value}' ({reader.TokenType}) to {enumType.Name}. Expected {(partOfArray ? "a valid array of defined strings or ints, " : "")}a defined string or an integer."),
    };

    private static object ParseFlags(JsonReader reader, Type enumType, EnumMetadata metadata)
    {
        if (reader.TokenType != JsonToken.StartArray)
            return ParseSingle(reader, enumType, metadata, false);

        var combined = 0UL;

        while (reader.Read() && reader.TokenType != JsonToken.EndArray)
            combined |= metadata.ToUInt64(ParseSingle(reader, enumType, metadata, true));

        return metadata.FromUInt64(combined);
    }

    /// <inheritdoc/>
    protected override void WriteJson(JsonWriter writer, [AllowNull] object value)
    {
        if (value == null)
        {
            writer.WriteNull();
            return;
        }

        var type = value.GetType();
        var enumType = Nullable.GetUnderlyingType(type) ?? type;
        var metadata = GetMetadata(enumType);

        if (!metadata.IsFlags)
        {
            var name = Enum.GetName(enumType, value);

            if (name != null)
                writer.WriteValue(name);
            else
                writer.WriteValue(metadata.ToUInt64(value));

            return;
        }

        var underlying = metadata.ToUInt64(value);

        if (underlying == 0)
        {
            writer.WriteValue(metadata.ZeroName);
            return;
        }

        var setFlags = new List<string>();
        var matchedBits = 0UL;

        foreach (var (enumVal, name) in metadata.Values)
        {
            var flag = metadata.ToUInt64(enumVal);

            if (flag == 0 || (underlying & flag) != flag)
                continue;

            setFlags.Add(name);
            matchedBits |= flag;
        }

        var leftoverBits = underlying & ~matchedBits;

        if (setFlags.Count == 0 && leftoverBits != 0)
            writer.WriteValue(underlying);
        else if (setFlags.Count == 1 && leftoverBits == 0)
            writer.WriteValue(setFlags[0]);
        else
        {
            writer.WriteStartArray();

            foreach (var flag in setFlags)
                writer.WriteValue(flag);

            if (leftoverBits != 0)
                writer.WriteValue(leftoverBits);

            writer.WriteEndArray();
        }
    }
}

/// <summary>
/// Type converter.
/// </summary>
public sealed class TypeConverter : OceanJsonConverter<Type>
{
    private static readonly Dictionary<string, Type> CachedTypes = [];

    /// <inheritdoc/>
    protected override Type ParseFromJson(JsonReader reader)
    {
        if (reader.TokenType != JsonToken.String)
            throw new InvalidDataException("Expected a string of the format as 'Namespace.TypeName, Assembly' or 'Namespace.TypeName' or full qualified name"); // Throw if invalid

        var name = reader.Value as string; // Convert to string

        if (!CachedTypes.TryGetValue(name!, out var type)) // Try to find if a type was already deserialised
            CachedTypes[name] = type = Type.GetType(name!) ?? throw new ArgumentException($"Cannot find type {name}!"); // Find type or throw if not found

        return type;
    }

    /// <inheritdoc/>
    protected override string ToValueString(Type value) => value.FullName + ", " + value.Assembly.GetName().Name;
}