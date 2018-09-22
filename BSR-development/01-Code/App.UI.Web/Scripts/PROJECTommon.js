/* System JavaScript Common Functions
*  (c) 2012 
*--------------------------------------------------------------------------*/
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

function imposeMaxLength200(source, arguments) {
    if (arguments.Value.length <= 200)
        arguments.IsValid = true;
    else
        arguments.IsValid = false;
}




var BDR = {

    ConfirmDelete: function () {
        if (confirm("Are you sure you want to delete this record?")) {
            return true;
        }
        else {
            return false;
        }

    },

    ConfirmLinktoExistingPatient: function () {
        if (confirm("After creating a link to an existing patient from another hospital it can only be deleted by a database administrator. Are you sure you want to link to this patient?")) {
            return true;
        }
        else {
            return false;
        }

    },


    CloseAndRebind: function () {
    debugger;
    alert("test");
    refreshGrid();
    win.add_close(OnInstituteVisitClose);

}




} // end of the DMS namespace

function ShowHelpWindow(url, title, width, height) {
    win = window.radopen(url);
    win.set_title(title);
    win.set_width(width);
    win.set_height(height);
    win.set_modal(true);
    win.set_visibleStatusbar(false);
    //Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Minimize + Telerik.Web.UI.WindowBehaviors.Close +  Telerik.Web.UI.WindowBehaviors.Pin +  Telerik.Web.UI.WindowBehaviors.Maximize + Telerik.Web.UI.WindowBehaviors.Move
    win.set_behaviors(Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Minimize + Telerik.Web.UI.WindowBehaviors.Close + Telerik.Web.UI.WindowBehaviors.Pin + Telerik.Web.UI.WindowBehaviors.Maximize + Telerik.Web.UI.WindowBehaviors.Move);
    win.add_close(OnFeedBoxHistoryClose);
    win.show();
    return false;
}

function ShowInstituteVisit() {
    win = window.radopen("InstituteModal.aspx");
    win.set_title("Select Institute Visit");
    win.set_width(850);
    win.set_height(480);
    win.set_modal(true);
    win.set_visibleStatusbar(false);
    //Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Minimize + Telerik.Web.UI.WindowBehaviors.Close +  Telerik.Web.UI.WindowBehaviors.Pin +  Telerik.Web.UI.WindowBehaviors.Maximize + Telerik.Web.UI.WindowBehaviors.Move
    win.set_behaviors(Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Close + Telerik.Web.UI.WindowBehaviors.Move);
    win.add_close(OnInstituteVisitClose);
    win.show();
    return false;
}


function OnInstituteVisitClose(oWnd, eventArgs) {
    window.parent.parent.LoadLookupPartial();
    oWnd.remove_close(OnInstituteVisitClose);
    //window.location.href = document.location;
    //document.location.reload();
}

function ShowPSA() {
    win = window.radopen("PSAModal.aspx");
    win.set_title("Select PSA Reading");
    win.set_width(850);
    win.set_height(480);
    win.set_modal(true);
    win.set_visibleStatusbar(false);
    //Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Minimize + Telerik.Web.UI.WindowBehaviors.Close +  Telerik.Web.UI.WindowBehaviors.Pin +  Telerik.Web.UI.WindowBehaviors.Maximize + Telerik.Web.UI.WindowBehaviors.Move
    win.set_behaviors(Telerik.Web.UI.WindowBehaviors.Resize + Telerik.Web.UI.WindowBehaviors.Close + Telerik.Web.UI.WindowBehaviors.Move);
    win.add_close(OnPSAReadingClose);
    win.show();
    return false;
}

function OnPSAReadingClose(oWnd, eventArgs) {
    window.parent.parent.LoadLookupPartial();
    oWnd.remove_close(OnPSAReadingClose);
    //window.location.href = document.location;
    //document.location.reload();
}


function refreshGrid() {
  //  __doPostBack('<%= UpdatePanel2.ClientID %>', '');
  //  __doPostBack('UpdatePanel2', '');
}