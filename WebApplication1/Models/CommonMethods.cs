using log4net.Core;
using log4net.Layout;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;

namespace WebApplication1.Models
{
    public class CommonMethods
    {
        public string db { get; set; }

        public CommonMethods(string dbName)
        {
            db = dbName;
        }

        public float getTotalMemoryUsage()
        {
            float totalMemoryUsage = 0;
            Process[] procs = Process.GetProcessesByName(db);

            foreach (Process proc in procs)
                totalMemoryUsage += proc.WorkingSet64;

            return totalMemoryUsage;
        }
    }
}