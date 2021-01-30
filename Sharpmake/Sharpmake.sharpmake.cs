﻿using System;
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

            CustomProperties.Add("AssemblySearchPaths", "$(AssemblySearchPaths);{CandidateAssemblyFiles};{HintPathFromItem};{TargetFrameworkDirectory};{GAC};{RawFileName}");
            // resolved runtime target assets should be copied locally.
            //CustomProperties.Add("CopyLocalRuntimeTargetAssets", "true");
            //CustomProperties.Add("CopyLocalLockFileAssemblies", "true");
        }

        public override void ConfigureAll(Configuration conf, Target target)
        {
            base.ConfigureAll(conf, target);
            conf.ProjectPath = @"[project.SourceRootPath]";

            conf.Options.Add(Options.CSharp.AllowUnsafeBlocks.Enabled);

            // this needs to remain a named reference otherwise the assembly won't work on mono for on unix platforms
            conf.ReferencesByNameExternal.Add("Microsoft.Build.Utilities.Core");

            conf.ReferencesByNuGetPackage.Add("Microsoft.CodeAnalysis.CSharp", "3.8.0");

            // This dependency is not strictly necessary, but Microsoft.CodeAnalysis.CSharp
            // will throw an exception at runtime if the DiaSymReader DLL is not found next to the exe
            conf.ReferencesByNuGetPackage.Add("Microsoft.DiaSymReader.Native", "1.7.0");
            conf.ReferencesByNuGetPackage.Add("Microsoft.VisualStudio.Setup.Configuration.Interop", "1.16.30");
        }
    }
}
