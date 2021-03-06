function onRequestEnd(e) {
    wnd = $("#modalWindowAlert").kendoWindow({
        title: "Confirmaci&oacute;n",
        modal: true,
        visible: false,
        resizable: false,
        width: 300
    }).data("kendoWindow");

    $("#yes").hide();
    $("#no").hide();

    if (e.type == "destroy" && !e.response.Errors) {
        $("#confirmMessage").html("Registro eliminado exitosamente");
        wnd.center().open();
        this.read();
    }

    if (e.type == "update" && !e.response.Errors) {
        $("#confirmMessage").html("Registro actualizado exitosamente");
        wnd.center().open();
        this.read();
    }

    if (e.type == "create" && !e.response.Errors) {
        $("#confirmMessage").html("Registro agregado exitosamente");
        wnd.center().open();
        this.read();
    }
}

function dataSourceBrowser(data, fieldname, value, fieldnamereturned) {
    var result = null;

    for (var i = 0; i < data.length; i++) {
        if (data[i][fieldname] === value) {
            result = data[i][fieldnamereturned];
        }
    }

    return result;
}

function onErrorGeneral(message) {
    wnd = $("#modalWindowAlert").kendoWindow({
        title: "Error",
        modal: true,
        visible: false,
        resizable: false,
        width: 300
    }).data("kendoWindow");

    $("#yes").hide();
    $("#no").hide();

    $("#confirmMessage").html(message);
    wnd.center().open();
}

function wsExecute(HTTPTYPE, DATATYPE, URL, DATA, ASYNC) {
    var result = {};

    $.ajax({
        type: HTTPTYPE,
        dataType: DATATYPE,
        url: URL,
        data: DATA,
        async: ASYNC,
        success: function (response) {
            result = response;
        },
        error: function (response) {
            result = response;
        }
    });

    return result;
}

function GetCifDollar(cifQ, ExchangeRate) {
    var value = 0;
    cifQ = (cifQ == null) ? ((cifQ == '') ? 0 : cifQ) : cifQ;
    ExchangeRate = (ExchangeRate == null) ? ((ExchangeRate == '') ? 0 : ExchangeRate) : ExchangeRate;

    if (cifQ != 0 && ExchangeRate != 0) {
        value = (cifQ / ExchangeRate);
    }

    return value;
}

function GetFobDollar(fobQ, ExchangeRate) {
    var value = 0;
    fobQ = (fobQ == null) ? ((fobQ == '') ? 0 : fobQ) : fobQ;
    ExchangeRate = (ExchangeRate == null) ? ((ExchangeRate == '') ? 0 : ExchangeRate) : ExchangeRate;

    if (fobQ != 0 && ExchangeRate != 0) {
        value = (fobQ / ExchangeRate);
    }

    return value;
}

function GetIva(cifQ, customDuties, IvaPercent) {
    var value = 0;
    cifQ = (cifQ == null) ? ((cifQ == '') ? 0 : cifQ) : cifQ;
    customDuties = (customDuties == null) ? ((customDuties == '') ? 0 : customDuties) : customDuties;
    IvaPercent = (IvaPercent == null) ? ((IvaPercent == '') ? 0 : IvaPercent) : IvaPercent;

    //if (cifQ != 0 && customDuties != 0 && IvaPercent != 0) {
    if (IvaPercent != 0) {
        value = ((cifQ + customDuties) * IvaPercent);
    }

    return value;
}

function GetDate(StringFormat) {
    var today = new Date();

    return kendo.toString(today, (StringFormat == null) ? 'dd/MM/yyyy' : StringFormat);
}

function EmulateTab(data, elementname) {
    var index = 0;
    for (var i = 0; i < data.length; i++) {
        if(data[i].DataBaseName === elementname){
            index = (data.length == i) ? i : (i + 1);
        }
    }

    if (data.length == index) {
        $('#btnGuardar').trigger('click');
    }
    else {
        var datatype = data[index].ObjectHtml, itemname = data[index].DataBaseName;
        switch (datatype) {
            case "TextBox":
                $('#' + itemname).focus();
                break;
            case "DropDownList":
                var kendoelement = $("#" + itemname).data("kendoDropDownList");
                kendoelement.wrapper.trigger('click');
                break;
            case "DatePicker":
                var kendoelement = $("#" + itemname).data("kendoDatePicker");
                kendoelement.element.focus();
                kendoelement.open();
                break;
            case "NumericTextBox":
                var kendoelement = $("#" + itemname).data("kendoNumericTextBox");
                $('#' + itemname).siblings("input:visible").focus();
                break;
        }
    }
}

function EmulateTabDetail(data, elementname) {
    var index = 0;
    for (var i = 0; i < data.length; i++) {
        if (data[i].DataBaseName === elementname) {
            index = (data.length == i) ? i : (i + 1);
        }
    }

    if (data.length == index) {
        $('#btnGuardar').trigger('click');
    }
    else {
        var datatype = data[index].HtmlObject, itemname = data[index].DataBaseName;
        switch (datatype) {
            case "TextBox":
                $('#' + itemname).focus();
                break;
            case "DropDownList":
                var kendoelement = $("#" + itemname).data("kendoDropDownList");
                kendoelement.wrapper.trigger('click');
                break;
            case "DatePicker":
                var kendoelement = $("#" + itemname).data("kendoDatePicker");
                kendoelement.element.focus();
                kendoelement.open();
                break;
            case "NumericTextBox":
                var kendoelement = $("#" + itemname).data("kendoNumericTextBox");
                $('#' + itemname).siblings("input:visible").focus();
                break;
        }
    }
}

function focusFirstElement(data, elementname) {
    var index = 0;

    var datatype = data[index].ObjectHtml, itemname = data[index].DataBaseName;
    switch (datatype) {
        case "TextBox":
            $('#' + itemname).focus();
            break;
        case "DropDownList":
            var kendoelement = $("#" + itemname).data("kendoDropDownList");
            kendoelement.wrapper.trigger('click');
            break;
        case "DatePicker":
            var kendoelement = $("#" + itemname).data("kendoDatePicker");
            kendoelement.element.focus();
            kendoelement.open();
            break;
        case "NumericTextBox":
            var kendoelement = $("#" + itemname).data("kendoNumericTextBox");
            $('#' + itemname).siblings("input:visible").focus();
            break;
    }
}