using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.OleDb;
/// <summary>
/// Summary description for Class1
/// </summary>
namespace query
{
    public static class queries
    {
        public static string connconst(HttpServerUtility Server)
        {
            return "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb");
        }
        public static bool connected(string str, HttpServerUtility Server)
        {
            bool b = false;
            OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
            conn.Open();
            OleDbDataReader dr = query("select * from tusers where Username=" + str,conn);
            b = dr.Read();
            conn.Close();
            return b;
        }
        /// <summary>
        /// Checks if the user given is administrator
        /// </summary>
        /// <param name="username">the name of the user to be checked</param>
        /// <param name="Server">the ServerUtility 
        /// (Used for the global location of the database)</param>
        /// <returns></returns>
        public static bool admin(string username,HttpServerUtility Server)
        {
            bool b = false;
            OleDbConnection conn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Server.MapPath("db.accdb"));
            conn.Open();
            OleDbDataReader dr = query("select * from tusers where Username='" + username + "'", conn);
            if (dr.Read())
                b = dr["permissions"].ToString() == "2";
            conn.Close();
            return b;
        }
        /// <summary>
        /// Executes a DML SQL query to the database (mine database daa)
        /// </summary>
        /// <param name="sql">the SQL query</param>
        /// <param name="conn">the connection to the database</param>
        public static void updateQuery(string sql, OleDbConnection conn)
        {
            OleDbCommand cmd = new OleDbCommand(sql, conn);
            cmd.ExecuteNonQuery();
        }
        /// <summary>
        /// Executes a SELECT SQL query and return OLEDB DataReader data structure- 
        /// with the results
        /// </summary>
        /// <param name="sql">the SQL query</param>
        /// <param name="conn">the connection to the database</param>
        /// <returns></returns>
        public static OleDbDataReader query(string sql, OleDbConnection conn)
        {
            OleDbCommand cmd = new OleDbCommand(sql, conn);
            OleDbDataReader dr = cmd.ExecuteReader();
            return dr;
        }
        public static int ConvertToUnixTimestamp()
        {
            DateTime date = DateTime.Now;
            DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
            TimeSpan diff = date.ToUniversalTime() - origin;
            return (int)Math.Floor(diff.TotalSeconds);
        }
    }
}