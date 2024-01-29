function createAccount() {
    fetch2(["user", "password", "dni"], [], "registro_cuentas.pl", function(response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            // TODO: update these when the  v   htmls are done
            createStatusElements(errors, "form");
        } else {
            alert("Cuenta creada correctamente");
            window.location = "./index_operarios.html";    
        }
    });
}