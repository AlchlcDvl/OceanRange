global using UnityEngine;

global using System;
global using System.IO;
global using System.Linq;
global using System.Collections.Generic;

global using JetBrains.Annotations;

#if !UNITY
// global using GadgetId = Gadget.Id;
global using Zone = ZoneDirector.Zone;
global using PediaId = PediaDirector.Id;
global using UObject = UnityEngine.Object;
global using FoodGroup = SlimeEat.FoodGroup;
global using Language = MessageDirector.Lang;
global using IdentifiableId = Identifiable.Id;
global using Ambiance = AmbianceDirector.Zone;
global using SpawnResourceId = SpawnResource.Id;
global using Category = ExchangeDirector.Category;
global using StorageType = SiloStorage.StorageType;
global using TimeMode = DirectedActorSpawner.TimeMode;
global using SlimeExpression = SlimeFace.SlimeExpression;
global using ProgressType = ProgressDirector.ProgressType;
global using PediaCategory = SRML.SR.PediaRegistry.PediaCategory;
global using RancherName = RancherChatMetadata.Entry.RancherName;
global using RegionId = MonomiPark.SlimeRancher.Regions.RegionRegistry.RegionSetId;

global using SRML.SR;

global using HarmonyLib;

global using OceanRange.Managers;
global using OceanRange.Modules;
global using OceanRange.Slimes;
global using OceanRange.Utils;

global using MonomiPark.SlimeRancher.Regions;

#else
global using Newtonsoft.Json;
#endif