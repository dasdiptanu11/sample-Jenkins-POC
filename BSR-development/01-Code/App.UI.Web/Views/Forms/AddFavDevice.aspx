<%@ Page Title="Add Favourite Device" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="AddFavDevice.aspx.cs" Inherits="App.UI.Web.Views.Forms.AddFavDevice" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="~/Views/Shared/ContentHeader.ascx" TagPrefix="uc" TagName="ContentHeader" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style type="text/css">
        .accordionContent {
            background-color: #eaedf2;
        }

        .accordionHeaderSelected {
            background-color: #4d657d;
            border: 1px solid #2F4F4F;
            color: white;
            cursor: pointer;
            font-family: Arial,Sans-Serif;
            font-size: 20px;
            font-weight: bold;
            padding-top: 7px;
            padding-left: 40px;
            margin-top: 5px;
            height: 30px;
            text-align: left;
            background-image: url("../../Images/Accordion Expand.png");
            background-repeat: no-repeat;
            background-position: left;
            background-size: contain;
            border-radius: 5px
        }

        .accordionHeader {
            background-color: #4d657d;
            border: 1px solid #2F4F4F;
            color: white;
            cursor: pointer;
            font-family: Arial,Sans-Serif;
            font-size: 20px;
            font-weight: bold;
            padding-top: 7px;
            padding-left: 40px;
            margin-top: 5px;
            height: 30px;
            background-image: url("../../Images/Accordion Collapse.png");
            background-repeat: no-repeat;
            background-position: left;
            background-size: contain;
            border-radius: 5px
        }

        .checkBoxItem tbody tr td {
            font-size: 12px;
            white-space: nowrap;
        }

        .checkBoxItem input[type="checkbox" i] {
            margin-left: 0px;
        }

        .checkBoxItem tbody tr td {
            padding-left: 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <telerik:RadWindowManager ID="Dialog" runat="server" AutoSize="true" KeepInScreenBounds="true" Modal="true"></telerik:RadWindowManager>
    <uc:ContentHeader ID="contentHeader" runat="server" Title="Add Favourite Device" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:BulletedList ID="AddFavDeviceErrorMsg" runat="server" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>
            <asp:ValidationSummary ID="vsAddFavDevice" runat="server" ValidationGroup="DeviceValidationGroup" CssClass="failureNotification" DisplayMode="List" />
            <br />
            <table>
                <tr>
                    <td>
                        <asp:Label ID="Country" runat="server" Text="Country " AssociatedControlID="Country_DropDown"></asp:Label>
                    </td>
                    <td>
                        <div style="float: left">
                            &nbsp;
                            <asp:DropDownList Font-Size="14px" ID="Country_DropDown" runat="server" Width="200px" AutoPostBack="true" OnSelectedIndexChanged="Country_SelectedIndexChanged"></asp:DropDownList>
                            &nbsp;
                        </div>
                    </td>
                </tr>
            </table>
            <br />
            <div id="divFavDeviceAccordion">
                <asp:CustomValidator ID="cvFavDeviceAccordian" runat="server" CssClass="failureNotification" ValidationGroup="DeviceDataValidationGroup" OnServerValidate="FavDeviceAccordian_ServerValidate" ErrorMessage=""></asp:CustomValidator>
                <ajaxToolkit:Accordion ID="FavouriteDeviceAccordion" runat="server"
                    HeaderCssClass="accordionHeader"
                    HeaderSelectedCssClass="accordionHeaderSelected"
                    ContentCssClass="accordionContent" FadeTransitions="true" SuppressHeaderPostbacks="true" TransitionDuration="250" FramesPerSecond="40" RequireOpenedPane="false">
                    <Panes>
                        <ajaxToolkit:AccordionPane ID="SurgeonAndSite_AccordionPane" runat="server" Width="500px">
                            <Header>Surgeon & Sites</Header>
                            <Content>
                                <br />
                                <asp:Panel ID="SurgeonDropDowntable" runat="server" Visible="false" Style="padding-left: 20px;">
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Surgeon" runat="server" Text="Surgeon " AssociatedControlID="Surgeon_DropDown"></asp:Label>
                                            </td>
                                            <td>
                                                <div style="float: left">
                                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                                    <asp:DropDownList Font-Size="14px" ID="Surgeon_DropDown" runat="server" Width="200px" AutoPostBack="true" OnSelectedIndexChanged="Surgeon_SelectedIndexChanged"></asp:DropDownList>
                                                    &nbsp;
                                                </div>
                                        </tr>
                                    </table>
                                </asp:Panel>
                                <asp:Panel ID="divsiteList" runat="server" Visible="false" Style="padding-left: 20px;">
                                    <table>
                                        <tr>
                                            <td>
                                                <div>
                                                    <br />
                                                    <asp:Label ID="SiteCheckList" runat="server" Text="Please select sites " AssociatedControlID="siteCheckBoxList"></asp:Label>
                                                    <br />
                                                    <br />
                                                    <asp:CheckBoxList ID="siteCheckBoxList" runat="server"
                                                        RepeatLayout="Table"
                                                        RepeatDirection="Horizontal"
                                                        Style="width: 100%; text-align: left"
                                                        TextAlign="Right" CellPadding="5" CssClass="checkBoxItem">
                                                    </asp:CheckBoxList>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <br />
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Button ID="Save_SurgeonAndSitePane" runat="server" Text="Next" OnClick="Save_SurgeonAndSitePane_OnClick" />
                                                        </td>
                                                        <td style="width: 25px"></td>
                                                        <td>
                                                            <asp:Button ID="Cancel_SurgeonAndSitePane" runat="server" Text="Cancel" OnClick="Cancel_SurgeonAndSitePane_OnClick" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </Content>
                        </ajaxToolkit:AccordionPane>
                        <ajaxToolkit:AccordionPane ID="TypesOfProcedure_AccordionPane" runat="server">
                            <Header>Type of Procedures</Header>
                            <Content>
                                <br />
                                <asp:Panel ID="divTypeOfProcs" runat="server" Visible="false" Style="padding-left: 20px; height: 425px">
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="ProcedureList" runat="server" Text="Please Select Type of Procedures" Font-Bold="true"></asp:Label>
                                                <br />
                                                <br />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Primary" runat="server" Text="Primary"></asp:Label>
                                                <br />
                                                <asp:CheckBoxList ID="typeOfPrimProcsCheckList" runat="server"
                                                    RepeatLayout="Table"
                                                    RepeatDirection="Vertical"
                                                    Style="width: 100%; text-align: left"
                                                    TextAlign="Right" CellPadding="5" CssClass="checkBoxItem">
                                                </asp:CheckBoxList>
                                                <br />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Revision" runat="server" Text="Revision"></asp:Label>
                                                <br />
                                                <asp:CheckBoxList ID="typeOfRevProcsCheckList" runat="server"
                                                    RepeatLayout="Table"
                                                    RepeatDirection="Vertical"
                                                    Style="width: 100%; text-align: left"
                                                    TextAlign="Right" CellPadding="5" CssClass="checkBoxItem">
                                                </asp:CheckBoxList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <br />
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Button ID="Save_TypeOfProcsPane" runat="server" Text="Next" OnClick="Save_TypeOfProcsPane_OnClick" /></td>
                                                        <td style="width: 25px"></td>
                                                        <td>
                                                            <asp:Button ID="Cancel_TypeOfProcsPane" runat="server" Text="Cancel" OnClick="Cancel_TypeOfProcsPane_OnClick" /></td>
                                                    </tr>
                                                </table>
                                                <br />
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>

                            </Content>
                        </ajaxToolkit:AccordionPane>
                        <ajaxToolkit:AccordionPane ID="Device_AccordionPane" runat="server">
                            <Header>Device</Header>
                            <Content>
                                <br />
                                <asp:Panel ID="divDevice" runat="server" Visible="false" Style="padding-left: 20px; height: 482px">
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Device" runat="server" Text="Please Select Type of Device" Font-Bold="true"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <br />
                                                <table border="0">
                                                    <colgroup>
                                                        <col width="200px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>

                                                            <asp:Label ID="DeviceTyper" runat="server" Text="Device Type "></asp:Label>
                                                        </td>
                                                        <td>
                                                            <div>
                                                                <telerik:RadComboBox Font-Size="14px" ID="DeviceType" runat="server" Width="222px" AutoPostBack="true"
                                                                    OnSelectedIndexChanged="DeviceType_SelectedIndexChanged">
                                                                </telerik:RadComboBox>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table border="0">
                                                    <colgroup>
                                                        <col width="200px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="Brand" AssociatedControlID="BrandName" runat="server" Text="Brand Name "></asp:Label>
                                                        </td>
                                                        <td>
                                                            <telerik:RadComboBox Font-Size="14px" ID="BrandName" Width="222px" runat="server" OnSelectedIndexChanged="BrandName_SelectedIndexChanged"
                                                                AutoPostBack="True">
                                                            </telerik:RadComboBox>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table border="0">
                                                    <colgroup>
                                                        <col width="200px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="Desc" AssociatedControlID="Description" runat="server" Text="Description " /></td>
                                                        <td>
                                                            <telerik:RadComboBox Font-Size="14px" ID="Description" runat="server" AutoPostBack="true" Width="222px" OnSelectedIndexChanged="Description_SelectedIndexChanged" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table>
                                                    <colgroup>
                                                        <col width="200px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="Modl" AssociatedControlID="Model" runat="server" Text="Model " /></td>
                                                        <td>
                                                            <telerik:RadComboBox Font-Size="14px" ID="Model" runat="server" Width="222px" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table>
                                                    <colgroup>
                                                        <col width="200px" />
                                                    </colgroup>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="Manuf" AssociatedControlID="Manufacturer" runat="server" Text="Manufacturer " /></td>
                                                        <td>
                                                            <telerik:RadComboBox Font-Size="14px" ID="Manufacturer" runat="server" Width="222px" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:Panel ID="OptionPanel" runat="server" CssClass="EmbeddedViewPlaceholder" Visible="false">
                                                    <asp:Panel runat="server" ID="ButtressPanel" Style="display: none">
                                                        <table width="100%">
                                                            <colgroup>
                                                                <col width="188px" />
                                                            </colgroup>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Buttrs" AssociatedControlID="Buttress" runat="server" Text="Buttress" /></td>
                                                                <td>
                                                                    <asp:RadioButtonList ID="Buttress" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="Buttress_SelectedIndexChanged" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <asp:Panel runat="server" ID="ButtressTypePanel" Style="display: none">
                                                        <table width="100%">
                                                            <colgroup>
                                                                <col width="188px" />
                                                            </colgroup>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="ButtressType" AssociatedControlID="ButtressTypeDropDown" runat="server" Text="Buttress Type" />
                                                                </td>
                                                                <td>
                                                                    <telerik:RadComboBox Font-Size="14px" ID="ButtressTypeDropDown" runat="server" Width="222px">
                                                                    </telerik:RadComboBox>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <asp:Panel ID="PrimaryPortPanel" runat="server" Style="display: none">
                                                        <table border="0">
                                                            <colgroup>
                                                                <col width="188px" />
                                                            </colgroup>
                                                            <tr>
                                                                <td>
                                                                    <asp:CheckBox ID="ChkPrimPortRet" runat="server" Text="Primary Port Retained" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <asp:Panel runat="server" ID="PortFixPanel" Style="display: none">
                                                        <table width="100%">
                                                            <colgroup>
                                                                <col width="188px" />
                                                            </colgroup>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="PrtFixMethod" AssociatedControlID="PortFixMethod" runat="server" Text="Port Fixation Method" Style="text-align: left" /></td>
                                                                <td style="align-items: flex-start">
                                                                    <telerik:RadComboBox Font-Size="14px" ID="PortFixMethod" runat="server" Width="222px" AutoPostBack="true" OnSelectedIndexChanged="PortFixMethod_SelectedIndexChanged" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <asp:Panel ID="AccessPortPanel" runat="server" Style="display: none">
                                                        <table width="100%">
                                                            <colgroup>
                                                                <col width="188px" />
                                                            </colgroup>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="PFBrandName" AssociatedControlID="PortFixBrandName" runat="server" Text="Brand Name" /></td>
                                                                <td>
                                                                    <telerik:RadComboBox Font-Size="14px" ID="PortFixBrandName" runat="server" Width="222px" AutoPostBack="true" OnSelectedIndexChanged="PortFixBrandName_SelectedIndexChanged" />
                                                            </tr>
                                                        </table>
                                                        <table>
                                                            <colgroup>
                                                                <col width="188px" />
                                                            </colgroup>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="PFDesc" AssociatedControlID="PortFixDescription" runat="server" Text="Description" /></td>
                                                                <td>
                                                                    <telerik:RadComboBox Font-Size="14px" ID="PortFixDescription" runat="server" Width="222px" AutoPostBack="true" OnSelectedIndexChanged="PortFixDescription_SelectedIndexChanged" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <table>
                                                            <colgroup>
                                                                <col width="188px" />
                                                            </colgroup>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="PFModel" AssociatedControlID="PortFixModel" runat="server" Text="Model" /></td>
                                                                <td>
                                                                    <telerik:RadComboBox Font-Size="14px" ID="PortFixModel" runat="server" Width="222px" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <table>
                                                            <colgroup>
                                                                <col width="188px" />
                                                            </colgroup>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="PFManufacturer" AssociatedControlID="PortFixManufacturer" runat="server" Text="Manufacturer" /></td>
                                                                <td>
                                                                    <telerik:RadComboBox Font-Size="14px" ID="PortFixManufacturer" runat="server" Width="222px" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <br />
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Button ID="Save_DevicePane" runat="server" Text="Save" OnClick="Save_Device_OnClick" />
                                                        </td>
                                                        <td style="width: 25px"></td>
                                                        <td>
                                                            <asp:Button ID="Cancel_DevicePane" runat="server" Text="Cancel" OnClick="Cancel_DevicePane_OnClick" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </Content>
                        </ajaxToolkit:AccordionPane>
                    </Panes>
                </ajaxToolkit:Accordion>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
