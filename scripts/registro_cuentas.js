function createAccount() {
    // TODO: accounts are only created with these now
    fetch2(["user", "password", "dni"], [], "registro_cuentas.pl", function(response) {
        if (errors.length != 0) {
            // TODO: update these when the  v   htmls are done
            createStatusElements(errors, "form");
        } else {
            alert("Cuenta creada correctamente");
            window.location = "./index_operarios.html";    
        }
    });
}