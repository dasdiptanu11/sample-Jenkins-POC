<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="uc" TagName="ContentHeader" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID='scriptManager' runat='server' EnablePageMethods="true" />
        <uc:ContentHeader ID="Header" runat="server" Title="Add Brand" />
        <asp:ValidationSummary ID="PatientValidationSummary" runat="server" ValidationGroup="PatientDataValidationGroup" CssClass="failureNotification" DisplayMode="List" ForeColor="Red" />
        <div>
        </div>
    </form>
</body>
</html>
