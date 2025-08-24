using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;

public class CreateAssetBundles
{
    static readonly List<Tuple<string, string, BuildTarget>> _targets = new()
    {
        new Tuple<string, string, BuildTarget>("Mac", "mac", BuiltTarget.StandaloneOSX),
        new Tuple<string, string, BuildTarget>("Win", "win", BuiltTarget.StandaloneWindows),
        new Tuple<string, string, BuildTarget>("Lin", "lin", BuiltTarget.StandaloneLinux64),
    };

    [MenuItem("AssetBundle/Build")]
    static void BuildBundles()
    {
        string assetBundleDirectory = Path.Combine("Assets", "StreamingAssets");
        PrepDirectory(assetBundleDirectory);

        string bundles = Path.Combine("Assets", "..", "..", "Source", "Resources", "Bundles");
        PrepDirectory(bundles);

        foreach ((string dir, string suffix, BuiltTarget target) in _targets)
        {
            string directory = Path.Combine(assetBundleDirectory, dir);
            PrepDirectory(directory);

            BuildPipeline.BuildAssetBundles(directory, BuildAssetBundleOptions.None, target);

            MoveAndRenameSpecificBundle(directory, bundles, suffix);
        }

        Directory.Delete(assetBundleDirectory, true);

        string metaPath = assetBundleDirectory + ".meta";

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
        string sourceBundlePath = Path.Combine(sourceDir, "oceanrange");

        if (!File.Exists(sourceBundlePath))
        {
            Debug.LogError($"Source bundle not found at: {sourceBundlePath}");
            return;
        }

        string destBundlePath = Path.Combine(targetDir, "ocean_range.bundle_" + newExtension);

        if (File.Exists(destBundlePath))
            File.Delete(destBundlePath);

        File.Move(sourceBundlePath, destBundlePath);
        Directory.EnumerateFiles(sourceDir, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);
    }
}
