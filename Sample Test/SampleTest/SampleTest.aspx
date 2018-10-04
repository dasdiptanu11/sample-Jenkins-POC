<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SampleTest.aspx.cs" Inherits="SampleTest.SampleTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <h1>Sample Jenkins test project</h1>
        <div>
            This a sample project to test Jenkins build v3.0
            Code of branch Master
        </div>
        <table>
            <tr>
                <td>
                    <table>
            <tr>
                <td> <asp:TextBox ID="input1" runat="server"></asp:TextBox></td>
                </tr>
            <tr>
                <td>
                <asp:DropDownList ID="OperatorDropDownList" runat="server">
                    <asp:ListItem> </asp:ListItem>
                    <asp:ListItem>+</asp:ListItem>
                    <asp:ListItem>-</asp:ListItem>
                    <asp:ListItem>*</asp:ListItem>
                    <asp:ListItem>/</asp:ListItem>
                </asp:DropDownList></td></tr>
            <tr>
                <td> <asp:TextBox ID="input2" runat="server"></asp:TextBox></td>
            </tr>
        </table>
                </td>
                <td> <asp:Button ID="Button1" runat="server" Text="=" OnClick="Button1_Click" /> </td>
                
                <td>
                    <asp:TextBox ID="result" runat="server" Enabled="false"></asp:TextBox>
                </td>
            </tr>
        </table>
        <asp:Label ID="Label1" runat="server" Text="Sample Test of Master Branch"></asp:Label>
        
    </form>
</body>
</html>
