namespace OceanRange.Data;

[Flags]
public enum DefinitionProps : byte
{
    None = 0,
    UseSlime2ForSound = 1 << 0 // I kept for parity's sake with SRML's largo props
}