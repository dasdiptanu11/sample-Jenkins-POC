<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Views/Shared/Site.Master" CodeBehind="SurgeonReport.aspx.cs" Inherits="App.UI.Web.Views.Reports.SurgeonReport" %>

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


    <uc:ContentHeader ID="contentHeader" runat="server" Title="Surgeon Report" />

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
                                    <asp:Label ID="lblReportFor" runat="server" Text="Patient Group" Width="125px" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="PatientGroupReport" runat="server" Width="175px"></asp:DropDownList>
                                </td>
                                <td>&nbsp;</td>
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

                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <rsweb:ReportViewer ID="SurgeonReportView" runat="server" Width="100%" Height="90%"
        WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" PageCountMode="Actual" Font-Names="Verdana" Font-Size="8pt">
        <ServerReport DisplayName="Surgeon Report " />
    </rsweb:ReportViewer>


    <asp:ObjectDataSource ID="odsSurgeonReport1" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonReport_SentinelEveCntTableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsSurgeonReport2" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonRpt_DiaxCntTableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsSurgeonReport3" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonRpt_PatCntTableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsSurgeonReport4" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonRpt_OpProcAndOpCntTableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsSurgeonReport5" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonRpt_SelfReportedWtCntTableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>


    <asp:ObjectDataSource ID="odsSurgeonReport6" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonRpt_FollowUpCntTableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    
    <asp:ObjectDataSource ID="odsSurgeonReport7" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonRpt_SentinelEveReasonTableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

      <asp:ObjectDataSource ID="odsSurgeonReport8" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonRpt_ReasonsForPort_SETableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsSurgeonReport9" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonRpt_ReasonsForSlip_SETableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />   
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />        
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsSurgeonReport10" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonRpt_DiaxCnt2TableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />   
            <asp:ControlParameter ControlID="PatientGroupReport" DefaultValue="" Name="pRunForLegacyOnly" PropertyName="SelectedValue" Type="Int32" />        
        </SelectParameters>
    </asp:ObjectDataSource>

    
    <asp:ObjectDataSource ID="odsSurgeonReport11" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_SurgeonRpt_DiaxCnt3TableAdapter"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="Site" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Surgeon" DefaultValue="" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />   
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
