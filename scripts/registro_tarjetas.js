function createCard() {
    // TODO: cards are only created with these now
    fetch2(["number", "password", ["currency", "s", "d"], "dni"], [], "registro_tarjetas.pl", function(response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            // TODO: update these when the  v   htmls are done
            createStatusElements(errors, "form");
        } else {
            alert("Tarjeta creada correctamente");
            location = "./index_operarios.html";
        }
    });
}

function generateNumber() {
    let number = "";
    for (let i = 0; i < 16; i++) {
        number += Math.floor(Math.random() * 9);
    }
    document.getElementById("number").value = number;
}

