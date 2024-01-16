function login() {
    let xhttp = new XMLHttpRequest();
    let user = document.getElementById("user");
    let password = document.getElementById("password");
    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            let response = xhttp.responseText;
            if (response == "wrong" && !document.getElementById("error")) {
                let error = document.createElement("h3");
                error.classList.add("error")
                error.id = "error";
                error.innerHTML = "El usuario o la contraseña son incorrectos. Verifíquelos y vuelva a intentarlo"
                document.getElementById("content").appendChild(error);
                user.classList.add(["error"]);
                password.classList.add(["error"]);
            } else if (response == "correct") {
                window.location = "./index_usuarios.html";
            }
        }
    };
    xhttp.open("POST", "./cgi-bin/usuarios.pl", true);
    xhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=ISO-8859-1');
    xhttp.send("user=" + user.value + "&password=" + password.value);
}