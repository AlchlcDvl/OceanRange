// ReSharper disable UnusedMember.Global

namespace OceanRange.Data;

[Flags]
public enum LargoAppearanceProps : byte
{
    None = 0,

    UseSlime2ForEyeColor = 1 << 0,
    UseSlime2ForEyeShape = 1 << 1,

    UseSlime2ForEyes = UseSlime2ForEyeColor | UseSlime2ForEyeShape,

    UseSlime2ForMouthColor = 1 << 2,
    UseSlime2ForMouthShape = 1 << 3,

    UseSlime2ForMouth = UseSlime2ForMouthColor | UseSlime2ForMouthShape,

    UseSlime2ForFace = UseSlime2ForEyes | UseSlime2ForMouth,

    UseSlime2ForBodyShape = 1 << 4,
    UseSlime2ForBodyMaterial = 1 << 5,

    UseSlime2ForBody = UseSlime2ForBodyShape | UseSlime2ForBodyMaterial,

    UseSlime2AsBase = UseSlime2ForFace | UseSlime2ForBody,

    ExcludeSlime1Structures = 1 << 6,
    ExcludeSlime2Structures = 1 << 7,

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