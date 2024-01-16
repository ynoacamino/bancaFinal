function doMovement() {
    const xhttp = new XMLHttpRequest();
    const depositInput = document.getElementById("deposit");
    const withdrawalInput = document.getElementById("withdrawal");
    const typeInput = depositInput.checked ? depositInput : withdrawalInput;
    const amountInput = document.getElementById("amount");

    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            const response = xhttp.responseText;
            if (response == "correct") {
                alert("Movimiento realizado correctamente");
                location = "./index_banca.html";
            } else {
                createStatusElements(xhttp);
            }
        }
    };

    xhttp.open("POST", "./cgi-bin/movimientos.pl", true);
    xhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=ISO-8859-1');
    xhttp.send("type=" + typeInput.value + "&amount=" + amountInput.value);
}