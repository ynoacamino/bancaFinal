function init(type) {
    firstLog(type);
    updateTimer(type);
    setInterval(function () { updateTimer(type) }, 1 * 1000);
}

function firstLog(type) {
    fetch2([], ["action=check", `type=${type}`], "sesion.pl", function (response) {
        let logged_in = response.getElementsByTagName("logged_in")[0].childNodes[0].nodeValue;
        if (logged_in == "1") {
            let welcome = document.createElement("h5");
            let name = response.getElementsByTagName("name")[0].childNodes[0].nodeValue;
            welcome.innerHTML = "Bienvenido, " + name + " ";
            document.getElementById("welcome").append(welcome);
        } else {
            redirectBack(type);
        }
    });
}

function updateTimer(type) {
    fetch2([], ["action=check", `type=${type}`], "sesion.pl", function (response) {
        let logged_in = response.getElementsByTagName("logged_in")[0].childNodes[0].nodeValue;
        if (logged_in == "1") {
            let timer = response.getElementsByTagName("expire_time")[0].childNodes[0].nodeValue;
            document.getElementById("timer").innerHTML = "Su sesión concluirá en: " + timer + "s";
        } else {
            redirectBack(type);
        }
    });
}

function closeSession(type) {
    fetch2([], ["action=close", `type=${type}`], "sesion.pl", function (response) {
        redirectBack(type);
    })
}

function redirectBack(type) {
    alert("Su sesión ha expirado");
    window.location = `./login_${type}s.html`;
}