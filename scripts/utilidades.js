function redirect(url, params) {
    if (params) {
        for (let i = 0; i < params.length; i++) {
            localStorage.setItem(params[i][0], params[i][1]);
        }
    }
    location = url;
}

// params son los id del formulario
// script es la ubicacion del archio perl, tiene que terminar en .pl
// func siempre debe tener el parametro (response)
function fetch2(html_params, extra_params, script, func) {
    let xhttp = new XMLHttpRequest();
    let query = "";
    for (let i = 0; i < html_params.length; i++) {
        try {
            let param_value = document.getElementById(html_params[i]).value;
            query += html_params[i] + "=" + param_value + "&";
        } catch (err) {
            alert ("Error obteniendo " + html_params[i]);
        }
    }

    for (let i = 0; i < extra_params.length; i++) {
        query += extra_params[i] + "&";
    }

    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            let response = xhttp.responseXML || new Document();
            func(response);
        }
    };

    xhttp.open("POST", "./cgi-bin/" + script, true);
    xhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=ISO-8859-1');
    xhttp.send(query);
}

