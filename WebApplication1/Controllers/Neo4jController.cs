﻿using Microsoft.Extensions.Logging;
using Neo4j.Driver;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Management;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using ZLogger;

namespace WebApplication1.Controllers
{
    public class Neo4jController : Controller, IDisposable
    {
        private readonly Stopwatch sw = null;
        private readonly Microsoft.Extensions.Logging.ILogger loggyNeo4jLocal;
        private readonly Microsoft.Extensions.Logging.ILogger loggyNeo4jAura;
        private readonly IDriver neoDriverLocal;
        private readonly IDriver neoDriverAura;
        private readonly Dictionary<string, string> neoIdDict = new Dictionary<string, string>() // Key = LocalID, Value = NeoID
        {
            { "1", "12" }, //PR001
            { "2", "13" }, //PR002
            { "3", "14" }, //PR003a
            { "4", "86" }, //PR003b
            { "5", "64" }, //PR004
            { "6", "65" }, //PR005
            { "7", "15" }, //PR101
            { "8", "66" }, //PR102
            { "9", "67" }, //PR103a
            { "10", "68" }, //PR103b
            { "11", "69" }, //PR104
            { "12", "70" }, //PR105
            { "13", "1" }, //PR106a
            { "14", "71" }, //PR106b
            { "15", "72" }, //PR107
            { "16", "16" }, //PR201
            { "17", "17" }, //PR202
            { "18", "18" }, //PR203a
            { "19", "3" }, //PR203b
            { "20", "19" }, //PR204
            { "21", "20" }, //PR205
            { "22", "21" }, //PR206a
            { "23", "2" }, //PR206b
            { "24", "22" }, //PR207
            { "25", "23" }, //PR208a
            { "36", "4" }, //PR208b
            { "26", "24" }, //PR301
            { "27", "25" }, //PR302
            { "28", "26" }, //PR303a
            { "29", "6" }, //PR303b
            { "30", "27" }, //PR304
            { "31", "28" }, //PR305
            { "32", "29" }, //PR306a
            { "33", "5" }, //PR306b
            { "34", "30" }, //PR307
            { "35", "31" }, //PR308a
            { "37", "7" }, //PR308b
            { "46", "32" }, //PR401
            { "47", "33" }, //PR402
            { "48", "34" }, //PR403a
            { "49", "76" }, //PR403b
            { "50", "35" }, //PR404
            { "51", "36" }, //PR405
            { "52", "37" }, //PR406a
            { "53", "73" }, //PR406b
            { "54", "38" }, //PR407
            { "55", "39" }, //PR408a
            { "38", "75" }, //PR408b
            { "56", "40" }, //PR501
            { "57", "41" }, //PR502
            { "58", "42" }, //PR503a
            { "59", "79" }, //PR503b
            { "60", "43" }, //PR504
            { "61", "44" }, //PR505
            { "62", "45" }, //PR506a
            { "63", "78" }, //PR506b
            { "64", "46" }, //PR507
            { "65", "47" }, //PR508a
            { "39", "77" }, //PR508b
            { "66", "48" }, //PR601
            { "67", "49" }, //PR602
            { "68", "50" }, //PR603a
            { "69", "81" }, //PR603b
            { "70", "51" }, //PR604
            { "71", "52" }, //PR605
            { "72", "53" }, //PR606a
            { "73", "82" }, //PR606b
            { "74", "54" }, //PR607
            { "75", "55" }, //PR608a
            { "40", "80" }, //PR608b
            { "76", "56" }, //PR701
            { "77", "57" }, //PR702
            { "78", "58" }, //PR703a
            { "79", "85" }, //PR703b
            { "80", "59" }, //PR704
            { "81", "60" }, //PR705
            { "42", "61" }, //PR706a
            { "43", "84" }, //PR706b
            { "44", "62" }, //PR707
            { "45", "63" }, //PR708a
            { "41", "83" }, //PR708b
            { "82", "8" }, //Scari_1
            { "83", "0" }, //Scari_2
            { "84", "9" }, //Scari_Mici
            { "85", "10" }, //Lift
            { "86", "11" }, //Iesire_1
            { "87", "74" }, //Iesire_2
        };

