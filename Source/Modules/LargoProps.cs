namespace OceanRange.Modules;

[Flags]
public enum LargoProps : ushort
{
    None = 0,

    // These should be self descriptive
    UseSlime2ForSound = 1 << 0, // I kept for parity's sake with SRML's largo props
    UseSlime2ForEyes = 1 << 1,
    UseSlime2ForMouth = 1 << 2,
    UseSlime2ForBody = 1 << 3,
    UseSlime2ForBodyMaterial = 1 << 4,
    UseSlime2NameFirst = 1 << 5,

    // Combines the above values so you don't have to write a long array just with the above values
    UseSlime2AsBase = UseSlime2ForSound | UseSlime2ForEyes | UseSlime2ForMouth | UseSlime2NameFirst | UseSlime2ForBody | UseSlime2ForBodyMaterial,

    CustomStructureSource = 1 << 6, // Use for custom mesh models that the base slimes don't use

    // Markers for whether custom (non base slime) materials are in use for relevant parts
    CustomSlime1StructureMaterials = 1 << 7,
    CustomSlime2StructureMaterials = 1 << 8,
    CustomBodyMaterial = 1 << 9,

    // Same as UseSlime2AsBase
    AllMaterialsAreCustom = CustomSlime1StructureMaterials | CustomSlime2StructureMaterials | CustomBodyMaterial,

    // Same as above
    FullyCustomBody = CustomStructureSource | AllMaterialsAreCustom
}