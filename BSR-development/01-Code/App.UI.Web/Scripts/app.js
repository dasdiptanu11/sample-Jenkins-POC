$(document).ready(function () {
    saveTimezoneOffset();
    applyCollapsibleStyle();
});


function applyOpenStyle(sectionId) {
    applyCollapsibleStyle();

    var elem = $("#" + sectionId);

    var showHide = "";
    var panel = $(elem).parent();
    var panelContent = $(panel).find(".sectionContent").first();

    openHide(elem.find("#action"));
}


function applyCollapsibleStyle() {
    var elements = $(".sectionHeader"); //collapsible
    for (var i = 0; i < elements.length; i++) {

        //if ( $(elements[i]).find("td#action").length > 0 ) 
        if ($(elements[i]).find("table").length > 0) {
            continue;
        }

        if ($(elements[i]).hasClass("collapsible")) {
            var showHide = "";
            var panel = $(elements[i]).parent();
            var panelContent = $(panel).find(".sectionContent").first();

            panelContent.hide();

            if (panelContent.is(":visible")) {
                showHide = "Hide";
            } else {
                showHide = "Show";
            }

            $(elements[i]).html("<table width=\"100%\" border=\"0\"><tr><td align=\"left\">" + $(elements[i]).html() + "</td><td id=\"action\"  onclick=\"return openHide(this);\"  style=\"cursor:pointer;\" align=\"right\">" + showHide + "</td></tr></table>");

            if ($(elements[i]).find(":checkbox")) {
                $(elements[i]).find(":checkbox").click(openHideOnCheckbox);
            }
        }
        else if ($(elements[i]).hasClass("collapsible_default_open")) {
            var showHide = "";
            var panel = $(elements[i]).parent();
            var panelContent = $(panel).find(".sectionContent").first();

            //panelContent.hide();

            if (panelContent.is(":visible")) {
                showHide = "Hide";
            } else {
                showHide = "Show";
            }

            $(elements[i]).html("<table width=\"100%\" border=\"0\"><tr><td align=\"left\">" + $(elements[i]).html() + "</td><td id=\"action\"  onclick=\"return openHide2(this);\"  style=\"cursor:pointer;\" align=\"right\">" + showHide + "</td></tr></table>");

            if ($(elements[i]).find(":checkbox")) {
                $(elements[i]).find(":checkbox").click(openHideOnCheckbox);
            }
        }

        else {
            $(elements[i]).html("<table width=\"100%\" border=\"0\"><tr><td align=\"left\">" + $(elements[i]).html() + "</td></tr></table>");
        }
    }
}

function openHide(elem) {
    var panel = $(elem).closest(".collapsible").parent();
    var panelContent = $(panel).find(".sectionContent").first();
    if (panelContent.is(":visible")) {
        $(elem).html("Show");
        panelContent.hide();
    } else {
        $(elem).html("Hide");
        panelContent.show();
    }
}

function openHide2(elem) {
    var panel = $(elem).closest(".collapsible_default_open").parent();
    var panelContent = $(panel).find(".sectionContent").first();
    if (panelContent.is(":visible")) {
        $(elem).html("Show");
        panelContent.hide();
    } else {
        $(elem).html("Hide");
        panelContent.show();
    }
}


function openHideOnCheckbox() {
    var panel = $(this).closest(".collapsible").parent();
    var panelContent = $(panel).find(".sectionContent").first();
    if ($(this).is(":checked")) {
        $(panel).find("#action").first().html("Hide");
        panelContent.show();
    } else {
        $(panel).find("#action").first().html("Show");
        panelContent.hide();
    }
}


function ShowFeedBoxHistory(boxNumber) 
{
    win = window.radopen("FeedBoxHistory.aspx?bn=" + boxNumber);
    win.set_title("Full History (Box Number: " + boxNumber + ")");
    win.set_width(400);
    win.set_height(300);
    win.set_modal(true);
    win.set_visibleStatusbar(false);
    //Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Minimize + Telerik.Web.UI.WindowBehaviors.Close +  Telerik.Web.UI.WindowBehaviors.Pin +  Telerik.Web.UI.WindowBehaviors.Maximize + Telerik.Web.UI.WindowBehaviors.Move
    win.set_behaviors(Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Close + Telerik.Web.UI.WindowBehaviors.Move);
    win.add_close(OnFeedBoxHistoryClose);
    win.show();
    return false;
}

