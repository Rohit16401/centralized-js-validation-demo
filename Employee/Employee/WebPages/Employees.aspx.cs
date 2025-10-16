using System;
using Employee.Models;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Employee.WebPages
{
    public partial class Employees : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string  SaveEmployee(EmployeesModel emp)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["sample"].ConnectionString;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = @"INSERT INTO EMPLOYEES (Name,Email,Phone,Gender,Department,Address) VALUES(@Name,@Email,@Phone,@Gender,@Department,@Address)";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Name", emp.Name);
                    cmd.Parameters.AddWithValue("@Email", emp.Email);
                    cmd.Parameters.AddWithValue("@Phone", emp.Phone);
                    cmd.Parameters.AddWithValue("@Gender", emp.Gender);
                    cmd.Parameters.AddWithValue("@Department", emp.Department);
                    cmd.Parameters.AddWithValue("@Address", emp.Address);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                return "Employee saved successfully!";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }

        }
        
    }
}