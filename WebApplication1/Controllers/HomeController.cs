using Neo4j.Driver;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using System.Web.UI.WebControls;

namespace WebApplication1.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            return View();
        }

        public string GetStats()
        {
            JObject result = new JObject();
            JObject jsonLine = new JObject(); ;
            JArray ja = new JArray();
            string log;
            IEnumerable<string> lines;

            //SQL Server
            log = "E:\\Licenta\\PrecisNav\\WebApplication1\\Logs\\SQLServer\\log_" + DateTime.Now.ToString("dd-MM-yyyy") + ".log";
            try
            {
                lines = System.IO.File.ReadLines(log);
                foreach (var line in lines) {
                    if (line != null && line != "") jsonLine = JObject.Parse(line);
                    ja.Add(jsonLine);
                }
            }catch (Exception ex) { Console.WriteLine(ex); }

            result["SQLServer"] = ja;

            //Neo4j
            ja = new JArray();
            log = "E:\\Licenta\\PrecisNav\\WebApplication1\\Logs\\Neo4j\\log_" + DateTime.Now.ToString("dd-MM-yyyy") + ".log";
            try
            {
                lines = System.IO.File.ReadLines(log);
                foreach (var line in lines)
                {
                    if (line != null && line != "") jsonLine = JObject.Parse(line);
                    ja.Add(jsonLine);
                }
            }
            catch (Exception ex) { Console.WriteLine(ex); }

            result["Neo"] = ja;

            return result.ToString();
        }
    }
}