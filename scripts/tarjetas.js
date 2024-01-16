function createCard() {
    const xhttp = new XMLHttpRequest();
    const numberInput = document.getElementById("number");
    const passwordInput = document.getElementById("password");

    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            const response = xhttp.responseText;
            if (response == "correct") {
                alert("Tarjeta creada correctamente");
                if (localStorage.getItem("fromaccounts")) {
                    localStorage.setItem("number", numberInput.value);
                    localStorage.removeItem("fromaccounts");
                    location = "./cuentas.html";
                } else {
                    location = "./index_usuarios.html";
                }
            } else {
                createStatusElements(xhttp);
            }
        }
    };

    xhttp.open("POST", "./cgi-bin/tarjetas.pl", true);
    xhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=ISO-8859-1');
    xhttp.send("number=" + numberInput.value + "&password=" + passwordInput.value);
}

function generateNumber() {
    let number = "";
    for (let i = 0; i < 16; i++) {
        number += Math.floor(Math.random() * 9);
    }
    document.getElementById("number").value = number;
}

function generatePassword() {
    const chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    let password = "";
    for (let i = 0; i < 10; i++) {
        password += chars.charAt(Math.random() * chars.length)
    }
    document.getElementById("password").value = password;
}