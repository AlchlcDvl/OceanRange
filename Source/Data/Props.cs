// ReSharper disable UnusedMember.Global

namespace OceanRange.Data;

[Flags]
public enum LargoAppearanceProps : byte
{
    None = 0,

    // These should be self-descriptive
    UseSlime2ForEyes = 1 << 0,
    UseSlime2ForMouth = 1 << 1,

    UseSlime2ForFace = UseSlime2ForEyes | UseSlime2ForMouth,

    UseSlime2ForBody = 1 << 2,
    UseSlime2ForBodyMaterial = 1 << 3,

    // Combines the above values so you don't have to write a long array just with the above values
    UseSlime2AsBodyBase = UseSlime2ForBody | UseSlime2ForBodyMaterial,

    UseSlime2AsBase = UseSlime2ForFace | UseSlime2AsBodyBase,

    ExcludeSlime1Structures = 1 << 4,
    ExcludeSlime2Structures = 1 << 5,

    // Same as UseSlime2AsBase
    ExcludeStructures = ExcludeSlime1Structures | ExcludeSlime2Structures
}

[Flags]
public enum DefinitionProps : byte
{
    None = 0,

    UseSlime2ForSound = 1 << 0, // I kept for parity's sake with SRML's largo props
    UseSlime2ForBody = 1 << 1,

    UseSlime2AsBase = UseSlime2ForSound | UseSlime2ForBody
}

[Flags]
public enum AppearanceType : byte
{
    None = 0,
    SS1 = 1 << 0,
    SS2 = 1 << 1,
    BothSS = SS1 | SS2
}