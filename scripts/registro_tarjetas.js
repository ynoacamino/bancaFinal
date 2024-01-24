function createCard() {
    // TODO: cards are only created with these now
    fetch2(["number", "password", ["currency", "soles", "dolares"], "dni"], [], "registro_tarjetas.pl", function(response) {
        if (errors.length != 0) {
            // TODO: update these when the  v   htmls are done
            createStatusElements(errors, "form");
        } else {
            alert("Cuenta creada correctamente");
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

function generatePassword() {
    const chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    let password = "";
    for (let i = 0; i < 10; i++) {
        password += chars.charAt(Math.random() * chars.length)
    }
    document.getElementById("password").value = password;
}