function doMovement() {
    fetch2([["type", "deposit", "withdrawal", "transference"], "card_id", "amount", "other_card"], [], "movimiento_cliente.pl", function (response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            createStatusElements(errors, "form");
        } else {
            alert("Movimiento realizado correctamente");
            window.location = "./index_clientes.html";
        }
    });
}