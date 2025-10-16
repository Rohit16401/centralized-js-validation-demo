using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Employee.Models
{
    public class EmployeesModel
    {
        //Data Source=1153-3853;Initial Catalog=sample;Integrated Security=True
        public int EId { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public long Phone { get; set; }
        public string Gender { get; set; }
        public string Department { get; set; }
        public string Address { get; set; }
    }
}