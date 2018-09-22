<%@ Page Title="Log In" Language="C#" MasterPageFile="~/Views/Shared/LoginSite.master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="App.UI.Web.Views.Home.Login" %>

<%@ Register Src="Login.ascx" TagName="Login" TagPrefix="uc1" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <meta name="format-detection" content="telephone=no"/>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <br /> <br /> <br />
    <table width="100%" border="0" style="height: 600px">
        <tbody>
            <tr>
                <td width="25%" align="center" valign="top">
                    <table>
                        <tr>
                            <td align="center">
                                <asp:Image ID="Image2" runat="server" ImageAlign="Middle" ImageUrl="~/Images/iso27001.gif" Width="45%" />
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <br />
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Image ID="NZImage" runat="server" ImageAlign="Middle" ImageUrl="~/Images/NZ_Logo.png" Width="70%" />
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="50%" valign="top">
                    <uc1:Login ID="ucLogin" runat="server" />
                </td>
                <td width="25%" valign="top" align="right">
                    <div style="text-align: left; padding-left: 0px; font-family: Calibri; font-size: 15px; color: #4D4F53;">
                        <h1 style="margin-top: 0">Contact us</h1>
                        <h2>Australia</h2>
                        <b>Mail: </b>
                        <br />
                        Project Officer   
                        <br />
                        The Alfred Centre 
                        <br />
                        99 Commercial Road
                        <br />
                        Melbourne VIC 3004
                        <br />
                        <br />
                        <b>Phone:</b> (61) 3 9903 0725
                        <br />
                        <b>Fax:</b> (61) 3 9903 0717
                        <br />
                        <b>Email:</b>
                        med-bsr@monash.edu

                          <br />
                        <h2>New Zealand</h2>
                        <b>Mail: </b>
                        <br />
                        School of Population Health,
                        <br />
                        The University of Auckland,
                        <br />
                        Private Bag 92019,<br />
                        Auckland Mail Centre Auckland,<br />
                        1142 New Zealand<br />
                        <br />
                        <b>Phone:</b> (64) 9 373 7599
                        <br />
                        <b>Fax:</b> (64) 9 373 1710
                        <br />
                        <b>Email:</b>
                        bsr@auckland.ac.nzu
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
</asp:Content>
