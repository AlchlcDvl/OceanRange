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
        if (!Directory.Exists(assetBundleDirectory))
        {
            Directory.CreateDirectory(assetBundleDirectory);
        }

        string mac = "Assets/StreamingAssets/Mac";
        PrepDirectory(mac);
        string win = "Assets/StreamingAssets/Win";
        PrepDirectory(win);
        string lin = "Assets/StreamingAssets/Lin";
        PrepDirectory(lin);

        BuildPipeline.BuildAssetBundles(mac, BuildAssetBundleOptions.None, BuildTarget.StandaloneOSX);
        BuildPipeline.BuildAssetBundles(win, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows);
        BuildPipeline.BuildAssetBundles(lin, BuildAssetBundleOptions.None, BuildTarget.StandaloneLinux64);

        string bundles = "Assets/StreamingAssets/Bundles";
        PrepDirectory(bundles);
        MoveAndRenameSpecificBundle(mac, bundles, "mac");
        MoveAndRenameSpecificBundle(lin, bundles, "lin");
        MoveAndRenameSpecificBundle(win, bundles, "win");
    }

    static void PrepDirectory(string path)
    {
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }
        else
        {
            Directory.EnumerateFiles(path, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);
        }
    }

    static void MoveAndRenameSpecificBundle(string sourceDir, string targetDir, string newExtension)
    {
        string sourceBundlePath = Path.Combine(sourceDir, "oceanrange");
        string destBundleFileName = "OceanRange.bundle_" + newExtension;
        string destBundlePath = Path.Combine(targetDir, destBundleFileName);

        if (File.Exists(sourceBundlePath))
        {
            try
            {
                if (File.Exists(destBundlePath))
                {
                    File.Delete(destBundlePath);
                }
                File.Move(sourceBundlePath, destBundlePath);
                Debug.Log($"Moved and renamed bundle: {sourceBundlePath} to {destBundlePath}");
            }
            catch (System.Exception e)
            {
                Debug.LogError($"Failed to move/rename bundle {sourceBundlePath}: {e.Message}");
            }

            Directory.EnumerateFiles(sourceDir, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);
        }
        else
        {
            Debug.LogWarning($"Bundle file not found: {sourceBundlePath}");
        }
    }
}
