using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;

public class CreateAssetBundles
{
    [MenuItem("AssetBundle/Build")]
    static void BuildBundles()
    {
        string assetBundleDirectory = "Assets/StreamingAssets";
        PrepDirectory(assetBundleDirectory);

        string mac = "Assets/StreamingAssets/Mac";
        PrepDirectory(mac);

        string win = "Assets/StreamingAssets/Win";
        PrepDirectory(win);

        string lin = "Assets/StreamingAssets/Lin";
        PrepDirectory(lin);

        BuildPipeline.BuildAssetBundles(mac, BuildAssetBundleOptions.None, BuildTarget.StandaloneOSX);
        BuildPipeline.BuildAssetBundles(win, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows);
        BuildPipeline.BuildAssetBundles(lin, BuildAssetBundleOptions.None, BuildTarget.StandaloneLinux64);

        string bundles = "Assets/../../Source/Resources/Bundles";
        PrepDirectory(bundles);

        MoveAndRenameSpecificBundle(mac, bundles, "mac");
        MoveAndRenameSpecificBundle(lin, bundles, "lin");
        MoveAndRenameSpecificBundle(win, bundles, "win");

        Directory.Delete(assetBundleDirectory, true);

        string metaPath = "Assets/StreamingAssets.meta";

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
        string destBundleFileName = "ocean_range.bundle_" + newExtension;
        string destBundlePath = Path.Combine(targetDir, destBundleFileName);

        if (!File.Exists(sourceBundlePath))
            return;

        if (File.Exists(destBundlePath))
            File.Delete(destBundlePath);

        File.Move(sourceBundlePath, destBundlePath);
        Directory.EnumerateFiles(sourceDir, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);
    }
}
