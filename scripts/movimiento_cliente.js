function doMovement() {
    fetch2([["deposit", "withdrawal"], amount], [], "movimiento_cliente.pl", function (response) {
        if (response == "correct") {
            alert("Movimiento realizado correctamente");
            location = "./index_clientes.html";
        } else {
            createStatusElements(xhttp);
        }
    });
}