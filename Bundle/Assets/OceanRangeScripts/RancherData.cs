using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Holder/Contacts")]
public sealed class Contacts : JsonData
{
    public RancherData[] Ranchers;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Rancher")]
public sealed class RancherData : JsonData
{
    public string[] Requests;
    public string[] Rewards;
    public string[] RareRewards;
    public string[] IndivRequests;
    public string[] IndivReward;
    public string[] IndivRareRewards;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}