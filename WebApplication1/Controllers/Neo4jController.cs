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

        public Neo4jController()
        {
            neoDriver = GraphDatabase.Driver("bolt://localhost:7687", AuthTokens.Basic("neo4j", "GrafuriVesele"));
        }

        [Obsolete]
        public async Task<string> CalculeazaTraseu(string punctPlecare, string punctDestinatie)
        {
            string traseu = "", cypher = "";

            cypher = "MATCH (start), (end) " +
                "WHERE id(start) = 15 AND id(end) = 12 " +
                "CALL apoc.algo.dijkstra(start, end, 'r', 'pondere') YIELD path, weight " +
                "RETURN path AS Path, weight AS Weight";

            var ses = neoDriver.AsyncSession();
            var res = await ses.ExecuteWriteAsync(async tx =>
            {
                var result = await tx.RunAsync(cypher);
                var record = await result.SingleAsync();

                traseu = "{ \"Pondere\": " + record[1].As<string>() + ", \"Traseu\": [";
                foreach (var node in record[0].As<IPath>().Nodes)
                    traseu += "{\"nume\": \"" + node.Properties["name"].ToString() + "\", \"id\": " + node.Id.ToString() + "},";
                traseu = traseu.Substring(0, traseu.Length - 1);
                traseu += "]}";

                return traseu;
            });

            return traseu;
        }

        void IDisposable.Dispose()
        {
            neoDriver?.Dispose();
        }
    }
}