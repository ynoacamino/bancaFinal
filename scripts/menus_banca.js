onload = function () {
    firstLog();
    updateTimer();
    setInterval(updateTimer, 1 * 1000);
};

function firstLog() {
    request("check", function (response) {
        let logged_in = response.getElementsByTagName("logged_in")[0].childNodes[0].nodeValue;
        if (logged_in == "1") {
            let welcome = document.createElement("h4");
            let name = response.getElementsByTagName("name")[0].childNodes[0].nodeValue;
            welcome.innerHTML = "Bienvenido, " + name;
            document.getElementById("welcome").append(welcome);
        } else {
            redirectBack();
        }
    });
}

function updateTimer() {
    request("check", function (response) {
        let logged_in = response.getElementsByTagName("logged_in")[0].childNodes[0].nodeValue;
        if (logged_in == "1") {
            let timer = response.getElementsByTagName("expire_time")[0].childNodes[0].nodeValue;
            document.getElementById("timer").innerHTML = "Su sesión concluirá en: " + timer + "s";
        } else {
            redirectBack();
        }
    });
}

function closeSession() {
    request("close", function () {
        redirectBack();
    });
}

function request(action, callback) {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            callback(xhttp.responseXML);
        }
    };
    xhttp.open("GET", "./cgi-bin/index_banca.pl?action=" + action, true);
    xhttp.send();
}

function redirectBack() {
    alert("Su sesión ha expirado");
    window.location = "./banca.html";
}

function createStatusElements(xhttp) {
    const xmlresponse = xhttp.responseXML;
    const errors = xmlresponse.getElementsByTagName("elem_status");
    for (let i = 0; i < errors.length; i++) {
        let element = errors[i].getElementsByTagName("element")[0].childNodes[0].nodeValue;
        let status = errors[i].getElementsByTagName("status")[0].childNodes[0].nodeValue;
        let statusElement = document.getElementById("status_" + element);
        if (statusElement) {
            statusElement.remove();
        }
        createElement(element, status);
    }
}

function createElement(element, status) {
    const statusElement = document.createElement("h3");
    const placeElement = document.getElementById(element);

    if (status != "Correcto") {
        placeElement.classList.add("error");
        statusElement.classList.add("error");
    } else {
        placeElement.classList.remove("error");
    }

    statusElement.id = "status_" + element;
    statusElement.innerHTML = status;
    document.getElementById("content").insertBefore(statusElement, placeElement);
}

