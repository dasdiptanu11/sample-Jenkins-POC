<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Views/Shared/Site.Master" CodeBehind="RevisionSurgerySummaryReport.aspx.cs" Inherits="App.UI.Web.Views.Reports.RevisionSurgerySummaryReport" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <telerik:RadCodeBlock ID="rcb" runat="server">
        <script type="text/javascript">

            function SetDate() {
                dateVar = new Date();
                var datepicker = $find("<%= rdpTo.ClientID %>");
                datepicker.set_selectedDate(dateVar);
            }

        </script>

    </telerik:RadCodeBlock>


    <uc:ContentHeader ID="contentHeader" runat="server" Title="Revision Surgery Summary Report" />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:ValidationSummary ID="vsInelligibleOptOff" runat="server" ValidationGroup="ErrorsGroup"
                CssClass="failureNotification" HeaderText="" />
            <div class="form">
                <div class="sectionPanel1">
                    <div class="sectionContent2">
                        <table border="0" width="100%">
                            <colgroup>
                                <col width="200px" />
                            </colgroup>
                            <tr>
                                <td>
                                    <asp:Label ID="lblFrom" AssociatedControlID="rdpFrom" runat="server" Text="Date From" Width="125px" />
                                </td>
                                <td>
                                    <telerik:RadDatePicker ID="rdpFrom" Width="100px" runat="server" Calendar-CultureInfo="en-AU" MinDate="1900-01-01" />
                                </td>
                                <td>
                                    <asp:Label ID="lblSpace1" runat="server" Text="" Width="75px" />
                                </td>
                                <td>
                                    <asp:Label ID="lblSurgeon" runat="server" Text="Surgeon" Width="125px" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="Surgeon" runat="server" Width="175px"></asp:DropDownList>
                                </td>
                                <td>
                                    <asp:Label ID="lblSpace2" runat="server" Text="" Width="75px" />
                                </td>
                                <td>
                                    &nbsp;</td>
                                <td>
                                    &nbsp;</td>
                            </tr>
                            <tr>

                                <td>
                                    <asp:Label ID="lblTo" AssociatedControlID="rdpTo" runat="server" Text="Date To" />
                                </td>
                                <td>
                                    <telerik:RadDatePicker ID="rdpTo" Width="100px" runat="server" Calendar-CultureInfo="en-AU" MinDate="1900-01-01" />
                                </td>

                                <td>
                                    <asp:Label ID="lblSpace3" runat="server" Text="" Width="75px" />
                                </td>
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
                        <asp:ObjectDataSource ID="odsRSSR" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_Report_RevisionSurgerySummaryReportTableAdapter" 
                            OldValuesParameterFormatString="original_{0}">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
                                <asp:ControlParameter ControlID="Surgeon" DefaultValue="-1" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
                                <asp:ControlParameter ControlID="rdpFrom"  DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
                                <asp:ControlParameter ControlID="rdpTo"  DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
                                 
                            </SelectParameters>
                        </asp:ObjectDataSource>

                         <asp:ObjectDataSource ID="odsRSSR2" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_RSSR_ReOpReasonTableAdapter" 
                            OldValuesParameterFormatString="original_{0}">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
                                <asp:ControlParameter ControlID="Surgeon" DefaultValue="-1" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
                                <asp:ControlParameter ControlID="rdpFrom"  DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
                                <asp:ControlParameter ControlID="rdpTo"  DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
                                 
                            </SelectParameters>
                        </asp:ObjectDataSource>

                         <asp:ObjectDataSource ID="odsRSSR3" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_RSSR_ReasonsForPort_ReOPTableAdapter" 
                            OldValuesParameterFormatString="original_{0}">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
                                <asp:ControlParameter ControlID="Surgeon" DefaultValue="-1" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
                                <asp:ControlParameter ControlID="rdpFrom"  DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
                                <asp:ControlParameter ControlID="rdpTo"  DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
                                 
                            </SelectParameters>
                        </asp:ObjectDataSource>

                             <asp:ObjectDataSource ID="odsRSSR4" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_RSSR_ReasonsForSlip_ReOPTableAdapter" 
                            OldValuesParameterFormatString="original_{0}">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
                                <asp:ControlParameter ControlID="Surgeon" DefaultValue="-1" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
                                <asp:ControlParameter ControlID="rdpFrom"  DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
                                <asp:ControlParameter ControlID="rdpTo"  DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
                                 
                            </SelectParameters>
                        </asp:ObjectDataSource>



                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <rsweb:ReportViewer ID="ReportView" runat="server" Width="100%" Height="90%"
        WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" PageCountMode="Actual" Font-Names="Verdana" Font-Size="8pt" >
        <ServerReport DisplayName="Revision Surgeon Surgery Report " />
    </rsweb:ReportViewer>


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
