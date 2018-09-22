using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;

namespace WebApplication.Views.SYSADMIN
{
    public partial class HealthMonitoring : Page
    {
        /// <summary>
        /// Page Load event handler for the Page
        /// </summary>
        /// <param name="sender">Health Monitoring Page as sender</param>
        /// <param name="e">Event Arguments</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            ShowClearButton();
        }

        // Showing or Hiding Clear button from UI
        private void ShowClearButton()
        {
            if (EventLog.Rows.Count > 0)
            {
                ClearDataButton.Visible = true;
            }
            else
            {
                ClearDataButton.Visible = false;
            }
        }

        /// <summary>
        /// Executing SQL scripts on the database
        /// </summary>
        /// <param name="sqlScript">SQL Script to execute</param>
        public void RunSQL(string sqlScript)
        {
            if (ConfigurationManager.ConnectionStrings["ApplicationServices"].ConnectionString == null)
            {
                throw new ArgumentException("ApplicationServices connection string required.");
            }

            string connectionString = ConfigurationManager.ConnectionStrings["ApplicationServices"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(connectionString);
            SqlCommand sqlCommand = new SqlCommand(sqlScript, sqlConnection);

            try
            {
                sqlConnection.Open();
                sqlCommand.Connection = sqlConnection;
                sqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);
            }
            finally
            {
                sqlConnection.Close();
            }
        }

        /// <summary>
        /// Clearing data from Event Log grid
        /// </summary>
        /// <param name="sender">Clear Data button as sender</param>
        /// <param name="e">Event Argument</param>
        protected void ClearDataClicked(object sender, EventArgs e)
        {
            String mysql = "DELETE FROM [aspnet_WebEvent_Events]";
            RunSQL(mysql);
            EventLog.DataBind();
        }
    }
}