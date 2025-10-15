namespace OceanRange.Data;

[Serializable, CreateAssetMenu(menuName = "OceanRange/Ranchers")]
public sealed class Contactsbook : ValueArrayHolder<RancherData>;

[Serializable]
public sealed partial class RancherData : ModData;