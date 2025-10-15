using System;

[Flags]
public enum LargoProps : ushort
{
    None = 0,

    // These should be self-descriptive
    UseSlime2ForEyes = 1 << 0,
    UseSlime2ForMouth = 1 << 1,

    UseSlime2ForFace = UseSlime2ForEyes | UseSlime2ForMouth,

    UseSlime2ForSound = 1 << 2, // I kept for parity's sake with SRML's largo props
    UseSlime2ForBody = 1 << 3,
    UseSlime2ForBodyMaterial = 1 << 4,

    // Combines the above values so you don't have to write a long array just with the above values
    UseSlime2AsBase = UseSlime2ForSound | UseSlime2ForFace | UseSlime2ForBody | UseSlime2ForBodyMaterial,

    // Markers for whether custom (non-base slime) structures/materials are in use for relevant parts
    CustomSlime1Structures = 1 << 5,
    CustomSlime2Structures = 1 << 6,
    CustomBody = 1 << 7,

    // Same as UseSlime2AsBase
    CustomStructures = CustomSlime1Structures | CustomSlime2Structures | CustomBody,

    ExcludeSlime1Structures = 1 << 8,
    ExcludeSlime2Structures = 1 << 9,

    // Same as UseSlime2AsBase
    ExcludeStructures = ExcludeSlime1Structures | ExcludeSlime2Structures
}