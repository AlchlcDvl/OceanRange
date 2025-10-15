using System.Collections.Generic;
using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Mail")]
public sealed class MailLangData : LangData
{
    public Dictionary<string, string> Subjects;
    public Dictionary<string, string> Bodies;
    public string MailKey;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}