function OnFeedBoxHistoryClose(oWnd, eventArgs) 
{
    oWnd.remove_close(OnFeedBoxHistoryClose);
    //document.location.reload();
    //window.location.href = document.location;
}

/*
function ShowPatientDetails(patientId) 
{
    win = window.radopen("ManagePatient.aspx?pid=" + patientId);
    win.set_title("Manage Patient");
    win.set_width(700);
    win.set_height(500);
    win.set_modal(true);
    win.set_visibleStatusbar(false);
    //Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Minimize + Telerik.Web.UI.WindowBehaviors.Close +  Telerik.Web.UI.WindowBehaviors.Pin +  Telerik.Web.UI.WindowBehaviors.Maximize + Telerik.Web.UI.WindowBehaviors.Move
    win.set_behaviors(Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Close + Telerik.Web.UI.WindowBehaviors.Move);
    win.add_close(OnPatientDetailsClose);
    win.show();
    return false;
}
*/

function OnPatientDetailsClose(oWnd, eventArgs) 
{
    oWnd.remove_close(OnPatientDetailsClose);
    //document.location.reload();
    //window.location.href = document.location;
}

function ShowUserDetails(username) 
{
    win = window.radopen("ManageUser.aspx?un=" + username);
    win.set_title("Manage User Account");
    win.set_width(600);
    win.set_height(480);
    win.set_modal(true);
    win.set_visibleStatusbar(false);
    //Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Minimize + Telerik.Web.UI.WindowBehaviors.Close +  Telerik.Web.UI.WindowBehaviors.Pin +  Telerik.Web.UI.WindowBehaviors.Maximize + Telerik.Web.UI.WindowBehaviors.Move
    win.set_behaviors(Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Close + Telerik.Web.UI.WindowBehaviors.Move);
    win.add_close(OnUserDetailsClose);
    win.show();
    return false;
}

function OnUserDetailsClose(oWnd, eventArgs) 
{
    oWnd.remove_close(OnUserDetailsClose);
    window.location.href = document.location;
    //document.location.reload();
}


function ConfirmDelete() {

    if (confirm("Are you sure you want to delete this record?")) {
        return true;
    }
    else {
        return false;
    }

}

function ConfirmLinktoExistingPatient() {

    var agree = confirm("After creating a link to an existing patient from another hospital it can only be deleted by a database administrator. Are you sure you want to link to this patient?");

    if (agree){
       return true;
    }
    else {
       return false;
    }

}












/*douglasw*/

/* RadDatePicker Set Max Date on client*/
/*  <ClientEvents OnLoad="RadDatePicker_SetMaxDateToCurrentDate" />   */
function RadDatePicker_SetMaxDateToCurrentDate(sender, args) {
    var date = new Date();
    var arr = new Array(date.getFullYear(), date.getMonth() + 1, date.getDate());
    sender.set_rangeMaxDate(arr);
}

/*TextAreaCheck MaxLength Start*/
function checkTextAreaMaxLength(textBox, e, length) {

    var mLen = textBox["MaxLength"];
    if (null == mLen) {
        mLen = length;
    }


    var maxLength = parseInt(mLen);
    if (!checkSpecialKeys(e)) {
        if (textBox.value.length > maxLength - 1) {
            if (window.event)//IE
            {
                e.returnValue = false;
                return false;
            }
            else//Firefox
            {
                e.preventDefault();
                return false;
            }

            textBox.value = textBox.value.substring(0, length);
        }
    }

    return true;
}
function checkSpecialKeys(e) {
    if (e.keyCode != 8 && e.keyCode != 46 && e.keyCode != 35 && e.keyCode != 36 && e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 49)
        return false;
    else
        return true;
}