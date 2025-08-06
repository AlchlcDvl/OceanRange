using OceanRange.Patches;
using SRML.SR.SaveSystem.Registry;
using SRML.SR.SaveSystem.Data;
using SRML.SR.SaveSystem;
using OceanRange.Saves;

namespace OceanRange.Managers;

public static class SaveManager
{
    private static readonly WorldDataLoadDelegate ReadData = ReadSaveData;
    private static readonly WorldDataSaveDelegate WriteData = WriteSaveData;

    // Configuring the modded mail data
#if DEBUG
    [TimeDiagnostic("Save Preload")]
#endif
    public static void PreLoadSaveData()
    {
        SaveRegistry.RegisterWorldDataLoadDelegate(ReadData);
        SaveRegistry.RegisterWorldDataSaveDelegate(WriteData);
    }

    private static readonly List<ISaveData> SaveData = [new MailSaveData(), new GordoSaveData()];

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

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void WriteSaveData(CompoundDataPiece piece)
    {
        FixAndProperlyShowMailPatch.IsLoaded = false;

        piece.SetValue("version", SaveData.Count);

        for (var i = 0; i < SaveData.Count; i++)
        {
            try
            {
                var data = SaveData[i];
                Main.Console.Log(data.GetType().Name);
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