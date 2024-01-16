function createClient() {
    const xhttp = new XMLHttpRequest();
    const dniInput = document.getElementById("dni");
    const namesInput = document.getElementById("names");
    const plastnameInput = document.getElementById("plastname");
    const mlastnameInput = document.getElementById("mlastname");
    const birthDateInput = document.getElementById("bdate");

    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            const response = xhttp.responseText;
            if (response == "correct") {
                alert("Cliente creado correctamente");
                location = "./index_usuarios.html";
            } else {
                createStatusElements(xhttp);
            }
        }
    };

    xhttp.open("POST", "./cgi-bin/clientes.pl", true);
    xhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=ISO-8859-1');
    xhttp.send("dni=" + dniInput.value + "&names=" + namesInput.value + "&plastname=" + plastnameInput.value + "&mlastname=" + mlastnameInput.value + "&bdate=" + birthDateInput.value);
}