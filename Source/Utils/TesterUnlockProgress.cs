using SRML.Console;

namespace OceanRange.Utils;

#if DEBUG
public class TesterUnlockProgressCommand : ConsoleCommand
{
    public override bool Execute(string[] args)
    {
        var model = SceneContext.Instance.ProgressDirector.model;
        
        if (model.progressDict.TryGetValue(ProgressType.CORPORATE_PARTNER, out _))
            model.progressDict[ProgressType.CORPORATE_PARTNER] = 999;
        else
            model.progressDict.Add(ProgressType.CORPORATE_PARTNER, 999);
        
        SceneContext.Instance.ProgressDirector.NoteProgressChanged(ProgressType.CORPORATE_PARTNER);
        
        Main.Console.Log("7Zee unlocked past max! You may have to reload save to apply changes.");
        
        return true;
    }

    public override string ID => "tester_unlock_progress";
    public override string Usage => "tester_unlock_progress";
    public override string Description => "Unlocks all 7Zee progress to quickly get to the Docks.";
}
#endif