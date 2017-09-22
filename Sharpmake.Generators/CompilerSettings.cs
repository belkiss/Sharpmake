﻿// Copyright (c) 2017 Ubisoft Entertainment
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
using System.Collections.Generic;

namespace Sharpmake.Generators
{
    public class CompilerSettings
    {
        public string CompilerName { get; private set; }
        public Platform PlatformFlags { get; set; } // TODO: Remove the public setter.
        public Strings ExtraFiles { get; private set; }
        public string Executable { get; private set; }
        public string RootPath { get; private set; }
        public DevEnv DevEnv { get; set; }
        public IDictionary<string, Configuration> Configurations { get; private set; }

        public CompilerSettings(
            string compilerName,
            Platform platform,
            Strings extraFiles,
            string executable,
            string rootPath,
            DevEnv devEnv,
            IDictionary<string, Configuration> configurations
        )
        {
            CompilerName = compilerName;
            PlatformFlags = platform;
            ExtraFiles = extraFiles;
            Executable = executable;
            RootPath = rootPath;
            DevEnv = devEnv;
            Configurations = configurations;
        }

        public class Configuration
        {
            public string BinPath { get; set; }
            public string LinkerPath { get; set; }
            public string ResourceCompiler { get; set; }
            public string Compiler { get; set; }
            public string Librarian { get; set; }
            public string Linker { get; set; }
            public string PlatformLibPaths { get; set; }
            public string Masm { get; set; }
            public string Executable { get; set; }
            public string UsingOtherConfiguration { get; set; }
            public Platform Platform { get; private set; }

            public Configuration(
                Platform platform,
                string binPath = FileGeneratorUtilities.RemoveLineTag,
                string linkerPath = FileGeneratorUtilities.RemoveLineTag,
                string resourceCompiler = FileGeneratorUtilities.RemoveLineTag,
                string compiler = FileGeneratorUtilities.RemoveLineTag,
                string librarian = FileGeneratorUtilities.RemoveLineTag,
                string linker = FileGeneratorUtilities.RemoveLineTag,
                string executable = FileGeneratorUtilities.RemoveLineTag,
                string usingOtherConfiguration = FileGeneratorUtilities.RemoveLineTag
            )
            {
                BinPath = binPath;
                LinkerPath = linkerPath;
                ResourceCompiler = resourceCompiler;
                Compiler = compiler;
                Librarian = librarian;
                Linker = linker;
                Executable = executable;
                UsingOtherConfiguration = usingOtherConfiguration;
                Platform = platform;
            }
        }
    }
}
