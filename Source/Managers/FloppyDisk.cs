using OceanRange.Patches;
using SRML.SR.SaveSystem.Data;
using SRML.SR.SaveSystem;
using OceanRange.Saves;

namespace OceanRange.Managers;

/// <summary>
/// Handles the saving and reading of modded data that implement <c><see cref="ISaveData"/></c>.
/// </summary>
public static class FloppyDisk
{
    /// <summary>
    /// Configures the events that handles the reading and writing of data.
    /// </summary>
#if DEBUG
    [TimeDiagnostic("Save Preload")]
#endif
    public static void PreloadSaveData()
    {
        SaveRegistry.RegisterWorldDataLoadDelegate(ReadSaveData);
        SaveRegistry.RegisterWorldDataSaveDelegate(WriteSaveData);
    }

    private static readonly ISaveData[] SaveData = [new MailSaveData(), new GordoSaveData()];

    /// <summary>
    /// Reads the save data from a compounded data piece.
    /// </summary>
    /// <param name="piece">The piece to be read from.</param>
#if DEBUG
    [TimeDiagnostic]
#endif
    private static void ReadSaveData(CompoundDataPiece piece)
    {
        FixAndProperlyShowMailPatch.IsLoaded = false;

        var version = piece.GetValue<int>("version");

        for (var i = 0; i < version; i++)
        {
            try
            {
                var data = SaveData[i];

                if (piece.GetValue<bool>($"data{i}Deprecated"))
                    continue;

                var buffer = piece.GetValue<ulong[]>($"data{i}Data");
                var padding = piece.GetValue<byte>($"data{i}Padding");
                data.Read(buffer, padding);
            }
            catch (Exception e)
            {
                Main.Console.LogError(e);
            }
        }

        FixAndProperlyShowMailPatch.IsLoaded = true;
    }

    /// <summary>
    /// Writes the save data to a compounded data piece.
    /// </summary>
    /// <param name="piece">The piece to be write to.</param>
#if DEBUG
    [TimeDiagnostic]
#endif
    private static void WriteSaveData(CompoundDataPiece piece)
    {
        FixAndProperlyShowMailPatch.IsLoaded = false;

        var length = SaveData.Length;
        piece.SetValue("version", length);

        for (var i = 0; i < length; i++)
        {
            try
            {
                var data = SaveData[i];
                piece.SetValue($"data{i}Deprecated", data.Deprecated);

                if (data.Deprecated)
                    continue;

                var buffer = data.Write(out var padding);
                piece.SetValue($"data{i}Data", buffer);
                piece.SetValue($"data{i}Padding", padding);
            }
            catch (Exception e)
            {
                Main.Console.LogError(e);
            }
        }

        FixAndProperlyShowMailPatch.IsLoaded = true;
    }
}