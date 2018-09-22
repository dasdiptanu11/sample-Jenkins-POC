<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="ConsentReportList.aspx.cs" Inherits="App.UI.Web.Views.Reports.ConsentReportList" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>


<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <uc:ContentHeader ID="contentHeader" runat="server" Title="Consent List Report" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:ValidationSummary ID="vsInelligibleOptOff" runat="server" ValidationGroup="ErrorsGroup"
                CssClass="failureNotification" HeaderText="" />
            <div class="form">
                <div class="sectionPanel1">
                    <div class="sectionContent2">
                        <%--Needed for reports - don't remove--%>
                                    <asp:Label ID="lblFrom" AssociatedControlID="rdpFrom" runat="server" Text="Date From" Width="125px" Visible ="false"  />
                                    <telerik:RadDatePicker ID="rdpFrom" Width="100px" runat="server" Calendar-CultureInfo="en-AU" MinDate="1900-01-01"  Visible ="false" />
                                    <asp:Label ID="lblTo" AssociatedControlID="rdpTo" runat="server" Text="Date To"   Visible ="false" />
                                    <telerik:RadDatePicker ID="rdpTo" Width="100px" runat="server" Calendar-CultureInfo="en-AU" MinDate="1900-01-01"  Visible ="false"  />
                        <table border="0" width="50%">
                            <colgroup>
                                  <col width="25%" style ="padding-left :0px" />                             
                            </colgroup>
                            <tr>                               
                                <td>
                                    <asp:Label ID="lblSurgeon" runat="server" Text="Surgeon" Width="125px" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="Surgeon" runat="server" Width="175px"></asp:DropDownList>
                                </td>

                                <td>
                                    <asp:Label ID="lblReportFor" runat="server" Text="Patient Group" Width="125px" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="PatientGroupReport" runat="server" Width="175px"></asp:DropDownList>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>                               
                                <td>
                                    <asp:Label ID="lblSite" runat="server" Text="Site" Width="125px" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="Site" runat="server" Width="175px"></asp:DropDownList>
                                </td>
                                <td>
                                    <asp:Label ID="lblSpace4" runat="server" Text="" Width="75px" />
                                </td>
                                <td>
                                    <asp:Button ID="RunReport" runat="server" Text="Run Report" Width="125px" OnClick="RunReport_Click" />
                                </td>
                            </tr>
                        </table>

                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <rsweb:ReportViewer ID="ReportView" runat="server" Width="100%" Height="90%" Font-Names="Verdana" Font-Size="8pt" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" PageCountMode="Actual">
        <ServerReport DisplayName="Conset List" />
    </rsweb:ReportViewer>

    <asp:ObjectDataSource ID="odsCLReport" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_ConsentReportTableAdapter" OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="-1" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOptOffdateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOptOffdateto" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="progressBackgroundFilter" class="progressBackgroundFilter">
            </div>
            <div id="processMessage" class="processMessage">
                <img alt="Loading" src="../../Images/Wait.gif" />
                &nbsp;&nbsp; Loading...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>




</asp:Content>