        public Neo4jController()
        {
            neoDriverLocal = GraphDatabase.Driver("bolt://localhost:7687", AuthTokens.Basic("neo4j", "GrafuriVesele"));
            neoDriverAura = GraphDatabase.Driver("neo4j+s://17a9c69d.databases.neo4j.io", AuthTokens.Basic("neo4j", "9GSC0BlBtfQZvpeMzct_U4O1AKtywsQBPyozr6l5eSw"));

            var factoryLocal = LoggerFactory.Create(logging =>
            {
                logging.SetMinimumLevel(LogLevel.Trace);
                logging.AddZLoggerFile("E:\\Licenta\\PrecisNav\\WebApplication1\\Logs\\Neo4jLocal\\log_" + DateTime.Now.ToString("dd-MM-yyyy") + ".log");
            });
            var factoryAura = LoggerFactory.Create(logging =>
            {
                logging.SetMinimumLevel(LogLevel.Trace);
                logging.AddZLoggerFile("E:\\Licenta\\PrecisNav\\WebApplication1\\Logs\\Neo4jAura\\log_" + DateTime.Now.ToString("dd-MM-yyyy") + ".log");
            });

            loggyNeo4jLocal = factoryLocal.CreateLogger("Neo4j_Logs_Local");
            loggyNeo4jAura = factoryAura.CreateLogger("Neo4j_Logs_Aura");
            sw = new Stopwatch();
        }

