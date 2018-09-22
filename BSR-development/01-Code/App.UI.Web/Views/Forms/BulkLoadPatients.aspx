<%@ Page Title="Bulk Patient Load" MasterPageFile="~/Views/Shared/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="BulkLoadPatients.aspx.cs" Inherits="App.UI.Web.Views.Forms.BulkLoadPatients" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        /*.rgAdvPart {
            display: none;
        }*/
    </style>
</asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        /* change font color for all the invalid text */
        $(document).ready(function () {
            $(".GridCustomClass").find("td").each(function () {
                var text = $(this).text();
                var errorMessages = new Array();
                errorMessages = [
                     "Must be filled",
                     "Name not valid",
                     "Id is not valid",
                     "Patient is less than 18 years",
                     "Date format is not correct e.g 12-Oct-1994",
                     "Value should be 1 or true",
                     "Value should be 0 or blank",
                     "Medicare Number should be of 11 digits",
                     "McareNo in .csv should not be in exponential format e.g. 1.2E+11",
                      "Number not valid",
                      "DvaNo should not be greater then 9 digits",
                       "DvaNo in .csv file should not be in exponential format e.g. 1.2E+11",
                      "Number should be null or empty",
                       "Surgeon ID is not a valid combination with Site ID.",
                       "AddrNotKnown is not valid",
                       "AddrNotKnown is true, Addr should be blank",
                       "Pcode is not valid",
                       "NHI number should not excced 10 characters",
                       "NhiNo in .csv file should not be in exponential format e.g. 1.2E+11",
                       "Value should be 1 or 2",
                        "Number should at least 9 digits and less than 16 digits",
                        "HomePh in .csv file should not be in exponential format e.g. 1.2E+11",
                        "MobPh in .csv file should not be in exponential format e.g. 1.2E+11", "Site ID and Hospital ID must be same",
                         "URNo in .csv file should not be in exponential format e.g. 1.2E+11",
                        "Site ID and Hospital ID must be same",
                         "Only numbers allowed",
                        "Death Date should not be greater then Todays Date",
                        "NHI number only applicable for country NZ",
                        "NoNhiNo number only applicable for country NZ",
                        "URNo already exists in the system",
                        "Multiple records have same URN Number",
                        "Opt off date should not be blank as Opt Off Status is set to Fully Opted Off",
                        "Opt Off Date must be '>01-Jan-2012' and 'less than Current Date'",
                        "Multiple records have same URN Number for the same site",
                        "Email ID is not valid"
                ];

                if ($.inArray(text, errorMessages) > -1) {
                    //set color 
                    $(this).css("color", "Red");
                }

            });
        })

    </script>

    <uc:ContentHeader ID="Header" runat="server" Title="Bulk Patient Load" />
    <br />
    <asp:Label ID="ErrorMessage" runat="server" CssClass="failureNotification"></asp:Label>
    <div>
        <asp:FileUpload ID="UploadFile" runat="server" />
        <asp:Button ID="BulkUpload" Text="Bulk Upload" OnClick="BulkUpload_Click" runat="server" />
    </div>
    <br />
    <asp:Label ID="InvalidCsv" runat="server" CssClass="failureNotification"></asp:Label>
    <asp:Label ID="LoadedRecord" runat="server" ForeColor="Green"></asp:Label>
    <br />
    <asp:Label ID="ExistingRecord" runat="server" CssClass="failureNotification"></asp:Label>
    <asp:BulletedList ID="PatientUploadErrorMessages" runat="server" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>

    <telerik:RadGrid ID="BulkLoadGrid" runat="server" AllowPaging="true" OnNeedDataSource="BulkLoadGrid_NeedDataSource"
        GridLines="None" ClientSettings-Scrolling-AllowScroll="true" HeaderStyle-Wrap="false" CssClass="GridCustomClass">
        <MasterTableView AutoGenerateColumns="true" PageSize="10" ItemStyle-Wrap="false" ItemStyle-Height="35" AlternatingItemStyle-Height="35">
            <PagerStyle PageSizeControlType="RadComboBox" AlwaysVisible="True" />
        </MasterTableView>
    </telerik:RadGrid>

    <telerik:RadGrid ID="ExistingRecordGrid" runat="server" AllowPaging="true" OnNeedDataSource="ExistingRecordGrid_NeedDataSource"
        GridLines="None" ClientSettings-Scrolling-AllowScroll="true" HeaderStyle-Wrap="false" CssClass="GridCustomClass">
        <MasterTableView AutoGenerateColumns="true" PageSize="10" ItemStyle-Wrap="false" ItemStyle-Height="35" AlternatingItemStyle-Height="35">
            <PagerStyle PageSizeControlType="RadComboBox" AlwaysVisible="True" />
        </MasterTableView>
    </telerik:RadGrid>

</asp:Content>

