using Neo4j.Driver;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace WebApplication1.Controllers
{
    public class Neo4jController : Controller, IDisposable
    {
        private readonly IDriver neoDriver;
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
            { "82", "61" }, //PR706a
            { "83", "84" }, //PR706b
            { "84", "62" }, //PR707
            { "85", "63" }, //PR708a
            { "41", "83" }, //PR708b
        };

        public Neo4jController()
        {
            neoDriver = GraphDatabase.Driver("bolt://localhost:7687", AuthTokens.Basic("neo4j", "GrafuriVesele"));
        }

        [Obsolete]
        public async Task<string> CalculeazaTraseu(string punctPlecare, string punctDestinatie, bool filtruScari, string puncteEvitate = "")
        {
            string traseu = "", idStart = "", idEnd = "", harta = "", checkCypher = "";

            try
            {
                idStart = neoIdDict[punctPlecare];
                idEnd = neoIdDict[punctDestinatie];

                Dictionary<string, object> para = new Dictionary<string, object>()
                {
                    { "idStart", idStart },
                    { "idEnd", idEnd }
                };

                string[] puncteEvitateList = puncteEvitate.Split(',');
                int len = puncteEvitateList.Length;
                for (int i = 0; i < len; i++) puncteEvitateList[i] = neoIdDict[puncteEvitateList[i]];

                harta += filtruScari ? "hartaFaraScari" : "hartaCompleta";
                harta += puncteEvitate.Replace(",", "o");

                //hartaCompleta este graful complet
                //hartaFaraScari este graful fara nodurile de tip scari
                //La ambele se poate concatena un sir de nr = punctele ce se doresc evitate

                var ses = neoDriver.AsyncSession();
                var res = await ses.ExecuteWriteAsync(async tx =>
                {
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

                    await tx.RunAsync(checkCypher);

                    //Calculeaza traseul si ponderea
                    var result = await tx.RunAsync("MATCH (start), (end) " +
                                        "WHERE id(start) = toInteger($idStart) AND id(end) = toInteger($idEnd) " +
                                        "CALL gds.shortestPath.dijkstra.stream(\"" + harta + "\", {" +
                                            "sourceNode: start, targetNode: end, " +
                                            "relationshipWeightProperty: \"pondere\"}) " +
                                        "YIELD totalCost, path " +
                                        "RETURN nodes(path) as path, totalCost", para);
                    var record = await result.SingleAsync();

                    //Daca a fost o harta personalizata trebuie eliminata proiectia din memorie
                    if (harta != "hartaCompleta" && harta != "hartaFaraScari")
                        await tx.RunAsync("CALL gds.graph.drop('" + harta + "')");

                    //Formateaza JSON-ul care contine traseul complet + costul + alte detalii
                    traseu = "{ \"Pondere\": " + record[1].As<string>() + ", \"Traseu\": [";
                    foreach (var node in record[0].As<List<INode>>())
                        traseu += "{\"nume\": \"" + node.Properties["name"].ToString() + "\", \"id\": " + node.Id.ToString() + "},";
                    traseu = traseu.Substring(0, traseu.Length - 1);
                    traseu += "]}";

                    return traseu;
                });
            } catch (Exception ex) {
                Console.WriteLine(ex);
            }
            
            return traseu;
        }

        void IDisposable.Dispose()
        {
            neoDriver?.Dispose();
        }
    }
}