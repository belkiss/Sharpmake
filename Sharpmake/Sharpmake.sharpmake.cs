using System;
using System.IO;
using System.Linq;
using System.Reflection;
using Sharpmake;

namespace SharpmakeGen
{
    [Generate]
    public class SharpmakeProject : Common.SharpmakeBaseProject
    {
        public SharpmakeProject()
        {
            Name = "Sharpmake";

            // indicates where to find the nuget(s) we reference without needing nuget.config or global setting
            CustomProperties.Add("RestoreAdditionalProjectSources", "https://api.nuget.org/v3/index.json");

            // workaround to be able to use Microsoft.Build.Utilities.Core from mono on unix platforms
            NetCoreSdkGACAssemblyLookup = true;
            // resolved runtime target assets should be copied locally.
            //CustomProperties.Add("CopyLocalRuntimeTargetAssets", "true");
            //CustomProperties.Add("CopyLocalLockFileAssemblies", "true");
        }

        public override void ConfigureAll(Configuration conf, Target target)
        {
            base.ConfigureAll(conf, target);
            conf.ProjectPath = @"[project.SourceRootPath]";

            conf.Options.Add(Options.CSharp.AllowUnsafeBlocks.Enabled);

            conf.ReferencesByNuGetPackage.Add("Microsoft.CodeAnalysis.CSharp", "3.8.0");

            // This dependency is not strictly necessary, but Microsoft.CodeAnalysis.CSharp
            // will throw an exception at runtime if the DiaSymReader DLL is not found next to the exe
            conf.ReferencesByNuGetPackage.Add("Microsoft.DiaSymReader.Native", "1.7.0");
            conf.ReferencesByNuGetPackage.Add("Microsoft.VisualStudio.Setup.Configuration.Interop", "2.3.2262-g94fae01e");
            conf.ReferencesByNuGetPackage.Add("Microsoft.Win32.Registry", "5.0.0");
        }
    }
}
