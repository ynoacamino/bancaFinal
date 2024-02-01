function doMovement() {
    // Delete after changing to forced input
    let input = document.getElementById("other_card");
    if (input.style.display == "block")
        input.value = input.value.replaceAll("-", "");
    fetch2([generateCardsQuery(), ["type", "deposit", "withdrawal", "transference"], "amount", "other_card"], [], "movimiento_cliente.pl", function (response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            createStatusElements(errors, "form");
        } else {
            alert("Movimiento realizado correctamente");
            window.location = "./index_clientes.html";
        }
    });
}

function setCardInput(state) {
    let input = document.getElementById("other_card");
    if (state)
        input.style.display = "block";
    else
        input.style.display = "none";
}