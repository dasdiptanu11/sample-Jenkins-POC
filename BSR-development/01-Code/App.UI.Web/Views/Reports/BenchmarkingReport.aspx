<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" MasterPageFile="~/Views/Shared/Site.Master" CodeBehind="BenchmarkingReport.aspx.cs" Inherits="App.UI.Web.Views.Reports.BenchmarkingReport" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <telerik:RadCodeBlock ID="rcb" runat="server">
        <script type="text/javascript">

        </script>

    </telerik:RadCodeBlock>


    <uc:ContentHeader ID="contentHeader" runat="server" Title="EWL Benchmarking (Graph)" />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:ValidationSummary ID="vsInelligibleOptOff" runat="server" ValidationGroup="ErrorsGroup"
                CssClass="failureNotification" HeaderText="" />
            <div class="form">
                <div class="sectionPanel1">
                    <div class="sectionContent2">
                        <table border="0" width="100%">
                            <tr>
                                <td>

                                    <table border="0" width="50%">
                                        <colgroup>
                                            <col width="200px" />
                                        </colgroup>
                                        <tr align="center">
                                            <td class="bold" colspan="2">
                                                <div style="padding-left: 125px">Criteria 1</div>
                                                <br />
                                                <br />
                                            </td>
                                        </tr>
                                        <tr style="display:none">
                                            <td>
                                                <asp:Label ID="lblPatientGroupA" runat="server" Text="Patient Group" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="PatientGroupA" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblCountryA" runat="server" Text="Country" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="CountryA" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblStateA" runat="server" Text="State" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="StateA" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblSiteA" runat="server" Text="Site" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="SiteA" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblSurgeonA" runat="server" Text="Surgeon" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="SurgeonA" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblOpStatA" runat="server" Text="Operation Type" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="OperationTypeA" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                                <td>
                                    <table border="0" width="50%">
                                        <colgroup>
                                            <col width="200px" />
                                        </colgroup>
                                        <tr align="center">
                                            <td class="bold" colspan="2">
                                                <div style="padding-left: 125px">Criteria 2</div>
                                                <br />
                                                <br />
                                            </td>

                                        </tr>
                                         <tr style="display:none">
                                            <td>
                                                <asp:Label ID="lblPatientGroupB" runat="server" Text="Patient Group" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="PatientGroupB" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblCountryB" runat="server" Text="Country" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="CountryB" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblStateB" runat="server" Text="State" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="StateB" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblSiteB" runat="server" Text="Site" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="SiteB" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblSurgeonB" runat="server" Text="Surgeon" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="SurgeonB" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblOpStatB" runat="server" Text="Operation Type" Width="125px" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="OperationTypeB" runat="server" Width="175px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="RunReport" runat="server" Text="Run Report" Width="125px" OnClick="RunReport_Click" />
                                </td>
                            </tr>
                        </table>
                        <%--                 
                        <asp:ObjectDataSource ID="odsSurgeonReport" runat="server" TypeName ="App.UI.Web.dsReportsTableAdapters.sp_SurgeonReport_OpProcAndCountOfOpsTableAdapter"
                             SelectMethod ="GetData" OldValuesParameterFormatString="original_{0}">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="ddlSite" DefaultValue="-1" Name="pSiteId" PropertyName="SelectedValue" Type="Int32" />
                                <asp:ControlParameter ControlID="ddlSurgeon" DefaultValue="-1" Name="pSurgeonId" PropertyName="SelectedValue" Type="Int32" />
                                <asp:ControlParameter ControlID="rdpFrom" DefaultValue="01/01/1940" Name="pOpDateFrom" PropertyName="SelectedDate" Type="DateTime" />
                                <asp:ControlParameter ControlID="rdpTo" DefaultValue="01/01/1940" Name="pOpDateTo" PropertyName="SelectedDate" Type="DateTime" />
                            </SelectParameters>
                        </asp:ObjectDataSource>  --%>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <rsweb:ReportViewer ID="BenchmarkReport" runat="server" Width="100%" Height="90%" Font-Names="Verdana" Font-Size="8pt" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" PageCountMode="Actual">
        <ServerReport DisplayName="Benchmarking" />
        <LocalReport EnableHyperlinks="True">
        </LocalReport>
    </rsweb:ReportViewer>

    <asp:ObjectDataSource ID="odsCLReport" runat="server" SelectMethod="GetData" TypeName="App.UI.Web.dsReportsTableAdapters.usp_BenchMarkingComparisonTableAdapter" OldValuesParameterFormatString="{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="SiteA" DefaultValue="-1" Name="pSiteId_A" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="StateA" DefaultValue="-1" Name="pStateId_A" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="CountryA" DefaultValue="-1" Name="pCountryId_A" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="SurgeonA" DefaultValue="-1" Name="pSurgeonId_A" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="OperationTypeA" DefaultValue="" Name="pOpTypeID_A" PropertyName="SelectedValue" Type="Int32" />
             <asp:ControlParameter ControlID="PatientGroupA" DefaultValue="-1" Name="pRunForLegacyOnly_A" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="SiteB" DefaultValue="-1" Name="pSiteId_B" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="StateB" DefaultValue="-1" Name="pStateId_B" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="CountryB" DefaultValue="-1" Name="pCountryId_B" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="SurgeonB" DefaultValue="-1" Name="pSurgeonId_B" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="OperationTypeB" DefaultValue="" Name="pOpTypeID_B" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="PatientGroupB" DefaultValue="-1" Name="pRunForLegacyOnly_B" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <%-- <rsweb:ReportViewer ID="rvSReport" runat="server" Width="100%" Height="90%" AsyncRendering="false" Visible="true"
        WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" PageCountMode="Actual" Font-Names="Verdana" Font-Size="8pt">
      <%--  <ServerReport DisplayName="Benchmarking Report " />
         <LocalReport ReportEmbeddedResource="App.UI.Web.Views.Reports.BenchmarkingReport.rdlc">
            <DataSources>
                <rsweb:ReportDataSource DataSourceId="dsBenchMarking" Name="dsBenchMarking" />
            </DataSources>
        </LocalReport>
    </rsweb:ReportViewer>--%>
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
