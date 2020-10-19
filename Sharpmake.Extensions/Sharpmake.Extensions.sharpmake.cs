using System;
using Sharpmake;

[module: Sharpmake.Include("*/Sharpmake.*.sharpmake.cs")]

namespace SharpmakeGen.Extensions
{
    public abstract class ExtensionBaseProject : Common.SharpmakeBaseProject
    {
        protected ExtensionBaseProject()
        {
            AssemblyName = "[project.Name]";
            RootNamespace = "Sharpmake";
        }

        public override void ConfigureAll(Configuration conf, Target target)
        {
            base.ConfigureAll(conf, target);

            conf.ProjectFileName = "[project.Name]";
            conf.SolutionFolder = "Extensions";

            var libTarget = target;
            if (target.Framework != Common.DefaultLibDotNetFramework)
                libTarget = (Target)target.Clone(Common.DefaultLibDotNetFramework);
            conf.AddPrivateDependency<SharpmakeProject>(libTarget);
            conf.AddPrivateDependency<SharpmakeGeneratorsProject>(libTarget);
        }
    }

    public abstract class ExtensionProject : ExtensionBaseProject
    {
        protected ExtensionProject()
        {
            AddTargets(Common.GetDefaultLibTargets());
        }
    }

    public abstract class ExtensionCoreProject : ExtensionBaseProject
    {
        protected ExtensionCoreProject()
        {
            AddTargets(Common.GetDefaultAppTargets());
        }
    }
}