        [Obsolete]
        public async Task<string> CalculeazaTraseu(bool aura, string punctPlecare, string punctDestinatie, bool filtruScari, string puncteEvitate = "", string puncteIntermediare = "")
        {
            string traseu = "", idStart = "", idEnd = "", harta = "", checkCypher = "", dateRulare = "", pondere="0";
            string[] puncteEvitateList = { }, puncteIntermediareList = { };
            int lenVia = 0;
            float ram = 0;
            double cpu;

            try
            {
                idStart = neoIdDict[punctPlecare];
                idEnd = neoIdDict[punctDestinatie];

                Dictionary<string, object> para = new Dictionary<string, object>()
                {
                    { "idStart", idStart },
                    { "idEnd", idEnd }
                };

                if (puncteEvitate != "")
                {
                    puncteEvitateList = puncteEvitate.Split(',');
                    int lenAnti = puncteEvitateList.Length;
                    for (int i = 0; i < lenAnti; i++) puncteEvitateList[i] = neoIdDict[puncteEvitateList[i]];
                }

                if (puncteIntermediare != "")
                {
                    puncteIntermediareList = puncteIntermediare.Split(',');
                    lenVia = puncteIntermediareList.Length;
                    for (int i = 0; i < lenVia; i++) puncteIntermediareList[i] = neoIdDict[puncteIntermediareList[i]];
                }

                harta += filtruScari ? "hartaFaraScari" : "hartaCompleta";
                harta += puncteEvitate.Replace(",", "o");

                //hartaCompleta este graful complet
                //hartaFaraScari este graful fara nodurile de tip scari
                //La ambele se poate concatena un sir de nr = punctele ce se doresc evitate
                
                //Verifica daca este proiectat in memorie o harta corespunzatoare
                checkCypher += "CALL apoc.when(NOT gds.graph.exists(\"" + harta + "\"), \"MATCH (n)-[r]->(m) ";
                if (filtruScari || puncteEvitate != "") checkCypher += "WHERE ";
                if (filtruScari) checkCypher += "(NOT n:scari) AND (NOT m:scari) ";
                if (puncteEvitate != "")
                {
                    if (filtruScari) checkCypher += "AND ";

                    checkCypher += "NOT id(n) IN [";
                    foreach (string pel in puncteEvitateList) checkCypher += "toInteger(" + pel + "), ";
                    checkCypher = checkCypher.Substring(0, checkCypher.Length - 2);
                    checkCypher += "] ";
                }
                checkCypher += "WITH gds.graph.project('" + harta + "', n, m, { relationshipProperties: r { .pondere } }) AS graf" + harta + " RETURN 'ok'\")";

                var ses = aura ? neoDriverAura.AsyncSession() : neoDriverLocal.AsyncSession();
                var res = await ses.ExecuteReadAsync(async tx =>
                {
                    sw.Start();

                    await tx.RunAsync(checkCypher);

                    //Calculeaza traseul si ponderea (fara puncte intermediare)
                    if (puncteIntermediare == "")
                    {
                        //Calcul traseu
                        var result = await tx.RunAsync("MATCH (start), (end) " +
                                            "WHERE id(start) = toInteger($idStart) AND id(end) = toInteger($idEnd) " +
                                            "CALL gds.shortestPath.dijkstra.stream(\"" + harta + "\", {" +
                                                "sourceNode: start, targetNode: end, " +
                                                "relationshipWeightProperty: \"pondere\"}) " +
                                            "YIELD totalCost, path " +
                                            "RETURN nodes(path) as path, totalCost", para);
                        var record = await result.SingleAsync();

                        //Formateaza JSON-ul care contine traseul complet + costul + alte detalii
                        pondere = record[1].As<string>();
                        traseu = "{ \"Pondere\": " + pondere + ", \"Traseu\": [";
                        foreach (var node in record[0].As<List<INode>>())
                            traseu += "{\"nume\": \"" + node.Properties["name"].ToString() + "\", \"id\": " + neoIdDict.FirstOrDefault(x => x.Value == node.Id.ToString()).Key + "},";
                        traseu = traseu.Substring(0, traseu.Length - 1);
                        traseu += "], ";
                    }
                    else
                    {
                        int costTraseuVia = 999, costTemp;
                        string traseuTemp = "{\"Traseu\": [";

                        for (int i = 0; i < lenVia; i++)
                        {
                            costTemp = 0;

                            //Calcul traseu Start - puncteIntermediareList - End
                            var result = await tx.RunAsync("MATCH (start), (end) " +
                                            "WHERE id(start) = toInteger($idStart) AND id(end) = toInteger(" + puncteIntermediareList[0] + ") " +
                                            "CALL gds.shortestPath.dijkstra.stream(\"" + harta + "\", {" +
                                                "sourceNode: start, targetNode: end, " +
                                                "relationshipWeightProperty: \"pondere\"}) " +
                                            "YIELD totalCost, path " +
                                            "RETURN nodes(path) as path, totalCost", para);
                            var record = await result.SingleAsync();
                            costTemp += record[1].As<int>();
                            foreach (var node in record[0].As<List<INode>>())
                                traseuTemp += "{\"nume\": \"" + node.Properties["name"].ToString() + "\", \"id\": " + neoIdDict.FirstOrDefault(x => x.Value == node.Id.ToString()).Key + "},";

                            for (int j = 0; j < lenVia - 1; j++)
                            {
                                result = await tx.RunAsync("MATCH (start), (end) " +
                                            "WHERE id(start) = toInteger(" + puncteIntermediareList[j] + ") AND id(end) = toInteger(" + puncteIntermediareList[j+1] + ") " +
                                            "CALL gds.shortestPath.dijkstra.stream(\"" + harta + "\", {" +
                                                "sourceNode: start, targetNode: end, " +
                                                "relationshipWeightProperty: \"pondere\"}) " +
                                            "YIELD totalCost, path " +
                                            "RETURN nodes(path) as path, totalCost", para);
                                record = await result.SingleAsync();
                                costTemp += record[1].As<int>();
                                foreach (var node in record[0].As<List<INode>>())
                                    traseuTemp += "{\"nume\": \"" + node.Properties["name"].ToString() + "\", \"id\": " + neoIdDict.FirstOrDefault(x => x.Value == node.Id.ToString()).Key + "},";
                            }

                            result = await tx.RunAsync("MATCH (start), (end) " +
                                                    "WHERE id(start) = toInteger(" + puncteIntermediareList[lenVia - 1] + ") AND id(end) = toInteger($idEnd) " +
                                                    "CALL gds.shortestPath.dijkstra.stream(\"" + harta + "\", {" +
                                                        "sourceNode: start, targetNode: end, " +
                                                        "relationshipWeightProperty: \"pondere\"}) " +
                                                    "YIELD totalCost, path " +
                                                    "RETURN nodes(path) as path, totalCost", para);
                            record = await result.SingleAsync();
                            costTemp += record[1].As<int>();
                            foreach (var node in record[0].As<List<INode>>())
                                traseuTemp += "{\"nume\": \"" + node.Properties["name"].ToString() + "\", \"id\": " + neoIdDict.FirstOrDefault(x => x.Value == node.Id.ToString()).Key + "},";

                            traseuTemp = traseuTemp.Substring(0, traseuTemp.Length - 1);
                            pondere = costTemp.ToString();
                            traseuTemp += "], \"Pondere\": " + pondere + ", ";

                            //Compara costul total al traseului cu ultimul salvat si retine traseul JSON + costul daca este mai mic
                            if (costTemp < costTraseuVia)
                            {
                                costTraseuVia = costTemp;
                                traseu = traseuTemp;
                            }

                            //Permuta puncteIntermediareList --> Primul element devine ultimul
                            traseuTemp = puncteIntermediareList[0];
                            for (int j = 0; j < lenVia - 1; j++)
                                puncteIntermediareList[j] = puncteIntermediareList[j + 1];
                            puncteIntermediareList[lenVia - 1] = traseuTemp;
                            traseuTemp = "{\"Traseu\": [";
                        }
                    }

                    //Daca a fost o harta personalizata trebuie eliminata proiectia din memorie
                    if (harta != "hartaCompleta" && harta != "hartaFaraScari")
                        await tx.RunAsync("CALL gds.graph.drop('" + harta + "')");

                    sw.Stop();
                    return traseu;
                });

                if (!aura)
                {
                    //Calcul memorie
                    ram = new PerformanceCounter("Process", "Working Set - Private", "Neo4j Desktop").NextValue() / (1024 * 1024);

                    //Calcul CPU
                    PerformanceCounter cpuIdlePC = new PerformanceCounter("Process", "% Processor Time", "_Total");
                    double timpTotal = 0.0;
                    Process[] proceseleInteres = Process.GetProcessesByName("Neo4j Desktop");
                    cpuIdlePC.NextValue();
                    foreach (Process proc in proceseleInteres)
                        timpTotal += proc.TotalProcessorTime.TotalMilliseconds;
                    Thread.Sleep(1500);
                    cpu = sw.ElapsedMilliseconds * cpuIdlePC.NextValue() / timpTotal;

                    dateRulare = "{ " +
                        "\"DateTime\": \"" + DateTime.Now.ToString("dd-MM-yyyy HH:mm") + "\", " +
                        "\"Pondere\": \"" + pondere + "\", " +
                        "\"NrPuncteIntermediare\": \"" + puncteIntermediareList.Length.ToString() + "\", " +
                        "\"NrPuncteEvitate\": \"" + puncteEvitateList.Length.ToString() + "\", " +
                        "\"TimpExecutie_ms\": \"" + sw.ElapsedMilliseconds.ToString() + "\", " +
                        "\"MemorieUtilizata_MB\": \"" + ram.ToString() + "\", " +
                        "\"CPU_Pr\": \"" + cpu.ToString() + "\" " +
                    "}";
                }
                else
                    dateRulare = "{ " + 
                        "\"DateTime\": \"" + DateTime.Now.ToString("dd-MM-yyyy HH:mm") + "\", " +
                        "\"Pondere\": \"" + pondere + "\", " +
                        "\"NrPuncteIntermediare\": \"" + puncteIntermediareList.Length.ToString() + "\", " +
                        "\"NrPuncteEvitate\": \"" + puncteEvitateList.Length.ToString() + "\", " +
                        "\"TimpExecutie_ms\": \"" + sw.ElapsedMilliseconds.ToString() + "\"" +
                    "}";


                traseu += "\"DateRulare\": " + dateRulare + "}";
                if (aura) loggyNeo4jAura.LogInformation(dateRulare);
                else loggyNeo4jLocal.LogInformation(dateRulare);
            }
            catch (Exception ex) {
                Console.WriteLine(ex);
                traseu = ex.ToString();
            }
            
            return traseu;
        }

        void IDisposable.Dispose()
        {
            neoDriverLocal?.Dispose();
            neoDriverAura?.Dispose();
        }
    }
}