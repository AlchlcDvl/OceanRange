using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using MonomiPark.SlimeRancher.Regions;

namespace TheOceanRange;

internal class Spawners
{
    [Serializable]
    [CompilerGenerated]
    private sealed class _003C_003Ec
    {
        public static readonly _003C_003Ec _003C_003E9 = new _003C_003Ec();

        public static Func<DirectedSlimeSpawner, bool> _003C_003E9__0_1;

        public static OnSaveGameLoadedDelegate _003C_003E9__0_0;

        internal void _003CCreateRosaSpawner_003Eb__0_0(SceneContext s)
        {
            //IL_005f: Unknown result type (might be due to invalid IL or missing references)
            //IL_0064: Unknown result type (might be due to invalid IL or missing references)
            //IL_006f: Unknown result type (might be due to invalid IL or missing references)
            //IL_007e: Unknown result type (might be due to invalid IL or missing references)
            //IL_008e: Expected O, but got Unknown
            foreach (DirectedSlimeSpawner item in from ss in Object.FindObjectsOfType<DirectedSlimeSpawner>()
                where (int)((SRBehaviour)ss).GetComponentInParent<Region>(true).GetZoneId() == 1
                select ss)
            {
                SpawnConstraint[] constraints = ((DirectedActorSpawner)item).constraints;
                foreach (SpawnConstraint val in constraints)
                {
                    List<Member> obj = new List<Member>(val.slimeset.members)
                    {
                        new Member
                        {
                            prefab = SRSingleton<GameContext>.Instance.LookupDirector.GetPrefab(Ids.ROSA_SLIME),
                            weight = 0.25f
                        }
                    };
                    val.slimeset.members = obj.ToArray();
                }
            }
        }

        internal bool _003CCreateRosaSpawner_003Eb__0_1(DirectedSlimeSpawner ss)
        {
            //IL_0008: Unknown result type (might be due to invalid IL or missing references)
            //IL_000d: Unknown result type (might be due to invalid IL or missing references)
            //IL_000e: Unknown result type (might be due to invalid IL or missing references)
            //IL_0010: Invalid comparison between Unknown and I4
            return (int)((SRBehaviour)ss).GetComponentInParent<Region>(true).GetZoneId() == 1;
        }
    }

    public static void CreateRosaSpawner()
    {
        //IL_0015: Unknown result type (might be due to invalid IL or missing references)
        //IL_001a: Unknown result type (might be due to invalid IL or missing references)
        //IL_0020: Expected O, but got Unknown
        object obj = _003C_003Ec._003C_003E9__0_0;
        if (obj == null)
        {
            OnSaveGameLoadedDelegate val2 = delegate
            {
                //IL_005f: Unknown result type (might be due to invalid IL or missing references)
                //IL_0064: Unknown result type (might be due to invalid IL or missing references)
                //IL_006f: Unknown result type (might be due to invalid IL or missing references)
                //IL_007e: Unknown result type (might be due to invalid IL or missing references)
                //IL_008e: Expected O, but got Unknown
                foreach (DirectedSlimeSpawner item in from ss in Object.FindObjectsOfType<DirectedSlimeSpawner>()
                    where (int)((SRBehaviour)ss).GetComponentInParent<Region>(true).GetZoneId() == 1
                    select ss)
                {
                    SpawnConstraint[] constraints = ((DirectedActorSpawner)item).constraints;
                    foreach (SpawnConstraint val in constraints)
                    {
                        List<Member> obj2 = new List<Member>(val.slimeset.members)
                        {
                            new Member
                            {
                                prefab = SRSingleton<GameContext>.Instance.LookupDirector.GetPrefab(Ids.ROSA_SLIME),
                                weight = 0.25f
                            }
                        };
                        val.slimeset.members = obj2.ToArray();
                    }
                }
            };
            _003C_003Ec._003C_003E9__0_0 = val2;
            obj = (object)val2;
        }
        SRCallbacks.PreSaveGameLoad += (OnSaveGameLoadedDelegate)obj;
    }
}
