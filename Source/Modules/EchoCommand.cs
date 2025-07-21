using SRML.Console;

namespace TheOceanRange.Modules;

public sealed class EchoCommand : ConsoleCommand
{
    public override string ID => "echo";
    public override string Usage => "echo [argument] [argument] ...";
    public override string Description => "Echos whatever arguments you type into the console.";
    public override string ExtendedDescription => "Echos whatever arguments you type into the console, great for passing temporary notes into logs.";

    public override bool Execute(string[] args)
    {
        var console = SRML.Console.Console.Instance;

        if (args?.Length is null or 0)
        {
            console.LogError("Cannot echo empty");
            return false;
        }

        console.Log(string.Join(" ", args));
        return true;
    }
}