addEventListener("load", checkFromCards);

function checkFromCards() {
    const number = localStorage.getItem("number");
    if (number) {
        localStorage.removeItem("number");
        document.getElementById("number").value = number;
    }
}

function createAccount() {
    const xhttp = new XMLHttpRequest();
    const numberInput = document.getElementById("number");
    const solesInput = document.getElementById("soles");
    const dollarsInput = document.getElementById("dollars");
    const currencyInput = solesInput.checked ? solesInput : dollarsInput;
    const dniInput = document.getElementById("dni");

    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            const response = xhttp.responseText;
            if (response == "correct") {
                alert("Cuenta creada correctamente");
                location = "./index_usuarios.html";
            } else {
                createStatusElements(xhttp);
            }
        }
    };

    xhttp.open("POST", "./cgi-bin/cuentas.pl", true);
    xhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=ISO-8859-1');
    xhttp.send("number=" + numberInput.value + "&currency=" + currencyInput.value + "&dni=" + dniInput.value);
}