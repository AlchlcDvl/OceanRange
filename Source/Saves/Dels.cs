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
            var writeMethod = Type.GetTypeCode(underlyingType) switch
            {
                TypeCode.Byte   => nameof(SaveWriter.WriteByte),
                TypeCode.SByte  => nameof(SaveWriter.WriteSByte),
                TypeCode.Int16  => nameof(SaveWriter.WriteShort),
                TypeCode.UInt16 => nameof(SaveWriter.WriteUShort),
                TypeCode.Int32  => nameof(SaveWriter.WriteInt),
                TypeCode.UInt32 => nameof(SaveWriter.WriteUInt),
                TypeCode.Int64  => nameof(SaveWriter.WriteLong),
                TypeCode.UInt64 => nameof(SaveWriter.WriteULong),
                _ => throw new NotSupportedException($"Enum underlying type {underlyingType.Name} is not supported.")
            };

            // Create method call: w.WriteMethod((UnderlyingType)v)
            var callExpr = Expression.Call(writerParam, Method(writeMethod), convertExpr);

            // Create lambda: (SaveWriter w, T v) => w.WriteMethod((UnderlyingType)v)
            return Expression.Lambda<Action<SaveWriter, T>>(callExpr, writerParam, valueParam).Compile();
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
            var readMethod = Type.GetTypeCode(underlyingType) switch
            {
                TypeCode.Byte   => nameof(SaveReader.ReadByte),
                TypeCode.SByte  => nameof(SaveReader.ReadSByte),
                TypeCode.Int16  => nameof(SaveReader.ReadShort),
                TypeCode.UInt16 => nameof(SaveReader.ReadUShort),
                TypeCode.Int32  => nameof(SaveReader.ReadInt),
                TypeCode.UInt32 => nameof(SaveReader.ReadUInt),
                TypeCode.Int64  => nameof(SaveReader.ReadLong),
                TypeCode.UInt64 => nameof(SaveReader.ReadULong),
                _ => throw new ArgumentException($"Enum size {Marshal.SizeOf(underlyingType)} not supported"),
            };

            // Create method call: r.ReadMethod()
            var readCall = Expression.Call(readerParam, Method(readMethod));

            // Convert from underlying type to enum type (this avoids boxing)
            var convertExpr = Expression.Convert(readCall, typeof(T));

            // Create lambda: (SaveReader r) => (T)r.ReadMethod()
            return Expression.Lambda<Func<SaveReader, T>>(convertExpr, readerParam).Compile();
        }
    }

    private static MethodInfo Method(string name) =>
        typeof(SaveReader).GetMethod(name, BindingFlags.Instance | BindingFlags.Public)
        ?? throw new MissingMethodException($"SaveReader missing method: {name}");
}