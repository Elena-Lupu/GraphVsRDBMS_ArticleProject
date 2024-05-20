using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static Microsoft.ClearScript.V8.V8CpuProfile;

namespace WebApplication1.Controllers
{
    public class SQLServerController : Controller, IDisposable
    {
        private readonly SqlConnection sqlServerDriver = null;
        private readonly Dictionary<string, string> sqlServerIdDict = new Dictionary<string, string>() // Key = LocalID, Value = sqlServerID
        {
            { "1", "1" }, //PR001
            { "2", "2" }, //PR002
            { "3", "3" }, //PR003a
            { "4", "4" }, //PR003b
            { "5", "5" }, //PR004
            { "6", "6" }, //PR005
            { "7", "13" }, //PR101
            { "8", "14" }, //PR102
            { "9", "15" }, //PR103a
            { "10", "16" }, //PR103b
            { "11", "17" }, //PR104
            { "12", "18" }, //PR105
            { "13", "19" }, //PR106a
            { "14", "20" }, //PR106b
            { "15", "21" }, //PR107
            { "16", "22" }, //PR201
            { "17", "23" }, //PR202
            { "18", "24" }, //PR203a
            { "19", "25" }, //PR203b
            { "20", "26" }, //PR204
            { "21", "27" }, //PR205
            { "22", "28" }, //PR206a
            { "23", "29" }, //PR206b
            { "24", "30" }, //PR207
            { "25", "31" }, //PR208a
            { "36", "32" }, //PR208b
            { "26", "33" }, //PR301
            { "27", "34" }, //PR302
            { "28", "35" }, //PR303a
            { "29", "36" }, //PR303b
            { "30", "37" }, //PR304
            { "31", "38" }, //PR305
            { "32", "39" }, //PR306a
            { "33", "40" }, //PR306b
            { "34", "41" }, //PR307
            { "35", "42" }, //PR308a
            { "37", "43" }, //PR308b
            { "46", "44" }, //PR401
            { "47", "45" }, //PR402
            { "48", "46" }, //PR403a
            { "49", "47" }, //PR403b
            { "50", "48" }, //PR404
            { "51", "49" }, //PR405
            { "52", "50" }, //PR406a
            { "53", "51" }, //PR406b
            { "54", "52" }, //PR407
            { "55", "53" }, //PR408a
            { "38", "54" }, //PR408b
            { "56", "55" }, //PR501
            { "57", "56" }, //PR502
            { "58", "57" }, //PR503a
            { "59", "58" }, //PR503b
            { "60", "59" }, //PR504
            { "61", "60" }, //PR505
            { "62", "61" }, //PR506a
            { "63", "62" }, //PR506b
            { "64", "63" }, //PR507
            { "65", "64" }, //PR508a
            { "39", "65" }, //PR508b
            { "66", "66" }, //PR601
            { "67", "67" }, //PR602
            { "68", "68" }, //PR603a
            { "69", "69" }, //PR603b
            { "70", "70" }, //PR604
            { "71", "71" }, //PR605
            { "72", "72" }, //PR606a
            { "73", "73" }, //PR606b
            { "74", "74" }, //PR607
            { "75", "75" }, //PR608a
            { "40", "76" }, //PR608b
            { "76", "77" }, //PR701
            { "77", "78" }, //PR702
            { "78", "79" }, //PR703a
            { "79", "80" }, //PR703b
            { "80", "81" }, //PR704
            { "81", "82" }, //PR705
            { "82", "83" }, //PR706a
            { "83", "84" }, //PR706b
            { "84", "85" }, //PR707
            { "85", "86" }, //PR708a
            { "41", "87" }, //PR708b
        };

        public SQLServerController() {
            SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder();

            sb.DataSource = "AGENTZ\\SQLEXPRESS";
            sb.InitialCatalog = "Precis";
            sb.UserID = "sa";
            sb.IntegratedSecurity = true;

            sqlServerDriver = new SqlConnection(sb.ConnectionString);
            sqlServerDriver.Open();
        }

        public string CalculeazaTraseu(string punctPlecare, string punctDestinatie, bool filtruScari, string puncteEvitate)
        {
            string idStart = "", idEnd = "", traseu = "";

            try
            {
                idStart = sqlServerIdDict[punctPlecare];
                idEnd = sqlServerIdDict[punctDestinatie];

                Dictionary<string, object> para = new Dictionary<string, object>()
                {
                    { "StartNode", idStart },
                    { "EndNode", idEnd },
                    { "FaraScari", filtruScari }
                };

                using (SqlCommand cmd = new SqlCommand("dbo.CalculeazaTraseu", sqlServerDriver))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                
                    foreach (KeyValuePair<string, object> k in para)
                        cmd.Parameters.AddWithValue(k.Key, k.Value);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        traseu = "{ \"Pondere\": " + reader.GetInt32(0) + ", \"Traseu\": [";
                        string[] pathIds = reader.GetString(1).Split(',');
                        string[] pathNames = reader.GetString(2).Split(',');
                        for (int i = 0; i < pathIds.Length; i++)
                            traseu += "{\"nume\": \"" + pathNames[i] + "\", \"id\": " + pathIds[i] + "},";
                    }
                    traseu = traseu.Substring(0, traseu.Length - 1);
                    traseu += "]}";

                    reader.Close();
                }
            } catch (Exception ex)
            {
                Console.WriteLine(ex);
            }

            return traseu;
        }

        void IDisposable.Dispose()
        {
            sqlServerDriver?.Dispose();
        }
    }
}