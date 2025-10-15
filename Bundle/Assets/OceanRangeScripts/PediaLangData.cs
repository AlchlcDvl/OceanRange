using System.Collections.Generic;
using System.IO;
using UnityEngine;

public abstract class PediaLangData : LangData
{
    public Dictionary<string, string> Intros;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}