function redirect(url) {
    location = url;
}

// html_params son los parametros que se buscan en el formulario (el id tiene que tener el mismo nombre)
// se permite el ingreso de seleccion multiple con un arreglo, el primer elemento es el nombre del parametro y los siguientes las opciones a buscar en el formulario
// extra_params son parametros adicionales que puedes ingresar manualmente "type=operario"
// script es la ubicacion del archio perl, tiene que terminar en .pl
// func siempre debe tener el parametro (response)
function fetch2(html_params, extra_params, script, func) {
    let xhttp = new XMLHttpRequest();
    let query = "";
    for (let i = 0; i < html_params.length; i++) {
        try {
            if (typeof html_params[i] == "object") {
                let chosenInput;
                for (let j = 1; j < html_params[i].length; j++) {
                    let input = document.getElementById(html_params[i][j]);
                    if (input.checked) {
                        chosenInput = input;
                        break;
                    }
                }
                query += html_params[i][0] + "=" + chosenInput.value + "&";
            } else {
                let param_value = document.getElementById(html_params[i]).value;
                query += html_params[i] + "=" + param_value + "&";
            }
        } catch (err) {
            alert("Error obteniendo " + html_params[i]);
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

function removeStatusElements() {
    let errorElements = document.getElementsByName("error");
    while (errorElements.length > 0) {
        errorElements[0].remove();
    }
}

function createStatusElements(errors, parent) {
    removeStatusElements(parent);
    for (let i = 0; i < errors.length; i++) {
        let element = errors[i].getElementsByTagName("element")[0].firstChild.nodeValue;
        let message = errors[i].getElementsByTagName("message")[0].firstChild.nodeValue;
        createElement(element, message, parent);
    }
}

function createElement(element, message, parent) {
    const statusElement = document.createElement("h3");
    const placeElement = document.getElementById(element);

    placeElement.classList.add("error");
    statusElement.classList.add("error");

    statusElement.innerHTML = message;
    statusElement.setAttribute("name", "error");
    document.getElementById(parent).insertBefore(statusElement, placeElement);
}

function generatePassword() {
    const chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    let password = "";
    for (let i = 0; i < 10; i++) {
        password += chars.charAt(Math.random() * chars.length)
    }
    document.getElementById("password").value = password;
    document.getElementById("password_output").value = password;
}