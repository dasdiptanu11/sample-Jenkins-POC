using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SampleTest
{
    public partial class SampleTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Button1_Click(object sender, EventArgs e)
        {
           

            switch (OperatorDropDownList.SelectedValue)
            {
                case " ":
                    result.Text = "Please select Operator";
                    break;
                case "+":
                    int a = Convert.ToInt32(input1.Text);
                    int b = Convert.ToInt32(input2.Text);
                    result.Text = (a + b).ToString();
                    break;
                case "-":
                    a = Convert.ToInt32(input1.Text);
                    b = Convert.ToInt32(input2.Text);
                    result.Text = (a - b).ToString();
                    break;
                case "*":
                    a = Convert.ToInt32(input1.Text);
                    b = Convert.ToInt32(input2.Text);
                    result.Text = (a * b).ToString();
                    break;
                case "/":
                    a = Convert.ToInt32(input1.Text);
                    b = Convert.ToInt32(input2.Text);
                    result.Text = ((a > b) ? a / b : b / a).ToString();
                    break;
                default:
                    result.Text = "Please select Operator";
                    break;
            }
        }
    }
}