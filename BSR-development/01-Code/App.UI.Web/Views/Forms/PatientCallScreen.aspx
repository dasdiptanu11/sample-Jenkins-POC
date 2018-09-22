<%@ Page Language="C#" AutoEventWireup="true" Title="Patient Call Work List" MasterPageFile="~/Views/Shared/Site.Master"
    CodeBehind="PatientCallScreen.aspx.cs" Inherits="App.UI.Web.Views.Forms.PatientCallScreen" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../Shared/ContentHeader.ascx" TagName="ContentHeader" TagPrefix="userControl" %>

<asp:Content ID="PageHeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .rgHeader {
            font-size: 14px;
            font-weight: 500 !important;
        }
    </style>
</asp:Content>

<asp:Content ID="CallScreenContent" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function genericPopup(href, width, height, title) {
                var oWindow = window.radopen(href, null, width, height, null, null);
                oWindow.SetModal(true);
                oWindow.set_visibleStatusbar(false);
                oWindow.heigh
                oWindow.set_behaviors(Telerik.Web.UI.WindowBehaviors.Move + Telerik.Web.UI.WindowBehaviors.Close);
                oWindow.set_autoSize(false);
                oWindow.set_title(title);
                oWindow.set_showContentDuringLoad(false);
                oWindow.add_close(RefreshPage);
                oWindow.show();
            }

            function RefreshPage(obj) {
                if (typeof (obj) !== 'undefined') {
                    var returnValue = obj.Argument;
                    if (typeof (returnValue) === 'string') {
                        if (returnValue === 'refresh') {
                            window.location.replace(window.location);
                        }
                        else {
                            window.location.href = returnValue;
                        }
                    }
                    else {
                        window.location.replace(window.location);
                    }
                }
                else {
                    window.location.replace(window.location);
                }
            }
        </script>

    </telerik:RadCodeBlock>

    <userControl:ContentHeader ID="PageHeader" runat="server" Title="Call Center Work List" />

    <asp:UpdatePanel ID="CallScreenUpdatePanel" runat="server">
        <ContentTemplate>
            <div id="patientCallForm" class="form">
                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                    <tr>
                        <td width="50%" valign="top">
                            <asp:Panel ID="SearchFieldPanel" runat="server" Width="100%" Style="height: 100%">
                                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                    <tr>
                                        <td width="150px">
                                            <asp:Label ID="CountryLabel" AssociatedControlID="CountrySelectionList" runat="server" Text="Country" />
                                        </td>
                                        <td abbr="50%">
                                            <asp:RadioButtonList AutoPostBack="true" ID="CountrySelectionList" runat="server" RepeatDirection="Horizontal"
                                                RepeatLayout="Table" OnSelectedIndexChanged="CountrySelectionChanged" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td width="150px">
                                            <asp:Label ID="StateLabel" AssociatedControlID="StateSelectionList" runat="server" Text="State" />
                                        </td>
                                        <td abbr="50%">
                                            <asp:DropDownList ID="StateSelectionList" runat="server" Width="70%" />
                                        </td>
                                    </tr>
                                </table>

                                <br />

                                <table width="20%">
                                    <tr>
                                        <td width="50%">
                                            <asp:Button ID="SearchButton" runat="server" CausesValidation="false" OnClick="SearchButtonClicked" Text="Search" Width="100px" />
                                        </td>
                                        <td width="50%">
                                            <asp:Button ID="ClearButton" runat="server" Text="Clear" CausesValidation="false" OnClick="ClearButtonClicked" Width="100px" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>

                        <%--<td width="50%" valign="top"></td>--%>
                        <td align="right" valign="top">
                            <asp:Panel ID="Panel1" runat="server">
                                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                    <tr>
                                        <td width="50%" align="right">
                                            <table>
                                                <tr>
                                                    <td class="auto-style16">
                                                        <asp:Label ID="Label1" runat="server" Text="In Window" Font-Bold="True"></asp:Label></td>
                                                    <td align="center" class="auto-style18">
                                                        <asp:Image ID="Image1" runat="server" ToolTip="In Window" ImageUrl="~/Images/ico-in_window.gif" ImageAlign="Right" />
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td class="auto-style16">
                                                        <asp:Label ID="Label2" runat="server" Text="Out of Window" Font-Bold="True"></asp:Label></td>
                                                    <td align="center" class="auto-style18">
                                                        <asp:Image ID="Image2" runat="server" ToolTip="Out of Window" ImageUrl="~/Images/ico-out_window.gif" ImageAlign="Right" /></td>
                                                </tr>

                                                <tr>
                                                    <td class="auto-style16">
                                                        <asp:Label ID="Label3" runat="server" Text="Assign call to Me" Font-Bold="True"></asp:Label></td>
                                                    <td align="center" class="auto-style18">
                                                        <asp:Image ID="Image3" runat="server" ToolTip="Assign call to Me" ImageUrl="~/Images/ico-assign.gif" ImageAlign="Right" />
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td class="auto-style16">
                                                        <asp:Label ID="Label4" runat="server" Text="Already Assigned" Font-Bold="True"></asp:Label></td>
                                                    <td align="center" class="auto-style18">
                                                        <asp:Image ID="Image4" runat="server" ToolTip="Already Assigned" ImageAlign="Right" ImageUrl="~/Images/ico-assigned.gif" /></td>
                                                </tr>

                                                <tr>
                                                    <td class="auto-style16">
                                                        <asp:Label ID="Label5" runat="server" Text="Assigned to Me" Font-Bold="True"></asp:Label></td>
                                                    <td align="center" class="auto-style18">
                                                        <asp:Image ID="Image5" runat="server" ToolTip="Assigned to Me" ImageAlign="Right" ImageUrl="~/Images/ico-assigned_me.gif" /></td>
                                                </tr>
                                            </table>
                                        </td>

                                        <td width="50%" align="right">
                                            <table>
                                                <tr>
                                                    <td class="auto-style16">
                                                        <asp:Label ID="CompleteLabel" runat="server" Text="Call Back" Font-Bold="True"></asp:Label></td>
                                                    <td align="center" class="auto-style18">
                                                        <asp:Image ID="CompleteImage" runat="server" ToolTip="Call Back" ImageUrl="~/Images/ico-call_back.gif" ImageAlign="Right" />
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td class="auto-style16">
                                                        <asp:Label ID="NotDueLabel" runat="server" Text="Not Answered" Font-Bold="True"></asp:Label></td>
                                                    <td align="center" class="auto-style18">
                                                        <asp:Image ID="NotDueImage" runat="server" ToolTip="No Answer" ImageUrl="~/Images/ico-no_answer.gif" ImageAlign="Right" /></td>
                                                </tr>

                                                <tr>
                                                    <td class="auto-style16">
                                                        <asp:Label ID="InCompleteLabel" runat="server" Text="Wrong Number" Font-Bold="True"></asp:Label></td>
                                                    <td align="center" class="auto-style18">
                                                        <asp:Image ID="InCompleteImage" runat="server" ToolTip="Wrong Number" ImageUrl="~/Images/ico-wrong_number.gif" ImageAlign="Right" />
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td class="auto-style16">
                                                        <asp:Label ID="NotApplicableLabel" runat="server" Text="Answered" Font-Bold="True"></asp:Label></td>
                                                    <td align="center" class="auto-style18">
                                                        <asp:Image ID="NotApplicableImage" runat="server" ToolTip="Answered" ImageAlign="Right" ImageUrl="~/Images/ico-answered.gif" /></td>
                                                </tr>

                                                <tr>
                                                    <td class="auto-style16">
                                                        <asp:Label ID="Label6" runat="server" Text="Call to be made" Font-Bold="True"></asp:Label></td>
                                                    <td align="center" class="auto-style18">
                                                        <asp:Image ID="Image6" runat="server" ToolTip="Call to be made" ImageAlign="Right" ImageUrl="~/Images/ico-phone.gif" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:UpdatePanel ID="CallScreenWorkListPanel" runat="server">
        <ContentTemplate>
            <telerik:RadGrid ID="CallScreenWorkListGrid" runat="server" AllowPaging="true" CellSpacing="0" GridLines="None"
                AutoGenerateColumns="false" AllowSorting="false" OnNeedDataSource="CallScreenWorkListGrid_NeedDataSource"
                OnItemCommand="CallScreenWorkListGrid_ItemCommand" OnItemDataBound="CallScreenWorkListGrid_ItemDataBound"
                EnableLinqExpressions="false" ReadOnly="false" AllowFilteringByColumn="true" PageSize="50">

                <ClientSettings AllowColumnsReorder="False" ReorderColumnsOnClient="False" Selecting-AllowRowSelect="false" EnablePostBackOnRowClick="false">
                    <Resizing AllowColumnResize="false" ResizeGridOnColumnResize="True" />
                    <Scrolling AllowScroll="true" SaveScrollPosition="true" ScrollHeight="625px" />
                </ClientSettings>

                <GroupingSettings CaseSensitive="false" />

                <MasterTableView DataKeyNames="PatientId,FollowUpId,SiteId" CommandItemDisplay="Top" HeaderStyle-HorizontalAlign="Center" FilterItemStyle-HorizontalAlign="Left">
                    <PagerStyle PageSizeControlType="RadComboBox" />

                    <CommandItemSettings ShowExportToPdfButton="false" ShowExportToExcelButton="false" ShowRefreshButton="false" ShowAddNewRecordButton="false" />

                    <ColumnGroups>
                        <telerik:GridColumnGroup HeaderText="Call Attempt" Name="CallAttempt" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" Font-Bold="true" />
                        </telerik:GridColumnGroup>
                    </ColumnGroups>

                    <Columns>
                        <telerik:GridTemplateColumn UniqueName="EditPatient" HeaderText="Patient Id" DataField="PatientId" FilterControlWidth="70px" HeaderStyle-Width="80px"
                            AllowFiltering="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" AutoPostBackOnFilter="true">
                            <ItemTemplate>
                                <asp:LinkButton ID="EditPatientLinkButton" Text='<%#Eval("PatientId")%>' runat="server" CommandName="EditPatient" ToolTip="Edit this Patient"></asp:LinkButton>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridBoundColumn DataField="PatientId" HeaderText="Patient Id" UniqueName="PatientId" HeaderStyle-Width="100px" ItemStyle-Width="100px"
                            AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true" Display="false" />

                        <telerik:GridBoundColumn DataField="FamilyName" HeaderText="Family Name" UniqueName="FamilyName" HeaderStyle-Width="100px" ItemStyle-Width="100px"
                            AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true"/>

                        <telerik:GridBoundColumn DataField="GivenName" HeaderText="Given Name" UniqueName="GivenName" HeaderStyle-Width="100px" ItemStyle-Width="100px"
                            AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true" />

                        <telerik:GridBoundColumn DataField="Mobile" HeaderText="Mobile" UniqueName="Mobile" HeaderStyle-Width="100px" ItemStyle-Width="100px"
                            AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true" Display="false" />

                        <telerik:GridTemplateColumn DataField="HomePhone" HeaderText="Home & Mobile" UniqueName="Phone" HeaderStyle-Width="100px" ItemStyle-Width="100px"
                            AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true">
                            <ItemTemplate>
                                <table>
                                    <tr>
                                        <td><%# DataBinder.Eval(Container.DataItem, "HomePhone") %></td>
                                    </tr>
                                    <tr>
                                        <td><%# DataBinder.Eval(Container.DataItem, "Mobile") %></td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn HeaderText="DOB & State" UniqueName="DOB" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="false">
                            <HeaderStyle Font-Bold="true" />
                            <ItemTemplate>
                                <table>
                                    <tr>
                                        <td><%# DataBinder.Eval(Container.DataItem, "StringBirthDate") %></td>
                                    </tr>
                                    <tr>
                                        <td><%# DataBinder.Eval(Container.DataItem, "State") %></td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridDateTimeColumn  DataField="OperationDate" HeaderText="Operation Date" UniqueName="OperationDate" HeaderStyle-Width="100px" ItemStyle-Width="100px" DataFormatString="{0:dd/MM/yyyy}" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="ProcedureType" HeaderText="Procedure" UniqueName="Procedure" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="FollowUpId" HeaderText="FollowUp" UniqueName="FollowUpId" HeaderStyle-Width="100px" AllowFiltering="false" Display="false" />
                        <telerik:GridBoundColumn DataField="FollowUpCallDetailsId" HeaderText="FollowUpCallId" UniqueName="FollowUpCallDetailsId" HeaderStyle-Width="100px" AllowFiltering="false" Display="false" />
                        <telerik:GridBoundColumn DataField="SiteId" HeaderText="SiteId" UniqueName="SiteId" HeaderStyle-Width="100px" AllowFiltering="false" Display="false" />
                        
                        <telerik:GridTemplateColumn HeaderText="Follow Up" UniqueName="FollowUpDetails" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="false" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:LinkButton ID="EditFollowUpLinkButton" Text='<%#Eval("FollowUpPeriod")%>' runat="server" CommandName="EditFollowup" ToolTip="Followup Details" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridBoundColumn DataField="FollowUpNotes" HeaderText="Information" UniqueName="FollowUpNotes" HeaderStyle-Width="100px" AllowFiltering="true" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true" />
                        <telerik:GridBoundColumn DataField="CallOneId" HeaderText="1" UniqueName="Call1" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="CallOneResult" HeaderText="CallOneResult" UniqueName="Call1Result" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="CallTwoId" HeaderText="2" UniqueName="Call2" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="CallTwoResult" HeaderText="CallTwoResult" UniqueName="Call2Result" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="CallThreeId" HeaderText="3" UniqueName="Call3" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="CallThreeResult" HeaderText="CallThreeResult" UniqueName="Call3Result" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="CallFourId" HeaderText="4" UniqueName="Call4" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="CallFourResult" HeaderText="CallFourResult" UniqueName="Call4Result" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="CallFiveId" HeaderText="5" UniqueName="Call5" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="CallFiveResult" HeaderText="CallFiveResult" UniqueName="Call5Result" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        

                        <telerik:GridTemplateColumn UniqueName="CallOneControl" HeaderText="1" HeaderStyle-Width="30Px" ItemStyle-Width="30Px" 
                            AllowFiltering="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true"
                            ColumnGroupName="CallAttempt" DataField="CallOneResult" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <telerik:RadButton ID="FollowUpCall1" CommandName="Call" CommandArgument="1" OnCommand="EditCall" ButtonType="StandardButton" Height="18px" Width="18px" runat="server" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn UniqueName="CallTwoControl" HeaderText="2" HeaderStyle-Width="30Px" ItemStyle-Width="30Px" 
                            AllowFiltering="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true"
                            ColumnGroupName="CallAttempt" DataField="CallTwoResult" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <telerik:RadButton ID="FollowUpCall2" CommandName="Call" CommandArgument="2" OnCommand="EditCall" ButtonType="StandardButton" Height="18px" Width="18px" runat="server" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn UniqueName="CallThreeControl" HeaderText="3" HeaderStyle-Width="30Px" ItemStyle-Width="30Px" 
                            AllowFiltering="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true"
                            ColumnGroupName="CallAttempt" DataField="CallThreeResult" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <telerik:RadButton ID="FollowUpCall3" CommandName="Call" CommandArgument="3" OnCommand="EditCall" ButtonType="StandardButton" Height="18px" Width="18px" runat="server" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn UniqueName="CallFourControl" HeaderText="4" HeaderStyle-Width="30Px" ItemStyle-Width="30Px" 
                            AllowFiltering="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true"
                            ColumnGroupName="CallAttempt" DataField="CallFourResult" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <telerik:RadButton ID="FollowUpCall4" CommandName="Call" CommandArgument="4" OnCommand="EditCall" ButtonType="StandardButton" Height="18px" Width="18px" runat="server" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn UniqueName="CallFiveControl" HeaderText="5" HeaderStyle-Width="30Px" ItemStyle-Width="30Px"
                            AllowFiltering="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true"
                            ColumnGroupName="CallAttempt" DataField="CallOFiveResult" ItemStyle-HorizontalAlign="Center" >
                            <ItemTemplate>
                                <telerik:RadButton ID="FollowUpCall5" CommandName="Call" CommandArgument="5" OnCommand="EditCall" ButtonType="StandardButton" Height="18px" Width="18px" runat="server" />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>


                        <telerik:GridTemplateColumn UniqueName="CallAssigned" HeaderText="Assign" HeaderStyle-Width="60px" ItemStyle-Width="50Px"
                            AllowFiltering="false" CurrentFilterFunction="Contains" ShowFilterIcon="false" AutoPostBackOnFilter="true"
                            ColumnGroupName="CallAttempt" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <telerik:RadButton ID ="AssignCall" height="18px" Width="18px" runat="server" CommandName="AssignCall" OnCommand="AssignClicked" ButtonType="ToggleButton" ToggleType="CustomToggle" Visible="true" Checked="false">
                                    <ToggleStates>
                                         <telerik:RadButtonToggleState Text="Assignable" PrimaryIconCssClass="rbToggleCheckbox" ImageUrl="~/Images/ico-assign.gif" IsBackgroundImage="false"/>
                                         <telerik:RadButtonToggleState Text="AssignedToMe" PrimaryIconCssClass="rbToggleCheckboxFilled" ImageUrl="~/Images/ico-assigned_me.gif" IsBackgroundImage="false" />
                                    </ToggleStates>
                                </telerik:RadButton>
                                <asp:image id="AssignedToOther" runat="server" ImageUrl="~/Images/ico-assigned.gif" Visible="false" />
                                
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>



                        <telerik:GridTemplateColumn HeaderText="Last Update" UniqueName="LastUpdate" HeaderStyle-Width="100px" ItemStyle-Width="100px" AllowFiltering="false">
                            <ItemTemplate>
                                <table>
                                    <tr>
                                        <td><%# DataBinder.Eval(Container.DataItem, "LastUpdatedBy") %></td>
                                        <tr>
                                            <td><%# DataBinder.Eval(Container.DataItem, "LastUpdatedDateTime", "{0:dd/MM/yyyy}") %></td>
                                        </tr>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridBoundColumn DataField="AssignedTo" HeaderText="AssignedTo" UniqueName="AssignedTo" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="LastConfirmedCall" HeaderText="LastConfirmedCall" UniqueName="LastConfirmedCall" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                        <telerik:GridBoundColumn DataField="FollowUpPeriod" HeaderText="FollowUpPeriod" UniqueName="FollowUpPeriod" HeaderStyle-Width="40px" ItemStyle-Width="40px" Display="false" AllowFiltering="false" />
                    </Columns>

                    <PagerStyle AlwaysVisible="true" />

                </MasterTableView>

            </telerik:RadGrid>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>