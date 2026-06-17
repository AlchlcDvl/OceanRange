using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;
using System.Collections.Generic;

class CreateAssetBundles
{
    static readonly List<(string, string, BuildTarget)> _targets = new List<(string, string, BuildTarget)>()
    {
        ("Mac", "mac", BuildTarget.StandaloneOSX),
        ("Win", "win", BuildTarget.StandaloneWindows),
        ("Lin", "lin", BuildTarget.StandaloneLinux64),
    };

    [MenuItem("Ocean Range/Build Bundles")]
    static void BuildBundles()
    {
        Debug.Log("Bundles building...");

        var assetBundleDirectory = Path.Combine("Assets", "StreamingAssets");
        PrepDirectory(assetBundleDirectory);

        var bundles = Path.Combine("Assets", "..", "..", "Source", "Resources", "Bundles");
        PrepDirectory(bundles);

        foreach ((string dir, string suffix, BuildTarget target) in _targets)
        {
            var directory = Path.Combine(assetBundleDirectory, dir);
            PrepDirectory(directory);

            BuildPipeline.BuildAssetBundles(directory, BuildAssetBundleOptions.None, target);

            MoveAndRenameSpecificBundle(directory, bundles, suffix);
        }

        Directory.Delete(assetBundleDirectory, true);

        var metaPath = assetBundleDirectory + ".meta";

        if (File.Exists(metaPath))
            File.Delete(metaPath);

        Debug.Log("Bundles built!");
    }

    static void PrepDirectory(string path)
    {
        if (!Directory.Exists(path))
            Directory.CreateDirectory(path);
        else
            Directory.EnumerateFiles(path, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);
    }

    static void MoveAndRenameSpecificBundle(string sourceDir, string targetDir, string newExtension)
    {
        var sourceBundlePath = Path.Combine(sourceDir, "oceanrange");

        if (!File.Exists(sourceBundlePath))
        {
            Debug.LogError($"Source bundle not found at: {sourceBundlePath}");
            return;
        }

        var destBundlePath = Path.Combine(targetDir, "ocean_range.bundle_" + newExtension);

        if (File.Exists(destBundlePath))
            File.Delete(destBundlePath);

        File.Move(sourceBundlePath, destBundlePath);

        Directory.Delete(sourceDir, true);

        var metaPath = sourceDir + ".meta";

        if (File.Exists(metaPath))
            File.Delete(metaPath);
    }
}
