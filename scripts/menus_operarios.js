onload = function () {
    firstLog();
    updateTimer();
    setInterval(updateTimer, 1 * 1000);
};

function firstLog() {
    fetch2([], ["action=check", "type=operario"], "sesion.pl", function(response) {
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
    fetch2([], ["action=check", "type=operario"], "sesion.pl", function(response) {
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
    fetch2([], ["action=close", "type=operario"], "sesion.pl", function(response) {
        redirectBack();
    })
}

function redirectBack() {
    alert("Su sesión ha expirado");
    window.location = "./login_operarios.html";
}