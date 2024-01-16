function login() {
    let xhttp = new XMLHttpRequest();
    let number = document.getElementById("number");
    let password = document.getElementById("password");
    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            let response = xhttp.responseText;
            if (response == "wrong" && !document.getElementById("error")) {
                let error = document.createElement("h3");
                error.classList.add("error")
                error.id = "error";
                error.innerHTML = "El número de tarjeta o la contraseña son incorrectos. Verifíquelos y vuelva a intentarlo"
                document.getElementById("content").appendChild(error);
                number.classList.add(["error"]);
                password.classList.add(["error"]);
            } else if (response == "correct") {
                window.location = "./index_banca.html";
            }
        }
    };
    xhttp.open("POST", "./cgi-bin/banca.pl", true);
    xhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=ISO-8859-1');
    xhttp.send("number=" + number.value + "&password=" + password.value);
}