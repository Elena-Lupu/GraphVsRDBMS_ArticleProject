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
    public class RunLogFormat : LayoutSkeleton
    {
        public override void ActivateOptions()
        {
        }

        public override void Format(TextWriter writer, LoggingEvent e)
        {
            var log = new
            {
                messageObject = e.MessageObject,
                logger = e.LoggerName,
                location = e.LocationInformation.ClassName,
            };

            writer.WriteLine(JsonConvert.SerializeObject(log));
        }
    }
}