using System.Linq.Expressions;
using System.Reflection;
using System.Runtime.InteropServices;

namespace OceanRange.Saves;

/// <summary>
/// Reusable cached delegates to improve performance, add more for data types as needed to avoid excess GC overhead
/// </summary>
public static class SaveWriterDels
{
    public static class Enum<T> where T : struct, Enum
    {
        public static readonly Action<SaveWriter, T> Func = CreateWriter();

        private static Action<SaveWriter, T> CreateWriter()
        {
            var underlyingType = Enum.GetUnderlyingType(typeof(T));

            // Create expression parameters
            var writerParam = Expression.Parameter(typeof(SaveWriter), "w");
            var valueParam = Expression.Parameter(typeof(T), "v");

            // Convert enum to underlying type (this avoids boxing)
            var convertExpr = Expression.Convert(valueParam, underlyingType);

            // Get the appropriate Write method based on size
            var writeMethod = Method(underlyingType.Name switch
            {
                "Byte" => nameof(SaveWriter.WriteByte),
                "SByte" => nameof(SaveWriter.WriteSByte),
                "Int16" => nameof(SaveWriter.WriteShort),
                "Int32" => nameof(SaveWriter.WriteInt),
                "Int64" => nameof(SaveWriter.WriteLong),
                "UInt16" => nameof(SaveWriter.WriteUShort),
                "UInt32" => nameof(SaveWriter.WriteUInt),
                "UInt64" => nameof(SaveWriter.WriteULong),
                _ => throw new ArgumentException($"Enum size {Marshal.SizeOf(underlyingType)} not supported"),
            });

            // Create method call: w.WriteMethod((UnderlyingType)v)
            var callExpr = Expression.Call(writerParam, writeMethod, convertExpr);

            // Create lambda: (SaveWriter w, T v) => w.WriteMethod((UnderlyingType)v)
            var lambda = Expression.Lambda<Action<SaveWriter, T>>(callExpr, writerParam, valueParam);

            return lambda.Compile();
        }
    }

    private static MethodInfo Method(string name) =>
        typeof(SaveWriter).GetMethod(name, BindingFlags.Instance | BindingFlags.Public)
        ?? throw new MissingMethodException($"SaveWriter missing method: {name}");
}

/// <summary>
/// Reusable cached delegates to improve performance, add more for data types as needed to avoid excess GC overhead
/// </summary>
public static class SaveReaderDels
{
    public static class Enum<T> where T : struct, Enum
    {
        public static readonly Func<SaveReader, T> Func = CreateReader();

        private static Func<SaveReader, T> CreateReader()
        {
            var underlyingType = Enum.GetUnderlyingType(typeof(T));

            // Create expression parameter
            var readerParam = Expression.Parameter(typeof(SaveReader), "r");

            // Get the appropriate Read method based on size
            var readMethod = Method(underlyingType.Name switch
            {
                "Byte" => nameof(SaveReader.ReadByte),
                "SByte" => nameof(SaveReader.ReadSByte),
                "Int16" => nameof(SaveReader.ReadShort),
                "Int32" => nameof(SaveReader.ReadInt),
                "Int64" => nameof(SaveReader.ReadLong),
                "UInt16" => nameof(SaveReader.ReadUShort),
                "UInt32" => nameof(SaveReader.ReadUInt),
                "UInt64" => nameof(SaveReader.ReadULong),
                _ => throw new ArgumentException($"Enum size {Marshal.SizeOf(underlyingType)} not supported"),
            });

            // Create method call: r.ReadMethod()
            var readCall = Expression.Call(readerParam, readMethod);

            // Convert from underlying type to enum type (this avoids boxing)
            var convertExpr = Expression.Convert(readCall, typeof(T));

            // Create lambda: (SaveReader r) => (T)r.ReadMethod()
            var lambda = Expression.Lambda<Func<SaveReader, T>>(convertExpr, readerParam);

            return lambda.Compile();
        }
    }

    private static MethodInfo Method(string name) =>
        typeof(SaveReader).GetMethod(name, BindingFlags.Instance | BindingFlags.Public)
        ?? throw new MissingMethodException($"SaveReader missing method: {name}");
}