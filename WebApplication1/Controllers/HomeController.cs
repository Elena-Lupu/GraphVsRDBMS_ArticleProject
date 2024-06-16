using Neo4j.Driver;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using System.Web.UI.WebControls;
using System.Diagnostics;

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
            citireaSQL:
            try
            {
                lines = System.IO.File.ReadLines(log);
                foreach (var line in lines) {
                    if (line != null && line != "")
                        try { jsonLine = JObject.Parse(line); }
                        catch { continue; }
                    ja.Add(jsonLine);
                }
            }
            catch (IOException)
            {
                System.IO.File.Copy(log, "E:\\Licenta\\PrecisNav\\WebApplication1\\Logs\\SQLServer\\log_" + DateTime.Now.ToString("dd-MM-yyyy") + "-Copie.log", true);
                log = "E:\\Licenta\\PrecisNav\\WebApplication1\\Logs\\SQLServer\\log_" + DateTime.Now.ToString("dd-MM-yyyy") + "-Copie.log";
                goto citireaSQL;
            }
            catch (Exception ex) { Console.WriteLine(ex); }

            result["SQLServer"] = ja;

            //Neo4j
            ja = new JArray();
            log = "E:\\Licenta\\PrecisNav\\WebApplication1\\Logs\\Neo4j\\log_" + DateTime.Now.ToString("dd-MM-yyyy") + ".log";
            citireaNeo:
            try
            {
                lines = System.IO.File.ReadLines(log);
                foreach (var line in lines)
                {
                    if (line != null && line != "")
                        try { jsonLine = JObject.Parse(line); }
                        catch { continue; }
                    ja.Add(jsonLine);
                }
            }
            catch (IOException)
            {
                System.IO.File.Copy(log, "E:\\Licenta\\PrecisNav\\WebApplication1\\Logs\\Neo4j\\log_" + DateTime.Now.ToString("dd-MM-yyyy") + "-Copie.log", true);
                log = "E:\\Licenta\\PrecisNav\\WebApplication1\\Logs\\Neo4j\\log_" + DateTime.Now.ToString("dd-MM-yyyy") + "-Copie.log";
                goto citireaNeo;
            }
            catch (Exception ex) { Console.WriteLine(ex); }

            result["Neo"] = ja;

            return result.ToString();
        }
    }
}