<%@ Page Title="Bulk Operation Load" MasterPageFile="~/Views/Shared/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="BulkLoadOperations.aspx.cs" Inherits="App.UI.Web.Views.Forms.BulkLoadOperations" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="uc" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">

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
                     "Date format is not correct e.g 12-OCT-1994 or 12-10-1994",
                       "Surgeon ID is not valid",
                         "Patient ID is not valid",
                         "Only numbers allowed",
                         "Hospital ID is not valid",
                         "Surgeon ID is not valid",
                         "Operation Date should be greater than Ethics date of Hospital and less than Todays Date",
                         "Must be Numeric",
                         "Mapped Proc ID is not valid",
                         "Operation date should be in between Admission Date and Discharge Date",
                         "Surgeon ID is not a valid combination with Site ID",
                         "Admission Date should not be greater than Todays Date",
                         "Discharge Date should be less than or equal to Todays Date",
                         "Operation date should be greater than Primary Operation Date",
                ];

                if ($.inArray(text, errorMessages) > -1) {
                    //set color 
                    $(this).css("color", "Red");
                }
            });
        })
    </script>

    <uc:ContentHeader ID="Header" runat="server" Title="Bulk Operation Load" />
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
    <asp:BulletedList ID="OperationsUploadErrorMessages" runat="server" CssClass="failureNotification" Style="list-style-type: none;"></asp:BulletedList>

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
