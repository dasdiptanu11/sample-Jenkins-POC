<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="App.UI.Web.Views.Forms.Test" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
    <script language="javascript" type="text/javascript">
        
    </script>
</telerik:RadScriptBlock>

<div class="form">

    <div class="sectionPanel1"> 
        <div class="sectionHeader collapsible">
            Header for Outer Section
        </div>
        <div class="sectionContent"> 
            Content for Outer Section 
            <!--==================== 
                Inner Panel 1  
            =========================-->
            <div class="sectionPanel2"> 
                <div class="sectionHeader collapsible">
                    Header for Inner Section 1
                </div>
                <div class="sectionContent"> 
                    Content for Inner Section 1 <br />
                    Content for Inner Section 1 <br />
                    Content for Inner Section 1 <br />
                    Content for Inner Section 1 <br />
                    Content for Inner Section 1 <br />
                    <!--==================== 
                        Inner Panel 1.1  
                    =========================-->
                    <div class="sectionPanel2"> 
                        <div class="sectionHeader collapsible">
                            Header for Inner Section 1.1
                        </div>
                        <div class="sectionContent"> 
                            Content for Inner Section 1.1 <br />
                            Content for Inner Section 1.1 <br />
                            Content for Inner Section 1.1 <br />
                            Content for Inner Section 1.1 <br />
                            Content for Inner Section 1.1 <br />
                        </div>    
                    </div>

                </div>    
            </div>
            <!--==================== 
                Inner Panel 2  
            =========================-->
            <div class="sectionPanel2"> 
                <div class="sectionHeader collapsible">
                    Header for Inner Section 2
                </div>
                <div class="sectionContent"> 
                    Content for Inner Section 2 <br />
                    Content for Inner Section 2 <br />
                    Content for Inner Section 2 <br />
                    Content for Inner Section 2 <br />
                    Content for Inner Section 2 <br />
                </div>    
            </div>

        </div>    
    </div>

</div>

</asp:Content>
