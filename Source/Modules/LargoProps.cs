namespace OceanRange.Modules;

[Flags]
public enum LargoProps : ushort
{
    None = 0,

    UseSlime2ForSound = 1 << 0,
    UseSlime2ForEyes = 1 << 1,
    UseSlime2ForMouth = 1 << 2,
    UseSlime2ForBody = 1 << 3,
    UseSlime2ForBodyMaterial = 1 << 4,
    UseSlime2NameFirst = 1 << 5,

    UseSlime2AsBase = UseSlime2ForSound | UseSlime2ForEyes | UseSlime2ForMouth | UseSlime2NameFirst | UseSlime2ForBody,

    UseSlime1Structures = 1 << 6,
    UseSlime2Structures = 1 << 7,
    UseBothSlimesForStructures = UseSlime1Structures | UseSlime2Structures,

    CustomStructureSource = 1 << 8,

    CustomSlime1StructureMaterials = 1 << 9,
    CustomSlime2StructureMaterials = 1 << 10,
    CustomBodyMaterial = 1 << 11,

    OnlyCustomMaterials = CustomSlime1StructureMaterials | CustomSlime2StructureMaterials | CustomBodyMaterial
}